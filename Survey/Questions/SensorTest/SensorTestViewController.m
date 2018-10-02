//
//  SensorTestViewController.m
//  QuantusActive
//
//  Created by Workstation on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SensorTestViewController.h"
#import "SensorView.h"
#import "DraggableView.h"

@interface SensorTestViewController () {
    NSUInteger     tracking;
    DraggableView *draggable;
    UIBezierPath  *circle;
}

@end

@implementation SensorTestViewController

- (void)loadView
{
    [super loadView];
    SensorView *sensor1 = [[SensorView alloc] initWithFrame:CGRectMake(250, 250, 200, 200)];
    sensor1.backgroundColor = [UIColor redColor];
    sensor1.alpha = 0.5;
    sensor1.delegate = self;
    [self.view addSubview:sensor1];
    
    SensorView *sensor2 = [[SensorView alloc] initWithFrame:CGRectMake(350, 350, 200, 200)];
    sensor2.backgroundColor = [UIColor blueColor];
    sensor2.alpha = 0.5;
    sensor2.delegate = self;
    [self.view addSubview:sensor2];
    
    SensorView *sensor3 = [[SensorView alloc] initWithFrame:CGRectMake(450, 550, 100, 100)];
    sensor3.backgroundColor = [UIColor greenColor];
    sensor3.alpha = 0.5;
    sensor3.layer.cornerRadius = 50.0;
    sensor3.delegate = self;
    [self.view addSubview:sensor3];
    
    circle = [UIBezierPath bezierPathWithOvalInRect:sensor3.frame];
    sensor3.hitPath = circle;

    for (int i = 0; i < 4; i++) {
        draggable = [[DraggableView alloc] initWithFrame:CGRectMake(300 + 25 * i, 600 + 25 * i, 75, 75)];
        draggable.backgroundColor = [UIColor grayColor];
        draggable.layer.borderColor = [UIColor whiteColor].CGColor;
        draggable.layer.borderWidth = 3.0f;
        draggable.layer.cornerRadius = 5.0;
        [self.view addSubview:draggable];
        [sensor1 trackView:draggable];
        [sensor2 trackView:draggable];
        [sensor3 trackView:draggable];
    }
    
    tracking = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Delegate methods
- (void)object:(UIView *)object didEnterSensorArea:(UIView *)sensor
{
    object.backgroundColor = sensor.backgroundColor;
    tracking++;

    if (tracking >= 5) {
        object.backgroundColor = [UIColor lightGrayColor];
        self.hasValidAnswers = YES;
    }
}

- (void)object:(UIView *)object didLeaveSensorArea:(UIView *)sensor
{
    object.backgroundColor = [UIColor grayColor];
    tracking--;
}


#pragma mark - Protocol methods

+ (NSUInteger)questionId
{
    return 99;
}

+ (void)load
{
    [super load];
}
@end
