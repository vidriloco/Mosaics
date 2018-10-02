/*
 *	NGLMatrix.h
 *	
 *	The NinevehGL Engine is a free 3D engine to work with OpenGL programmable pipeline, made with pure
 *	Objective-C for iOS (iPhone, iPad and iPod Touch). NinevehGL is prepared to import 3D file with the
 *	formats:
 *		- WaveFront OBJ file (.obj);
 *		- COLLADA file (.dae).
 *
 *	More information at the official web site: http://nineveh.gl
 *
 *  Created by Diney Bomfim on 2/2/11.
 *  Copyright (c) 2011 DB-Interactively. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "NGLRuntime.h"
#import "NGLDataType.h"

#pragma mark -
#pragma mark Data Type Definitions
#pragma mark -
//**************************************************
//  Data Type Definitions
//**************************************************

/*!
 *					A matrix of order 4 (4 columns by 4 rows) represented by a linear array of 16 elements
 *					of float data type. OpenGL uses the matrix 4x4 to deal with complex operations in the
 *					3D world, like rotations, translates and scales.
 *					A 4 x 4 matrix could be represented as following:
 *
 *					<pre>
 *
 *					| 1  0  0  0 |
 *					|            |
 *					| 0  1  0  0 |
 *					|            |
 *					| 0  0  1  0 |
 *					|            |
 *					| 0  0  0  1 |
 *
 *					</pre>
 *
 *					IMPORTANT:
 * 
 *					OpenGL represents its matrices with the rows and columns swapped from the tradicional
 *					mathematical matrices (this swapped format is also known as column-major format).
 *					So, in all the following code you'll see the SWAPPED MATRICES operations.
 *
 *					The OpenGL uses one dimensional array ({0,1,2,3,4...}) to work with matricies, 
 *					the indices of the array can be represented as following:
 *	
 *					<pre>
 *
 *					  Tradicional                   OpenGL
 *
 *					| 0  1  2  3  |             | 0  4  8  12 |
 *					|             |             |             |
 *					| 4  5  6  7  |             | 1  5  9  13 |
 *					|             |             |             |
 *					| 8  9  10 11 |             | 2  6  10 14 |
 *					|             |             |             |
 *					| 12 13 14 15 |             | 3  7  11 15 |
 *
 *					</pre>
 */
typedef float NGLmat4[16];

#pragma mark -
#pragma mark Fixed Functions
#pragma mark -
//**********************************************************************************************************
//
//  Fixed Functions
//
//**********************************************************************************************************

/*!
 *					Loads the identity matrix into a NGLmat4.
 *
 *					A base matrix with neutral values. Works like a multiplication by 1 in a linear algebra,
 *					that means, doesn't change the multiplied object. Every matrix which multiply or
 *					be multiplied by the identity matrix will result in the same matrix. This is the
 *					identity matrix representation:
 *
 *					<pre>
 *
 *					| 1  0  0  0 |
 *					|            |
 *					| 0  1  0  0 |
 *					|            |
 *					| 0  0  1  0 |
 *					|            |
 *					| 0  0  0  1 |
 *
 *					</pre>
 *	
 *	@param			result
 *					The matrix which will have the identity matrix's values.
 */
NGL_INLINE void nglMatrixIdentity(NGLmat4 result)
{
    result[0] = result[5] = result[10] = result[15] = 1.0f;
    result[1] = result[2] = result[3] = result[4] = 0.0f;
    result[6] = result[7] = result[8] = result[9] = 0.0f;
    result[11] = result[12] = result[13] = result[14] = 0.0f;
}

/*!
 *					Creates a NGLmat4 based on an NSArray.
 *
 *					The NSArray must has at least 16 values on it, only the first 16 values will be used.
 *	
 *	@param			array
 *					The NSArray with at least 16 elements.
 *	
 *	@param			result
 *					The matrix which will receive the result.
 */
