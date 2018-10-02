//
//  FootballTeamsViewController.m
//  QuantusActive
//
//  Created by Alejandro on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FootballTeamsViewController.h"
#import "FootballTeamsView.h"
#import "NSMutableArray+Shuffle.h"
#import "SoundPlayerPool.h"
#import "DraggableItem.h"
#import "SurveyDefaults.h"

#define APPEARING_ITEM_DURATION 0.5f

@interface FootballTeamsViewController()
    @property (nonatomic, strong) NSEnumerator *itemsSequence;
    @property (nonatomic, strong) NSMutableArray *droppableList;
    @property (nonatomic, strong) NSMutableArray *draggableList;
@end

@implementation FootballTeamsViewController
@synthesize itemsSequence, droppableList, draggableList;


- (id) initWithMarshaller:(Marshaller *)marshaller_
{
    if((self=[super initWithMarshaller:marshaller_]))
    {
        self.draggableList = [NSMutableArray array];
        self.droppableList = [NSMutableArray array];
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
    FootballTeamsView *footballView = [[FootballTeamsView alloc] initWithFrame:self.view.bounds];
    self.view = footballView;    
    
    NSMutableArray *categories = [NSMutableArray arrayWithArray:[self.marshaller categories]];
    NSEnumerator *sequence = [categories objectEnumerator];
    
    // Place first category in center
    CGPoint centerCategory = CGPointMake(self.view.frame.size.width/2-categorySize/2, categoryPositionY-categorySize);
    [droppableList addObject:[footballView placeDroppableWithCenter:centerCategory withName:[sequence nextObject]]];
    
    // Place the other categories
    int categoryPositionX = 0; 
    id category = NULL;
    while ((category = [sequence nextObject])) {
        categoryPositionX += categorySeparation;
        CGPoint position = CGPointMake(categoryPositionX, categoryPositionY+categorySeparation/2);
        [droppableList addObject:[footballView placeDroppableWithCenter:position withName:category]];
        categoryPositionX += categorySize;
    }
    
    // Place the items
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.marshaller items]];
    [items shuffle];
    
    for (NSString *item in items) {
        DraggableItem *footItem = [DraggableItem newWithName:item];
        [draggableList addObject:footItem];
        [footItem setTargetArea:[SurveyDefaults interactiveArea]];

        for (DroppableArea *droppableArea in droppableList) {
            [droppableArea trackView:footItem];
            droppableArea.delegate = self;
            footItem.delegate = self;
        }
    }
    itemsSequence = [draggableList objectEnumerator];
    [self makeNextTeamItemVisibleAndSelectable];
}

// Draggables and Droppables 

- (void)object:(UIView *)object didEnterSensorArea:(UIView *)sensor {
    [sensor hoverIn:nil];
    [(DraggableItem*) object setCurrentSensor:sensor];
}

- (void)object:(UIView *)object didLeaveSensorArea:(UIView *)sensor {
    [sensor hoverOut:nil];
    [(DraggableItem*) object setCurrentSensor:NULL];
}

- (void)draggableViewDidStopDragging:(id)draggableView {
    if ([draggableView currentSensor] != NULL) {
        [self.marshaller pushItem:[[draggableView currentSensor] name] onCategory:[draggableView name]];
        [draggableView droppedWithAnimation];
    } 
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(keyPath==@"dropped")
    {
        if ([object dropped]) {
            [self makeNextTeamItemVisibleAndSelectable];
        }
    }
}

- (void) makeNextTeamItemVisibleAndSelectable
{
    DraggableItem *item = [itemsSequence nextObject];
    if (item == NULL) {
        self.hasValidAnswers = YES;
        return;
    }
    [SoundPlayerPool playFile:@"whistle.caf"];
    item.alpha = 0;
    [self.view addSubview:item];

    [UIView animateWithDuration:APPEARING_ITEM_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         item.alpha = 1;
                     }
                     completion:nil];
    
    
    [item addObserver:self forKeyPath:@"dropped" options:NSKeyValueChangeReplacement context:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // destroy observers
    for (SensorView *droppable in droppableList) {
        for (DraggableItem *view in draggableList) {
            [droppable untrackView:view];
        }
    }
}

#pragma mark - protocol methods

+ (NSUInteger) questionId
{
    return 4;
}

+ (void)load
{
    [super load];
}

@end
