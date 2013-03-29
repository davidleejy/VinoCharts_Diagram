//
//  Note.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define DBG_NOTE_CLASS 0

#import "Note.h"
#import "Constants.h"
#import "ViewHelper.h"

@implementation Note

-(void)updatePos {
    //Updating
    _textView.transform = _body.affineTransform;
    
    // Correcting velocity
    if (cpvlength(_body.vel)>0 && cpvlength(_body.vel)<5) {
        _body.vel = cpv(0,0);
    }
    else {
        _body.vel = cpvmult(_body.vel,0.5); //dampening velocity
    }
    
    // dampening angle
    _body.angVel *=0.5;
    // Correcting angle
    
    if (_body.angle >0.1 && fabs(_body.angVel)<0.3) {
        _body.angVel = -0.4;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (_body.angle <-0.1 && fabs(_body.angVel)<0.3) {
        _body.angVel = 0.4;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (_body.angle >0.001 && fabs(_body.angVel)<0.4) {
        _body.angVel = -0.1;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (_body.angle <-0.001 && fabs(_body.angVel)<0.4){
        _body.angVel = 0.1;
        if (DBG_NOTE_CLASS) NSLog(@"DBG_NOTE_CLASS updatePos() is correcting angle");
    }
    else if (fabs(_body.angle) <= 0.001 && fabs(_body.angVel)<0.3){
        _body.angVel *= 0.5;
        if (fabs(_body.angVel)<0.1)
            _body.angVel = 0.0;
    }
    
}

-(id)initWithText:(NSString*)t{
    
    if(self = [super init]){
        
        _textView = [[UITextView alloc]init];
        [_textView setText:t];
        [_textView setDelegate:self];
        [_textView setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        
        //Set states
        _beingPanned = NO;
        
        //Resize frame's dimensions to fit NOTE_CONTENT_CHAR_LIM number of chars.
        _textView.bounds = CGRectMake(0, 0, NOTE_DEFAULT_WIDTH ,NOTE_DEFAULT_HEIGHT);
		        
        _textView.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, NOTE_DEFAULT_WIDTH, NOTE_DEFAULT_HEIGHT);
        
        [_textView setEditable:NO]; //since we're using a button to make this note editable.
        
        //Attach a button to the _textview so that the user can click on it to edit this view.
        _editView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tri.jpg"]];
        _editView.frame = CGRectMake(0, NOTE_DEFAULT_HEIGHT-20, 20, 20);
        [_textView addSubview:_editView];
        
        //Initialise frameOriginIndicator
        _frameOriginIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_on_top_left.jpg"]];
        _frameOriginIndicator.frame = CGRectMake(0, 0, 20, 20);
        
		// Set up Chipmunk objects.
		cpFloat mass = 50;
		
		// The moment of inertia is like the rotational mass of an object.
		// Chipmunk provides a number of helper functions to help you estimate the moment of inertia.
		cpFloat moment = cpMomentForBox(mass, NOTE_DEFAULT_WIDTH, NOTE_DEFAULT_HEIGHT);
        
		
		// A rigid body is the basic skeleton you attach joints and collision shapes too.
		// Rigid bodies hold the physical properties of an object such as the postion, rotation, and mass of an object.
		// You attach collision shapes to rigid bodies to define their shape and allow them to collide with other objects,
		// and you can attach joints between rigid bodies to connect them together.
		_body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
		_body.pos = cpv(0, 0);
        

        
		// Chipmunk supports a number of collision shape types. See the documentation for more information.
		// Because we are storing this into a local variable instead of an instance variable, we can use the autorelease constructor.
		// We'll let the chipmunkObjects NSSet hold onto the reference for us.
		ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:_body width:NOTE_DEFAULT_WIDTH height:NOTE_DEFAULT_HEIGHT];
		
		// The elasticity of a shape controls how bouncy it is.
		shape.elasticity = 1.0f;
		// The friction propertry should be self explanatory. Friction values go from 0 and up- they can be higher than 1f.
		shape.friction = 0.2f;
		
		// Set the collision type to a unique value (the class object works well)
		// This type is used as a key later when setting up callbacks.
		shape.collisionType = [Note class];
		
		// Set data to point back to this object.
		// That way you can get a reference to this object from the shape when you are in a callback.
		shape.data = self;
		
		// Keep in mind that you can attach multiple collision shapes to each rigid body, and that each shape can have
		// unique properties. You can make the player's head have a different collision type for instance. This is useful
        // for brain damage.
		
		// Now we just need to initialize the instance variable for the chipmunkObjects property.
		// ChipmunkObjectFlatten() is an easy way to build this set. You can pass any object to it that
		// implements the ChipmunkObject protocol and not just primitive types like bodies and shapes.
		
		// Notice that we didn't even have to keep a reference to 'shape'. It was created using the autorelease convenience function.
		// This means that the chipmunkObjects NSSet will manage the memory for us. No need to worry about forgetting to call
		// release later when you're using Objective-Chipmunk!
		
		// Note the nil terminator at the end! (this is how it knows you are done listing objects)
		_chipmunkObjects = [[NSArray alloc] initWithObjects:_body, shape, nil];
	}
	
	return self;
    
}


-(void)showFrameOriginIndicator{
    [_textView addSubview:_frameOriginIndicator];
}


-(void)hideFrameOriginIndicator{
    [_frameOriginIndicator removeFromSuperview];
}


/******* UITextViewDelegate methods below *******/

/*
** The delegate method below concerns editing of the text in a UITextView.
** Character limits are enforced here.
*/
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = [textView.text length]+[text length] - range.length;
    if (newLength > NOTE_CONTENT_CHAR_LIM) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Cannot exceed %d characters.",NOTE_CONTENT_CHAR_LIM]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:(BOOL)NO afterDelay:0.0f];
        
        return NO;
    }
    else
        return YES;
}

@end
