//
//  ConstantSumViewController.m
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import "HouseBuyViewController.h"
#import "FBSliderWithGhost.h"
#import "UILabel+Shadow.h"
#import "SurveyDefaults.h"
#import "NSMutableArray+Shuffle.h"

@interface HouseBuyViewController() {
    NSMutableArray *categories;
    NSMutableArray *sliders;
    NSMutableArray *valueLabels;
}

@end

@implementation HouseBuyViewController

- (id)initWithMarshaller:(Marshaller *)marshaller_
{
    if ((self = [super initWithMarshaller:marshaller_])) {
        // Initialization code
        categories = [NSMutableArray arrayWithArray:[marshaller_ items]];
        [categories shuffle];
    }
    return self;
}

- (void)sliderChanged:(FBSliderWithGhost*)slider
{
    CGFloat total = 0;
    for (int i = 0; i < [sliders count]; i++) {        
        FBSliderWithGhost *currentSlider = [sliders objectAtIndex:i];
        UILabel_Shadow *currentLabel = [valueLabels objectAtIndex:i];
        total += currentSlider.value;
        currentLabel.text = [NSString stringWithFormat:@"%d", (int) currentSlider.value];
    }        
    UILabel *totalLabel = valueLabels.lastObject;
    totalLabel.text = [NSString stringWithFormat:@"%d", (int) total];
        
    CGFloat ghost = MAX(0, 100 - total);
    for (FBSliderWithGhost* sl in sliders) {
        sl.ghostValue = sl.value + ghost;
        [sl setNeedsDisplay];
    }            
    
    if ((int) floor(total) == 100) {
        self.hasValidAnswers = YES;
    } else {
        self.hasValidAnswers = NO;
    }
}

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
    
    // Background image
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_housebuy.jpg"]];
    [self.view addSubview:background];
    
    sliders     = [[NSMutableArray alloc] init];
    valueLabels = [[NSMutableArray alloc] init];
    
    int xPos = 150;
    int yPos = 450;
    int sliderOffset = -30;
    int sliderWidth = 768 - (xPos + sliderOffset) * 2;
    int step = 80;
    
    for (int i = 0; i < [categories count]; i++) {
        // label
        UILabel_Shadow *label = [[UILabel_Shadow alloc] init];
        label.text = [categories objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [SurveyDefaults H2Font];
        label.frame = CGRectMake(xPos, yPos + step * i, [label.text sizeWithFont:label.font].width, [label.text sizeWithFont:label.font].height);            
        [self.view addSubview:label];            
        
        // value label
        UILabel_Shadow *valueLabel = [[UILabel_Shadow alloc] init];
        valueLabel.text = @"0";
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [SurveyDefaults H3Font];
        valueLabel.frame = CGRectMake(xPos + sliderWidth, yPos + step * i + label.frame.size.height, [@"000" sizeWithFont:valueLabel.font].width, [@"000" sizeWithFont:valueLabel.font].height);
        [self.view addSubview:valueLabel];            
        [valueLabels addObject:valueLabel];           
        
        // slider
        FBSliderWithGhost *slider = [[FBSliderWithGhost alloc] initWithFrame:CGRectMake(xPos + sliderOffset, yPos + step * i + label.frame.size.height, sliderWidth, 30)];                
        slider.stops = 21;
        slider.minimumValue = 0;
        slider.maximumValue = 100;
        slider.value = 0;        
        slider.ghostValue = 100;
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];  
        [self.view addSubview:slider];             
        [sliders addObject:slider];                      
    }                            
    // total
    UILabel_Shadow *totalLabel = [[UILabel_Shadow alloc] init];
    totalLabel.text = @"Total:   ";
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = [SurveyDefaults H2Font];
    totalLabel.frame = CGRectMake(xPos + sliderWidth, yPos - step, -[totalLabel.text sizeWithFont:totalLabel.font].width, [totalLabel.text sizeWithFont:totalLabel.font].height);        
    
    UILabel_Shadow *valueLabel = [[UILabel_Shadow alloc] init];
    valueLabel.text = @"0";
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [SurveyDefaults H2Font];
    valueLabel.frame = CGRectMake(xPos + sliderWidth, yPos - step, [@"100" sizeWithFont:valueLabel.font].width, [@"100" sizeWithFont:valueLabel.font].height);        
    
    [self.view addSubview:totalLabel];                    
    [self.view addSubview:valueLabel];            
    [valueLabels addObject:valueLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Protocol methods
+ (void)load
{
    [super load];
}

+ (NSUInteger)questionId
{
    return 8;
}

- (void)disableInteractions
{
    for (FBSliderWithGhost *slider in sliders) {
        [slider cancelTrackingWithEvent:nil];
        slider.enabled = NO;
    }
    [super disableInteractions];
}

- (void)enableInteractions
{
    for (FBSliderWithGhost *slider in sliders)
        slider.enabled = YES;
    
    [super enableInteractions];
}

- (BOOL)needsConfirmation
{
    return YES;
}

- (void)collectAnswers
{
    for (NSString *category in categories) {
        FBSliderWithGhost *slider = [sliders objectAtIndex:[categories indexOfObject:category]];
        [self.marshaller pushItem:[[NSNumber numberWithInt:slider.value] stringValue] onCategory:category];
    }
}

@end
