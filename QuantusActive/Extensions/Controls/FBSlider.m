//
//  BetterSlider.m
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import "FBSlider.h"
#import "SurveyDefaults.h"
#define LABEL_SPACING 15

@interface FBSlider() {
    UILabel *minimumValueLabel;
    UILabel *maximumValueLabel;
    float oldValue;
}
@end

@implementation FBSlider
@synthesize useTooltip, stops;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [super addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];                
        self.continuous = YES;                        
        maximumValueLabel = [[UILabel alloc] init];
        maximumValueLabel.backgroundColor = [UIColor clearColor];
        maximumValueLabel.textColor = [UIColor whiteColor];
        maximumValueLabel.font = [SurveyDefaults H3Font];
        maximumValueLabel.hidden = YES;
        [self addSubview:maximumValueLabel];
        
        minimumValueLabel = [[UILabel alloc] init];
        minimumValueLabel.backgroundColor = [UIColor clearColor];
        minimumValueLabel.textColor = [UIColor whiteColor];
        minimumValueLabel.font = [SurveyDefaults H3Font];
        minimumValueLabel.hidden = YES;
        [self addSubview:minimumValueLabel];
    }
    return self;
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    if (oldValue != value) {
        [super setValue:value animated:animated];
        oldValue = value;
    }
}

- (void)sliderChanged
{    
    if (stops > 1) {
        self.value = round((stops - 1) * (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue)) * (self.maximumValue - self.minimumValue) / (stops - 1) + self.minimumValue;            
    }    
}

- (void)setMinimumValueText:(NSString*)text
{
    minimumValueLabel.text = text;
    CGSize textSize = [text sizeWithFont:minimumValueLabel.font];
    minimumValueLabel.frame = CGRectMake(-(textSize.width + LABEL_SPACING), (CGRectGetHeight(self.frame) - textSize.height) / 2.0, textSize.width, textSize.height);
    minimumValueLabel.frame = CGRectIntegral(minimumValueLabel.frame);
    minimumValueLabel.hidden = NO;
}

- (void)setMaximumValueText:(NSString*)text
{
    maximumValueLabel.text = text;
    CGSize textSize = [text sizeWithFont:maximumValueLabel.font];
    maximumValueLabel.frame = CGRectMake(CGRectGetMaxX(self.bounds) + LABEL_SPACING, (CGRectGetHeight(self.frame) - textSize.height) / 2.0, textSize.width, textSize.height);
    maximumValueLabel.frame = CGRectIntegral(maximumValueLabel.frame);
    maximumValueLabel.hidden = NO; 
}

@end
            
