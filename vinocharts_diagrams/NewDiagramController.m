//
//  NewDiagramController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/25/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NewDiagramController.h"
#import "EditDiagramController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "GridView.h"

@implementation NewDiagramController


- (void)viewDidLoad
{
    [super viewDidLoad]; // Do any additional setup after loading the view.
    
    _height = 600; _width = 600;
    _heightOutput.text = [NSString stringWithFormat:@"%.2f",_height];
    _widthOutput.text = [NSString stringWithFormat:@"%.2f",_width];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"EditDiagramController"]) {
        EditDiagramController *eDC = [segue destinationViewController];
        eDC.requestedCanvasHeight = _height;
        eDC.requestedCanvasWidth = _width;
    }
    
}

/* ***** Orientation ****** */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

/* Don't care about stuff below this line */
/********************************************************************************/

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
    [self setHeightOutput:nil];
    [self setWidthOutput:nil];
    [super viewDidUnload];
}

// Old stuff
- (IBAction)createCanvasButton:(id)sender {
    
    EditDiagramController *eDC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDiagramController"];
    
    eDC.requestedCanvasHeight = _height;
    eDC.requestedCanvasWidth = _width;
    
    // *** Transit to edit diagram scene ***
    
    [self presentViewController:eDC animated:NO completion:nil];
}


@end
