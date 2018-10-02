
#import "CarBrandsViewController.h"
#import "DraggableLogo.h"
#import "TooltipView.h"
#import "Viewport.h"
#import "SoundPlayerPool.h"
#import "NSMutableArray+Shuffle.h"

#define TARGET_AREA         CGRectMake(60 + 20, 260 + 20, 660 - 40, 660 - 40)
#define STARTING_POSITION   CGPointMake(384, 960)
#define OUTSIDE_POSITION    CGPointMake(384, 1024 + 72)

@interface CarBrandsViewController() {
    @private
    UIImageView    *glow;
    NSMutableArray *brands;
    NSEnumerator   *sequence;
}
@end

@implementation CarBrandsViewController

- (id)initWithMarshaller:(Marshaller *)marshaller_
{
    if ((self = [super initWithMarshaller:marshaller_])) {
        brands = [NSMutableArray arrayWithArray:[marshaller_ items]];
        [brands shuffle];
        sequence = [brands objectEnumerator];
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
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_background.png"]];
    [self.view addSubview:background];
    
    // Glow
    glow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glow.png"]];
    glow.userInteractionEnabled = NO;
    glow.center = STARTING_POSITION;        
    glow.alpha = 0.0;
    [self.view addSubview:glow];
}

//- (void)draggableViewDidStopDragging:(id)draggableView {
- (void)itemPlaced:(id)sender {
    id next = [sequence nextObject];
    if (next) {
        DraggableLogo *logo = [[DraggableLogo alloc] initWithImage:[UIImage imageNamed:[[next stringByAppendingString:@".png"] lowercaseString]]];
        logo.name = next;
        logo.delegate = self;
        logo.center = OUTSIDE_POSITION;
//        logo.targetArea = TARGET_AREA;
        
        // Tooltip
        [TooltipView setAnchorPoint:CGPointMake(STARTING_POSITION.x, STARTING_POSITION.y - 10.0)];
        [TooltipView performSelector:@selector(displayText:)
                          withObject:next
                          afterDelay:0.5];
        
        [self.view addSubview:logo];         
        [self.view bringSubviewToFront:glow];
        
        // Animate
        [logo floatTo:STARTING_POSITION];
//        [logo setCenter:STARTING_POSITION animated:YES];
        
        // Glow
        [UIView animateWithDuration:0.1
                              delay:0.4
                            options:0
                         animations:^{
                             glow.alpha = 1.0;
                         }
                         completion:^(BOOL finished){     
                             [UIView animateWithDuration:0.1
                                              animations:^{
                                                  glow.alpha = 0.0;
                                              }];
                             // Play a sound
                             [SoundPlayerPool playFile:@"ding.aiff"];
                         }];                           
    } else    
        self.hasValidAnswers = YES;   
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Fetch the current item    
    [self performSelector:@selector(itemPlaced:) withObject:nil afterDelay:5.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Protocol methods
+ (NSUInteger)questionId
{
    return 7;
}

+ (void)load
{
    [super load];
}

- (BOOL)needsConfirmation
{
    return YES;
}

- (void)collectAnswers
{
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[DraggableLogo class]])
            continue;
        
        DraggableLogo *logo = (DraggableLogo *)view;
        CGFloat x = 2.0 * (logo.center.x - CGRectGetMinX(TARGET_AREA)) / CGRectGetWidth(TARGET_AREA)  - 1.0;
        CGFloat y = -2.0 * (logo.center.y - CGRectGetMinY(TARGET_AREA)) / CGRectGetHeight(TARGET_AREA) + 1.0;
        [self.marshaller pushItem:[[NSNumber numberWithFloat:x] stringValue] onCategory:logo.name];
        [self.marshaller pushItem:[[NSNumber numberWithFloat:y] stringValue] onCategory:logo.name];
    }
}

@end
