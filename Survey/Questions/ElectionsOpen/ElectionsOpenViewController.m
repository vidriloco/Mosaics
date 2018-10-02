//
//  OpenAnswerViewController.m
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ElectionsOpenViewController.h"
#import "SurveyDefaults.h"

#define numOfChars    140
#define minNumOfChars 7

@interface ElectionsOpenViewController() {
    @private
    UILabel *charsLeft;
    UITextView *answer;
    BOOL    edited;
}
@end

@implementation ElectionsOpenViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle


- (void)loadView
{
    [super loadView];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elections-background.jpg"]];
    [self.view addSubview:background];

    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(-5, height/2-150, width+10, 380)];
    
    [[panel layer] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor];
    [[panel layer] setBorderColor:[UIColor colorWithWhite:10.0 alpha:0.5].CGColor];
    [[panel layer] setBorderWidth:2]; 
    [[panel layer] setShadowOffset: CGSizeMake(0, 3)];
    [[panel layer] setShadowColor: [UIColor blackColor].CGColor];
    [[panel layer] setShadowOpacity: 0.8];
    
    UIFont *font = [UIFont systemFontOfSize:20];
    
    answer = [[UITextView alloc] initWithFrame:CGRectMake(width/2-300, panel.frame.size.height/2-120, 600, 240)];
    answer.text = [NSString stringWithFormat:@"Escriba aquí su respuesta, mínimo %d caracteres.", minNumOfChars];
    answer.textColor = [UIColor grayColor];
    answer.keyboardType = UIKeyboardTypeASCIICapable;
    [answer setDelegate:self];
    [answer setFont:font];
    [[answer layer] setCornerRadius:7];
    [panel addSubview:answer];
    
    // auto show keyboard
    [answer performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:2.0];
    
    charsLeft = [[UILabel alloc] initWithFrame:CGRectMake(panel.frame.size.width-300, height/2-195, 250, 40)];
    [charsLeft setFont:[UIFont systemFontOfSize:18]];
    [charsLeft setBackgroundColor:[UIColor clearColor]];
    [charsLeft setTextColor:[UIColor whiteColor]];
    [charsLeft setText:[NSString stringWithFormat:@"%d caracteres restantes", numOfChars]];
    [panel addSubview:charsLeft];
    [self.view addSubview:panel];
    edited = NO;    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.hasValidAnswers = NO;
    if (!edited) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
        edited = YES;        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
{
    if ([text rangeOfCharacterFromSet:[SurveyDefaults illegalCharacterSet]].location != NSNotFound)
        return NO;
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if (newLength > numOfChars) {
        charsLeft.textColor = [UIColor redColor];
        return NO;
    } else {
        if (newLength >= minNumOfChars) {
            self.hasValidAnswers = YES;
        } else {
            self.hasValidAnswers = NO;
        }
            
        charsLeft.textColor = [UIColor whiteColor];
        [charsLeft setText:[NSString stringWithFormat:@"%d caracteres restantes", numOfChars-newLength]];
        return YES;
    }
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
    return 10;
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
    [self.marshaller pushItem:answer.text onCategory:@"Opinión"];
}

@end
