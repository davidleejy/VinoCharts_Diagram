//
//  NewDiagramController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/25/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GridView;

@interface NewDiagramController : UIViewController

/*properties*/
@property (readwrite) double height;
@property (readwrite) double width;
@property (readwrite) GridView *grid;

/*Actions*/
- (IBAction)createCanvasButton:(id)sender; //NOT CONNECTED. OLD. USING SEGUE NOW.

/*Outlets*/
@property (weak, nonatomic) IBOutlet UILabel *heightOutput;
@property (weak, nonatomic) IBOutlet UILabel *widthOutput;


@end
