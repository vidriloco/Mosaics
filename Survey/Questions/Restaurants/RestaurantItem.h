//
//  RestaurantCategory.h
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Styled.h"
#import "EvaluationPanelDelegate.h"

@class FastFoodPerception;

@interface RestaurantItem : UIView {
    NSString* name;
    id<EvaluationPanelDelegate> delegate;
}

@property (nonatomic, strong) NSString *name; 
@property (nonatomic, strong) id<EvaluationPanelDelegate> delegate;

+ (id) newWithName:(NSString*)name andColor:(int)color;

- (void) startSelectedAnimation;
- (void) startDismissedAnimation;
- (void) startReadyToBeDismissedAnimation;

@end
