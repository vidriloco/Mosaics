//
//  NewspaperLikertViewController.m
//  Fubu
//
//  Created by Remote on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CyclingViewController.h"
#import "NSMutableArray+Shuffle.h"
#import "UILabel+Shadow.h"
#import "SurveyDefaults.h"
#import "SoundPlayerPool.h"

@interface CyclingViewController() {
    @private
    int currentSlider;
    SliderOptionDisplayBar *displayBar;
    NSMutableArray *sliders;
    NSMutableArray *categories;
}
@end

@implementation CyclingViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{        
    [super loadView];
    categories = [NSMutableArray arrayWithArray:[self.marshaller items]];
    [categories shuffle];
    
    // Answer options
    NSMutableArray *optionList = [NSMutableArray arrayWithArray:[self.marshaller categories]];
    
    // Background image
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cycle_road_background.png"]];
    [self.view addSubview:background];
    
    sliders = [[NSMutableArray alloc] init];
    
    int xPos = 50;
    int yPos = 450;
    int sliderWidth = self.view.bounds.size.width - 150;
    int sliderOffset = (self.view.bounds.size.width - sliderWidth) / 2.0;
    int step = 80;
    
    for (int i = 0; i < [categories count]; ++i) {
        // label
        UILabel_Shadow *label = [[UILabel_Shadow alloc] init];
        label.text = [categories objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [SurveyDefaults H3Font];
        label.frame = CGRectMake(xPos, yPos + step * i, [label.text sizeWithFont:label.font].width, [label.text sizeWithFont:label.font].height);            
        [self.view addSubview:label];            
        
        // slider
        FBSliderWithOptions *slider = [[FBSliderWithOptions alloc] initWithFrame:CGRectMake(sliderOffset, yPos + step * i + label.frame.size.height, sliderWidth, 30)];                            
        slider.enabled = NO;
        [slider useOptions:optionList]; 
        [slider addTarget:self action:@selector(sliderReleased:) forControlEvents:UIControlEventTouchUpInside];      
        [slider addTarget:self action:@selector(sliderReleased:) forControlEvents:UIControlEventTouchUpOutside];      
        [slider addTarget:self action:@selector(sliderChanged:)  forControlEvents:UIControlEventValueChanged]; 
        [self.view addSubview:slider];             
        [sliders addObject:slider];                       
    }         
    displayBar = [[SliderOptionDisplayBar alloc] initWithSlider:((FBSliderWithOptions*) sliders.lastObject)];
    [self.view addSubview:displayBar];
    currentSlider = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FBSliderWithOptions* firstSlider = [sliders objectAtIndex:0];
    [UIView animateWithDuration:2.25
                     animations:^(void) {
                         firstSlider.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [SoundPlayerPool playFile:@"ding.aiff"];
                         firstSlider.enabled = YES;                         
                     }];

    [displayBar performSelector:@selector(floatToView:) withObject:firstSlider afterDelay:2.0];
    [displayBar hilightOption:firstSlider.value - 1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)sliderChanged:(FBSliderWithOptions*)slider
{
    [displayBar hilightOption:(int) (slider.value - 1)];
}

- (void)sliderReleased:(FBSliderWithOptions*)slider
{
    slider.used = YES;
    slider.userInteractionEnabled = NO;
    // Completion
    currentSlider++;
    if (currentSlider < [sliders count]) {
        FBSliderWithOptions* nextSlider = [sliders objectAtIndex:currentSlider];
        nextSlider.enabled = YES;
        [displayBar floatToView:nextSlider];
        [self sliderChanged:nextSlider];
    } else {
        [displayBar floatToPoint:CGPointMake(0, self.view.frame.size.height * 1.25)];
        self.hasValidAnswers = YES;
    }
    
    // Play a sound
    [SoundPlayerPool playFile:@"ding.aiff"];
}

#pragma mark - Protocol methods

+ (NSUInteger)questionId
{
    return 2;
}

+ (void)load
{
    [super load];
}

- (void)collectAnswers
{
    for (NSString *category in categories) {
        FBSliderWithOptions *slider = [sliders objectAtIndex:[categories indexOfObject:category]];
        [self.marshaller pushItem:slider.selectedOption onCategory:category];
    }
}

@end
