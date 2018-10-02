//
//  PerceptionViewController.m
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import "FastFoodViewController.h"
#import "SelectableOption.h"
#import "RestaurantItem.h"
#import "Viewport.h"
#import "NSMutableArray+Shuffle.h"
#import "UIColor+Extras.h"
#import "SoundPlayerPool.h"

#define TRASLATION_ITEM_DURATION    1
#define PANE_APPEARING_DURATION     0.7
#define CATEGORIES_MARGIN_BOTTOM    200
#define CATEGORIES_TOP_HEIGHT       300
#define START_POSITION_FOR_Y        100

@interface FastFoodViewController()
@property (nonatomic, strong) NSEnumerator *itemsSequence;
@property (nonatomic, strong) EvaluationPaneView *evaluationPane;
- (int) randomColor;
@end

@implementation FastFoodViewController

@synthesize itemsSequence, evaluationPane;

- (id) initWithMarshaller:(Marshaller *)marshaller_
{
    if((self=[super initWithMarshaller:marshaller_]))
    {
        CGRect frame = CGRectMake(0, 450, [Viewport bounds].size.width, [Viewport bounds].size.height/2);
        evaluationPane = [[EvaluationPaneView alloc] initWithFrame:frame withColor:[self randomColor]];
        
        NSMutableArray *items = [NSMutableArray arrayWithArray:[self.marshaller items]];
        [items shuffle];
        self.itemsSequence = [items objectEnumerator];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) prepareEvaluationViewForAppearing:(id)sender
{
    [evaluationPane setHidden:NO];
    [UIView animateWithDuration:PANE_APPEARING_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         evaluationPane.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [sender setUserInteractionEnabled:YES];
                     }];
}

- (void) commitEvaluationViewAndClear:(id)sender {
    [self.marshaller setAnswerList:evaluationPane.selectedOptions forCategory:[sender name]];

    [evaluationPane resetPaths];
    [evaluationPane setHidden:YES];
    [UIView animateWithDuration:PANE_APPEARING_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         evaluationPane.alpha = 0;
                     }
                     completion:NULL];
    [self loadNextItemView];
}

- (int) randomColor {
    int colors[6] = { 0xFFFFF, 0xFCAFDD, 0x33CC00, 0x0066FF, 0XFF9900, 0x660066 }; 
    return colors[arc4random()%6];
}

#pragma mark - View lifecycle


- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[Viewport bounds]];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:evaluationPane];
    [evaluationPane setHidden:YES];
    
    [self loadNextItemView];
    
    int posInY= START_POSITION_FOR_Y;
    int posInX= 150;

    for (NSString *categoryName in [self.marshaller categories]) {
        SelectableOption *category = [SelectableOption newWithName:categoryName andCenter:CGPointMake(posInX, posInY)];
        posInY += CATEGORIES_MARGIN_BOTTOM;
        if (posInY > CATEGORIES_TOP_HEIGHT) {
            posInY=START_POSITION_FOR_Y;
            posInX+=300;
        }
        [evaluationPane addSubview:category];
    }
}

- (void) loadNextItemView
{
    [evaluationPane setColor:[self randomColor]];
    NSString *itemNamed = [itemsSequence nextObject];
    if (itemNamed == NULL) {
        self.hasValidAnswers = YES;
        return;
    }
    
    RestaurantItem *item = [RestaurantItem newWithName:itemNamed andColor:[evaluationPane color]];
    float center = self.view.frame.size.width/2;
    item.delegate = self;
    [item setCenter:CGPointMake(arc4random() % (int) [Viewport bounds].size.width, arc4random() % (int) [Viewport bounds].size.height)];
    item.alpha = 0;
    [self.view addSubview:item];
    [SoundPlayerPool playFile:@"propulsion.caf"];
    [UIView animateWithDuration:TRASLATION_ITEM_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         item.alpha = 1;
                         item.center = CGPointMake(center, 500);
                     }
                     completion:^(BOOL finished) {
                         [item startSelectedAnimation];
                     }];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - protocol methods

+ (NSUInteger) questionId
{
    return 9;
}

+ (void)load
{
    [super load];
}

@end
