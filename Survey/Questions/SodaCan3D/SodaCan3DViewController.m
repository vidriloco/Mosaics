#import "SodaCan3DViewController.h"
#import "SodaCan3DRenderView.h"
#import "NSMutableArray+Shuffle.h"
#import "FBSliderWithOptions.h"
#import "SoundPlayerPool.h"
#import "TooltipView.h"

@interface SodaCan3D() {
    UIImageView    *touchIcon;
    NSMutableArray *categories;
    NSMutableArray *sliders;
    NSUInteger      currentSlider;
}

@end

@implementation SodaCan3D

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithMarshaller:(Marshaller *)aMarshaller
{
    if ((self = [super initWithMarshaller:aMarshaller])) {
        // Initialization code
        categories = [NSMutableArray arrayWithArray:[self.marshaller items]];    
        [categories shuffle];
        
        // Sliders
        sliders = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    // Background image
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_green_leather.jpg"]];
    [self.view addSubview:background];
    
    CGFloat side = 700;
    NGLView *glView = [[SodaCan3DRenderView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - side) / 2, 200, side, side)];
    [self.view addSubview:glView];
       
    // touch icon
    touchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_icon.png"]];
    touchIcon.userInteractionEnabled = NO;
    touchIcon.center = glView.center;
    touchIcon.frame = CGRectIntegral(touchIcon.frame);
    touchIcon.alpha = 0.66;
    [self.view addSubview:touchIcon];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide touch icon after a while
    [UIView animateWithDuration:1.0
                          delay:3.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         touchIcon.alpha = 0;
                     }
                     completion:^(BOOL finished) {                         
                         touchIcon.hidden = YES;
                         [touchIcon removeFromSuperview];
                     }];
    
    // Show first subscreen
    [self presentNextSubscreen];
}

- (SurveyQuestionSubscreen *)subscreenAtIndex:(NSUInteger)index
{
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 9.0);
    rect = CGRectOffset(rect, 0, self.view.bounds.size.height - rect.size.height);

    // Subscreen appearance configuration
    SurveyQuestionSubscreen *subscreen = [[SurveyQuestionSubscreen alloc] initWithFrame:rect];
    subscreen.backgroundColor = [[UIColor scrollViewTexturedBackgroundColor] colorWithAlphaComponent:0.75];
    subscreen.layer.cornerRadius = 15.0;
    
    // animations
    subscreen.animationStartPosition = CGPointMake(subscreen.center.x - subscreen.bounds.size.width, subscreen.center.y);
    subscreen.animationEndPosition   = CGPointMake(subscreen.center.x + subscreen.bounds.size.width, subscreen.center.y);
    subscreen.animationOptions       = QuestionSubscreenAnimationOptionTranslate | 
                                       QuestionSubscreenAnimationOptionCrossDissolve;
    subscreen.animationDuration      = 0.5;
    
    // Slider
    int xPos = 150;
    int sliderHeight = 30;
    int yPos = (rect.size.height - sliderHeight) / 2.0;
    int sliderWidth = 768 - xPos * 2;
    
    NSArray *current = [[categories objectAtIndex:index] componentsSeparatedByString:@"-"];
    FBSliderWithOptions *slider = [[FBSliderWithOptions alloc] initWithFrame:CGRectMake(xPos, yPos, sliderWidth, sliderHeight)];                            
    [slider setMinimumValueText:[current objectAtIndex:0]];
    [slider setMaximumValueText:[current objectAtIndex:1]];
    slider.minimumValue = -2;
    slider.maximumValue = 2;
    slider.value = 0;
    slider.stops = 5;
//    [slider addTarget:self action:@selector(showTooltip:) forControlEvents:UIControlEventValueChanged]; 
    [slider addTarget:self action:@selector(sliderReleased:) forControlEvents:UIControlEventTouchUpInside];      
    [slider addTarget:self action:@selector(sliderReleased:) forControlEvents:UIControlEventTouchUpOutside]; 
    [subscreen addSubview:slider];             
    [sliders addObject:slider];
    
    return subscreen;
}

- (NSUInteger)numberOfSubscreens
{
    return [categories count];
}

- (void)sliderReleased:(FBSliderWithOptions*)slider
{    
    slider.used = YES;
    slider.userInteractionEnabled = NO;    
    // Completion
    currentSlider++;
    if (currentSlider == categories.count)
        self.hasValidAnswers = YES;
    
    // Play a sound
    [SoundPlayerPool playFile:@"ding.aiff"];
    
    // Present next subscreen
    [self presentNextSubscreen];
}

- (void)showTooltip:(FBSliderWithOptions*)slider
{          
    // Tooltip
    CGRect thumb = [slider thumbRectForBounds:slider.bounds trackRect:slider.frame value:slider.value];
    CGPoint thumbCenter = CGPointMake(CGRectGetMidX(thumb), CGRectGetMidY(thumb));
    [TooltipView setAnchorPoint:[slider convertPoint:thumbCenter toView:nil]];
    [TooltipView displayText:[NSNumber numberWithFloat:fabs(slider.value)].stringValue];
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
    return 12;
}

+ (void)load
{
    [super load];
}

- (void)collectAnswers
{
    for (NSString *category in categories) {
        FBSliderWithOptions *slider = [sliders objectAtIndex:[categories indexOfObject:category]];
        [self.marshaller pushItem:[[NSNumber numberWithInt:(int) slider.value] stringValue] onCategory:category];
    }
}

@end
