//
//  Note.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Note.h"
#import "Constants.h"
#import "ViewHelper.h"

@implementation Note

-(void)updatePos {
    _textView.transform = _body.affineTransform;
}

-(id)initWithText:(NSString*)t{
    
    if(self = [super init]){
        
        _textView = [[UITextView alloc]init];
        [_textView setText:t];
        [_textView setDelegate:self];

        
        //Resize frame's dimensions to fit NOTE_CONTENT_CHAR_LIM number of chars.
//        _textView.frame = CGRectMake(0, 0, NOTE_DEFAULT_WIDTH ,NOTE_DEFAULT_HEIGHT);
        _textView.bounds = CGRectMake(0, 0, NOTE_DEFAULT_WIDTH ,NOTE_DEFAULT_HEIGHT);
        NSLog(@"content size %.5f,%.5f",_textView.contentSize.width,_textView.contentSize.height);
		        
        _textView.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, NOTE_DEFAULT_WIDTH, NOTE_DEFAULT_HEIGHT);
        
        [_textView setEditable:NO];
        
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
//        _body.pos = cpv(NOTE_DEFAULT_WIDTH/2.0, NOTE_DEFAULT_HEIGHT/2.0);
		_body.pos = cpv(200, 200);

        
		// Chipmunk supports a number of collision shape types. See the documentation for more information.
		// Because we are storing this into a local variable instead of an instance variable, we can use the autorelease constructor.
		// We'll let the chipmunkObjects NSSet hold onto the reference for us.
		ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:_body width:NOTE_DEFAULT_WIDTH height:NOTE_DEFAULT_HEIGHT];
		
		// The elasticity of a shape controls how bouncy it is.
		shape.elasticity = 0.45f;
		// The friction propertry should be self explanatory. Friction values go from 0 and up- they can be higher than 1f.
		shape.friction = 0.77f;
		
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


// UITextViewDelegate method
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"#####");
    
    UITouch *touch = [touches anyObject];
    if ([_textView isFirstResponder] && [touch view] != _textView) {
        
        [_textView resignFirstResponder];
    }
    // My comment : If you have several text controls copy/paste/modify a block above and you are DONE!
}

@end
