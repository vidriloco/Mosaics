//
//  EvaluationPaneView.m
//

#import "EvaluationPaneView.h"
#import "UIColor+Extras.h"
#import "SelectableOption.h"

@implementation EvaluationPaneView

@synthesize currentPath, color, selectedOptions;


- (id)initWithFrame:(CGRect)frame withColor:(int)color_
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setColor:color_];
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0];
        self.selectedOptions = [NSMutableArray array];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentPath = [UIBezierPath bezierPath];
    currentPath.lineWidth = 8.0;
    [currentPath moveToPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.currentPath addLineToPoint:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[SelectableOption class]]) {
            
            int widthP = subview.frame.size.width*roundingThreshold; 
            int heightP = subview.frame.size.height*roundingThreshold;
            
            CGPoint middle = subview.center;
            CGPoint leftTop = CGPointMake(subview.frame.origin.x+widthP, subview.frame.origin.y+heightP);
            CGPoint rightTop = CGPointMake(subview.frame.origin.x+subview.frame.size.width-widthP, 
                                          subview.frame.origin.y+heightP);
            CGPoint leftBottom = CGPointMake(subview.frame.origin.x+widthP, 
                                           subview.frame.origin.y+subview.frame.size.height-heightP);
            CGPoint rightBottom = CGPointMake(subview.frame.origin.x+subview.frame.size.width-widthP, 
                                           subview.frame.origin.y+subview.frame.size.height-heightP);
            
            if ([currentPath containsPoint:middle] && ([currentPath containsPoint:leftTop] || [currentPath containsPoint:rightTop] || 
                [currentPath containsPoint:leftBottom] || [currentPath containsPoint:rightBottom])) {
                SelectableOption *optionS = (SelectableOption*) subview;
                [optionS toogleSelectedWithColor:[UIColor colorWithRGB:self.color].CGColor];
                [self.selectedOptions addObject:optionS.text];
            }
        }
    }
    
    [self setCurrentPath:[UIBezierPath bezierPath]];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRGB:self.color] set];
    [self.currentPath stroke];
}

- (void) resetPaths
{
    self.currentPath = nil;
    self.selectedOptions = [NSMutableArray array];
    [self setNeedsDisplay];
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[SelectableOption class]]) {
            SelectableOption *optionS = (SelectableOption*) subview;
            [optionS toogleDeselected];
        }
    }
    
}

@end