NGL_INLINE void nglMatrixFromNSArray(NSArray *array, NGLmat4 result)
{
	// Fisrt Column
    result[0]  = [[array objectAtIndex:0] floatValue];
    result[1]  = [[array objectAtIndex:1] floatValue];
    result[2]  = [[array objectAtIndex:2] floatValue];
    result[3]  = [[array objectAtIndex:3] floatValue];
    
	// Second Column
    result[4]  = [[array objectAtIndex:4] floatValue];
    result[5]  = [[array objectAtIndex:5] floatValue];
    result[6]  = [[array objectAtIndex:6] floatValue];
    result[7]  = [[array objectAtIndex:7] floatValue];
    
	// Third Column
    result[8]  = [[array objectAtIndex:8] floatValue];
    result[9]  = [[array objectAtIndex:9] floatValue];
    result[10] = [[array objectAtIndex:10] floatValue];
    result[11] = [[array objectAtIndex:11] floatValue];
    
	// Fourth Column
    result[12] = [[array objectAtIndex:12] floatValue];
    result[13] = [[array objectAtIndex:13] floatValue];
    result[14] = [[array objectAtIndex:14] floatValue];
    result[15] = [[array objectAtIndex:15] floatValue];
}

/*!
 *					Copies the values from one matrix to another.
 *
 *					This method copies the memory, so newer changes to the original matrix will not affect
 *					the resulting matrix.
 *	
 *	@param			original
 *					The matrix to be copied.
 *	
 *	@param			result
 *					The matrix which will receive the result.
 */
NGL_INLINE void nglMatrixCopy(NGLmat4 original, NGLmat4 result)
{
	memcpy(result, original, NGL_SIZE_MAT4);
}

/*!
 *					Multiply two matrices.
 *
 *					Before start the multiplication process, the values are cached. That means the result
 *					instance can be the same as multiplication product. For example:
 *
 *					<pre>
 *
 *					NGLmat4 matA = &lt;Some initial value&gt;;
 *					NGLmat4 matB = &lt;Some initial value&gt;;
 *
 *					nglMatrixMultiply(matA, matB, matA);
 *
 *					</pre>
 *
 *					The multiplication process will occurs multiplying each line value of the first
 *					matrix by the columns of the second matrix, each line for each columns, and so on:
 *	
 *					<pre>
 *
 *					      m1                           m2
 *					 ------> Lines
 *
 *					| 0  4  8  12 |         C    | 0  4  8  12 |
 *					|             |         o |  |             |
 *					| 1  5  9  13 |         l |  | 1  5  9  13 |
 *					|             |    X    u |  |             |
 *					| 2  6  10 14 |         m |  | 2  6  10 14 |
 *					|             |         n V  |             |
 *					| 3  7  11 15 |         s    | 3  7  11 15 |
 *
 *					</pre>
 *
 *					IMPORTANT:
 *					Matrix multiplication IS NOT commutative. So A x B is not the same as B x A.
 *	
 *	@param			m1
 *					The first product matrix.
 *
 *	@param			m2
 *					The second product matrix.
 *	
 *	@param			result
 *					The matrix which will receive the result.
 */
