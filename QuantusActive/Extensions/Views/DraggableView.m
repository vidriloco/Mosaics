//
//  DraggableView.m
//  QuantusActive
//
//  Created by Remote on 26/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DraggableView.h"
#define CONSTRAIN(val, min_val, max_val) MIN(max_val, MAX(min_val, val))
#define ANIMATION_DURATION 0.5

@interface DraggableView() {
    CGPoint touchOffset;
}
@end

@implementation DraggableView
@synthesize delegate, targetArea;

- (id)initWithImage:(UIImage *)image
{
    if ((self = [super init])) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        self.bounds = imageView.bounds;        
        [self addSubview:imageView];
    }
    return self;
}

// Clamp to integer coords for sharp drawing
- (void)setCenter:(CGPoint)newCenter
{
    [super setCenter:newCenter];
    self.frame = CGRectIntegral(self.frame);
}

- (void)setCenter:(CGPoint)center animated:(BOOL)animated
{
    if (!animated) {
        [self setCenter:center];
        return;
    }
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [self setCenter:center];
                        } completion:^(BOOL finished) {
                            
                        }];
}

- (void)moveTo:(CGPoint)location
{
    [self.superview bringSubviewToFront:self];
    location = CGPointMake(location.x - touchOffset.x, location.y - touchOffset.y);    
    self.center = location;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{        
    touchOffset = [[touches anyObject] locationInView:self];
    touchOffset = CGPointMake(touchOffset.x - self.bounds.size.width / 2.0f, touchOffset.y - self.bounds.size.height / 2.0f);    
    if ([self.delegate respondsToSelector:@selector(draggableViewWillBeginDragging:)])
        [self.delegate draggableViewWillBeginDragging:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    CGPoint location = [[touches anyObject] locationInView:self.superview];
    [self moveTo:location];
    if ([self.delegate respondsToSelector:@selector(draggableViewDidDrag:)])
        [self.delegate draggableViewDidDrag:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{   
    CGPoint location = [[touches anyObject] locationInView:self.superview];
    location = CGPointMake(location.x - touchOffset.x, location.y - touchOffset.y);  
    if (!CGRectIsEmpty(self.targetArea) && !CGRectContainsPoint(targetArea, location)) {
        location = CGPointMake(CONSTRAIN(location.x, CGRectGetMinX(self.targetArea), CGRectGetMaxX(self.targetArea)),
                               CONSTRAIN(location.y, CGRectGetMinY(self.targetArea), CGRectGetMaxY(self.targetArea)));
        [self setCenter:location animated:YES];
    } else
        self.center = location;
    
    if ([self.delegate respondsToSelector:@selector(draggableViewDidStopDragging:)])
        [self.delegate draggableViewDidStopDragging:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end