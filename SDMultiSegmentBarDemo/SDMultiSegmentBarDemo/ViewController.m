//
//  ViewController.m
//  SDMultiSegmentBarDemo
//
//  Created by Sergey on 25/11/2013.
//  Copyright (c) 2013 Sergey Dvornikov. All rights reserved.
//

#import "ViewController.h"
#import "SDMultiSegmentBar.h"

@interface ViewController () <SDMultiSegmentBarDelegate>
@property (weak, nonatomic) IBOutlet SDMultiSegmentBar *multiSegmentBar;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.multiSegmentBar.delegate = self;
    [self.multiSegmentBar setSegments:@[[SDBarSegment barSegmentWithValue:0.1 color:[UIColor redColor]],
                                        [SDBarSegment barSegmentWithValue:0.3 color:[UIColor greenColor]],
                                        [SDBarSegment barSegmentWithValue:0.07 color:[UIColor yellowColor]]]];
    //self.multiSegmentBar.markPosition = 0.47;
    self.multiSegmentBar.markStyle = SDMultiSegmentBarMarkStylePannable;
}

- (NSString*) annotationTextForMarkPosition:(float)position {
    return [NSString stringWithFormat:@"*** %i ***",(int)(position*100)];
}

@end
