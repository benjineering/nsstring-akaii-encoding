//
//  NSString+AKAIIStringEncoding.m
//  AKAIIStringEncoding
//
//  Created by Ben Williams on 16/12/17.
//  Copyright © 2017 Benjineering. All rights reserved.
//

#import <objc/runtime.h>
#import "NSString+AKAIIStringEncoding.h"

/*
 * Character    ASCII       AKAII
 * ----------------------------------
 * 0 - 9       48 - 57     0 - 9
 * space       32          10
 * A - Z       65 - 90     11 - 36
 * #           35          37
 * +           43          38
 * -           45          39
 * .           46          40
 */
const unichar CHAR_TABLE[] = {
   '.', '.', '.', '.', '.', '.', '.', '.',
   '.', '.', '.', '.', '.', '.', '.', '.',
   '.', '.', '.', '.', '.', '.', '.', '.',
   '.', '.', '.', '.', '.', '.', '.', '.',
   ' ', '.', '.', '#', '.', '.', '.', '.',
   '.', '.', '.', '+', '.', '-', '.', '.',
   '0', '1', '2', '3', '4', '5', '6', '7',
   '8', '9', '.', '.', '.', '.', '.', '.',
   '.', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
   'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
   'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
   'X', 'Y', 'Z', '.', '.', '.', '.', '.',
   '.', '.', '.', '.', '.', '.', '.', '.',
   '.', '.', '.', '.', '.', '.', '.', '.',
   '.', '.', '.', '.', '.', '.', '.', '.',
   '.', '.', '.', '.', '.', '.', '.', '.'
};

@implementation NSString (AKAIIStringEncoding)

// Edward Swizzlehands
+ (void)load {
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      Class class = [self class];
      
      SEL originalSelector = @selector(dataUsingEncoding:allowLossyConversion:);
      SEL swizzledSelector = @selector(akaii_dataUsingEncoding:allowLossyConversion:);
      
      Method originalMethod = class_getInstanceMethod(class, originalSelector);
      Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
      
      BOOL didAddMethod = class_addMethod(class,
                                          originalSelector,
                                          method_getImplementation(swizzledMethod),
                                          method_getTypeEncoding(swizzledMethod));
      
      if (didAddMethod) {
         class_replaceMethod(class,
                             swizzledSelector,
                             method_getImplementation(originalMethod),
                             method_getTypeEncoding(originalMethod));
      }
      else {
         method_exchangeImplementations(originalMethod, swizzledMethod);
      }
   });
}

- (nullable NSData *)akaii_dataUsingEncoding:(NSStringEncoding)encoding
                        allowLossyConversion:(BOOL)lossy {
   if (encoding != AKAIIStringEncoding) {
      return [self akaii_dataUsingEncoding:encoding allowLossyConversion:lossy];
   }
   
   char *str = malloc([self length]);
   strcpy(str, [self cStringUsingEncoding:NSASCIIStringEncoding]);
   size_t len = strlen(str);
   
   for (size_t i = 0; i < len; ++i) {
      int val = str[i];
      str[i] = CHAR_TABLE[val];
   }
   
   return [NSData dataWithBytes:str length:len];
}

@end

