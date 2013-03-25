//
//  NewDiagramController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/25/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDiagramController : UIViewController

/*properties*/
@property (readwrite) double height;
@property (readwrite) double width;

/*Actions*/
- (IBAction)createCanvasButton:(id)sender;

/*Outlets*/
@property (weak, nonatomic) IBOutlet UILabel *heightOutput;
@property (weak, nonatomic) IBOutlet UILabel *widthOutput;


@end
