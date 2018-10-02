/*
 *	NGLCamera.h
 *	
 *	The NinevehGL Engine is a free 3D engine to work with OpenGL programmable pipeline, made with pure
 *	Objective-C for iOS (iPhone, iPad and iPod Touch). NinevehGL is prepared to import 3D file with the
 *	formats:
 *
 *		- WaveFront OBJ file (.obj);
 *		- COLLADA file (.dae).
 *
 *	More information at the official web site: http://nineveh.gl
 *
 *	Created by Diney Bomfim on 11/6/10.
 *	Copyright (c) 2010 DB-Interactively. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NGLRuntime.h"
#import "NGLMatrix.h"
#import "NGLMath.h"
#import "NGLArray.h"
#import "NGLObject3D.h"
#import "NGLMesh.h"
#import "NGLGroup3D.h"

@class NGLMesh;

/*!
 *					Defines the projection type for a #NGLCamera#.
 *
 *					The projection is similar to the lens of real world cameras. It affects the final image
 *					produced by a camera. There are two projection types supported by NinevehGL:
 *
 *						- Perspective;
 *						- Orthographic.
 *
 *					<strong>Perspective</strong>
 *					<pre>
 *
 *					      ___________
 *					     |           |  Aspect Ratio (Width / Height)
 *					     ____________  __
 *					    |           /|   |
 *					   ||          / |   |
 *					   ||         /  |   |
 *					   ||        /   | ----> Far Plane
 *					   ||       /    |   |
 *					  | |      /     |   |
 *					  | |_____/______| __|
 *					  | /    /       /
 *					  |/____/      /
 *					  |     |    /  ----> Field of View
 *					  |     |  /
 *					  |_____|/ -----> Angle of View
 *					     |
 *					     |--> Near
 *					          Plane
 *
 *					</pre>
 *
 *
 *					<strong>Orthographic</strong>
 *					<pre>
 *					        _________
 *					       |         |  Aspect Ratio (Width / Height)
 *					       __________  __
 *					      /         /|   |
 *					     /|        / |   |
 *					    / |       /  | ----> Far Plane
 *					   /  |      /   |   |
 *					  /   |_____/____| __|
 *					 /    /    /     /
 *					/____/____/     /
 *					|   /     |    /  ----> Field of View
 *					|  /      |   /
 *					| /       |  /
 *					|/        | /
 *					|_________|/
 *					     |
 *					     |--> Near
 *					          Plane
 *
 *					</pre>
 *
 *	@see			NGLCamera::lensPerspective:near:far:aspectRatio:
 *	@see			NGLCamera::lensOrthographic:near:far:
 *	
 *	@var			NGLProjectionPerspective
 *					Represents Perspective projection type.
 *
 *	@var			NGLProjectionOrthographic
 *					Represents Orthographic projection type.
 */
typedef enum
{
	NGLProjectionPerspective,
	NGLProjectionOrthographic,
} NGLProjection;

