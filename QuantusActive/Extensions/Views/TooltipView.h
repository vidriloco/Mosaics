//
//  FBTooltipView.h
//  Fubu
//
//  Created by Remote on 22/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface TooltipView : UIView {
    CGFloat autoHideDelay;
    UILabel *textLabel;
}
@property CGFloat autoHideDelay;
@property (nonatomic, retain) UILabel *textLabel;

+ (id)sharedInstance;
+ (void)show;
+ (void)displayText:(NSString*)text;
+ (void)setAnchorView:(UIView*)anchorView;
+ (void)setAnchorPoint:(CGPoint)anchorPoint;

@end
