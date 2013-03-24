//
//  ViewHelper.m
//  Game
//
//  Created by Lee Jian Yi David on 3/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewHelper.h"

@implementation ViewHelper

+ (UIView*) embedText:(NSString*)txt
         WithFrame:(CGRect)frame
         TextColor:(UIColor*)color
      DurationSecs:(double)t
                In:(UIView*)view1
{
    UILabel *lbl = [[UILabel alloc]init];
    [lbl setFrame:frame];
    [lbl setText:txt];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:color];
    [view1 addSubview:lbl];
    
    if (t <= 0.0) {
        return lbl;
    }
    else // lbl will remove itself from view1 after t seconds.
        [lbl performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return lbl;
}


+(UIView*)embedMark:(CGPoint)coord
     WithColor:(UIColor*)color
  DurationSecs:(double)t
            In:(UIView*)view1
{
    UIView *mark = [[UIView alloc]initWithFrame:CGRectMake(coord.x, coord.y, 5, 5)];
    [mark setBackgroundColor:color];
    [view1 addSubview:mark];
    
    if (t <= 0.0) {
        return mark;
    }
    else // mark will remove itself from view1 after t seconds.
        [mark performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return mark;
}



@end