/*!
 *					The NinevehGL camera class.
 *
 *					The NGLCamera works exactly like a camera in professional 3D softwares like Maya,
 *					3DS Max, LightWave, Cinema4D, Modo and others. NGLCamera is one of the most important
 *					pieces in NinevehGL's render process.
 *
 *					OpenGL's shaders works greatly with a type of matrix called ModelViewProjection Matrix.
 *					The NGLCamera is responsible for generating the ViewProjection part of that matrix.
 *
 *					Using an user friendly approach, NGLCamera can easily move the camera in the 3D world,
 *					rotate it, get focus and follow a target. All that using just few simple methods.
 *
 *					Another important NGLCamera responsability is to deal with the lens. As you know,
 *					cameras in the real world have a lot of lenses type to capture different kind of images.
 *					The NGLCamera works similarly, producing different kind of images based on lens.
 *					You can easily adjust the lens using two methods. By default, every NGLCamera instance
 *					is initialized with a Perspective Projection based on the device's screen.
 *
 *					To make all those things, NGLCamera needs to know what object its lens will see.
 *					In NinevehGL all 3D objects, the visible ones, need to be rendered from a camera.
 *					Objects outside a camera scope will be ignored in NinevehGL's render process.
 *
 *					About the camera behavior, the important thing to remember is that OpenGL by default
 *					uses the right handed orientation. That means, the axis orientation will be,
 *					looking from the front perspective of the device:
 *
 *						- Axis X positive to the right and negative to the left of the device.
 *						- Axis Y positive upward and negative to downard of the device.
 *						- Axis Z axis positive coming toward the screen, in direction to the user and
 *							negative outgoing toward the screen, in direction to device's back.
 *
 *					<pre>
 *
 *						     ____________________________
 *						    /___________________________/|
 *						   ||___________________________||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||            +y   -z        ||
 *						   ||            |   /          ||
 *						   ||            |  /           ||
 *						   ||            | /            ||
 *						   ||  -x _______|/________ +x  ||
 *						   ||            /              ||
 *						   ||           /|              ||
 *						   ||          / |              ||
 *						   ||         /  |              ||
 *						   ||        /   |              ||
 *						   ||       +z   -y             ||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||                           ||
 *						   ||           Right Hand Rule ||
 *						   ||___________________________||
 *						   |             ___             |
 *						   |            |   |            |
 *						   |            |___|            |
 *						   |_____________________________|
 *
 *					</pre>
 *
 *					So when you increase the Z position of a 3D object, it will come near to the screen
 *					and when you decrease the Z, the 3D object goes away from the screen. The important
 *					thing about the camera is when you decrease Z, it will go away from the screen too,
 *					but this will produce the effect of the objects coming toward the screen, because
 *					the render always will produce the image by the camera lens point of view.
 *
 *					If you have two or more cameras and render it at the same time, the final image will
 *					be composed by the superimposition of the images captured by all cameras. This image
 *					composition will happen in the same order as the cameras was rendered.
 *
 *					One camera can hold many meshes, but each mesh can be rendered by only one camera
 *					at time. If a mesh was attached to more than one camera, just the last attachment will
 *					be valid to the render process and the mesh will be automatically removed from the
 *					previously attached duplication.
 *
 *					From a NGLCamera you can get the VIEW MATRIX, PROJECTION MATRIX and the VIEW
 *					PROJECTION MATRIX. Also, you can get the normal MODEL MATRIX as the NGLCamera is a
 *					subclass of the #NGLObject3D#.
 */
@interface NGLCamera : NGLObject3D
{
@private
	// Matrices
	NGLmat4					_pMatrix;
	NGLmat4					_vMatrix;
	NGLmat4					_vpMatrix;
	BOOL					_cCache;
	
	float					_angleView;
	float					_nearPlane;
	float					_farPlane;
	float					_aspectRatio;
	NGLProjection			_projection;
	
	// Meshes
	NGLArray				*_meshes;
	
	// Helpers
	BOOL					_rotateAnimated;
}

/*!
 *					Defines angle of view to the camera lens.
 *
 *					This property doesn't affect the Orthographic #projection#, just the Perspective.
 *					Angle of View is the aperture angle that defines the Field of View (FOV) in Perspective
 *					projection type.
 *
 *					The default value is 45.0.
 */
@property (nonatomic) float angleView;

/*!
 *					Defines near plane for the camera lens. Nearest objects will be clipped.
 *
 *					The default value is 0.001.
 */
@property (nonatomic) float nearPlane;

/*!
 *					Defines far plane for the camera lens. Farthest objects will be clipped.
 *
 *					The default value is 100.0.
 */
@property (nonatomic) float farPlane;

/*!
 *					Defines size for the camera's field of view (FOV). This property is valid for both
 *					projections: Perspective and Orthographic.
 *
 *					This property represents the same object in both projections: the final visible frame.
 *					With the Perspective #projection#, this is what it represents:
 *
 *					<pre>
 *					           Width
 *					        ___________
 *					       |           |  Aspect Ratio (Width / Height)
 *					       ____________  __
 *					      |           /|   |
 *					     ||          / |   |
 *					     ||         /  |   |
 *					     ||        /   |   |  Height
 *					     ||       /    |   |
 *					    | |      /     |   |
 *					    | |_____/______| __|
 *					    | /    /       /
 *					    |/____/      /
 *					    |     |    /  ----> Field of View (FOV)
 *					    |     |  /
 *					    |_____|/
 *
 *					</pre>
 *
 *					With the Orthographic #projection#, this is what it represents:
 *
 *					<pre>
 *					          Width
 *					        _________
 *					       |         |  Aspect Ratio (Width / Height) - Perspective Porjection only
 *					       __________  __
 *					      /         /|   |
 *					     /|        / |   |
 *					    / |       /  |   |  Height
 *					   /  |      /   |   |
 *					  /   |_____/____| __|
 *					 /    /    /     /
 *					/____/____/     /
 *					|   /     |    /  ----> Field of View (FOV)
 *					|  /      |   /
 *					| /       |  /
 *					|/        | /
 *					|_________|/
 *
 *					</pre>
 *
 *					The default value is based on device's screen frame (width / height).
 *
 *	@see			NGLProjection
 */
