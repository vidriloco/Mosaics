#import "DialogBalloonView.h"
#import "SurveyDefaults.h"

#define SGN(x)                          (x > 0) * 2 - 1 //(x > 0) - (x < 0)
#define CONSTRAIN(x, min_val, max_val)  MIN(max_val, MAX(min_val, x))
#define EPSILON                         0.0001
#define SLOPE                           3.0

@implementation DialogBalloonView
@synthesize strokeColor;
@synthesize rectColor;
@synthesize strokeWidth;
@synthesize cornerRadius;
@synthesize emitterPosition;
@synthesize tipLength;
@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.opaque = NO;
        self.strokeColor = kDefaultStrokeColor;
        super.backgroundColor = [UIColor clearColor];
        self.rectColor = kDefaultRectColor;
        self.strokeWidth = kDefaultStrokeWidth;
        self.cornerRadius = kDefaultCornerRadius;
        self.emitterPosition = CGPointZero;
        self.tipLength = kDefaultTipLength;
        self.bounds = CGRectInset(frame, -tipLength, -tipLength);
        
        // Label
        textLabel = [[UILabel alloc] initWithFrame:CGRectInset(frame, cornerRadius, cornerRadius)];
        textLabel.font = [SurveyDefaults H3Font];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = UITextAlignmentLeft;
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];

    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)newBGColor {
    // Ignore
}

- (void)setOpaque:(BOOL)newIsOpaque {
    // Ignore
}

- (void)drawRect:(CGRect)rect {
    CGRect rrect = CGRectInset(rect, tipLength + strokeWidth / 2.0, tipLength + strokeWidth / 2.0);
    
    CGFloat radius = cornerRadius;
    CGFloat width  = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width / 2.0)
        radius = width / 2.0;
    if (radius > height / 2.0)
        radius = height / 2.0;    
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);

    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    
    // Balloon tip
    CGFloat cx = CGRectGetMidX(rrect);
    CGFloat cy = CGRectGetMidY(rrect);
    CGFloat sx = emitterPosition.x - cx;
    CGFloat sy = emitterPosition.y - cy;
    CGFloat fx, fy, ix, iy, kx, ky;
        
    // vertical
    if (abs(sy * width / height) < abs(sx)) {
        sx = SGN(sx);
        sy = SGN(sy);
        fx = sx * width / 2.0 + cx;
        fy = CONSTRAIN(emitterPosition.y, miny + radius + EPSILON, maxy - radius - EPSILON);
        ix = fx;
        iy = fy - sy * tipLength;
        kx = fx + sx * tipLength;
        ky = fy - sy * SLOPE;
    }
    // horizontal
    else {
        sx = SGN(sx);
        sy = SGN(sy);
        fx = CONSTRAIN(emitterPosition.x, minx + radius + EPSILON, maxx - radius - EPSILON); 
        fy = sy * height / 2.0 + cy;
        ix = fx - sx * tipLength;
        iy = fy;
        kx = fx - sx * SLOPE;
        ky = fy + sy * tipLength;
    }
    
    NSMutableArray *points = [NSMutableArray arrayWithObjects:
                              // inset corners                              
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(minx, miny)], @"outset", nil],
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(minx, maxy)], @"outset", nil],
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(maxx, maxy)], @"outset", nil],
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(maxx, miny)], @"outset", nil],                              
                              // border corners
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(minx + radius, miny         )], @"corner", nil],
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(maxx - radius, miny         )], @"corner", nil], 
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(maxx         , miny + radius)], @"corner", nil], 
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(maxx         , maxy - radius)], @"corner", nil], 
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(maxx - radius, maxy         )], @"corner", nil], 
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(minx + radius, maxy         )], @"corner", nil], 
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(minx         , maxy - radius)], @"corner", nil],
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(minx         , miny + radius)], @"corner", nil],
                              // balloon tip
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(fx, fy)], @"tip", nil],
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(ix, iy)], @"tip", nil],
                              [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:CGPointMake(kx, ky)], @"tip", nil],
                              nil];
        
    // counterclockwise drawing order
    [points sortUsingComparator: ^(id a, id b) {
        NSArray *pairA = a;
        NSArray *pairB = b;
        NSValue *valueA = [pairA objectAtIndex:0];
        NSValue *valueB = [pairB objectAtIndex:0];
        CGPoint pa = [valueA CGPointValue];
        CGPoint pb = [valueB CGPointValue];                
        return atan2(pa.y - cy, pa.x - cx) < atan2(pb.y - cy, pb.x - cx);
        //CGFloat d = pa.x * pa.x + pa.y * pa.y;        
        //NSNumber *val1 = [NSNumber numberWithFloat:atan2(pa.y, pa.x)];
        //NSNumber *val2 = [NSNumber numberWithFloat:atan2(pb.y, pb.x)];
        //return (NSComparisonResult) [val2 compare:val1];
    }];
      
    UIBezierPath *balloon = [UIBezierPath bezierPath];
    NSArray *pair = [points objectAtIndex:0];
    [balloon moveToPoint:[[pair objectAtIndex:0] CGPointValue]];
    for (int i = 0; i < [points count]; i++) {
        pair = [points objectAtIndex:i];
        NSValue *current = [pair objectAtIndex:0];        
        NSString *type = [pair objectAtIndex:1];        
        [balloon addLineToPoint:[current CGPointValue]];
        if ([type isEqualToString:@"corner"] && i < [points count] - 1) {
            //[balloon addLineToPoint:[current CGPointValue]];
            pair = [points objectAtIndex:++i];
            current = [pair objectAtIndex:0];
            CGPoint controlPoint = [current CGPointValue];
            pair = [points objectAtIndex:++i];
            current = [pair objectAtIndex:0];
            CGPoint endPoint = [current CGPointValue];
            [balloon addQuadCurveToPoint:endPoint controlPoint:controlPoint];            
        }            
    }
    [balloon closePath];
    [rectColor setFill]; 
    [strokeColor setStroke]; 
    [balloon fill];
    balloon.lineWidth = strokeWidth;
    balloon.lineJoinStyle = kCGLineJoinRound;
    [balloon stroke];
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:[touch view]];
//    emitterPosition = location;
//    [self setNeedsDisplay];
//}

@end
