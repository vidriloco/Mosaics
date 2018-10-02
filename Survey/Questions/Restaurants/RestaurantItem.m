//
//  RestaurantCategory.m
//
//  This class draws rounded options which upon interaction with the user
//  activates a selection path for the user to select an item so it gets
//  associated with a selectable element.
//
//

#import "RestaurantItem.h"
#import "UIColor+Extras.h"
#import <QuartzCore/QuartzCore.h>
#import "EvaluationPaneView.h"
#import <AVFoundation/AVFoundation.h>
#import "SoundPlayerPool.h"

#define SIZE                            150
#define ANIMATIONS_DURATION             0.8
#define ANIMATIONS_DELAY                0.1

enum Status {
    SELECTED = 1,
    AWAITING_SELECTION = 2,
    DISMISSED = 3
};

@interface RestaurantItem()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation RestaurantItem

@synthesize name, imageView, delegate;

+ (id) newWithName:(NSString *)name andColor:(int)color
{
    RestaurantItem *option = [RestaurantItem circleWithFrame:CGRectMake(0, 0, SIZE, SIZE) withBorderWidth:5];
    [option setName:name];
    [option setBorderAndBackgroundColorWithColor:color];
    NSString *filename = [NSString stringWithFormat:@"%@.png",name];
    [option setImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]]];
    [option.imageView setCenter:option.center];
    [option addSubview:option.imageView];
    return option;
}

- (void) startSelectedAnimation
{
    [SoundPlayerPool playFile:@"drykick.caf"];
    [UIView animateWithDuration:ANIMATIONS_DURATION
                          delay:ANIMATIONS_DELAY
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         self.center = CGPointMake(self.center.x, 300);
                         self.alpha = 1;
                         [delegate prepareEvaluationViewForAppearing:self];
                     } completion:nil];

    [self performSelector:@selector(startReadyToBeDismissedAnimation) withObject:nil afterDelay:10];
}

- (void) startDismissedAnimation
{
    [UIView animateWithDuration:ANIMATIONS_DURATION
                          delay:ANIMATIONS_DELAY
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void) startReadyToBeDismissedAnimation
{
    [UIView animateWithDuration:ANIMATIONS_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.9, 0.9);
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:ANIMATIONS_DURATION
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              self.transform = CGAffineTransformInvert(self.transform);
                                              self.alpha = 0.5;
                                          } completion:^(BOOL finished) {
                                              [self startReadyToBeDismissedAnimation];
                                          }];
                     }];
        
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        UITouch * touch = [touches anyObject];
        if ([touch tapCount] == 1) {
            if (CGRectContainsPoint(self.bounds, [touch locationInView:self])) {
                [delegate commitEvaluationViewAndClear:self];
                [self startDismissedAnimation];
            }
        }
        
    }
}


@end
