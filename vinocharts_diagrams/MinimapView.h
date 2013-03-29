//
//  MinimapController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/30/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Note;

@interface MinimapView : UIView

@property (readwrite) UIView *map;
@property (readwrite) UIView *minimapDisplay;
@property (readwrite) NSMutableArray *notesArray;

- (id)initWithMinimapDisplayFrame:(CGRect)frame MapOf:(UIView*)canvas PopulateWith:(NSMutableArray*)notesArray;

- (void)removeAllNotes;

- (void)add:(Note*)n1;

- (void)remakeWith:(NSMutableArray*)notesArray;

@end
