//
//  BanksViewController.m
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BanksViewController.h"
#import "SurveyDefaults.h"
#import "UIView+Styled.h"
#import "DraggableItem.h"
#import "NSMutableArray+Shuffle.h"
#import "BankAgrouperView.h"
#import "SoundPlayerPool.h"
#import "GridGenerator.h"

#define sizeOfCategory      400

@interface BanksViewController()
@property (nonatomic, strong) BankAgrouperView *category;
@property (nonatomic, strong) NSMutableArray *draggableList;
@end

@implementation BanksViewController
@synthesize category, draggableList;

- (id) initWithMarshaller:(Marshaller *)marshaller_
{
    if((self=[super initWithMarshaller:marshaller_])){
        self.draggableList = [NSMutableArray array];
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
    [super loadView];
    // Background image
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banks.jpeg"]];
    [self.view addSubview:background];
    
    CGRect vFrame = self.view.frame;
    category = [BankAgrouperView circleWithFrame:CGRectMake(vFrame.size.width/2-sizeOfCategory/2, 
                                                            vFrame.size.height-sizeOfCategory/2, 
                                                            sizeOfCategory, sizeOfCategory) 
                                 withBorderWidth:5];
    category.delegate = self;
    [category setName:@"kSelected"];
    
    [self.view addSubview:category];
    
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.marshaller items]];
    [items shuffle];
    
    NSUInteger itemsPerSide = (NSUInteger) ceil(sqrtf([items count]));
//    RandomGridGenerator *randomGrindGen = [[RandomGridGenerator alloc] initWithLowerBounds:CGPointMake(100, 300) 
    //                                                                    andUpperBounds:CGPointMake(400, 500)];
    NSEnumerator *gridEnnumerator = [[GridGenerator jitteredGridWithFrame:CGRectMake(50, 300,
                                                                                     self.view.bounds.size.width - 100, 450)
                                                                  numRows:itemsPerSide
                                                                  numCols:itemsPerSide] objectEnumerator];
    for (NSString *item in items) {
        DraggableItem *bankItem = [DraggableItem newWithName:item];
        [bankItem setTargetArea:[SurveyDefaults interactiveArea]];
        
        [draggableList addObject:bankItem];
        
        [category trackView:bankItem];
        
        bankItem.delegate = self;
        [self.view addSubview:bankItem];
        
//        CGPoint newCenter = [randomGrindGen nextRandomCenterWithWidth:[bankItem frame].size.width withHeight:[bankItem frame].size.height];
        CGPoint newCenter = [[gridEnnumerator nextObject] CGPointValue];
        [bankItem setCenter:newCenter];
    }
}

- (void)object:(UIView *)object didEnterSensorArea:(UIView *)sensor
{
    [(DraggableItem*) object setCurrentSensor:sensor];
    [sensor hoverIn:nil];
}

- (void)object:(UIView *)object didLeaveSensorArea:(UIView *)sensor
{
    [(DraggableItem*) object setCurrentSensor:NULL];
    [sensor hoverOut:nil];
}

- (void)draggableViewDidStopDragging:(id)draggableItem {
    if ([draggableItem currentSensor] != NULL) {
        [SoundPlayerPool playFile:@"swallow.caf"];
        [self.marshaller pushItem:[[draggableItem currentSensor] name] onCategory:[draggableItem name]];
        [draggableItem droppedWithAnimation];
        [[draggableItem currentSensor] itemDroppedWithAnimation];
        
        [self setHasValidAnswers:YES];
    } 
}

- (void)collectAnswers
{
    
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
    return 11;
}

+ (void)load
{
    [super load];
}

- (BOOL)needsConfirmation
{
    return YES;
}


@end
