//
//  TestViewController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.view.opaque = YES;
//    self.view.backgroundColor = [UIColor yellowColor];
//    self.textView.opaque = NO;
//    self.textView.backgroundColor = [UIColor clearColor];
//    self.textView.textColor = [UIColor orangeColor];
    
    [_scrollView setContentSize:CGSizeMake(1000, 1000)];
    [_scrollView setBackgroundColor:[UIColor greenColor]];
    
    UITextView *tv1 = [[UITextView alloc]initWithFrame:CGRectMake(100, 100, 150, 150)];
    tv1.opaque = YES;
    tv1.backgroundColor = [UIColor blackColor];
    [tv1 setText:@"helelowginroisfgsoij"];
    [tv1 setTextColor:[UIColor whiteColor]];
    [_scrollView addSubview:tv1];
    
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
