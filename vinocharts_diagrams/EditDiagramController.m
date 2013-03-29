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

#import "CanvasSettingController.h"

#import "GridView.h"

#import "Constants.h"
#import "ViewHelper.h"


// An object to use as a collision type for the screen border.
// Class objects and strings are easy and convenient to use as collision types.
static NSString *borderType = @"borderType";

@implementation EditDiagramController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(DEBUG) NSLog(@"Requested w & h are %.2f , %.2f", _requestedCanvasWidth, _requestedCanvasHeight);
    
    // Initialise _notesArray
    _notesArray = [[NSMutableArray alloc]init];
    
    // Initialise toolbar that appears when editing notes
    [self createEditNoteToolBar];
    
    // Initialise actual dimensions of canvas.
    // The actual dimensions of the canvas differ from the frame of _canvas when zooming
    // takes place in the _canvasWindow.
    _actualCanvasHeight = _requestedCanvasHeight;
    _actualCanvasWidth = _requestedCanvasWidth;
    /*TODO see if you can delete requestedcanvaswidth and requestedcanvasheight.
     And replace them with actualcanvaswidth and actualcanvasheight.*/
    
    // Initialise _canvasWindow
//    CGSize easelSize = CGSizeMake(_requestedCanvasWidth+EASEL_BORDER_CANVAS_BORDER_OFFSET*2.0, _requestedCanvasHeight+EASEL_BORDER_CANVAS_BORDER_OFFSET*2.0);
//    [_canvasWindow setContentSize:easelSize];
    
    [_canvasWindow setBackgroundColor:[UIColor grayColor]];
    // Zooming
    [_canvasWindow setDelegate:self];
    [_canvasWindow setMaximumZoomScale:2.0];
    [_canvasWindow setMinimumZoomScale:0.1];
    [_canvasWindow setClipsToBounds:YES];
    //Memorise original canvasWindow height.
    _canvasWindowOrigHeight = _canvasWindow.frame.size.height;
    
    // Initialise _canvas
//    _canvas = [[UIView alloc]initWithFrame:CGRectMake(EASEL_BORDER_CANVAS_BORDER_OFFSET,
//                                                     EASEL_BORDER_CANVAS_BORDER_OFFSET,
//                                                      _requestedCanvasWidth,
//                                                      _requestedCanvasHeight)];
    //todo clear up the initialisation of canvaswindow. Namely, decide on whether setting content insets is good anot.
    _canvas = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                      0,
                                                      _requestedCanvasWidth,
                                                      _requestedCanvasHeight)];
    
    [_canvasWindow setContentSize:_canvas.frame.size];
    [_canvasWindow setContentInset:UIEdgeInsetsMake(EASEL_BORDER_CANVAS_BORDER_OFFSET,
                                                    EASEL_BORDER_CANVAS_BORDER_OFFSET,
                                                    EASEL_BORDER_CANVAS_BORDER_OFFSET,
                                                    EASEL_BORDER_CANVAS_BORDER_OFFSET)];
    
    [_canvas setBackgroundColor:[UIColor whiteColor]];
    [_canvasWindow addSubview:_canvas];
    
    
    // Initialise states
    _editingANote = NO;
    _noteBeingEdited = nil;
    _snapToGridEnabled = NO;
    
    // Initialise _space (Chipmunk physics space)
    _space = [[ChipmunkSpace alloc] init];
    [_space addBounds:_canvas.bounds
            thickness:100000.0f elasticity:0.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    [_space setGravity:cpv(0, 0)];
    
    // Initialise gridView
        //gridView is initialised by pressing the snap to grid button.
    
    // Attach gesture recognizers
    UITapGestureRecognizer *singleTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapResponse:)];
    [_canvasWindow addGestureRecognizer:singleTapRecog];
    
}

// =============== Segues ==================
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CanvasSettingController"]) {
        _currentPopoverSegue = (UIStoryboardPopoverSegue *)segue; // Will be used in dismissing this popover.
        _canvasSettingController = [segue destinationViewController];
        [_canvasSettingController setDelegate:self]; //Set delegate. IMPORTANT!
        // Initialise popover view's information.
        NSString *currCanvasW = [NSString stringWithFormat:@"%.2f",_actualCanvasWidth];
        NSString *currCanvasH = [NSString stringWithFormat:@"%.2f",_actualCanvasHeight];
        _canvasSettingController.widthDisplay.text = currCanvasW;
        _canvasSettingController.heightDisplay.text = currCanvasH;
    }
}


// =============== Canvas Settings ==================

