//
//  MultipleAnswerInputViewController.m
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoViewController.h"
#import "UILabel+Shadow.h"
#import "SurveyDefaults.h"

#define MAX_LENGTH 42

@interface VideoViewController() {
    UITextField             *activeField;
    NSMutableArray          *fields;
    MPMoviePlayerController *player;
    UIScrollView            *scrollView;
}
- (void)registerForKeyboardNotifications;
@end

@implementation VideoViewController

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 1.5);
    [self.view addSubview:scrollView];
    
    // Background images

    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"background_wood2.jpg"].CGImage scale:1.0 orientation:UIImageOrientationDownMirrored]];
    
    // Text fields
    [self registerForKeyboardNotifications];
    
    CGRect questionRect = CGRectMake(0, 0, 300, 30);
    int left = 50;
    int top = 256 + 360 + 90;
    
    UILabel_Shadow *questionLabel = [[UILabel_Shadow alloc] init];
    questionLabel.text = @"Después de ver el comercial, ¿qué marcas vienen a su mente?";
    questionLabel.backgroundColor = [UIColor clearColor];
    questionLabel.textColor = [UIColor whiteColor];
    questionLabel.font = [SurveyDefaults H3Font];
    questionLabel.frame = CGRectMake(left, top, [questionLabel.text sizeWithFont:questionLabel.font].width, [questionLabel.text sizeWithFont:questionLabel.font].height);
    /*
     questionLabel.textAlignment = UITextAlignmentCenter;        
     questionLabel.lineBreakMode = UILineBreakModeWordWrap;
     questionLabel.numberOfLines = 0;
     */
    [scrollView addSubview:questionLabel];    
    
    fields = [[NSMutableArray alloc] init];
    
    left += 40;
    top  += 50;
    for (int i = 0; i < [[self.marshaller items] count]; i++) {
        UITextField *textFieldRounded = [[UITextField alloc] initWithFrame:CGRectOffset(questionRect, left, top + i * 40)];
        bool isFirstField = (i < 1);
        textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
        textFieldRounded.textColor = [UIColor blackColor]; //text color
        textFieldRounded.font = [UIFont systemFontOfSize:17.0];  //font size
        textFieldRounded.placeholder = @"Responder aquí";  //place holder
        [textFieldRounded setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support    
        textFieldRounded.keyboardType = UIKeyboardTypeASCIICapable;  // type of the keyboard
        textFieldRounded.returnKeyType = UIReturnKeyDone;  // type of the return key    
        textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right		        
        textFieldRounded.delegate = self;	// let us be the delegate    
        textFieldRounded.hidden = !isFirstField;
        
        [fields addObject:textFieldRounded];
        [scrollView addSubview:textFieldRounded];
        activeField = textFieldRounded;
    }
    
    NSURL *m = [[NSBundle mainBundle] URLForResource:@"TGV" withExtension:@"mp4"];
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"TGV"
                                                          ofType:@"mp4"];
    // Video overlays
    self->player = [[MPMoviePlayerController alloc] initWithContentURL:m];
    self->player.shouldAutoplay = NO;
    [self->player setScalingMode:MPMovieScalingModeAspectFit];
    [self->player prepareToPlay];
    [self->player.view setFrame:CGRectMake(144, 256, 480, 360)];
    [scrollView addSubview:self->player.view];
    
    // TV overlay
    UIImageView *tvOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tv_overlay.png"]];
    tvOverlay.center = CGPointMake(768 / 2, 256 + (360 / 2));
    [scrollView addSubview:tvOverlay];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // hide nav bar
    self.hasValidAnswers = NO;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
       
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.center)) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y + kbSize.height - self.view.frame.size.height + activeField.frame.size.height + 10);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];    
}

// TODO: Fix length checking
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if ([string rangeOfCharacterFromSet:[SurveyDefaults illegalCharacterSet]].location != NSNotFound)
        return NO;
    
    int length = [textField.text length] ;
    if (length >= MAX_LENGTH && ![string isEqualToString:@""]) {
        textField.text = [textField.text substringToIndex:MAX_LENGTH];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {    
    activeField = textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    textField.layer.borderWidth = 2.5f;
    textField.layer.cornerRadius = 4.0f;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 0.0f;
    textField.layer.cornerRadius = 0.0f;
    textField.backgroundColor = (textField.text.length > 0)? [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] : [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{ 
    activeField = nil;
    int count = 0;
    for (UITextField *i in fields)
        count += i.text.length;
    
    if (count > 0)
        self.hasValidAnswers = YES;
    
    int nextIndex = [fields indexOfObject:textField] + 1;
    if (nextIndex < fields.count)
        ((UITextField *)[fields objectAtIndex:nextIndex]).hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Protocol methods

+ (NSUInteger)questionId
{
    return 3;
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
    NSString *baseKey = @"Marca ";
    for (UITextField *field in fields) {
        NSString *key = [baseKey stringByAppendingString:[[NSNumber numberWithInt:[fields indexOfObject:field] + 1] stringValue]];
        if (field.text != NULL) {
            [self.marshaller pushItem:field.text onCategory:key];
        }
    }
}

@end