@property (nonatomic) float aspectRatio;

/*!
 *					Defines lens type, also known as camera projection. It can be:
 *
 *						- Perspective;
 *						- Orthographic.
 *
 *					The default value is NGLProjectionPerspective.
 *
 *	@see			NGLProjection
 */
@property (nonatomic) NGLProjection projection;

/*!
 *					Returns the current VIEW MATRIX. NinevehGL doesn't use this property, it's
 *					just a reference in case you need to get it.
 */
@property (nonatomic, readonly) NGLmat4 *matrixView;

/*!
 *					Returns the current PROJECTION MATRIX. NinevehGL doesn't use this property, it's
 *					just a reference in case you need to get it.
 */
@property (nonatomic, readonly) NGLmat4 *matrixProjection;

/*!
 *					Represents the Camera Matrix, also known as VIEW PROJECTION MATRIX.
 */
@property (nonatomic, readonly) NGLmat4 *matrixViewProjection;

/*!
 *					Initializes a camera instance with some meshes attached to it. The camera will retain
 *					the meshes internally.
 *
 *					This method requires nil termination.
 *
 *	@param			firstMesh
 *					The first mesh (#NGLMesh#) to be added, followed by a comma.
 *
 *	@param			...
 *					A list of meshes, all followed by commas. This method requires a nil termination.
 *
 *	@result			A new initialized instance.
 */
- (id) initWithMeshes:(NGLMesh *)firstMesh, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 *					Places new lens on camera.
 *
 *					This lens has a perspective #projection#.
 *
 *	@param			aspect
 *					This parameter represents the aspect ratio relative to the device's screen.
 *					OpenGL produces squared image and if the device's screen is not squared the final
 *					image will be stretched to fit into the device's screen.
 *					With this parameter that problem can be avoided. What you need to do is inform the
 *					screen's aspect ratio (or the desired part of screen).
 *					To calculate it, just divide the final width by the final height (width / height).
 *
 *	@param			near
 *					Indicates the minimum distance for the camera to capture an objects. This value is
 *					associated with a generic unit, the same used in the 3D space. A good value to it could
 *					be 0.01, by this way only the objects very close to the camera will be clipped.
 *
 *	@param			far
 *					Indicates the maximum range for the camera capture an objects. This value is associated
 *					with a generic unit, the same used in the 3D space. A good value to it could
 *					be 100.0, by this way only the objects very far to the camera will be clipped.
 *
 *	@param			angle
 *					The Angle of View. It's also called as Field of View (FOV), but actually they are not
 *					the same thing, though they are related. The human eye total perception goes around
 *					130º to 160º, but the focus is around 45º to 60º. So these could be good values to use.
 *					Great angles are like Gran Angular lens (as the Fisheye Lens).
 *					Here are some acceptable values and their equivalent lenses:
 *
 *						- 100 = 15mm lens;
 *						- 83 = 20mm lens;
 *						- 73 = 24mm lens;
 *						- 65 = 28mm lens;
 *						- 54 = 35mm lens;
 *						- 39 = 50mm lens;
 *						- 23 = 85mm lens;
 *						- 15 = 135mm lens;
 *						- 10 = 200mm lens.
 *
 *					Values higher than 170 and smaller than 10 produce bizarre results and distort
 *					a lot of the real 3D world.
 */
- (void) lensPerspective:(float)aspect near:(float)near far:(float)far angle:(float)angle;

/*!
 *					Places new lens on camera.
 *
 *					This lens has an orthographic #projection#.
 *
 *	@param			aspect
 *					This parameter represents the aspect ratio relative to the device's screen.
 *					OpenGL produces squared image and if the device's screen is not squared the final
 *					image will be stretched to fit into the device's screen.
 *					With this parameter that problem can be avoided. What you need to do is inform the
 *					screen's aspect ratio (or the desired part of screen).
 *					To calculate it, just divide the final width by the final height (width / height).
 *
 *	@param			near
 *					Indicates the minimum distance for the camera to capture an objects. This value is
 *					associated with a generic unit, the same used in the 3D space. A good value to it could
 *					be 0.01, by this way only the objects very close to the camera will be clipped.
 *
 *	@param			far
 *					Indicates the maximum range for the camera capture an objects. This value is associated
 *					with a generic unit, the same used in the 3D space. A good value to it could
 *					be 100.0, by this way only the objects very far to the camera will be clipped.
 */
