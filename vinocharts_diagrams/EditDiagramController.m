//
//  EditDiagramController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define DEBUG 1

#import "EditDiagramController.h"

#import "Note.h"

#import "Constants.h"
#import "ViewHelper.h"


// An object to use as a collision type for the screen border.
// Class objects and strings are easy and convenient to use as collision types.
static NSString *borderType = @"borderType";

@implementation EditDiagramController

- (void)viewDidLoad
{
    [super viewDidLoad]; // Do any additional setup after loading the view.
    
    if(DEBUG) NSLog(@"Requested w & h are %.2f , %.2f", _requestedCanvasWidth, _requestedCanvasHeight);
    
    // Initialise _notesArray
    _notesArray = [[NSMutableArray alloc]init];
    
    // Initialise _canvasWindow
    CGSize easelSize = CGSizeMake(_requestedCanvasWidth+EASEL_BORDER_CANVAS_BORDER_OFFSET*2.0, _requestedCanvasHeight+EASEL_BORDER_CANVAS_BORDER_OFFSET*2.0);
    [_canvasWindow setContentSize:easelSize];
    [_canvasWindow setBackgroundColor:[UIColor grayColor]];
    
    // Initialise _canvas
    _rect1 = [[UIView alloc]initWithFrame:CGRectMake(EASEL_BORDER_CANVAS_BORDER_OFFSET,
                                                     EASEL_BORDER_CANVAS_BORDER_OFFSET, _requestedCanvasWidth, _requestedCanvasHeight)];
    [_rect1 setBackgroundColor:[UIColor whiteColor]];
    [_canvasWindow addSubview:_rect1];
    
    // Initialise states
    _editingANote = NO;
    _noteBeingEdited = nil;
    
    // Initialise _space (Chipmunk physics space)
    _space = [[ChipmunkSpace alloc] init];
    [_space addBounds:_rect1.bounds
            thickness:1000.0f elasticity:0.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    [_space setGravity:cpv(0, 0)];
    
    // Attach gesture recognizers

}


/* ***** Gesture Recognizer methods ****** */

-(void)notePanResponse:(UIPanGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _canvasWindow.scrollEnabled = NO; //Disable scrolling
        [_space remove:((Note*)((UITextView*)recognizer.view).delegate)]; //Remove note from space
    }
    
    cpVect origBodyPos = ((Note*)((UITextView*)recognizer.view).delegate).body.pos;
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    
    // Move only the body. Somehow the view is constantly updated by _displayLink. Wow.
    ((Note*)((UITextView*)recognizer.view).delegate).body.pos = cpv(origBodyPos.x+translation.x,
                                                                    origBodyPos.y+translation.y);
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    
	if(recognizer.state == UIGestureRecognizerStateEnded) {
        _canvasWindow.scrollEnabled = YES; //enable scrolling
        [_space add:((Note*)((UITextView*)recognizer.view).delegate)]; //Re-add note into space
    }
}

/* ***** Toolbar buttons ****** */

- (IBAction)addNewNoteButton:(id)sender {
    
    Note *newN = [[Note alloc]initWithText:@"new"];
    
    // Determine coordinates of new note
    CGPoint centerOfNewNote = [_rect1 convertPoint:CGPointMake(_canvasWindow.contentOffset.x+_canvasWindow.center.x, _canvasWindow.contentOffset.y+_canvasWindow.center.y) fromView:_canvasWindow];
    newN.body.pos = centerOfNewNote; // Give coordinates to body ONLY.
    newN.textView.backgroundColor = [UIColor brownColor]; //Give color
    
    //Attach gesture recognizer
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(notePanResponse:)];
    [newN.textView addGestureRecognizer:panRecog];
    
    [_notesArray addObject:(Note*)newN]; // Stored in property
    [_rect1 addSubview:newN.textView]; // Visible to user
    [_space add:newN]; // Visible to physics engine
}

- (IBAction)backButton:(id)sender {
}


/* ***** Chipmunk Physics Engine ****** */

// When the view appears on the screen, start the animation timer and tilt callbacks.
- (void)viewDidAppear:(BOOL)animated {
	// Set up the display link to control the timing of the animation.
	_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
	_displayLink.frameInterval = 1;
	[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// The view disappeared. Stop the animation timers and tilt callbacks.
- (void)viewDidDisappear:(BOOL)animated {
	// Remove the timer.
	[_displayLink invalidate];
	_displayLink = nil;
}

// This method is called each frame to update the scene.
// It is called from the display link every time the screen wants to redraw itself.
- (void)update {
	// Step (simulate) the space based on the time since the last update.
	cpFloat dt = _displayLink.duration*_displayLink.frameInterval;
	[_space step:dt];
    
    for (int i = 0; i<_notesArray.count; i++) {
        [[_notesArray objectAtIndex:i]updatePos];
    }
}


/* ***** Orientation of this view controller ****** */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

/* ***** DON'T CARE BELOW THIS LINE ****** */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCanvasWindow:nil];
    [super viewDidUnload];
}

@end
