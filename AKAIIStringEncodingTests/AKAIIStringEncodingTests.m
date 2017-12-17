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
   XCTAssertEqual(NSAKAIIStringEncoding, 50);
}

- (void)testCFStringEncodingValueIs50 {
   XCTAssertEqual(kCFStringEncodingAKAII, 50);
}

- (void)testConvertAKAIIToNSStringEncoding {
   NSStringEncoding actual =
      akai_StringConvertEncodingToNSStringEncoding(kCFStringEncodingAKAII);
   XCTAssertEqual(actual, NSAKAIIStringEncoding);
}

- (void)testConvertASCIIToNSStringEncoding {
   NSStringEncoding actual =
      akai_StringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
   XCTAssertEqual(actual, NSASCIIStringEncoding);
}

- (void)testConvertAKAIIToCFStringEncoding {
   CFStringEncoding actual =
   akai_StringConvertNSStringEncodingToEncoding(NSAKAIIStringEncoding);
   XCTAssertEqual(actual, kCFStringEncodingAKAII);
}

- (void)testConvertASCIIToCFStringEncoding {
   CFStringEncoding actual =
      akai_StringConvertNSStringEncodingToEncoding(NSASCIIStringEncoding);
   XCTAssertEqual(actual, kCFStringEncodingASCII);
}

- (void)testDataUsingEncodingWithAKAII {
   const char actualBytes[] = { 65, 46, 90, 48, 57, 32, 35, 45, 43, '\0' };
   NSData *actualData = [[NSString stringWithUTF8String:actualBytes]
                         dataUsingEncoding:NSAKAIIStringEncoding allowLossyConversion:true];
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

- (void)testLocalizedNameOfAKAIIEncoding {
   NSString *actual = [NSString localizedNameOfStringEncoding:NSAKAIIStringEncoding];
   XCTAssertTrue([actual isEqualToString:@"AKAII"]);
}

- (void)testLocalizedNameOfASCIIEncoding {
   NSString *actual = [NSString localizedNameOfStringEncoding:NSASCIIStringEncoding];
   XCTAssertTrue([actual isEqualToString:@"Western (ASCII)"]);
}

@end