- (void) lensOrthographic:(float)aspect near:(float)near far:(float)far;

/*!
 *					Adds a new mesh to this camera. The camera will retain the meshes internally.
 *
 *					If a mesh is already attached to this camera, new attempts to put it in the same
 *					camera will be ignored. One single mesh can be attached to multiple cameras.
 *
 *	@param			mesh
 *					A #NGLMesh# to be attached to this camera.
 */
- (void) addMesh:(NGLMesh *)mesh;

/*!
 *					Adds a set of new meshes to this camera. The camera will retain the meshes internally.
 *
 *					This method is similar to #addMesh:# method, but this one takes meshes from an array.
 *
 *	@param			array
 *					A NSArray containing the meshes to be attached to this camera.
 */
- (void) addMeshesFromArray:(NSArray *)array;

/*!
 *					Adds a set of new meshes to this camera. The camera will retain the meshes internally.
 *
 *					This method is similar to #addMesh:# method, but this one takes meshes from a group.
 *					Only instances of #NGLMesh# will be taken from the group, any other object inside the
 *					group will be ignored by this method.
 *
 *	@param			group
 *					A #NGLGroup3D# containing the meshes to be attached to this camera.
 *
 *	@see			NGLGroup3D
 */
- (void) addMeshesFromGroup3D:(NGLGroup3D *)group;

/*!
 *					Checks if a specific mesh is already attached to this camera.
 *
 *					Return a BOOL indicating if the mesh is or not attached to this camera.
 *
 *	@param			mesh
 *					A #NGLMesh# to search for.
 *
 *	@result			A BOOL data type indicating if the mesh is attached to this camera.
 */
- (BOOL) hasMesh:(NGLMesh *)mesh;

/*!
 *					Removes a specific mesh attached to this camera. The meshes are released when removed
 *					from camera.
 *
 *					If the mesh is not found in this camera, this method does nothing.
 *
 *	@param			mesh
 *					A #NGLMesh# to remove.
 */
- (void) removeMesh:(NGLMesh *)mesh;

/*!
 *					Removes all meshes attached to this camera. All the meshes will receive a
 *					release message.
 *
 *					If no mesh was found in this camera, this method does nothing.
 */
- (void) removeAllMeshes;

/*!
 *					Draws the image capture by this camera's lens.
 *
 *					Call this method at every render cycle or every time you want to draw the image
 *					produced by this camera. A single call to this method will make all the meshes
 *					attached to this camera be drawn.
 *
 *					This method should be called inside a drawView method from a #NGLView# or equivalent
 *					delegation. The produced image will be attached to the #NGLView# from where this method
 *					was called.
 */
- (void) drawCamera;

/*!
 *					<strong>(Internal only)</strong> You should never use this directly.
 *
 *					Gets all the meshes currently in this camera.
 *
 *	@result			A NSArray containing all the meshes.
 */
- (NSArray *) allMeshes;

@end

/*!
 *					A category deals with iOS interactions.
 *
 *					This category implements methods to deal with any kind of interaction between NinevehGL
 *					structure and Cocoa Touch Framework. It includes things like: device's orientation,
 *					touches, accelerometer and any kind of input specific to iOS devices.
 */
@interface NGLCamera(NGLCameraInteractive)

/*!
 *					Sets the camera auto-adjust.
 *
 *					The auto-adjust will fit the camera FOV to the current device's screen, trying to
 *					identify its orientation and adjusting the current camera's settings. This adjust will
 *					change the FOV for every device's orientation change. If you're not planning to rotate
 *					for every orientation, then make your own implementation using the
 *					#adjustToScreenAnimated:# method when there is a change in orientation.
 *
 *	@param			value
 *					A Boolean value indicating if the camera will start to auto-adjust or not.
 *
 *	@param			animating
 *					A Boolean value indicating if the auto adjust will be animated or not. This parameter
 *					has no effect if the first parameter is NO.
 *
 *	@see			adjustToScreenAnimated:
 */
- (void) autoAdjustToScreen:(BOOL)value animated:(BOOL)animating;

/*!
 *					Adjusts the current camera's settings to fir the current device's screen.
 *
 *					This method will be performed automatically if the auto-adjust is set to YES. The adjust
 *					will be performed with or without animation. The animation occurs in the iOS rotation
 *					times. This time can vary depending on the device and iOS version.
 *
 *	@param			value
 *					A Boolean value indicating if the adjust will be animated or not.
 *
 *	@see			autoAdjustToScreen:animated:
 */
- (void) adjustToScreenAnimated:(BOOL)value;

@end