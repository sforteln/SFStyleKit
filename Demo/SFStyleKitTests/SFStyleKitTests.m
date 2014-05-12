//
//  SFStyleKitTests.m
//  SFStyleKitTests
//
//  Created by Simon Fortelny on 5/10/14.
//  Copyright (c) 2014 Simon Fortelny. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFStyle.h"

@interface SFStyleKitTests : XCTestCase

@end

@implementation SFStyleKitTests

- (NSDictionary *)dataFromJSONFileNamed:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return json;
}

- (void)testLoadUser
{
    SFStyle *style = [SFStyle sharedInstance];
}

@end
