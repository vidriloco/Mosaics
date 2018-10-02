#import "AnswerViewKeys.h"
#import <QuartzCore/QuartzCore.h>

@protocol AnswerOptionViewProtocol
@property (nonatomic, retain) id value;
@property (nonatomic, retain) UIControl *actionLayer;
// The following two methods are called from this answer component answer's view 
// right after the propagation of this visual element has ocurred

/*
 * This method visually selects this component. The visual effect for this 
 * behavior needs to be implemented
 */
- (void) markAsSelected;

/*
 * This method visually DEselects this component. The visual effect for this 
 * behavior needs to be implemented
 */
- (void) markAsDeselected;

/*
 * Retrieves the actual answer value for this visual component
 */
- (id) getAnswerValue;

@end