//
//  SurveyQuestionSubscreen.m
//  QuantusActive
//
//  Created by Workstation on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyQuestionSubscreen.h"

@implementation SurveyQuestionSubscreen
@synthesize animationOptions, animationStartPosition, animationEndPosition, animationDuration;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.animationStartPosition = self.center;
        self.animationEndPosition   = self.center;
        self.animationOptions       = QuestionSubscreenAnimationOptionNone;
        self.animationDuration      = 0.0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