// CanvasSettingControllerDelegate callback function
- (void)CanvasSettingControllerDelegateOkButton:(double)newWidth :(double)newHeight{
    
    // Display alert.
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Canvas settings successfully changed.\nWidth:%.2f Height:%.2f",newWidth,newHeight]
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    
    // Update actual canvas height and width.
    _actualCanvasHeight = newHeight;
    _actualCanvasWidth = newWidth;
    
    // Modify _canvas.
    [_canvas setFrame:CGRectMake(_canvas.frame.origin.x,
                                _canvas.frame.origin.y,
                                 _actualCanvasWidth*[_canvasWindow zoomScale],
                                 _actualCanvasHeight*[_canvasWindow zoomScale])];
    
    // Remove all notes from space.
    for (int i =0; i < _notesArray.count; i++) {
        [_space remove:[ _notesArray objectAtIndex:i]];
    }
    
    // Modify _space. (Destroy and make anew);
    _space = nil;
    _space = [[ChipmunkSpace alloc] init];
    [_space addBounds:_canvas.bounds
            thickness:100000.0f elasticity:0.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    [_space setGravity:cpv(0, 0)];
    
    // Add notes to new space.
    for (int i =0; i < _notesArray.count; i++) {
        [_space add:[ _notesArray objectAtIndex:i]];
    }
    
    // Redraw grid
    if (_snapToGridEnabled) {
        [self gridSnappingButton:nil];
        [self gridSnappingButton:nil];
    }
    
    [[_currentPopoverSegue popoverController] dismissPopoverAnimated: YES]; // dismiss the popover.
}

// CanvasSettingControllerDelegate callback function
- (void)CanvasSettingControllerDelegateCancelButton{
    [[_currentPopoverSegue popoverController] dismissPopoverAnimated: YES]; // dismiss the popover.
}


// =============== Gesture Recognizer methods ===============

-(void)notePanResponse:(UIPanGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _canvasWindow.scrollEnabled = NO; //Disable scrolling
        [_space remove:((Note*)((UITextView*)recognizer.view).delegate)]; //Remove note from space
        ((UITextView*)recognizer.view).alpha = 0.5; //Dim note's appearance.
        [_canvas bringSubviewToFront:((UITextView*)recognizer.view)]; //Give illusion of lifting note up from canvas.
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
        ((UITextView*)recognizer.view).alpha = 1; //Un-dim note's appearance.
    }
}

-(void)noteDoubleTapResponse:(UITapGestureRecognizer*)recognizer {
    [((UITextView*)(recognizer.view.superview)) setEditable:YES];
    //Summon keyboard.
    [((UITextView*)(recognizer.view.superview)) becomeFirstResponder];
    //Adjusting states below. These states are kept for programmatically dismissing the keyboard.
    _editingANote = YES;
    _noteBeingEdited = ((Note*)((UITextView*)(recognizer.view.superview)).delegate);
    
    //Move _canvasWindow to show the note being edited. _canvasWindow is resized.
    _canvasWindow.frame=CGRectMake(_canvasWindow.frame.origin.x, _canvasWindow.frame.origin.y, _canvasWindow.frame.size.width, 400);
    CGRect rc = [_noteBeingEdited.textView convertRect:CGRectMake(0, 0, _noteBeingEdited.textView.frame.size.width, _noteBeingEdited.textView.frame.size.height) toView:_canvasWindow];
    [_canvasWindow scrollRectToVisible:rc animated:YES];
    
    //Show tool bar related to editing notes.
    [self.view addSubview:_editNoteToolBar];
}

- (void)singleTapResponse:(UITapGestureRecognizer *)recognizer {
    if (_editingANote)
    {
        [self.view endEditing:YES];
        _editingANote = NO;
        [_noteBeingEdited.textView setEditable:NO];
        _noteBeingEdited = nil;
        
        //Reinstate _canvasWindow to original size
        _canvasWindow.frame=CGRectMake(_canvasWindow.frame.origin.x, _canvasWindow.frame.origin.y, _canvasWindow.frame.size.width, _canvasWindowOrigHeight);
        
        //Hide tool bar related to editing notes
        [_editNoteToolBar removeFromSuperview];
    }
}

// =============== Toolbar buttons ===============

- (IBAction)addNewNoteButton:(id)sender {
    
    // Limit the max number of notes a canvas can have.
    if (_notesArray.count > CANVAS_NOTE_COUNT_LIM) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Cannot exceed %d notes on one diagram.",CANVAS_NOTE_COUNT_LIM]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:(BOOL)NO afterDelay:0.0f];
        return; //terminate adding new note
    }
    
    Note *newN = [[Note alloc]initWithText:@"new"];
    
    // Determine coordinates of new note
    CGPoint centerOfNewNote = [_canvas convertPoint:CGPointMake(_canvasWindow.contentOffset.x+_canvasWindow.center.x, _canvasWindow.contentOffset.y+_canvasWindow.center.y) fromView:_canvasWindow];
    newN.body.pos = centerOfNewNote; // Give coordinates to body ONLY.
    newN.textView.backgroundColor = [UIColor brownColor]; //Give color
    
    /*Attach gesture recognizers*/
    
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(notePanResponse:)];
    [newN.textView addGestureRecognizer:panRecog];
    
    UITapGestureRecognizer *doubleTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteDoubleTapResponse:)];
    doubleTapRecog.numberOfTapsRequired = 2;
    [newN.editView addGestureRecognizer:doubleTapRecog];
    [newN.editView setUserInteractionEnabled:YES];
    
    [_notesArray addObject:(Note*)newN]; // Stored in property
    [_canvas addSubview:newN.textView]; // Visible to user
    [_space add:newN]; // Visible to physics engine
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)resetZoomButton:(id)sender {
    if (DEBUG) {
        NSLog(@"_canvasWindow's zoomscale (before): %.2f",[_canvasWindow zoomScale]);
    }
    [_canvasWindow setZoomScale:1];
    if (DEBUG) {
        NSLog(@"_canvasWindow's zoomscale (after): %.2f",[_canvasWindow zoomScale]);
    }
}