NGL_INLINE void nglMatrixMultiply(NGLmat4 m1, NGLmat4 m2, NGLmat4 result)
{
	// First matrix.
	float m1_00 = m1[0], m1_01 = m1[4], m1_02 = m1[8],  m1_03 = m1[12];
	float m1_10 = m1[1], m1_11 = m1[5], m1_12 = m1[9],  m1_13 = m1[13];
	float m1_20 = m1[2], m1_21 = m1[6], m1_22 = m1[10], m1_23 = m1[14];
	float m1_30 = m1[3], m1_31 = m1[7], m1_32 = m1[11], m1_33 = m1[15];
	
	// Second matrix.
	float m2_00 = m2[0], m2_01 = m2[4], m2_02 = m2[8],  m2_03 = m2[12];
	float m2_10 = m2[1], m2_11 = m2[5], m2_12 = m2[9],  m2_13 = m2[13];
	float m2_20 = m2[2], m2_21 = m2[6], m2_22 = m2[10], m2_23 = m2[14];
	float m2_30 = m2[3], m2_31 = m2[7], m2_32 = m2[11], m2_33 = m2[15];
	
	// Fisrt Column
    result[0]  = m1_00*m2_00 + m1_01*m2_10 + m1_02*m2_20 + m1_03*m2_30;
    result[1]  = m1_10*m2_00 + m1_11*m2_10 + m1_12*m2_20 + m1_13*m2_30;
    result[2]  = m1_20*m2_00 + m1_21*m2_10 + m1_22*m2_20 + m1_23*m2_30;
    result[3]  = m1_30*m2_00 + m1_31*m2_10 + m1_32*m2_20 + m1_33*m2_30;
    
	// Second Column
    result[4]  = m1_00*m2_01 + m1_01*m2_11 + m1_02*m2_21 + m1_03*m2_31;
    result[5]  = m1_10*m2_01 + m1_11*m2_11 + m1_12*m2_21 + m1_13*m2_31;
    result[6]  = m1_20*m2_01 + m1_21*m2_11 + m1_22*m2_21 + m1_23*m2_31;
    result[7]  = m1_30*m2_01 + m1_31*m2_11 + m1_32*m2_21 + m1_33*m2_31;
    
	// Third Column
    result[8]  = m1_00*m2_02 + m1_01*m2_12 + m1_02*m2_22 + m1_03*m2_32;
    result[9]  = m1_10*m2_02 + m1_11*m2_12 + m1_12*m2_22 + m1_13*m2_32;
    result[10] = m1_20*m2_02 + m1_21*m2_12 + m1_22*m2_22 + m1_23*m2_32;
    result[11] = m1_30*m2_02 + m1_31*m2_12 + m1_32*m2_22 + m1_33*m2_32;
    
	// Fourth Column
    result[12] = m1_00*m2_03 + m1_01*m2_13 + m1_02*m2_23 + m1_03*m2_33;
    result[13] = m1_10*m2_03 + m1_11*m2_13 + m1_12*m2_23 + m1_13*m2_33;
    result[14] = m1_20*m2_03 + m1_21*m2_13 + m1_22*m2_23 + m1_23*m2_33;
    result[15] = m1_30*m2_03 + m1_31*m2_13 + m1_32*m2_23 + m1_33*m2_33;
}

/*!
 *					Transposes a matrix.
 *
 *					This method invert the lines with the columns:
 *
 *					<pre>
 *
 *					| 0  4  8  12 |         | 0  1  2  3  |
 *					|             |         |             |
 *					| 1  5  9  13 |         | 4  5  6  7  |
 *					|             |    =    |             |
 *					| 2  6  10 14 |         | 8  9  10 11 |
 *					|             |         |             |
 *					| 3  7  11 15 |         | 12 13 14 15 |
 *
 *					</pre>
 *
 *	
 *	@param			original
 *					The matrix to be transposed.
 *
 *	@param			result
 *					The matrix which will receive the result.
 */
NGL_INLINE void nglMatrixTranspose(NGLmat4 original, NGLmat4 result)
{
	float m00 = original[0], m01 = original[4], m02 = original[8], m03 = original[12];
	float m10 = original[1], m11 = original[5], m12 = original[9], m13 = original[13];
	float m20 = original[2], m21 = original[6], m22 = original[10], m23 = original[14];
	float m30 = original[3], m31 = original[7], m32 = original[11], m33 = original[15];
	
	// Fisrt Column
	result[0] = m00;
	result[1] = m01;
	result[2] = m02;
	result[3] = m03;
	
	// Second Column
	result[4] = m10;
	result[5] = m11;
	result[6] = m12;
	result[7] = m13;
	
	// Third Column
	result[8] = m20;
	result[9] = m21;
	result[10] = m22;
	result[11] = m23;
	
	// Fourth Column
	result[12] = m30;
	result[13] = m31;
	result[14] = m32;
	result[15] = m33;
}

/*!
 *					Inverts a matrix.
 *
 *					The inverse of a matrix (M¡) is one that confirm the sentence:
 *
 *					<pre>
 *
 *					| M  x M¡ = Identity
 *					| M¡ x M  = Identity
 *
 *					</pre>
 *	
 *	@param			original
 *					The matrix to be inverted.
 *
 *	@param			result
 *					The matrix which will receive the result.
 */
