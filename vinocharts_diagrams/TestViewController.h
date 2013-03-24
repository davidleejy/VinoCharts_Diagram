//
//  TestViewController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <quartzcore/CADisplayLink.h>
#import "Note.h"

@interface TestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (readwrite) CADisplayLink *displayLink;
@property (readwrite) ChipmunkSpace *space;
@property (readwrite) Note *n1;
@property (readwrite) NSMutableArray *notesArray;
@property (readwrite) UIView *rect1;

// States
@property (readwrite) BOOL editingANote;
@property (readwrite) Note *noteBeingEdited;

- (IBAction)newNoteButton:(id)sender;
- (IBAction)forceEdit:(id)sender;
- (IBAction)gravityOff:(id)sender;
- (IBAction)gravityOn:(id)sender;

- (void)singleTapResponse:(UITapGestureRecognizer *)recognizer;
// EFFECTS: Executes what a single tap is supposed to do.

-(void)notePanResponse:(UIPanGestureRecognizer*)recognizer;
// EFFECTS: Executes what a note is supposed to do during panning.

@end
