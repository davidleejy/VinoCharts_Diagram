//
//  DebugHelper.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/30/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugHelper : NSObject

+(void)printCGRect:(CGRect)myRect :(NSString*)prefixText;

+(void)printCGSize:(CGSize)s :(NSString*)prefixText;

+(void)printUIScrollView:(UIScrollView*)sV :(NSString*)prefixText;

@end
