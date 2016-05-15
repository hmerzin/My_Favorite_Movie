//
//  TouchView.h
//  Reef
//
//  Created by Ant on 1/22/16.
//  Copyright © 2016 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchViewDelegate <NSObject>

- (void)didDoubleTapZoomableView:(UIView *)zoomableView state:(bool) bStartTap;

@end
@interface TouchView : UIView

@property (nonatomic, weak) id<TouchViewDelegate> delegate;

@end

