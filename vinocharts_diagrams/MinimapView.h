//
//  MinimapController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/30/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Note;
@class FramingLinesView;

@interface MinimapView : UIView

@property (readwrite) UIView *terrain;
@property (readonly) FramingLinesView *screenTracker;
@property (readwrite) UIView *minimapDisplay;
@property (readwrite) NSMutableArray *notesArray;

- (id)initWithMinimapDisplayFrame:(CGRect)frame MapOf:(UIView*)canvas PopulateWith:(NSMutableArray*)notesArray;

- (void)setScreenTrackerFrame:(CGRect)screenFrame;

- (void)removeAllNotes;

- (void)add:(Note*)n1;

- (void)remakeWith:(NSMutableArray*)notesArray;

@end
