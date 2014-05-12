//
//  SFViewController.m
//  SFStyleKit
//
//  Created by Simon Fortelny on 5/10/14.
//  Copyright (c) 2014 Simon Fortelny. All rights reserved.
//

#import "SFViewController.h"
#import "UIView+SFStyleKit.h"

@interface SFViewController ()

@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.label sk_configureWithElementName:@"chat.header.name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
