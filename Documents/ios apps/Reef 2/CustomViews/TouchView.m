//
//  TouchView.m
//  Reef
//
//  Created by Ant on 1/22/16.
//  Copyright © 2016 iOSDevStar. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.delegate didDoubleTapZoomableView:self state:true];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate didDoubleTapZoomableView:self state:false];
}

@end
