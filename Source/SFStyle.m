//
//  SFStyle.m
//  SFStyleKit
//
//  Created by Simon Fortelny on 5/10/14.
//  Copyright (c) 2014 Simon Fortelny. All rights reserved.
//

#import "SFStyle.h"

static SFStyle *__sharedInstance;
static dispatch_once_t onceToken;
static NSString *styleFileName = @"style";

@interface SFStyle ()
@property (nonatomic,strong) NSDictionary *vars;
@property (nonatomic,strong) NSDictionary *aliases;
@property (nonatomic,strong) NSDictionary *elements;

@end

@implementation SFStyle

+ (void)setCustomStyleFileName:(NSString *)styleFile{
    styleFileName = styleFileName;
}

+ (id)sharedInstance {
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[SFStyle alloc] init];
    });
    
    return __sharedInstance;
}

-(id)init{
    self=[super init];
    if(self)
    {
        [self loadStyle];
    }
    return self;
}

-(void)loadStyle{
    NSDictionary *json= [self dataFromJSONFileNamed:styleFileName];
    NSAssert([json objectForKey:@"variables"], @"Missing variables section");
    NSAssert([json objectForKey:@"element-names"], @"Missing element-names section");
    
    //process vars

    _vars = [self processVariables:json[@"variables"]];
    _aliases = [self processAliases:json[@"aliases"]];
    _elements = [self processElementsFromJson:json[@"element-names"] variables:_vars aliases:_aliases];
}

-(NSDictionary *)processVariables:(NSDictionary *)variableJson{
    NSMutableDictionary *vars = [NSMutableDictionary new];
    for (NSString *key in [variableJson allKeys]){
        if([variableJson[key] isKindOfClass:NSString.class]){
            vars[key] = [self objectForProperty:key valueString:variableJson[key]];
        }else {
            vars[key] = variableJson[key];
        }
        
    }
    return vars;
}

-(NSDictionary *)processElementsFromJson:(NSDictionary *)elementsJson
                               variables:(NSDictionary *)vars
                                 aliases:(NSDictionary *)aliases{
    
    NSMutableDictionary *elements = [NSMutableDictionary new];
    for (NSString *elementName in [elementsJson allKeys]){
        elements[elementName] = [NSMutableDictionary new];
        NSDictionary *properties =elementsJson[elementName];
        for(__strong NSString *propertyName in [properties allKeys] ){
            id propertyValue = properties[propertyName];
            //check if property is an alias
            if([propertyName hasPrefix:@"$"] && aliases[propertyName]){
                propertyName = aliases[propertyName];
            }
            if([propertyValue isKindOfClass:NSString.class] && [propertyValue hasPrefix:@"$"]){
                //look up variable
                NSString *variableValue = vars[propertyValue];
                NSAssert(variableValue, @"Unable to find variable named %@",propertyName);
                elements[elementName][propertyName] = variableValue;
            }else if([properties[propertyName] isKindOfClass:NSString.class]){
                elements[elementName][propertyName] = [self objectForProperty:propertyName valueString:propertyValue];
            }else {
                elements[elementName][propertyName] = propertyValue;
            }
        }
    }
    return elements;
}

-(NSDictionary *)processAliases:(NSDictionary *)aliasesJson{
    return aliasesJson;
}

-(id)objectForProperty:(NSString *)property valueString:(NSString *) value{
    if([value hasPrefix:@"font"]){
        return [self fontForFontString:value];
    }else if([value hasPrefix:@"cgcolor"] || [property isEqualToString:@"layer.borderColor"]){
        return (id)[self colorForColorString:value].CGColor;
    }else if([value hasPrefix:@"color"]){
        return [self colorForColorString:value];
    }else {
        return value;
    }
}

-(UIFont *)fontForFontString:(NSString *)fontString{
    NSMutableCharacterSet *skippedCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@"(,)"];
    
    NSScanner *scanner = [NSScanner scannerWithString:fontString];
    [scanner setCharactersToBeSkipped:skippedCharacters];
    NSString *fontPrefix, *fontName;
    NSInteger size;
    
    //possible font name chars a-zA-Z and '-'
    NSMutableCharacterSet *fontCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [fontCharacters formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    
    [scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&fontPrefix];//ignore
    [scanner scanCharactersFromSet:fontCharacters intoString:&fontName];
    
    [scanner scanInteger:&size];
    UIFont *font =[UIFont fontWithName:fontName size:size];
    NSAssert(font, @"Unable to make font from %@",fontString);
    return font;
}

-(UIColor *)colorForColorString:(NSString *)colorString{
    NSMutableCharacterSet *skippedCharacters = [NSMutableCharacterSet punctuationCharacterSet];
    [skippedCharacters formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    
    NSScanner *scanner = [NSScanner scannerWithString:colorString];
    [scanner setCharactersToBeSkipped:skippedCharacters];
    
    CGFloat red, green, blue, alpha;
    [scanner scanFloat:&red];
    [scanner scanFloat:&green];
    [scanner scanFloat:&blue];
    [scanner scanFloat:&alpha];
    UIColor *color = [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha/255.f];
    NSAssert(color, @"Unable to make cgcolor from %@",colorString);
    return color;
}


- (NSDictionary *)dataFromJSONFileNamed:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSAssert(data, @"Error finding json file %@", filePath);
    NSError *error;
    NSDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSAssert(!error, @"Error parsing style json file %@.json", fileName);
    return json;
}

-(NSDictionary *)dictionaryForElementName:(NSString *)elementName{
    NSAssert([self.elements objectForKey:elementName], @"No style for element %@",elementName);
    return [[self.elements objectForKey:elementName] copy];
}

@end
