//
//  DraggableItem.m
//  QuantusActive
//
//  Created by Alejandro on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DraggableItem.h"

#define ITEM_ORIGIN         CGPointMake(384, 960)
#define ROTATE_DURATION     1
#define FADEOUT_DURATION    1.5f
#define TRANSLATE_DURATION  0.3f

@implementation DraggableItem
@synthesize name, currentSensor, dropped;

- (id) initWithImage:(UIImage *)anImage
{
    if((self=[super initWithImage:anImage]))
    {
        self.dropped = NO;
        self.currentSensor = NULL;
    }
    return self;
}

+ (DraggableItem*) newWithName:(NSString*)name
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]];
    DraggableItem *football = [[DraggableItem alloc] initWithImage:image];
    [football setName:name];
    [football setCenter:ITEM_ORIGIN];
    return football;
}

- (void) changeDroppedStatusToDropped {
    [self setDropped:YES];
    [self removeFromSuperview];
    [self.currentSensor hoverOut:nil];
}

- (void) droppedWithAnimation;
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);

    [UIView animateWithDuration:FADEOUT_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:TRANSLATE_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.center = [currentSensor center]; 
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:ROTATE_DURATION         
                                               delay:0
                                             options:UIViewAnimationCurveLinear
                                          animations:^{
                                              self.transform = transform;
                                          }
                                          completion:^(BOOL finished) {
                                              [self changeDroppedStatusToDropped];
                                          }];
                     }];
}

@end
