//
//  Note.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"

@interface Note : NSObject <ChipmunkObject>

@property (readwrite) UITextView *textView;
@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects;

-(void)updatePos;

@end
