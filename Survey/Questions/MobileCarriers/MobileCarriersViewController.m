//
//  MobileCarriersViewController.m
//  QuantusActive
//
//  Created by Alejandro on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MobileCarriersViewController.h"
#import "UIColor+Extras.h"
#import "CarrierBoxView.h"
#import "UIView+Styled.h"

#define OBSERVED_BOX_ATTR       @"currentCount"

@interface MobileCarriersViewController()
@property (nonatomic, strong) NSMutableDictionary* orderings;
@property (nonatomic, strong) NSMutableArray* observedBoxes;
@end

@implementation MobileCarriersViewController
@synthesize orderings, observedBoxes;

- (id) initWithMarshaller:(Marshaller *)marshaller_ {
    if ((self = [super initWithMarshaller:marshaller_])) {
        self.orderings = [NSMutableDictionary dictionary];
        self.observedBoxes = [NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[Viewport bounds]];
    // Background image
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [self.view addSubview:background];
    
    int xPos=-50;
    int margin=25;
    for (NSString *item in [self.marshaller items]) {
        CarrierBoxView *box = [CarrierBoxView newWithName:item withMaxCount:[self.marshaller items].count-1];
        [self.view addSubview:box];
        
        xPos += box.frame.size.width+margin;
        float yPos = self.view.frame.size.height-box.frame.size.height;
        [box setInitialCenter:CGPointMake(xPos, yPos)];
        [self trackBoxCount:box];
        [self.observedBoxes addObject:box];
    }
    
}

- (void)dealloc {
    
    // remove observers for boxes
    for (CarrierBoxView *box in self.observedBoxes) {
        NSLog(@"Removing observer");
        [self untrackBoxCount:box];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)needsConfirmation
{
    return YES;
}

#pragma mark - protocol methods

+ (NSUInteger) questionId
{
    return 6;
}

+ (void)load
{
    [super load];
}

// Controller Observers

- (void) trackBoxCount:(UIView *)carrierBox
{
    [carrierBox addObserver:self forKeyPath:OBSERVED_BOX_ATTR options:NSKeyValueChangeReplacement context:nil];
}

- (void) untrackBoxCount:(UIView *)carrierBox
{
    [carrierBox removeObserver:self forKeyPath:OBSERVED_BOX_ATTR];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (keyPath == OBSERVED_BOX_ATTR) {
        [self updateCounterWithName:[object name] 
                          withCount:[NSString stringWithFormat:@"%d", [object currentCount]]];
    }
}

// Decider

- (void) updateCounterWithName:(NSString*)name withCount:(NSString*)count
{
    [orderings setObject:count forKey:name];
    self.hasValidAnswers = ([[NSSet setWithArray:[orderings allValues]] count] == [self.marshaller items].count);
    
    if (self.hasValidAnswers) {
        for (NSString *category in [orderings allKeys]) {
            [self.marshaller pushItem:[orderings objectForKey:category] onCategory:category];
        }
    }
}

@end
