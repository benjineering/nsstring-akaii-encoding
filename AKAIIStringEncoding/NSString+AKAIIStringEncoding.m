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
const char CHAR_TABLE[] = {
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

NSStringEncoding akai_StringConvertEncodingToNSStringEncoding(CFStringEncoding encoding) {
   if (encoding == kCFStringEncodingAKAII) {
      return NSAKAIIStringEncoding;
   }
   
   return CFStringConvertEncodingToNSStringEncoding(encoding);
}


CFStringEncoding akai_StringConvertNSStringEncodingToEncoding(NSStringEncoding encoding) {
   if (encoding == NSAKAIIStringEncoding) {
      return kCFStringEncodingAKAII;
   }
   
   return CFStringConvertNSStringEncodingToEncoding(encoding);
}

@implementation NSString (AKAIIStringEncoding)

// Edward Swizzlehands
+ (void)load {
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      Class instanceClass = [self class];
      Class class = object_getClass((id)self);
      
      SEL originalDAESelector = @selector(dataUsingEncoding:allowLossyConversion:);
      SEL swizzledDAESelector = @selector(akaii_dataUsingEncoding:allowLossyConversion:);
      Method originalDAEMethod = class_getInstanceMethod(instanceClass, originalDAESelector);
      Method swizzledDAEMethod = class_getInstanceMethod(instanceClass, swizzledDAESelector);
      
      BOOL didAddDAEMethod = class_addMethod(instanceClass,
                                             originalDAESelector,
                                             method_getImplementation(swizzledDAEMethod),
                                             method_getTypeEncoding(swizzledDAEMethod));
      
      if (didAddDAEMethod) {
         class_replaceMethod(instanceClass,
                             swizzledDAESelector,
                             method_getImplementation(originalDAEMethod),
                             method_getTypeEncoding(originalDAEMethod));
      }
      else {
         method_exchangeImplementations(originalDAEMethod, swizzledDAEMethod);
      }
      
      SEL originalLNSESelector = @selector(localizedNameOfStringEncoding:);
      SEL swizzledLNSESelector = @selector(akai_localizedNameOfStringEncoding:);
      Method originalLNSEMethod = class_getClassMethod(class, originalLNSESelector);
      Method swizzledLNSEMethod = class_getClassMethod(class, swizzledLNSESelector);
      
      BOOL didAddLNSEMethod = class_addMethod(class,
                                              originalLNSESelector,
                                              method_getImplementation(swizzledLNSEMethod),
                                              method_getTypeEncoding(swizzledLNSEMethod));
      
      if (didAddLNSEMethod) {
         class_replaceMethod(class,
                             swizzledLNSESelector,
                             method_getImplementation(originalLNSEMethod),
                             method_getTypeEncoding(originalLNSEMethod));
      }
      else {
         method_exchangeImplementations(originalLNSEMethod, swizzledLNSEMethod);
      }
   });
}

- (nullable NSData *)akaii_dataUsingEncoding:(NSStringEncoding)encoding
                        allowLossyConversion:(BOOL)lossy {
   if (encoding != NSAKAIIStringEncoding) {
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

+ (nullable NSString *)akai_localizedNameOfStringEncoding:(NSStringEncoding)encoding {
   if (encoding == NSAKAIIStringEncoding) {
      return @"AKAII";
   }
   
   return [self akai_localizedNameOfStringEncoding:encoding];
}

@end
