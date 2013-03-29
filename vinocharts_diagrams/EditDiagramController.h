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
#import "CanvasSettingController.h"
#import "GridView.h"

@interface EditDiagramController : UIViewController <UIScrollViewDelegate, UIPopoverControllerDelegate, CanvasSettingControllerDelegate>

/*Outlets*/
@property (weak, nonatomic) IBOutlet UIScrollView *canvasWindow;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gridSnappingButton;


/*Actions*/
- (IBAction)addNewNoteButton:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)resetZoomButton:(id)sender;
- (IBAction)gridSnappingButton:(id)sender;
- (IBAction)minimapButton:(id)sender;

/*States*/
@property (readwrite) BOOL editingANote;
@property (readwrite) Note *noteBeingEdited;
@property (readwrite) BOOL snapToGridEnabled;




/*Properties*/
@property (readwrite) CADisplayLink *displayLink;
@property (readwrite) ChipmunkSpace *space;
@property (readwrite) NSMutableArray *notesArray;
@property (readwrite) UIView *canvas;

// Toolbar when editing a note
@property (readwrite) UIToolbar *editNoteToolBar;

// Memorise canvasWindow's height. Need this when desummoning keyboarding.
@property (readwrite) double canvasWindowOrigHeight;

// Data from another view controller's summoning of this view controller. Only used ONCE when initialising this view controller.
@property (readwrite) double requestedCanvasWidth;
@property (readwrite) double requestedCanvasHeight;

// Canvas Setting Controller. Popover kind.
@property (readwrite) CanvasSettingController *canvasSettingController;
@property (readwrite) UIStoryboardPopoverSegue *currentPopoverSegue;

// Actual width and height of canvas. Not affected by zooming of _canvasWindow.  _canvasWindow will affect the width and height of _canvas (a UIView* that is attached to a UIScrollView*, _canvasWindow.)
@property (readwrite) double actualCanvasWidth;
@property (readwrite) double actualCanvasHeight;

// Grid
@property (readwrite) GridView *grid;

// Minimap
//TODO
@property (readwrite) UIView *minimap;
@property (readwrite) UIView *minimap2;

/*Gesture Recognizer Methods*/

-(void)notePanResponse:(UIPanGestureRecognizer*)recognizer;
// EFFECTS: Executes what a note is supposed to do during panning.

-(void)noteDoubleTapResponse:(UITapGestureRecognizer*)recognizer;
// EFFECTS: Executes what a note is supposed to do when the button at the bottom left of the note is double tapped.

- (void)singleTapResponse:(UITapGestureRecognizer *)recognizer;
// EFFECTS: Executes what a single tap is supposed to do.

/*Methods*/


@end
