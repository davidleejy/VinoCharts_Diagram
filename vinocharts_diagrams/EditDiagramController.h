//
//  EditDiagramController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <quartzcore/CADisplayLink.h>
#import "Note.h"

@interface EditDiagramController : UIViewController

/*Outlets*/
@property (weak, nonatomic) IBOutlet UIScrollView *canvasWindow;

/*Actions*/
- (IBAction)addNewNoteButton:(id)sender;
- (IBAction)backButton:(id)sender;

/*States*/
@property (readwrite) BOOL editingANote;
@property (readwrite) Note *noteBeingEdited;

/*Properties*/
@property (readwrite) CADisplayLink *displayLink;
@property (readwrite) ChipmunkSpace *space;
@property (readwrite) NSMutableArray *notesArray;
@property (readwrite) UIView *canvas;
// Data from another view controller's summoning of this view controller.
@property (readwrite) double requestedCanvasWidth;
@property (readwrite) double requestedCanvasHeight;


/*Gesture Recognizer Methods*/

-(void)notePanResponse:(UIPanGestureRecognizer*)recognizer;
// EFFECTS: Executes what a note is supposed to do during panning.

-(void)noteDoubleTapResponse:(UITapGestureRecognizer*)recognizer;
// EFFECTS: Executes what a note is supposed to do when the button at the bottom left of the note is double tapped.

- (void)singleTapResponse:(UITapGestureRecognizer *)recognizer;
// EFFECTS: Executes what a single tap is supposed to do.

/*Methods*/


@end
