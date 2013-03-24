//
//  TestViewController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TestViewController.h"

#import "Note.h"

#import "Constants.h"
#import "ViewHelper.h"

@interface TestViewController ()

@end

// An object to use as a collision type for the screen border.
// Class objects and strings are easy and convenient to use as collision types.
static NSString *borderType = @"borderType";

@implementation TestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Initialise _scrollView
    [_scrollView setContentSize:CGSizeMake(3000, 1000)];
    [_scrollView setBackgroundColor:[UIColor greenColor]];
    
    // Initialise notesArray
    _notesArray = [[NSMutableArray alloc]init];
    
    _rect1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1000, 400)];
    [_rect1 setBackgroundColor:[UIColor purpleColor]];
    [_scrollView addSubview:_rect1];
    
    // Create and initialize the Chipmunk space.
	// Chipmunk spaces are containers for simulating physics.
	// You add a bunch of objects and joints to the space and the space runs the physics simulation on them all together.
	_space = [[ChipmunkSpace alloc] init];
	
	// This method adds four static line segment shapes to the space.
	// Most 2D physics games end up putting all the gameplay in a box. This method just makes that easy.
	// We'll tag these segment shapes with the borderType object. You'll see what this is for next.
	[_space addBounds:_rect1.bounds
            thickness:1000.0f elasticity:1.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    [_space setGravity:cpv(0, 700)];
    
    NSLog(@"%.5f,%.5f,%.5f,%.5f",_rect1.bounds.origin.x,
          _rect1.bounds.origin.y,
          _rect1.bounds.size.width,
          _rect1.bounds.size.height);
	
	// This adds a callback that happens whenever a shape tagged with the
	// [FallingButton class] object and borderType objects collide.
	// You can use any object you want as a collision type identifier.
	// I often find it convenient to use class objects to define collision types.
	// There are 4 different collision events that you can catch: begin, pre-solve, post-solve and separate.
	// See the documentation for a description of what they are all for.
	[_space addCollisionHandler:self
                         typeA:[Note class] typeB:borderType
                         begin:@selector(beginCollision:space:)
                      preSolve:nil
                     postSolve:nil
                      separate:nil
     ];
	
	
	// You have to actually put things in a Chipmunk space for it to do anything interesting.
	// I've created a game object controller class called FallingButton that makes a UIButton that is influenced by physics.
    _n1 = [[Note alloc]initWithText:STR_WITH_140_CHARS];
	// Add the uitextview to the view hierarchy.
	[_rect1 addSubview:_n1.textView];
    
    
	
	// Adding physics objects in Objective-Chipmunk is a snap thanks to the ChipmunkObject protocol.
	// No matter how many physics objects (collision shapes, joints, etc) the fallingButton has, it can be added in a single line!
	// See FallingButton.m to see how easy it is to implement the protocol.
	[_space add:_n1];

    
    
    //testing uitextview
    UITextView *tv1 = [[UITextView alloc]init];
    tv1.opaque = YES;
    tv1.backgroundColor = [UIColor blackColor];
    [tv1 setText:STR_WITH_140_CHARS];
    [tv1 setTextColor:[UIColor whiteColor]];
    [tv1 setEditable:NO];
    [_scrollView addSubview:tv1];
    
    tv1.frame = CGRectMake(100, 100, 260 ,90);
//    CGRect frame = tv1.frame;
//    frame.size.height = tv1.contentSize.height;
//    tv1.frame = frame;
    
    
    //          Attach gesture recognizers          //
    UITapGestureRecognizer *taprecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapResponse:)];
    [_scrollView addGestureRecognizer:taprecog];
    
    
    //          Setting state                      //
    _editingANote = NO;
    
}

- (IBAction)newNoteButton:(id)sender {
    Note *newN = [[Note alloc]initWithText:@"I am a new note"];
    [_rect1 addSubview:newN.textView];
    [_space add:newN];
    [_notesArray addObject:(Note*)newN];
}

- (IBAction)forceEdit:(id)sender {
    [_n1.textView setEditable:YES];
    [_n1.textView becomeFirstResponder];
    _editingANote = YES;
    _noteBeingEdited = _n1;
}

- (bool)beginCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
	
	NSLog(@"First object in the collision is %@ second object is %@.", buttonShape.data, border.data);
	
    Note *fb = buttonShape.data;
	
	return TRUE; // We return true, so the collision is handled normally.
}


// When the view appears on the screen, start the animation timer and tilt callbacks.
- (void)viewDidAppear:(BOOL)animated {
	// Set up the display link to control the timing of the animation.
	_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
	_displayLink.frameInterval = 1;
	[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

// This method is called each frame to update the scene.
// It is called from the display link every time the screen wants to redraw itself.
- (void)update {
	// Step (simulate) the space based on the time since the last update.
	cpFloat dt = _displayLink.duration*_displayLink.frameInterval;
	[_space step:dt];
	
	// Update the button.
	// This sets the position and rotation of the button to match the rigid body.
	[_n1 updatePos];
    
    double x2 = _n1.textView.frame.origin.x + _n1.textView.frame.size.width;
    double y2 = _n1.textView.frame.origin.y + _n1.textView.frame.size.height;
    [ViewHelper embedMark:CGPointMake(_n1.textView.frame.origin.x, _n1.textView.frame.origin.y) WithColor:[UIColor redColor] DurationSecs:0.1f In:_rect1];
    [ViewHelper embedMark:CGPointMake(x2, _n1.textView.frame.origin.y) WithColor:[UIColor redColor] DurationSecs:0.1f In:_rect1];
    [ViewHelper embedMark:CGPointMake(_n1.textView.frame.origin.x, y2) WithColor:[UIColor redColor] DurationSecs:0.1f In:_rect1];
    [ViewHelper embedMark:CGPointMake(x2, y2) WithColor:[UIColor redColor] DurationSecs:0.1f In:_rect1];
    double bx = _n1.textView.bounds.origin.x;
    double by = _n1.textView.bounds.origin.y;
    double bx2 = bx + _n1.textView.bounds.size.width;
    double by2 = by + _n1.textView.bounds.size.height;
    [ViewHelper embedMark:CGPointMake(bx, by) WithColor:[UIColor whiteColor] DurationSecs:0.1f In:_rect1];
    [ViewHelper embedMark:CGPointMake(bx, by2) WithColor:[UIColor whiteColor] DurationSecs:0.1f In:_rect1];
    [ViewHelper embedMark:CGPointMake(bx2, by) WithColor:[UIColor whiteColor] DurationSecs:0.1f In:_rect1];
    [ViewHelper embedMark:CGPointMake(bx2, by2) WithColor:[UIColor whiteColor] DurationSecs:0.1f In:_rect1];
    
    for (int i = 0; i<_notesArray.count; i++) {
        [[_notesArray objectAtIndex:i]updatePos];
    }
}


- (void)singleTapResponse:(UITapGestureRecognizer *)recognizer {
    NSLog(@"single tap detected");
    if (_editingANote)
    {
        [self.view endEditing:YES];
        _editingANote = NO;
        [_noteBeingEdited.textView setEditable:NO];
        _noteBeingEdited = nil;
    }
}


// The view disappeared. Stop the animation timers and tilt callbacks.
- (void)viewDidDisappear:(BOOL)animated {
	// Remove the timer.
	[_displayLink invalidate];
	_displayLink = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end
