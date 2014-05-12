//
//  SFStyle.h
//  SFStyleKit
//
//  Created by Simon Fortelny on 5/10/14.
//  Copyright (c) 2014 Simon Fortelny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFStyle : NSObject

+ (id)sharedInstance;
/**
 *  Use a custom file for styling information. Be sure to call this method BEFORE the first invocation of +sharedInstance.
 *
 *  @param styleFile the name of the json file that has the style information
 */
+ (void)setCustomStyleFileName:(NSString *)styleFile;
/**
 *  Most likely only used by the UIView category to get the properties to apply to the UIView.
 *
 *  @param elementName the name of the element you want <keypath,value> for
 *
 *  @return A NSDictionary of the keypaths and values for the elementName.
 *   In debug it will fail an NSAssert if data for the elementName is not found otherwise it will return nil.
 */
-(NSDictionary *)dictionaryForElementName:(NSString *)elementName;
@end
