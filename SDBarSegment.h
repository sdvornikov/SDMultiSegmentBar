//
//  SDBarSegment.h
//  SDMultiSegmentBarDemo
//
//  Created by Sergey on 30/11/2013.
//  Copyright (c) 2013 Sergey Dvornikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDBarSegment : NSObject
- (id) initWithValue:(CGFloat)value color:(UIColor*)color;
+ (SDBarSegment*) barSegmentWithValue:(CGFloat)value color:(UIColor*)color;

@property (readonly,nonatomic) UIColor *color;
@property (readonly,nonatomic) CGFloat value;
@end
