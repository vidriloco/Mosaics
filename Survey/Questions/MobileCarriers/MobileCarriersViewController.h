//
//  MobileCarriersViewController.h
//  QuantusActive
//
//  Created by Alejandro on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionBaseController.h"
#import "SurveyQuestionProtocol.h"
#import "Viewport.h"

@interface MobileCarriersViewController : SurveyQuestionBaseController<SurveyQuestionProtocol> 

- (void) updateCounterWithName:(NSString*)name withCount:(NSString*)count;

- (void) trackBoxCount:(UIView *)carrierBox;
- (void) untrackBoxCount:(UIView *)carrierBox;

@end