NGL_INLINE void nglMatrixInverse(NGLmat4 original, NGLmat4 result)
{
	float m00 = original[0], m01 = original[4], m02 = original[8], m03 = original[12];
	float m10 = original[1], m11 = original[5], m12 = original[9], m13 = original[13];
	float m20 = original[2], m21 = original[6], m22 = original[10], m23 = original[14];
	float m30 = original[3], m31 = original[7], m32 = original[11], m33 = original[15];
	
	// Fisrt Column
	result[0] = m12*m23*m31 - m13*m22*m31 + m13*m21*m32 - m11*m23*m32 - m12*m21*m33 + m11*m22*m33;
	result[1] = m13*m22*m30 - m12*m23*m30 - m13*m20*m32 + m10*m23*m32 + m12*m20*m33 - m10*m22*m33;
	result[2] = m11*m23*m30 - m13*m21*m30 + m13*m20*m31 - m10*m23*m31 - m11*m20*m33 + m10*m21*m33;
	result[3] = m12*m21*m30 - m11*m22*m30 - m12*m20*m31 + m10*m22*m31 + m11*m20*m32 - m10*m21*m32;
	
	// Second Column
	result[4] = m03*m22*m31 - m02*m23*m31 - m03*m21*m32 + m01*m23*m32 + m02*m21*m33 - m01*m22*m33;
	result[5] = m02*m23*m30 - m03*m22*m30 + m03*m20*m32 - m00*m23*m32 - m02*m20*m33 + m00*m22*m33;
	result[6] = m03*m21*m30 - m01*m23*m30 - m03*m20*m31 + m00*m23*m31 + m01*m20*m33 - m00*m21*m33;
	result[7] = m01*m22*m30 - m02*m21*m30 + m02*m20*m31 - m00*m22*m31 - m01*m20*m32 + m00*m21*m32;
	
	// Third Column
	result[8] = m02*m13*m31 - m03*m12*m31 + m03*m11*m32 - m01*m13*m32 - m02*m11*m33 + m01*m12*m33;
	result[9] = m03*m12*m30 - m02*m13*m30 - m03*m10*m32 + m00*m13*m32 + m02*m10*m33 - m00*m12*m33;
	result[10] = m01*m13*m30 - m03*m11*m30 + m03*m10*m31 - m00*m13*m31 - m01*m10*m33 + m00*m11*m33;
	result[11] = m02*m11*m30 - m01*m12*m30 - m02*m10*m31 + m00*m12*m31 + m01*m10*m32 - m00*m11*m32;
	
	// Fourth Column
	result[12] = m03*m12*m21 - m02*m13*m21 - m03*m11*m22 + m01*m13*m22 + m02*m11*m23 - m01*m12*m23;
	result[13] = m02*m13*m20 - m03*m12*m20 + m03*m10*m22 - m00*m13*m22 - m02*m10*m23 + m00*m12*m23;
	result[14] = m03*m11*m20 - m01*m13*m20 - m03*m10*m21 + m00*m13*m21 + m01*m10*m23 - m00*m11*m23;
	result[15] = m01*m12*m20 - m02*m11*m20 + m02*m10*m21 - m00*m12*m21 - m01*m10*m22 + m00*m11*m22;
}

/*!
 *					Finds the determinant.
 *
 *					The determinant is a scale value which represents the matrix diagonals.
 *	
 *	@param			original
 *					The matrix to be inverted.
 *
 *	@result			The determinant scalar value.
 */
NGL_INLINE float nglMatrixDeterminant(NGLmat4 original)
{
	float m00 = original[0], m01 = original[4], m02 = original[8], m03 = original[12];
	float m10 = original[1], m11 = original[5], m12 = original[9], m13 = original[13];
	float m20 = original[2], m21 = original[6], m22 = original[10], m23 = original[14];
	float m30 = original[3], m31 = original[7], m32 = original[11], m33 = original[15];
	
	// Calculates the sub-determinants for each set of 2x2.
	float value = 
	m03*m12*m21*m30 - m02*m13*m21*m30 - m03*m11*m22*m30 + m01*m13*m22*m30+
	m02*m11*m23*m30 - m01*m12*m23*m30 - m03*m12*m20*m31 + m02*m13*m20*m31+
	m03*m10*m22*m31 - m00*m13*m22*m31 - m02*m10*m23*m31 + m00*m12*m23*m31+
	m03*m11*m20*m32 - m01*m13*m20*m32 - m03*m10*m21*m32 + m00*m13*m21*m32+
	m01*m10*m23*m32 - m00*m11*m23*m32 - m02*m11*m20*m33 + m01*m12*m20*m33+
	m02*m10*m21*m33 - m00*m12*m21*m33 - m01*m10*m22*m33 + m00*m11*m22*m33;
	
	return value;
}

