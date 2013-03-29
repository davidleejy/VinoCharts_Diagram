//
//  DebugHelper.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/30/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DebugHelper.h"

@implementation DebugHelper

+(void)printCGRect:(CGRect)myRect :(NSString*)prefixText{
    NSLog(@"%@ x%.2f y%.2f w%.2f h%.2f",prefixText,myRect.origin.x,myRect.origin.y,myRect.size.width,myRect.size.height);
}

+(void)printCGSize:(CGSize)s :(NSString*)prefixText{
    NSLog(@"%@ w%.2f h%.2f",prefixText,s.width,s.height);
}

+(void)printUIScrollView:(UIScrollView*)sV :(NSString*)prefixText{
    NSLog(@"%@",prefixText);
    [self printCGRect:sV.frame :@"   frame"];
    [self printCGRect:sV.bounds :@"   bounds"];
    [self printCGSize:sV.contentSize :@"   contentSize"];
    NSLog(@"   zoomScale:%.2f contentScaleFactor:%.2f",sV.zoomScale,sV.contentScaleFactor);
}

@end
