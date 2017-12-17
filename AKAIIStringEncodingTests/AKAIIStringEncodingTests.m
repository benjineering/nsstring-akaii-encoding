//
//  AKAIIStringEncodingTests.m
//  AKAIIStringEncodingTests
//
//  Created by Ben Williams on 16/12/17.
//  Copyright © 2017 Benjineering. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+AKAIIStringEncoding.h"

@interface AKAIIStringEncodingTests : XCTestCase

@end

@implementation AKAIIStringEncodingTests

- (void)setUp {
   [super setUp];
}

- (void)tearDown {
   [super tearDown];
}

- (void)testNSStringEncodingValueIs50 {
   XCTAssertEqual(AKAIIStringEncoding, 50);
}

- (void)testDataUsingEncodingWithAKAII {
   const char actualBytes[] = { 65, 46, 90, 48, 57, 32, 35, 45, 43, '\0' };
   NSData *actualData = [[NSString stringWithUTF8String:actualBytes]
                         dataUsingEncoding:AKAIIStringEncoding allowLossyConversion:true];
   NSString *actual = [NSString stringWithUTF8String:[actualData bytes]];
   NSString *expected = [NSString stringWithUTF8String:"A.Z09 #-+"];
   XCTAssertTrue([expected isEqualToString:actual]);
}

- (void)testDataUsingEncodingWithASCII {
   const char *str = "@hello_babie&~";
   NSData *actualData = [[NSString stringWithUTF8String:str]
                         dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:true];
   NSString *actual = [NSString stringWithUTF8String:[actualData bytes]];
   NSString *expected = [NSString stringWithUTF8String:str];
   XCTAssertTrue([expected isEqualToString:actual]);
}

@end

