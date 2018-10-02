//
//  DraggableLogo.m
//  Fubu
//
//  Created by Remote on 26/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DraggableLogo.h"
#import "SoundPlayerPool.h"

#define STARTING_POSITION   CGPointMake(384, 960)
#define TARGET_AREA         CGRectMake(60 + 20, 260 + 20, 660 - 40, 660 - 40)
#define CONSTRAIN(val, min_val, max_val) MIN(max_val, MAX(min_val, val))

@interface DraggableLogo() {
    @private
    BOOL placed;
    CGPoint touchOffset;
}
@end

@implementation DraggableLogo
@synthesize delegate, name;

- (void)setup
{
    placed = NO;
    self.userInteractionEnabled = YES;
}

- (id)initWithImage:(UIImage*)image
{
    if ((self = [super initWithImage:image])) {
        [self setup];
    }
    return self;
}

- (void)moveTo:(CGPoint)location
{
    self.center = CGPointMake(location.x - touchOffset.x, location.y - touchOffset.y);    
}

- (void)placeAt:(CGPoint)location
{
    [self floatTo:location];
    if (!placed) {
        placed = YES;
        [self.delegate itemPlaced:self];
    }
    
    // Play a sound
    [SoundPlayerPool playFile:@"drykick.caf"];
}

- (void)floatTo:(CGPoint)location;
{        
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self moveTo:location];
                     }
                     completion:^(BOOL finished){
                         // Align to integral positions
                         self.frame = CGRectIntegral(self.frame);
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.image.size.width, self.image.size.height);
                     }
     ];    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{        
    [self.superview bringSubviewToFront:self];
    touchOffset = [[touches anyObject] locationInView:self];
    touchOffset = CGPointMake(touchOffset.x - self.image.size.width / 2.0f, touchOffset.y - self.image.size.height / 2.0f);    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self.superview bringSubviewToFront:self];
    CGPoint location = [[touches anyObject] locationInView:self.superview];        
    [self moveTo:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{    
    CGPoint location = CGPointZero;
    location = [[touches anyObject] locationInView:self.superview];
    if (CGRectContainsPoint(TARGET_AREA, location)) {            
        [self moveTo:location];
    } else {
        // Limit to area
        if (!placed) {
            touchOffset = CGPointZero;
            [self floatTo:STARTING_POSITION];
            return;
        }
        location = CGPointMake(CONSTRAIN(location.x, CGRectGetMinX(TARGET_AREA), CGRectGetMaxX(TARGET_AREA)),
                               CONSTRAIN(location.y, CGRectGetMinY(TARGET_AREA), CGRectGetMaxY(TARGET_AREA)));     
    }        
    [self placeAt:location];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end
