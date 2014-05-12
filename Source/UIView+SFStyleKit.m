//
//  UIView+SFStyleKit.m
//  SFStyleKit
//
//  Created by Simon Fortelny on 5/10/14.
//  Copyright (c) 2014 Simon Fortelny. All rights reserved.
//

#import "UIView+SFStyleKit.h"
#import "SFStyle.h"

@implementation UIView (SFStyleKit)

-(void)sk_configureWithElementName:(NSString *)elementName{
    NSDictionary *properties = [[SFStyle sharedInstance] dictionaryForElementName:elementName];
    for (NSString *keyPath in [properties allKeys]){
        [self setValue:properties[keyPath] forKeyPath:keyPath];
    }
    
}

-(void)setConfigureWithElementName:(NSString *)elementName{
    [self sk_configureWithElementName:elementName];
}

@end
