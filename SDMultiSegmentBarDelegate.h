//
//  SDMultiSegmentBarDelegate.h
//  Version 0.1
//  Created by Sergey Dvornikov on 9/11/2013.
//

#import <Foundation/Foundation.h>

@protocol SDMultiSegmentBarDelegate <NSObject>
- (NSString*) annotationTextForMarkPosition:(float)position;
@end
