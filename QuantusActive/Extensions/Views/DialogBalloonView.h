#import <UIKit/UIKit.h>

#define kDefaultStrokeColor         [UIColor whiteColor]
#define kDefaultRectColor           [UIColor blackColor]
#define kDefaultStrokeWidth         3.0
#define kDefaultCornerRadius        30.0
#define kDefaultTipLength           40.0

@interface DialogBalloonView : UIView {
    UIColor     *strokeColor;
    UIColor     *rectColor;
    CGFloat     strokeWidth;
    CGFloat     cornerRadius;    
    CGFloat     tipLength;
    UILabel     *textLabel;
}
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat tipLength;
@property (nonatomic, assign) CGPoint emitterPosition;
@property (nonatomic, readonly) UILabel *textLabel;
@end