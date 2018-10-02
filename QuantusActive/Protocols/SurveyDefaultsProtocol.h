//
//  SurveyDefaultsProtocol.h
//  QuantusActive
//
//  Created by Workstation on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SurveyDefaultsProtocol <NSObject>
+ (UIFont *)H1Font;
+ (UIFont *)H2Font;
+ (UIFont *)H3Font;
+ (UIFont *)textFont;
+ (UIFont *)controlsFont;
+ (NSCharacterSet *)illegalCharacterSet;
+ (CGRect)interactiveArea;
@end
