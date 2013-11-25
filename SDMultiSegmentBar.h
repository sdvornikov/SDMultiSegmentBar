//
//  SDMultiSegmentBar.h
//  Version 0.1
//  Created by Sergey Dvornikov on 9/11/2013.
//

#import <UIKit/UIKit.h>
#import "SDMultiSegmentBarDelegate.h"

@interface SDMultiSegmentBar : UIView
@property (strong,nonatomic) NSArray *progressSegments;         // of NSNumbers with float values
@property (strong,nonatomic) NSArray *progressSegmentColors;    // of UIColors
@property (nonatomic) float markPosition;
@property (weak,nonatomic) id<SDMultiSegmentBarDelegate> delegate;

@end
