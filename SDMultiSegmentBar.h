//
//  SDMultiSegmentBar.h
//  Version 0.1
//  Created by Sergey Dvornikov on 9/11/2013.
//

#import <UIKit/UIKit.h>
#import "SDBarSegment.h"

@protocol SDMultiSegmentBarDelegate <NSObject>
- (NSString*) annotationTextForMarkPosition:(float)position;
@end

typedef NS_ENUM(NSInteger, SDMultiSegmentBarMarkStyle) {
    SDMultiSegmentBarMarkStyleNone,
    SDMultiSegmentBarMarkStyleStatic,
    SDMultiSegmentBarMarkStylePannable,
};

@interface SDMultiSegmentBar : UIView
@property (nonatomic) SDMultiSegmentBarMarkStyle markStyle;
@property (nonatomic) float markPosition;
@property (weak,nonatomic) id<SDMultiSegmentBarDelegate> delegate;

- (void) setSegments:(NSArray*)segments;

@end
