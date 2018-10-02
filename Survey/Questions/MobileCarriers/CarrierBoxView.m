//
//  CarrierBoxView.m
//  QuantusActive
//
//  Created by Alejandro on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CarrierBoxView.h"
#import "SoundPlayerPool.h"

#define SIZE                        150
#define FONT_BLINK_DURATION         2
#define VERTICAL_MOVEMENT_DURATION  0.5f
#define FALL_MOVEMENT_DURATION      1
#define INCREMENT_Y                 40

@interface CarrierBoxView()
@property (nonatomic, assign) int maxCount;
@property (nonatomic, assign) float initialYPos;
@property (nonatomic, strong) UILabel *label;
- (void) incrementNumber;
- (void) decrementNumber;
- (void) onNumberChange;
@end

@implementation CarrierBoxView

@synthesize name, maxCount, initialYPos, label, currentCount;


- (id) initWithFrame:(CGRect)frame withBorderWidth:(int)width withRadius:(float)radius
{
    if ((self = [super initWithFrame:frame withBorderWidth:width withRadius:radius])) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SIZE, SIZE)];
        self.label.center = CGPointMake(SIZE/2, SIZE/2);
        self.label.alpha = 0;
        [self.label setTextAlignment:UITextAlignmentCenter];
        [self.label setShadowColor:[UIColor blackColor]];
        [self.label setShadowOffset:CGSizeMake(3, 3)];
        [self.label setTextColor:[UIColor whiteColor]];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:70]];
        [self setCurrentCount:1];
        [self addSubview:self.label];
        self.alpha = 0;
    }
    return  self;
}

+ (CarrierBoxView*) newWithName:(NSString*)name withMaxCount:(int)count
{
    CGRect frame = CGRectMake(100, 100, SIZE, SIZE);
    CarrierBoxView *area = [CarrierBoxView rectangleWithFrame:frame withBorderWidth:5 withCornerRadius:15.0f];
    [area incrementNumber];
    area.name = name;
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]]];
    [area addSubview:logo];
    [area sendSubviewToBack:logo];
    logo.center = CGPointMake(SIZE/2, SIZE/2);
    area.maxCount = count;
    
    UIView *transparent = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, SIZE, SIZE) withBorderWidth:5 withRadius:15.0f];
    [transparent setBackgroundColor:[UIColor clearColor]];
    [area addSubview:transparent];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] 
                                              initWithTarget:area 
                                              action:@selector(decrementNumber)];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [transparent addGestureRecognizer:swipeGestureDown];
    
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] 
                                                  initWithTarget:area 
                                                  action:@selector(incrementNumber)];
    [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [transparent addGestureRecognizer:swipeGestureUp];
    
    return area;
}

- (float) minAlpha
{
    return 0.2f;
}

- (int) initialColor
{
    return 0xF0FFFF;
}

- (void) onNumberChange 
{
    [SoundPlayerPool playFile:@"lego.caf"];
    self.label.alpha = 1;
    [UIView animateWithDuration:FONT_BLINK_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.label.alpha = 0.5
                         ;
                     }
                     completion:nil];
}

- (void) decrementNumber
{
    NSInteger newCount = currentCount-1;
    if (newCount < 0) {
        newCount = 0;
    } else {
        [self onNumberChange];
        float nextPos = initialYPos-(self.frame.size.height+INCREMENT_Y)*newCount;
        
        [self.label setText:[NSString stringWithFormat:@"%d", newCount+1]];
        
        [UIView animateWithDuration:VERTICAL_MOVEMENT_DURATION         
                              delay:0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                         self.center = CGPointMake(self.center.x, nextPos);
                     }
                         completion:nil];
        [self blink];
    }
    [self setCurrentCount:newCount];
}


- (void) incrementNumber
{
    NSInteger newCount = currentCount+1;
    if (newCount > self.maxCount) {
        newCount = self.maxCount;
    } else {
        [self onNumberChange];
        float nextPos = initialYPos-(self.frame.size.height+INCREMENT_Y)*newCount;
    
        [self.label setText:[NSString stringWithFormat:@"%d", newCount+1]];

        [UIView animateWithDuration:VERTICAL_MOVEMENT_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.center = CGPointMake(self.center.x, nextPos);
                     }
                     completion:nil];
        [self blink];
    }
    [self setCurrentCount:newCount];
}

- (void) setInitialCenter:(CGPoint)center
{
    [UIView animateWithDuration:FALL_MOVEMENT_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.alpha = 1;
                         self.center = center;
                     }
                     completion:nil];
    initialYPos = center.y;
}


@end
