//
//  SDBarSegment.m
//  SDMultiSegmentBarDemo
//
//  Created by Sergey on 30/11/2013.
//  Copyright (c) 2013 Sergey Dvornikov. All rights reserved.
//

#import "SDBarSegment.h"

@interface SDBarSegment ()
@property (nonatomic) CGFloat value;
@property (strong,nonatomic) UIColor *color;
@end

@implementation SDBarSegment

- (id)initWithValue:(CGFloat)value color:(UIColor *)color {
    self = [super init];
    if (self) {
        self.value = value;
        self.color = color;
    }
    return self;
}

+ (SDBarSegment *)barSegmentWithValue:(CGFloat)value color:(UIColor *)color {
    return [[SDBarSegment alloc] initWithValue:value color:color];
}

@end
