//
//  EvaluationPaneView.h
//
//

#import <UIKit/UIKit.h>

#define roundingThreshold 0.80

@interface EvaluationPaneView : UIView {
    UIBezierPath *currentPath;
    int color;
    NSMutableArray *selectedOptions;
}

@property (nonatomic, strong) UIBezierPath *currentPath;
@property (nonatomic, assign) int color;
@property (nonatomic, strong) NSMutableArray *selectedOptions;

- (id)initWithFrame:(CGRect)frame withColor:(int)color_;
- (void) resetPaths;

@end
