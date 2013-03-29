//
//  CanvasSettingController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define DEBUG 1

#import "CanvasSettingController.h"

@implementation CanvasSettingController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButton:(id)sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *w = [f numberFromString:_widthDisplay.text];
    NSNumber *h = [f numberFromString:_heightDisplay.text];
    
    if (DEBUG) {
        NSLog(@"CanvasSettingController okButton width %@ height %@",w,h);
    }
    
    if (w == nil || h == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Width and height must be numbers."]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:(BOOL)NO afterDelay:1.0f];
    }
    else {
        [_delegate CanvasSettingControllerDelegateOkButton:[w doubleValue] :[h doubleValue]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButton:(id)sender {
    [_delegate CanvasSettingControllerDelegateCancelButton];
}

- (void)viewDidUnload {
    [self setWidthDisplay:nil];
    [self setHeightDisplay:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
