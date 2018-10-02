//
//  EvaluationPanelDelegate.h
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EvaluationPanelDelegate <NSObject>

@required
- (void) prepareEvaluationViewForAppearing:(id)sender;
- (void) commitEvaluationViewAndClear:(id)sender;
@end
