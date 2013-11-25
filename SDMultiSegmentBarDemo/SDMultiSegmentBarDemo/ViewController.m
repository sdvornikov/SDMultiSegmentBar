//
//  ViewController.m
//  SDMultiSegmentBarDemo
//
//  Created by Sergey on 25/11/2013.
//  Copyright (c) 2013 Sergey Dvornikov. All rights reserved.
//

#import "ViewController.h"
#import "SDMultiSegmentBar.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SDMultiSegmentBar *multiSegmentBar;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.multiSegmentBar.progressSegmentColors = @[[UIColor redColor],[UIColor greenColor],[UIColor yellowColor]];
    self.multiSegmentBar.progressSegments = @[@0.1,@0.3,@0.07];
    self.multiSegmentBar.markPosition = 0.47;
}


@end
