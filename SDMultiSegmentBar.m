//
//  SDMultiSegmentBar.m
//  Version 0.1
//  Created by Sergey Dvornikov on 9/11/2013.
//

#import "SDMultiSegmentBar.h"

@interface SDMultiSegmentBar()

@property (strong,nonatomic) NSMutableArray *privateSegments;

@property (readonly,nonatomic) CGFloat widthScaleFactor;
@property (readonly,nonatomic) CGFloat topOffset;
@property (readonly,nonatomic) CGFloat bottomOffset;
@property (readonly,nonatomic) CGFloat markXPosition;

@property (nonatomic) CGFloat privateMarkPosition;
@property (readonly,nonatomic) UIColor *borderColor;
@property (readonly,nonatomic) UIColor *emptyBarColor;
@property (nonatomic) BOOL touchInProgress;

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
}

- (void)setMarkPosition:(float)markPosition {
    _markPosition = markPosition;
    self.privateMarkPosition = markPosition;
}

- (void)setHideStaticMark:(BOOL)hideStaticMark {
    _hideStaticMark = hideStaticMark;
    [self setNeedsDisplay];
}

- (NSMutableArray *)privateSegments {
    if (!_privateSegments) {
        _privateSegments = [NSMutableArray array];
    }
    return _privateSegments;
}

- (void)setDelegate:(id<SDMultiSegmentBarDelegate>)delegate {
    _delegate = delegate;
    [self setupGertureRecognizer];
}

- (void)setMarkStyle:(SDMultiSegmentBarMarkStyle)markStyle {
    _markStyle = markStyle;
    [self setupGertureRecognizer];
}

- (void)setPrivateMarkPosition:(CGFloat)privateMarkPosition {
    if (privateMarkPosition < 0.0) {
        privateMarkPosition = 0.0;
    }
    if (privateMarkPosition > 1.0) {
        privateMarkPosition = 1.0;
    }
    if (privateMarkPosition == _privateMarkPosition) {
        return;
    }
    _privateMarkPosition = privateMarkPosition;
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
    return self.privateMarkPosition/self.widthScaleFactor + self.bottomOffset;
}

- (UIColor *)borderColor {
    return [UIColor colorWithWhite:0.65 alpha:1];
}

- (UIColor *)emptyBarColor {
    return [UIColor colorWithWhite:0.9 alpha:1];
}

#pragma mark - public methods
- (void)setSegments:(NSArray *)segments {
    CGFloat newMarkPosition = 0;
    for (id segment in segments) {
        if (![segment isKindOfClass:[SDBarSegment class]]) {
            return;
        }
        SDBarSegment *barSegment = (SDBarSegment*)segment;
        newMarkPosition += barSegment.value;
    }
    self.privateMarkPosition = newMarkPosition;
    self.privateSegments = [segments mutableCopy];
    [self setNeedsDisplay];
}

#pragma mark - gesture recognizer
- (void) setupGertureRecognizer {
    self.userInteractionEnabled = NO;
    if (self.markStyle != SDMultiSegmentBarMarkStylePannable)
        return;
    if (![self.delegate respondsToSelector:@selector(annotationTextForMarkPosition:)])
        return;
    self.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.markPosition = self.privateMarkPosition;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat touchx = [[touches anyObject] locationInView:self].x;
    self.touchInProgress = YES;
    self.privateMarkPosition = self.widthScaleFactor * (touchx - self.bottomOffset);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchInProgress = NO;
    self.privateMarkPosition = self.markPosition;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
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
    [self drawAnnotation];
}

- (CGRect) barRectOfWidth:(CGFloat)width startFrom:(CGFloat)start {
    return CGRectMake((start / self.widthScaleFactor)+self.bottomOffset,
                      self.topOffset,
                      (width / self.widthScaleFactor),
                      self.bounds.size.height - self.topOffset - self.bottomOffset);
}

- (void) drawEmptyProgressBar {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[self barRectOfWidth:1 startFrom:0]
                                                    cornerRadius:self.bounds.size.height/6];
    [self.emptyBarColor setFill];
    [path fill];
    [path addClip];
}

- (void) drawProgressBarBorder {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[self barRectOfWidth:1 startFrom:0]
                                                    cornerRadius:self.bounds.size.height/6];
    [self.borderColor setStroke];
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
        [self.borderColor setStroke];
        [mark stroke];
    }
}

- (void) drawProgressSegments {
    CGFloat offset = 0;
    for (SDBarSegment *segment in self.privateSegments) {
        CGFloat segmentWigth = segment.value;
        UIColor *progressSegmentColor = segment.color ? segment.color : [UIColor blueColor];
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
    if (self.markStyle == SDMultiSegmentBarMarkStyleNone)
        return;
    if (self.hideStaticMark && !self.touchInProgress)
        return;
    
    [self.borderColor setStroke];
    [self.borderColor setFill];
    
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
    if (!self.touchInProgress)
        return;
    NSString *annotationText = [self.delegate annotationTextForMarkPosition:self.privateMarkPosition];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Verdana" size:[self topOffset]*0.7],
                                 NSForegroundColorAttributeName: self.borderColor};
    CGSize annotationSize = [annotationText sizeWithAttributes:attributes];
    CGFloat pointX = (self.markXPosition - annotationSize.width/2);
    pointX = pointX < 0.0 ? 0 : pointX;
    pointX = pointX > (self.bounds.size.width - annotationSize.width) ? self.bounds.size.width - annotationSize.width : pointX;
    
    [annotationText drawAtPoint:CGPointMake(pointX, 0) withAttributes:attributes];
}

@end
