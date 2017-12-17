//
//  NSString+AKAIIStringEncoding.h
//  AKAIIStringEncoding
//
//  Created by Ben Williams on 16/12/17.
//  Copyright © 2017 Benjineering. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSStringEncoding AKAIIStringEncoding = 50;

@interface NSString (AKAIIStringEncoding)
- (nullable NSData *)akaii_dataUsingEncoding:(NSStringEncoding)encoding
                        allowLossyConversion:(BOOL)lossy;
@end

