//
//  SurveyDefaults.m
//  QuantusActive
//
//  Created by Workstation on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyDefaults.h"
#import "Viewport.h"

@interface SurveyDefaults() {
    @private
    UIFont         *H1Font;
    UIFont         *H2Font;
    UIFont         *H3Font;
    UIFont         *textFont;
    UIFont         *controlsFont;
    NSCharacterSet *illegalCharacterSet;
}
@end

@implementation SurveyDefaults

static SurveyDefaults *sharedInstance = nil;

+ (SurveyDefaults *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[SurveyDefaults alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if ((self = [super init])) {
        // Init
        H1Font = [UIFont fontWithName:@"TrebuchetMS" size:40.0];
        H2Font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:26.0];
        H3Font = [UIFont fontWithName:@"TrebuchetMS" size:24.0];
        textFont = [UIFont systemFontOfSize:17.0];
//        controlsFont = [UIFont fontWithName:@"Verdana-Bold" size:23];
        controlsFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
        illegalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"#$%&/\\|{}[]<>+-_^*"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Protocol methods
+ (UIFont *)H1Font
{
    return [self sharedInstance]->H1Font;
}

+ (UIFont *)H2Font
{
    return [self sharedInstance]->H2Font;
}

+ (UIFont *)H3Font
{
    return [self sharedInstance]->H3Font;
}

+ (UIFont *)textFont
{
    return [self sharedInstance]->textFont;
}

+ (UIFont *)controlsFont
{
    return [self sharedInstance]->controlsFont;
}

+ (NSCharacterSet *)illegalCharacterSet
{
    return [self sharedInstance]->illegalCharacterSet;
}

+ (CGRect)interactiveArea
{
    return CGRectMake(0, 256, [Viewport bounds].size.width, [Viewport bounds].size.height - 256);
}

@end
