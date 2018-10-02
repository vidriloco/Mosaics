/*
 *	NGLBoundingBox.h
 *	NinevehGL
 *	
 *	Created by Diney Bomfim on 3/1/12.
 *	Copyright 2012 DB-Interactive. All rights reserved.
 */

#import "NGLDataType.h"
#import "NGLVector.h"
#import "NGLMatrix.h"

#pragma mark -
#pragma mark Fixed Functions
#pragma mark -
//**********************************************************************************************************
//
//  Fixed Functions
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Construction Functions
//**************************************************
//	Construction Functions
//**************************************************

/*!
 *					Fills the "volume" attribute of a bounding box structure as is advised by NGLbox.
 *
 *	@param			box
 *					The bounding box pointer. The pointed variable will receive the values.
 *
 *	@param			bounds
 *					The bounds that will delimiter the bounding box's volume.
 *
 *	@see			NGLBoundingBox
 *	@see			NGLbounds
 */
NGL_INLINE void nglBoundingBoxDefine(NGLBoundingBox *box, NGLbounds bounds)
{
	NGLvec3 vMin = bounds.min, vMax = bounds.max;
	
	// The original Volume.
	(*box).volume[0] = (NGLvec3){ vMin.x, vMin.y, vMin.z };
	(*box).volume[1] = (NGLvec3){ vMin.x, vMax.y, vMin.z };
	(*box).volume[2] = (NGLvec3){ vMax.x, vMax.y, vMin.z };
	(*box).volume[3] = (NGLvec3){ vMax.x, vMin.y, vMin.z };
	(*box).volume[4] = (NGLvec3){ vMin.x, vMin.y, vMax.z };
	(*box).volume[5] = (NGLvec3){ vMin.x, vMax.y, vMax.z };
	(*box).volume[6] = (NGLvec3){ vMax.x, vMax.y, vMax.z };
	(*box).volume[7] = (NGLvec3){ vMax.x, vMin.y, vMax.z };
	
	// The current Bounds.
	(*box).aligned = bounds;
}

/*!
 *					Fills the "aligned" attribute of a bounding box structure.
 *
 *	@param			box
 *					The bounding box pointer. The pointed variable will receive the values.
 *
 *	@param			matrix
 *					A transformation matrix that will transform the original bounding box's volume.
 *
 *	@see			NGLBoundingBox
 *	@see			NGLmat4
 */
NGL_INLINE void nglBoundingBoxAABB(NGLBoundingBox *box, NGLmat4 matrix)
{
	NGLvec3 vMin, vMax, vertex;
	NGLvec3 *boxStructure = malloc(NGL_SIZE_BOX);
	
	unsigned short i;
	unsigned short length = 8;
	for (i = 0; i < length; ++i)
	{
		boxStructure[i] = nglVec3ByMatrix((*box).volume[i], matrix);
	}
	
	vertex = boxStructure[0];
	vMin = vertex;
	vMax = vertex;
	
	for (i = 1; i < length; ++i)
	{
		vertex = boxStructure[i];
		
		// Stores the minimum value for vertices coordinates.
		vMin.x = (vMin.x > vertex.x) ? vertex.x : vMin.x;
		vMin.y = (vMin.y > vertex.y) ? vertex.y : vMin.y;
		vMin.z = (vMin.z > vertex.z) ? vertex.z : vMin.z;
		
		// Stores the maximum value for vertices coordinates.
		vMax.x = (vMax.x < vertex.x) ? vertex.x : vMax.x;
		vMax.y = (vMax.y < vertex.y) ? vertex.y : vMax.y;
		vMax.z = (vMax.z < vertex.z) ? vertex.z : vMax.z;
	}
	
	nglFree(boxStructure);
	
	(*box).aligned.min = vMin;
	(*box).aligned.max = vMax;
}

#pragma mark -
#pragma mark Intersection Functions
//**************************************************
//	Intersection Functions
//**************************************************

/*!
 *					Checks if two bouding boxes are touching their selves.
 *
 *	@param			boxA
 *					The first bounding box.
 *
 *	@param			boxB
 *					The seconds bounding box.
 *
 *	@see			NGLBoundingBox
 */
NGL_INLINE BOOL nglBoundingBoxCollision(NGLBoundingBox boxA, NGLBoundingBox boxB)
{
	BOOL isColliding = NO;
	NGLbounds boundsA = boxA.aligned, boundsB = boxB.aligned;
	
	if (boundsA.min.x < boundsB.max.x && boundsA.max.x > boundsB.min.x &&
		boundsA.min.y < boundsB.max.x && boundsA.max.y > boundsB.min.y &&
		boundsA.min.z < boundsB.max.y && boundsA.max.z > boundsB.min.z)
	{
		isColliding = YES;
	}
	
	return isColliding;
}

/*!
 *					Checks if a point is inside a bouding box.
 *
 *	@param			box
 *					The bounding box.
 *
 *	@param			point
 *					A NGLvec2 representing the point.
 *
 *	@see			NGLBoundingBox
 */
/*
NGL_INLINE BOOL nglBoundingBoxCollisionWithPoint(NGLBoundingBox box, NGLvec2 point)
{
	return NO;
}
//*/