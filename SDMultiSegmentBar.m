//
//  SDMultiSegmentBar.m
//  Version 0.1
//  Created by Sergey Dvornikov on 9/11/2013.
//

#import "SDMultiSegmentBar.h"

@interface SDMultiSegmentBar()

@property (readonly,nonatomic) CGFloat widthScaleFactor;
@property (readonly,nonatomic) CGFloat topOffset;
@property (readonly,nonatomic) CGFloat bottomOffset;
@property (readonly,nonatomic) CGFloat markXPosition;
@end

@implementation SDMultiSegmentBar

- (void)awakeFromNib
{
    [self setup];
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.contentMode = UIViewContentModeRedraw;
    
    // test values !!!
    self.progressSegmentColors = @[[UIColor redColor],[UIColor greenColor],[UIColor yellowColor]];
    self.progressSegments = @[@0.1,@0.3,@0.07];
    self.markPosition = 0.47;
}

- (void)setMarkPosition:(float)markPosition {
    if (markPosition == _markPosition) {
        return;
    }
    if (markPosition < 0) {
        _markPosition = 0;
    }
    if (markPosition > 1) {
        _markPosition = 1;
    }
    _markPosition = markPosition;
    [self setNeedsDisplay];
}

- (CGFloat)widthScaleFactor {
    return 1 / (self.bounds.size.width - 2*self.bottomOffset);
}

- (CGFloat)topOffset {
    return self.bounds.size.height/3;
}

- (CGFloat)bottomOffset {           // nnes a better name
    return self.bounds.size.height/7;
}

-(CGFloat)markXPosition {
    return self.markPosition/self.widthScaleFactor + self.bottomOffset;
}
#pragma mark - draw methods

- (void) drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawEmptyProgressBar];    // clips to roundrect
    [self drawProgressSegments];
    [self drawProgressBarBorder];
    CGContextRestoreGState(context);    // unclups
    //[self drawSeporators];
    [self drawMark];
}

- (CGRect) barRectOfWidth:(CGFloat)width startFrom:(CGFloat)start {
    return CGRectMake((start / self.widthScaleFactor)+self.bottomOffset,
                      self.topOffset,
                      (width / self.widthScaleFactor),
                      self.bounds.size.height - self.topOffset - self.bottomOffset);
}

- (void) drawEmptyProgressBar {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[self barRectOfWidth:1 startFrom:0]
                                                    cornerRadius:self.bounds.size.height/5];
    [[UIColor lightGrayColor] setFill];
    [path fill];
    [path addClip];
}

- (void) drawProgressBarBorder {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[self barRectOfWidth:1 startFrom:0]
                                                    cornerRadius:self.bounds.size.height/5];
    [[UIColor darkGrayColor] setStroke];
    [path setLineWidth:2];
    [path stroke];
    [path addClip];
}

- (void) drawSeporators {
    int numOfSepatators = 15;   // test value !!!
    for (int index = 1; index<numOfSepatators - 1; index++) {
        CGFloat separatorX = self.bounds.size.width/(numOfSepatators-1)*index;
        UIBezierPath *mark = [[UIBezierPath alloc] init];
        [mark moveToPoint:CGPointMake(separatorX, 0)];
        [mark addLineToPoint:CGPointMake(separatorX, self.bounds.size.height)];
        [[UIColor darkGrayColor] setStroke];
        [mark stroke];
    }
}

- (void) drawProgressSegments {
    CGFloat offset = 0;
    for (int i=0; i<[self.progressSegments count]; i++) {
        CGFloat segmentWigth = [(NSNumber*)(self.progressSegments[i]) floatValue];
        
        UIColor *progressSegmentColor = [UIColor blueColor];
        if ([self.progressSegmentColors count]>i && [self.progressSegmentColors[i] isKindOfClass:[UIColor class]]) {
            progressSegmentColor = self.progressSegmentColors[i];
        }
        
        [self drawProgressSegmentOfWidth:segmentWigth startFrom:offset whthColor:progressSegmentColor];
        offset += segmentWigth;
    }
}

- (void) drawProgressSegmentOfWidth:(CGFloat)width startFrom:(CGFloat)start whthColor:(UIColor*)color {
    UIBezierPath *segmentPath = [UIBezierPath bezierPathWithRect:[self barRectOfWidth:width startFrom:start]];
    [color setFill];
    [segmentPath fill];
}

- (void) drawMark {
    [[UIColor darkGrayColor] setStroke];
    [[UIColor darkGrayColor] setFill];
    
    UIBezierPath *mark = [[UIBezierPath alloc] init];
    [mark moveToPoint:CGPointMake(self.markXPosition, self.topOffset)];
    [mark addLineToPoint:CGPointMake(self.markXPosition, self.bounds.size.height)];
    [mark stroke];
    
    UIBezierPath *markTriangle = [[UIBezierPath alloc] init];
    [markTriangle moveToPoint:CGPointMake(self.markXPosition, self.bounds.size.height - self.bottomOffset)];
    [markTriangle addLineToPoint:CGPointMake(self.markXPosition+self.bottomOffset, self.bounds.size.height)];
    [markTriangle addLineToPoint:CGPointMake(self.markXPosition-self.bottomOffset, self.bounds.size.height)];
    [markTriangle closePath];
    [markTriangle fill];
}

- (void) drawAnnotation {
    NSString *annotationText = [self.delegate annotationTextForMarkPosition:self.markPosition];
    if (!annotationText) {
        annotationText = [NSString stringWithFormat:@"%f", self.markPosition];  // for testing !!!
    }
}

@end
