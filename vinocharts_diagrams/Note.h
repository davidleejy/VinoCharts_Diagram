//
//  Note.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"

@interface Note : NSObject <ChipmunkObject,UITextViewDelegate>

@property (readwrite) UITextView *textView;
@property (readwrite) UIImageView *editView;
@property (readwrite) UIImageView *frameOriginIndicator;
@property (readwrite) UIImageView *foreShadow; //Used in snap to grid to show where note will land after snapping.
@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects;

/*State*/
@property (readwrite) BOOL beingPanned;


-(void)updatePos;
//MODIFIES: textView
//EFFECTS: updates textView to follow body. Called at each delta time when using chipmunk physics engine.

-(id)initWithText:(NSString*)t;
//REQUIRES: parameter t has at most 140 characters.
//EFFECTS: ctor

-(void)showFrameOriginIndicator;
-(void)hideFrameOriginIndicator;


@end