- (IBAction)gridSnappingButton:(id)sender {
    // Toggles snapping to grid feature.
    if (_snapToGridEnabled) {
        [_grid removeFromSuperview]; //hide.
        _snapToGridEnabled = NO; //toggle.
    }
    else {
        _grid = [[GridView alloc]initWithFrame:CGRectMake(0, 0, _actualCanvasWidth, _actualCanvasHeight) Step:10 LineColor:[UIColor greenColor]];
        [_canvas addSubview:_grid]; //Show.
        [_canvas sendSubviewToBack:_grid]; //Don't block notes.
        _snapToGridEnabled = YES; //Toggle.
    }
}


// =============== Edit Note Tool Bar ===============
-(void)createEditNoteToolBar{
    _editNoteToolBar = [[UIToolbar alloc]init];
    _editNoteToolBar.frame = CGRectMake(0, 0, 1024, 44);
    //create buttons
    //TODO enhance intuitivity of symbols on buttons.
    //TODO better editing capabilities. Currently is naive.
    UIBarButtonItem *boldButton = [[UIBarButtonItem alloc]initWithTitle:@"Bold" style:UIBarButtonItemStyleBordered target:self action:@selector(boldText:)];
    UIBarButtonItem *italicsButton = [[UIBarButtonItem alloc]initWithTitle:@"Italics" style:UIBarButtonItemStyleBordered target:self action:@selector(italicizeText:)];
    UIBarButtonItem *underlineButton = [[UIBarButtonItem alloc]initWithTitle:@"Underline" style:UIBarButtonItemStyleBordered target:self action:@selector(underlineText:)];
    UIBarButtonItem *fontButton = [[UIBarButtonItem alloc]initWithTitle:@"Font" style:UIBarButtonItemStyleBordered target:self action:@selector(changeFont:)];
    UIBarButtonItem *textColorButton = [[UIBarButtonItem alloc]initWithTitle:@"Text Color" style:UIBarButtonItemStyleBordered target:self action:@selector(changeTextColor:)];
    UIBarButtonItem *noteColorButton = [[UIBarButtonItem alloc]initWithTitle:@"Note Color" style:UIBarButtonItemStyleBordered target:self action:@selector(changeNoteColor:)];
    UIBarButtonItem *deleteNoteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteNote:)];
    //Put buttons in an array
    NSArray *buttonArr = [NSArray arrayWithObjects:boldButton,italicsButton,underlineButton,fontButton,textColorButton,noteColorButton,deleteNoteButton, nil];
    //Add the array of buttons into toolbar
    [_editNoteToolBar setItems:buttonArr animated:NO];
}

- (IBAction)boldText:(id)sender{
    _noteBeingEdited.textView.font = [UIFont boldSystemFontOfSize:12];
}

- (IBAction)italicizeText:(id)sender{
    
}

- (IBAction)underlineText:(id)sender{
    
}

- (IBAction)changeFont:(id)sender{
    
}

- (IBAction)changeTextColor:(id)sender{
    
}

- (IBAction)changeNoteColor:(id)sender{
    
}

- (IBAction)deleteNote:(id)sender{
    
    [_noteBeingEdited.textView setUserInteractionEnabled:NO]; // for safety reasons.
    [_noteBeingEdited.textView removeFromSuperview];
    [_space remove:_noteBeingEdited];
    [_notesArray removeObjectIdenticalTo:_noteBeingEdited];
    
    [self.view endEditing:YES];
    _editingANote = NO;
    _noteBeingEdited = nil;
    
    //Reinstate _canvasWindow to original size
    _canvasWindow.frame=CGRectMake(_canvasWindow.frame.origin.x, _canvasWindow.frame.origin.y, _canvasWindow.frame.size.width, _canvasWindowOrigHeight);
    
    //Hide tool bar related to editing notes
    [_editNoteToolBar removeFromSuperview];
}

// =============== Chipmunk Physics Engine Stuff ===============

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


// =============== Orientation of this view controller ===============

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

// =============== UIScrollView delegate method ===============
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    NSLog(@"seag");
    return _canvas;
}


// =============== DON'T CARE BELOW THIS LINE ===============

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
