//
//  NSString+AKAIIStringEncoding.h
//  AKAIIStringEncoding
//
//  Created by Ben Williams on 16/12/17.
//  Copyright © 2017 Benjineering. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSStringEncoding NSAKAIIStringEncoding = 50;

static const CFStringEncoding kCFStringEncodingAKAII = 50;

NSStringEncoding akai_StringConvertEncodingToNSStringEncoding(CFStringEncoding encoding);

CFStringEncoding akai_StringConvertNSStringEncodingToEncoding(NSStringEncoding encoding);

@interface NSString (AKAIIStringEncoding)
- (nullable NSData *)akaii_dataUsingEncoding:(NSStringEncoding)encoding
                        allowLossyConversion:(BOOL)lossy;
@end
