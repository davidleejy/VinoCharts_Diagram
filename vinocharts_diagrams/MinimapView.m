//
//  MinimapController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/30/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MinimapView.h"
#import "ViewHelper.h"
#import "FramingLinesView.h"
#import "Note.h"

@implementation MinimapView


- (id)initWithMinimapDisplayFrame:(CGRect)frame MapOf:(UIView*)canvas PopulateWith:(NSMutableArray*)notesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Create the map.
        _terrain = [[UIView alloc]initWithFrame:canvas.bounds];
        [_terrain setBackgroundColor:canvas.backgroundColor];
        
        // Create the minimapDisplay.
        [self setBackgroundColor:[ViewHelper invColorOf:canvas.backgroundColor]];
        _minimapDisplay = [[UIView alloc]initWithFrame:CGRectMake(500, 0, 200, 200)]; //TODO change
        [_minimapDisplay setBackgroundColor:[ViewHelper invColorOf:canvas.backgroundColor]];
        
        //Fit map into minimapDisplay.
//        double scaleFactor;
//        if (_map.frame.size.width >= _map.frame.size.height) {
//            scaleFactor =  _minimapDisplay.frame.size.width /_map.frame.size.width;
//        }
//        else{
//            scaleFactor =  _minimapDisplay.frame.size.height/_map.frame.size.height;
//        }
        double scaleFactor;
        if (_terrain.frame.size.width >= _terrain.frame.size.height) {
            scaleFactor =  self.frame.size.width /_terrain.frame.size.width;
        }
        else{
            scaleFactor =  self.frame.size.height/_terrain.frame.size.height;
        }
        
        _terrain.transform = CGAffineTransformScale(_terrain.transform, scaleFactor, scaleFactor);
        _terrain.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
//        [DebugHelper printCGRect:_minimap2.bounds :@"minimap2 bounds"];
//        [DebugHelper printCGRect:_minimap2.frame :@"minimap2 frame"];
        [self addSubview:_terrain];
//        [DebugHelper printCGRect:_minimap2.frame :@"minimap2 frame aft"];
        //    [self.view addSubview:_minimap2];
        
        
        
        //Populate map.
        _notesArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < notesArray.count; i++) {
            // Set frame of new citizen.
            UIView *newCitizen = [[UIView alloc]initWithFrame:((Note*)[notesArray objectAtIndex:i]).textView.frame];
            // Set color of new citizen.
            [newCitizen setBackgroundColor:((Note*)[notesArray objectAtIndex:i]).textView.backgroundColor];
            // Show citizen on map.
            [_terrain addSubview:newCitizen];
            // Keep citizen in property.
            [_notesArray addObject:newCitizen];
        }
        
        
        // Initialise screen tracker
        _screenTracker = [[FramingLinesView alloc]initToDemarcateFrame:CGRectMake(0, 0, 1, 1) LineColor:[UIColor redColor] Thickness:30];
        [_screenTracker addTo:_terrain];
        
        
    }
    return self;
}


- (void)setScreenTrackerFrame:(CGRect)screenFrame {
    [_screenTracker setDemarcatedFrame:screenFrame];
}

- (void)removeAllNotes{
    for (int i = _notesArray.count-1; i!=-1; i--) {
        [((UIView*)[_notesArray objectAtIndex:i]) removeFromSuperview];
        [_notesArray removeObjectAtIndex:i];
    }
}


- (void)remakeWith:(NSMutableArray*)notesArray{
    [self removeAllNotes];
    //Populate map.
    for (int i = 0; i < notesArray.count; i++) {
        // Set frame of new citizen.
        UIView *newCitizen = [[UIView alloc]initWithFrame:((Note*)[notesArray objectAtIndex:i]).textView.frame];
        // Set color of new citizen.
        [newCitizen setBackgroundColor:((Note*)[notesArray objectAtIndex:i]).textView.backgroundColor];
        // Show citizen on map.
        [_terrain addSubview:newCitizen];
        // Keep citizen in property.
        [_notesArray addObject:newCitizen];
    }
}


- (void)add:(Note*)n1{
    // Set frame of new citizen.
    UIView *newCitizen = [[UIView alloc]initWithFrame:n1.textView.frame];
    // Set color of new citizen.
    [newCitizen setBackgroundColor:n1.textView.backgroundColor];
    // Show citizen on map.
    [_terrain addSubview:newCitizen];
    // Keep citizen in property.
    [_notesArray addObject:newCitizen];
}



@end
