//
//  UIView+SFStyleKit.h
//  SFStyleKit
//
//  Created by Simon Fortelny on 5/10/14.
//  Copyright (c) 2014 Simon Fortelny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SFStyleKit)
/**
 *  Configure a UIView with the keypaths and values 
 *   for this element name from the style json
 *
 *  @param elementName the name from the style to use from the style json
 */
-(void)sk_configureWithElementName:(NSString *)elementName;
/**
 *  This selector is here to allow KVC suuport so 
 *   you can configure viewsin interface builder
 *
 *  @param elementName the name from the style to use from the style json
 */
-(void)setConfigureWithElementName:(NSString *)elementName;
@end
