//
//  SurveyViewController.h
//  QuantusActive
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarViewController.h"
#import "SurveyControlDelegate.h"
#import "SurveyAnswersCommitDelegate.h"

@interface SurveyViewController : UIViewController<SurveyControlDelegate, SurveyAnswersCommitDelegate> {
    
}

@end
