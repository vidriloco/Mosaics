//
//  SurveyQuestionViewController.h
//  QuantusActive
//
//  Created by Workstation on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Marshaller.h"
#define kGreetingQuestionId 0
#define kFarewellQuestionId NSIntegerMax

@interface SurveyQuestionBaseController : UIViewController {
    Marshaller *marshaller;
}
@property (nonatomic, readonly) BOOL hasValidAnswers;
@property (nonatomic, strong) Marshaller *marshaller;

+ (NSDictionary *)getRegisteredQuestions;
- (id) initWithMarshaller:(Marshaller*)marshaller;
- (void)disableInteractions;
- (void)enableInteractions;
- (void)reset;
- (BOOL)needsConfirmation;
- (BOOL)canBeReset;
- (BOOL)skipsNavigation;
- (BOOL)collectsAnswers;

// Subscreen management
- (void)presentSubscreenAtIndex:(NSUInteger)index;
- (void)dismissSubscreenAtIndex:(NSUInteger)index;
- (void)presentNextSubscreen;

@end