/*!
 *					Normalize a matrix.
 *
 *					The matrix normalization involves all the 
 *	
 *	@param			original
 *					The matrix to be normalized.
 *
 *	@param			result
 *					The matrix which will receive the result.
 */
NGL_INLINE void nglMatrixNormalize(NGLmat4 original, NGLmat4 result)
{
	float m00 = original[0], m01 = original[4], m02 = original[8];
	float m10 = original[1], m11 = original[5], m12 = original[9];
	float m20 = original[2], m21 = original[6], m22 = original[10];
	float mag;
	
	// Right vector length.
	mag = sqrtf(m00*m00 + m01*m01 + m02*m02);
	result[0] = m00/mag;
	result[4] = m01/mag;
	result[8] = m02/mag;
	
	// Up vector length.
	mag = sqrtf(m10*m10 + m11*m11 + m12*m12);
	result[1] = m10/mag;
	result[5] = m11/mag;
	result[9] = m12/mag;
	
	// Look vector length.
	mag = sqrtf(m20*m20 + m21*m21 + m22*m22);
	result[2] = m20/mag;
	result[6] = m21/mag;
	result[10] = m22/mag;
}

/*!
 *					Isolates the rotation matrix, discarding scale and translation components.
 *
 *					If the original matrix contains scale information, those information will
 *					be ignored.
 *	
 *	@param			original
 *					The matrix to extract rotation from.
 *
 *	@param			result
 *					The matrix which will receive the result.
 */
NGL_INLINE void nglMatrixIsolateRotation(NGLmat4 original, NGLmat4 result)
{
	float m00 = original[0], m01 = original[4], m02 = original[8];
	float m10 = original[1], m11 = original[5], m12 = original[9];
	float m20 = original[2], m21 = original[6], m22 = original[10];
	float mag;
	
	// The length of the vector formed by the first column represents the scale X.
	// Then divides it by the Right vector to get the original rotation, without scales.
	mag = sqrtf(m00*m00 + m10*m10 + m20*m20);
	result[0] = m00/mag;
	result[1] = m10/mag;
	result[2] = m20/mag;
	result[3] = 0.0f;
	
	// The length of the vector formed by the second column represents the scale Y.
	// Then divides it by the Up vector to get the original rotation, without scales.
	mag = sqrtf(m01*m01 + m11*m11 + m21*m21);
	result[4] = m01/mag;
	result[5] = m11/mag;
	result[6] = m21/mag;
	result[7] = 0.0f;
	
	// The length of the vector formed by the third column represents the scale Z.
	// Then divides it by the Front vector to get the original rotation, without scales.
	mag = sqrtf(m02*m02 + m12*m12 + m22*m22);
	result[8] = m02/mag;
	result[9] = m12/mag;
	result[10] = m22/mag;
	result[11] = 0.0f;
	
	result[12] = 0.0f;
	result[13] = 0.0f;
	result[14] = 0.0f;
	result[15] = 1.0f;
}

/*!
 *					Describes a matrix.
 *
 *					A user friendly representation will be shown on console panel. The representation
 *					will use traditional mathematic notation (row-major format), like this:
 *
 *					<pre>
 *
 *					| 0  1  2  3  |
 *					|             |
 *					| 4  5  6  7  |
 *					|             |
 *					| 8  9  10 11 |
 *					|             |
 *					| 12 13 14 15 |
 *
 *					</pre>
 *	
 *	@param			original
 *					The matrix to be described.
 */
NGL_INLINE void nglMatrixDescribe(NGLmat4 original)
{
	NSString *describe = [NSString stringWithFormat:
						  @"|%f  %f  %f  %f|\n|%f  %f  %f  %f|\n|%f  %f  %f  %f|\n|%f  %f  %f  %f|",
						  original[0],original[4],original[8],original[12],
						  original[1],original[5],original[9],original[13],
						  original[2],original[6],original[10],original[14],
						  original[3],original[7],original[11],original[15]];
	
	NSLog(@"Describe matrix:\n%@", describe);
}