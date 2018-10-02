//
//  3DSemanticDifferentialRenderView.m
//  Fubu
//
//  Created by Workstation on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SodaCan3DRenderView.h"

#define BRAKE_TIME 0.35
#define MIN_POS 6.0 
#define MAX_POS 18.0

@interface SodaCan3DRenderView() {
    @private
    NGLMesh *canEdges;
    NGLMesh *canLabel;
	NGLCamera *camera;
	
	NGLvec4 color;
	NGLTexture *label;
    NGLTexture *aluminum;
    NGLTexture *environment;
    
    NGLQuaternion *rotation;
    
    CGPoint start;
    CGFloat startScale;
}

@end

@implementation SodaCan3DRenderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.antialias = NGLAntialias4X;    
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:16.0];  
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [self addGestureRecognizer:panRecognizer];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        pinchRecognizer.delegate = self;    
        [self addGestureRecognizer:pinchRecognizer];
        
        // ninevehGL    
        // global
        nglGlobalColor((NGLvec4){ 0.3, 0.15, 0.2, 1.0 });
        nglGlobalTextureQuality(NGLTextureQualityTrilinear);
        nglGlobalTextureOptimize(NGLTextureOptimizeAlways);
        nglGlobalTextureRepeat(NGLTextureRepeatMirrored);
        nglGlobalFPS(30);
        
        canEdges = [[NGLMesh alloc] initWithFile:@"can_edges.obj" settings:nil delegate:nil];
        canLabel = [[NGLMesh alloc] initWithFile:@"can_label.obj" settings:nil delegate:nil];
        
        [canEdges setPivot:(NGLvec3){ 0.0, 3.75, 0.0 }];
        [canLabel setPivot:(NGLvec3){ 0.0, 3.75, 0.0 }];
        
        label = [[NGLTexture alloc] init2DWithFile:@"label2.png"];
        
        aluminum = [[NGLTexture alloc] init2DWithFile:@"aluminum.png"];
        
        environment = [[NGLTexture alloc] init2DWithFile:@"env.jpg"];    
        
        NGLShaders *shader = [NGLShaders shadersWithFileVertex:@"can.vsh" andFragment:@"can.fsh"];
        [shader bindTexture:@"envmap" texture:environment];
        
        NGLMaterial *aluminumMaterial = [NGLMaterial materialSilver];
        aluminumMaterial.diffuseMap = aluminum;
        //    aluminumMaterial.reflectiveMap = environment;
        aluminumMaterial.reflectiveLevel = 0.15;
        aluminumMaterial.shininess = 2.0;
        aluminumMaterial.ambientColor = (NGLvec4){ 0.015, 0.01, 0.02, 1.0 };
        
        NGLMaterial *labelMaterial = [aluminumMaterial copy];
        labelMaterial.diffuseMap = label;
        labelMaterial.shininess = 3.0;
        labelMaterial.reflectiveLevel = 0.25;
        
        canEdges.material = aluminumMaterial;
        canEdges.shaders = shader;
        [canEdges compileCoreMesh];
        
        canLabel.material = labelMaterial;
        canLabel.shaders = shader;
        [canLabel compileCoreMesh];
        
        camera = [[NGLCamera alloc] initWithMeshes:canEdges, canLabel, nil];
        camera.aspectRatio = 1.0;    
        camera.angleView = 60.0;
        camera.z = 8.5;
        
        [NGLLight defaultLight].y = 1.0;
        [NGLLight defaultLight].z = 6.0;
        
        rotation = [[NGLQuaternion alloc] init];
        [rotation identity];

    }
    
    return self;
}

- (void) drawView
{   
    //    [canEdges rotateRelativeToX:0.0 toY:1.0 toZ:0.0];
    //    [canLabel rotateRelativeToX:0.0 toY:1.0 toZ:0.0];
    [camera drawCamera];
}

- (void)pinch:(UIPinchGestureRecognizer*)sender
{    
    if (sender.state == UIGestureRecognizerStateBegan)
        startScale = sender.scale;
    
    camera.z -= 25.0 * (sender.scale - startScale);
    camera.z = MIN(MAX_POS, MAX(MIN_POS, camera.z));
    
    startScale = sender.scale;
}

- (void)move:(UIPanGestureRecognizer*)sender
{	
    CGPoint translatedPoint = [sender translationInView:self];
    
    if (sender.state == UIGestureRecognizerStateBegan)
        start = translatedPoint;
    
    CGPoint delta = CGPointMake(translatedPoint.x - start.x, translatedPoint.y - start.y);
    start = translatedPoint;
    
    [rotation rotateByEuler:(NGLvec3){ delta.y, delta.x, 0.0 } mode:NGLAddModePrepend];
    [canEdges rotateToX:rotation.euler.x toY:rotation.euler.y toZ:rotation.euler.z];
    [canLabel rotateToX:rotation.euler.x toY:rotation.euler.y toZ:rotation.euler.z];
    
    //	if ([sender state] == UIGestureRecognizerStateEnded) {        
    //        CGFloat finalX = translatedPoint.x + (BRAKE_TIME * BRAKE_TIME * [sender velocityInView:self.view].x) - start.x;
    //		CGFloat finalY = translatedPoint.y + (BRAKE_TIME * BRAKE_TIME * [sender velocityInView:self.view].y) - start.y;
    //        [rotation rotateByEuler:(NGLvec3){ finalY, finalX, 0.0 } mode:NGLAddModePrepend];
    //        
    //        NSDictionary *rot = [NSDictionary dictionaryWithObjects:
    //                             [NSArray arrayWithObjects:
    //                              [NSNumber numberWithFloat:rotation.euler.x],
    //                              [NSNumber numberWithFloat:rotation.euler.y], 
    //                              [NSNumber numberWithFloat:rotation.euler.z], nil]
    //                             
    //                                                        forKeys:
    //                             [NSArray arrayWithObjects:
    //                              @"rotateX",
    //                              @"rotateY",
    //                              @"rotateZ", nil]];
    //        
    //        [NGLTween tweenWithTarget:canEdges duration:BRAKE_TIME values:rot];
    //        [NGLTween tweenWithTarget:canLabel duration:BRAKE_TIME values:rot];
    //	}
}

@end
