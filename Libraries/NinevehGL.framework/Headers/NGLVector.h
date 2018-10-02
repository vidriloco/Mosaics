/*
 *	NGLVector.h
 *	
 *	The NinevehGL Engine is a free 3D engine to work with OpenGL programmable pipeline, made with pure
 *	Objective-C for iOS (iPhone, iPad and iPod Touch). NinevehGL is prepared to import 3D file with the
 *	formats:
 *		- WaveFront OBJ file (.obj);
 *		- COLLADA file (.dae).
 *
 *	More information at the official web site: http://nineveh.gl
 *	
 *	Created by Diney Bomfim on 4/9/11.
 *	Copyright (c) 2011 DB-Interactively. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "NGLDataType.h"
#import "NGLMatrix.h"
#import "NGLMath.h"

#pragma mark -
#pragma mark Fixed Functions
#pragma mark -
//**********************************************************************************************************
//
//  Fixed Functions
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Color Functions
//**************************************************
//	Color Functions
//**************************************************

/*!
 *					This function generates a color based on RGBA parameters.
 *
 *					The colors in OpenGL should be clamped to (0.0, 1.0), so this function will clamp the
 *					values to that range automatically.
 *	
 *	@param			r
 *					The red channel/component of the color.
 *	
 *	@param			g
 *					The green channel/component of the color.
 *	
 *	@param			b
 *					The blue channel/component of the color.
 *	
 *	@param			a
 *					The alpha channel/component of the color.
 *
 *	@result			A NGLvec4 with the desired color.
 */
NGL_INLINE NGLvec4 nglColorMake(float r, float g, float b, float a)
{
	r = nglClamp(r, 0.0f, 1.0f);
	g = nglClamp(g, 0.0f, 1.0f);
	b = nglClamp(b, 0.0f, 1.0f);
	a = nglClamp(a, 0.0f, 1.0f);
	
	NGLvec4 color = (NGLvec4){r,g,b,a};
	
	return color;
}

/*!
 *					This function generates a color based on RGBA values. Each value is in range [0, 255].
 *	
 *	@param			r
 *					The red channel/component of the color.
 *	
 *	@param			g
 *					The green channel/component of the color.
 *	
 *	@param			b
 *					The blue channel/component of the color.
 *	
 *	@param			a
 *					The alpha channel/component of the color.
 *
 *	@result			A NGLvec4 with the desired color.
 */
NGL_INLINE NGLvec4 nglColorFromRGBA(unsigned short r, unsigned short g, unsigned short b, unsigned short a)
{
	float rf = (float)r / 255.0f;
	float gf = (float)g / 255.0f;
	float bf = (float)b / 255.0f;
	float af = (float)a / 255.0f;
	
	return nglColorMake(rf, gf, bf, af);
}

/*!
 *					This function generates a color based on an hexadecimal color. This color will be
 *					opaque, that means, its alpha component will be 1.0. The hexadecimal value must be in
 *					RGB format (0xNNNNNN).
 *	
 *	@param			hex
 *					A color in hexadecimal notation (0xNNNNNN).
 *
 *	@result			A NGLvec4 with the desired color.
 */
NGL_INLINE NGLvec4 nglColorFromHexadecimal(unsigned int hex)
{
	return nglColorFromRGBA((hex >> 16) & 0xFF, (hex >> 8) & 0xFF, (hex >> 0) & 0xFF, 255);
}

/*!
 *					This function generates a color based on an UIColor, it must be in RGB color space.
 *	
 *	@param			color
 *					An UIColor instance.
 *
 *	@result			A NGLvec4 with the desired color.
 */
NGL_INLINE NGLvec4 nglColorFromUIColor(UIColor *uiColor)
{
	NGLvec4 color = (NGLvec4){0.0f, 0.0f, 0.0f, 0.0f};
	
	[uiColor getRed:&color.r green:&color.g blue:&color.b alpha:&color.a];
	
	return color;
}

/*!
 *					Checks if the color is not a black one.
 *
 *					This check ignores the alpha channel/component, checking only the true colors.
 *	
 *	@param			color
 *					A NGLvec4 with the color to check.
 *
 *	@result			A BOOL data type indicating if the color is not black. Returns 0 if it's black.
 */
NGL_INLINE BOOL nglColorNotBlack(NGLvec4 color)
{
	return (color.x != 0.0f || color.y != 0.0f || color.z != 0.0f);
}

#pragma mark -
#pragma mark Vec2 Functions
//**************************************************
//	Vec2 Functions
//**************************************************

/*!
 *					Checks if informed vector is null.
 *
 *					A vector is considered null if all its values are equal to 0.0.
 *	
 *	@param			vec
 *					A NGLvec2 to check.
 *
 *	@result			A BOOL data type indicating if the vector is null. Returns 1 if it's null.
 */
NGL_INLINE BOOL nglVec2IsZero(NGLvec2 vec)
{
	return (vec.x == 0.0f && vec.y == 0.0f);
}

/*!
 *					Checks if informed vector A is equal to the vector B.
 *
 *					Two vectors are considered equals if all its values are equals.
 *	
 *	@param			vecA
 *					The vector A.
 *	
 *	@param			vecB
 *					The vector B.
 *
 *	@result			A BOOL data type indicating if the vectors are equals. Returns 1 if they are equals.
 */
NGL_INLINE BOOL nglVec2IsEqual(NGLvec2 vecA, NGLvec2 vecB)
{
	return (vecA.x == vecB.x && vecA.y == vecB.y);
}

/*!
 *					Calculates the length of a vector.
 *
 *					The length of a vector, also known as magnitude, is calculated using the
 *					Pythagorean Theorem and represents the size of a vector.
 *
 *					<pre>
 *					           __    ___
 *					          /        /|
 *					         /        / |
 *					 Length /        / 
 *					       /        /  Vector
 *					      /__      /
 *					             {0.0, 0.0, 0.0}
 *
 *					</pre>
 *
 *					It's said "unit vector" that which has it's length equal to 1.0.
 *
 *	@param			vec
 *					The vector to extract its length.
 *
 *	@result			A float data type with its length.
 */
NGL_INLINE float nglVec2Length(NGLvec2 vec)
{
	return sqrtf(vec.x * vec.x + vec.y * vec.y);
}

/*!
 *					Normalizes the values inside a vector to make it an "unit vector".
 *
 *					It's said "unit vector" that which has it's length equal to 1.0.
 *
 *	@param			vec
 *					The vector to be normalized.
 *
 *	@result			The returning vector normalized.
 */
NGL_INLINE NGLvec2 nglVec2Normalize(NGLvec2 vec)
{
	// Find the magnitude/length. This variable is called inverse magnitude (iMag)
	// because instead divide each element by this magnitude, let's do multiplication, is faster.
	float iMag = nglVec2Length(vec);
	
	// Avoid divisions by 0.
	if (iMag != 0.0f)
	{
		iMag = 1.0f / iMag;
		
		vec.x *= iMag;
		vec.y *= iMag;
	}
	
	return vec;
}

/*!
 *					Indentifies NaN values and set them to 0 (zero).
 *
 *	@param			vec
 *					The vector.
 *
 *	@result			The returning cleared vector.
 */
NGL_INLINE NGLvec2 nglVec2Cleared(NGLvec2 vec)
{
	NGLvec2 cleared;
	cleared.x = nglIsNaN(vec.x) ? 0.0f : vec.x;
	cleared.y = nglIsNaN(vec.y) ? 0.0f : vec.y;
	
	return cleared;
}

/*!
 *					Adds two vectors.
 *
 *					The sum of two vectors produces a new vector which has direction and magnitude in
 *					the middle of the originals.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning added vector.
 */
NGL_INLINE NGLvec2 nglVec2Add(NGLvec2 vecA, NGLvec2 vecB)
{
	return (NGLvec2){vecA.x + vecB.x, vecA.y + vecB.y};
}

/*!
 *					Subtracts vector B from the vector A.
 *
 *					The of parameters is important here. The subtraction is also known as distance.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning subtracted vector.
 */
NGL_INLINE NGLvec2 nglVec2Subtract(NGLvec2 vecA, NGLvec2 vecB)
{
	return (NGLvec2){vecA.x - vecB.x, vecA.y - vecB.y};
}

/*!
 *					Multiplies two vectors.
 *
 *					This is not the Cross product neither the Dot product. This function just multiply
 *					their scalar values.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning multiplied vector.
 */
NGL_INLINE NGLvec2 nglVec2Multiply(NGLvec2 vecA, NGLvec2 vecB)
{
	return (NGLvec2){vecA.x * vecB.x, vecA.y * vecB.y};
}

/*!
 *					Multiplies vector by a scalar value.
 *
 *					The scalar value is multiplied by each element of the vector.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			value
 *					The floating number.
 *
 *	@result			The returning multiplied vector.
 */
NGL_INLINE NGLvec2 nglVec2Multiplyf(NGLvec2 vecA, float value)
{
	return (NGLvec2){vecA.x * value, vecA.y * value};
}

/*!
 *					Finds the dot product of two vectors.
 *
 *					The dot product returns the cosine of the angle formed by two vectors.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			A float data type with the dot product.
 */
NGL_INLINE float nglVec2Dot(NGLvec2 vecA, NGLvec2 vecB)
{
	return vecA.x * vecB.x + vecA.y * vecB.y;
}

/*!
 *					Multiplies a vector by a matrix.
 *
 *					The matrix is always given as a 4x4 matrix, but the returning vector depends on the
 *					input vector type.
 *
 *	@param			vec
 *					The vector to be multiplied by a matrix.
 *
 *	@param			matrix
 *					The matrix 4x4.
 *
 *	@result			A vector altered by the matrix.
 */
NGL_INLINE NGLvec2 nglVec2ByMatrix(NGLvec2 vec, NGLmat4 matrix)
{
	NGLvec2 result;
	
	result.x = vec.x * matrix[0] + vec.y * matrix[1] + matrix[3];
	result.y = vec.x * matrix[4] + vec.y * matrix[5] + matrix[7];
	
	return result;
}

#pragma mark -
#pragma mark Vec3 Functions
//**************************************************
//	Vec3 Functions
//**************************************************

/*!
 *					Checks if informed vector is null.
 *
 *					A vector is considered null if all its values are equal to 0.0.
 *	
 *	@param			vec
 *					A NGLvec2 to check.
 *
 *	@result			A BOOL data type indicating if the vector is null. Returns 1 if it's null.
 */
NGL_INLINE BOOL nglVec3IsZero(NGLvec3 vec)
{
	return (vec.x == 0.0f && vec.y == 0.0f && vec.z == 0.0f);
}

/*!
 *					Checks if informed vector A is equal to the vector B.
 *
 *					Two vectors are considered equals if all its values are equals.
 *	
 *	@param			vecA
 *					The vector A.
 *	
 *	@param			vecB
 *					The vector B.
 *
 *	@result			A BOOL data type indicating if the vectors are equals. Returns 1 if they are equals.
 */
NGL_INLINE BOOL nglVec3IsEqual(NGLvec3 vecA, NGLvec3 vecB)
{
	return (vecA.x == vecB.x && vecA.y == vecB.y && vecA.z == vecB.z);
}

/*!
 *					Calculates the length of a vector.
 *
 *					The length of a vector, also known as magnitude, is calculated using the
 *					Pythagorean Theorem and represents the size of a vector.
 *
 *					<pre>
 *					           __  ___
 *					          /      /|
 *					         /      / |
 *					 Length /      / 
 *					       /      /  Vector
 *					      /__    /
 *					             0, 0, 0
 *
 *					</pre>
 *
 *					It's said "unit vector" that which has it's length equal to 1.0.
 *
 *	@param			vec
 *					The vector to extract its length.
 *
 *	@result			A float data type with its length.
 */
NGL_INLINE float nglVec3Length(NGLvec3 vec)
{
	return sqrtf(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
}

/*!
 *					Normalizes the values inside a vector to make it an "unit vector".
 *
 *					It's said "unit vector" that which has it's length equal to 1.0.
 *
 *	@param			vec
 *					The vector to be normalized.
 *
 *	@result			The returning vector normalized.
 */
NGL_INLINE NGLvec3 nglVec3Normalize(NGLvec3 vec)
{
	// Find the magnitude/length. This variable is called inverse magnitude (iMag)
	// because instead divide each element by this magnitude, let's do multiplication, is faster.
	float iMag = nglVec3Length(vec);
	
	// Avoid divisions by 0.
	if (iMag != 0.0f)
	{
		iMag = 1.0f / iMag;
		
		vec.x *= iMag;
		vec.y *= iMag;
		vec.z *= iMag;
	}
	
	return vec;
}

/*!
 *					Indentifies NaN values and set them to 0 (zero).
 *
 *	@param			vec
 *					The vector.
 *
 *	@result			The returning cleared vector.
 */
NGL_INLINE NGLvec3 nglVec3Cleared(NGLvec3 vec)
{
	NGLvec3 cleared;
	cleared.x = nglIsNaN(vec.x) ? 0.0f : vec.x;
	cleared.y = nglIsNaN(vec.y) ? 0.0f : vec.y;
	cleared.z = nglIsNaN(vec.z) ? 0.0f : vec.z;
	
	return cleared;
}

/*!
 *					Adds two vectors.
 *
 *					The sum of two vectors produces a new vector which has direction and magnitude in
 *					the middle of the originals.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning added vector.
 */
NGL_INLINE NGLvec3 nglVec3Add(NGLvec3 vecA, NGLvec3 vecB)
{
	return (NGLvec3){vecA.x + vecB.x, vecA.y + vecB.y, vecA.z + vecB.z};
}

/*!
 *					Subtracts vector B from the vector A.
 *
 *					The of parameters is important here. The subtraction is also known as distance.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning subtracted vector.
 */
NGL_INLINE NGLvec3 nglVec3Subtract(NGLvec3 vecA, NGLvec3 vecB)
{
	return (NGLvec3){vecA.x - vecB.x, vecA.y - vecB.y, vecA.z - vecB.z};
}

/*!
 *					Multiplies two vectors.
 *
 *					This is not the Cross product neither the Dot product. This function just multiply
 *					their scalar values.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning multiplied vector.
 */
NGL_INLINE NGLvec3 nglVec3Multiply(NGLvec3 vecA, NGLvec3 vecB)
{
	return (NGLvec3){vecA.x * vecB.x, vecA.y * vecB.y, vecA.z * vecB.z};
}

/*!
 *					Multiplies vector by a scalar value.
 *
 *					The scalar value is multiplied by each element of the vector.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			value
 *					The floating number.
 *
 *	@result			The returning multiplied vector.
 */
NGL_INLINE NGLvec3 nglVec3Multiplyf(NGLvec3 vecA, float value)
{
	return (NGLvec3){vecA.x * value, vecA.y * value, vecA.z * value};
}

/*!
 *					Finds the dot product of two vectors.
 *
 *					The dot product returns the cosine of the angle formed by two vectors.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			A float data type with the dot product.
 */
NGL_INLINE float nglVec3Dot(NGLvec3 vecA, NGLvec3 vecB)
{
	return vecA.x * vecB.x + vecA.y * vecB.y + vecA.z * vecB.z;
}

/*!
 *					Finds the cross product of two vectors.
 *
 *					The cross product returns a new vector that is orthogonal with the other two,
 *					that means, the new vector is mutually perpendicular to the other two.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			A vector which is perpendicular to two inputs.
 */
NGL_INLINE NGLvec3 nglVec3Cross(NGLvec3 vecA, NGLvec3 vecB)
{
	NGLvec3 vec;
	
	vec.x = vecA.y * vecB.z - vecA.z * vecB.y;
	vec.y = vecA.z * vecB.x - vecA.x * vecB.z;
	vec.z = vecA.x * vecB.y - vecA.y * vecB.x;
	
	return vec;
}

/*!
 *					Multiplies a vector by a matrix.
 *
 *					The matrix is always given as a 4x4 matrix, but the returning vector depends on the
 *					input vector type.
 *
 *	@param			vec
 *					The vector A.
 *
 *	@param			matrix
 *					The matrix 4x4.
 *
 *	@result			A vector altered by the matrix.
 */
NGL_INLINE NGLvec3 nglVec3ByMatrix(NGLvec3 vec, NGLmat4 matrix)
{
	NGLvec3 result;
	
	result.x = vec.x * matrix[0] + vec.y * matrix[4] + vec.z * matrix[8] + matrix[12];
	result.y = vec.x * matrix[1] + vec.y * matrix[5] + vec.z * matrix[9] + matrix[13];
	result.z = vec.x * matrix[2] + vec.y * matrix[6] + vec.z * matrix[10] + matrix[14];
	
	return result;
}

/*!
 *					Multiplies a vector by the transposed of a matrix, if the matrix is orthogonal, the
 *					transposed matrix is equal the its inverse.
 *
 *					The matrix is always given as a 4x4 matrix, but the returning vector depends on the
 *					input vector type.
 *
 *	@param			vec
 *					The vector A.
 *
 *	@param			matrix
 *					The matrix 4x4.
 *
 *	@result			A vector altered by the matrix.
 */
NGL_INLINE NGLvec3 nglVec3ByMatrixTransposed(NGLvec3 vec, NGLmat4 matrix)
{
	NGLvec3 result;
	
	result.x = vec.x * matrix[0] + vec.y * matrix[1] + vec.z * matrix[2] + matrix[3];
	result.y = vec.x * matrix[4] + vec.y * matrix[5] + vec.z * matrix[6] + matrix[7];
	result.z = vec.x * matrix[8] + vec.y * matrix[9] + vec.z * matrix[10] + matrix[11];
	
	return result;
}

/*!
 *					Extract the euler angles from a rotation matrix.
 *
 *					The matrix needs to be orthogonal, rotation isolated and column-major format.
 *					The returning values are given in degrees and represents the rotation in relation to
 *					the first and second quadrants of the circle, that means, the returning values stay
 *					in the range [-180.0, 180.0].
 *
 *					This is the column-major format:
 *
 *					<pre>
 *
 *					| 0  4  8  12 |
 *					|             |
 *					| 1  5  9  13 |
 *					|             |
 *					| 2  6  10 14 |
 *					|             |
 *					| 3  7  11 15 |
 *
 *					</pre>
 *
 *	@param			matrix
 *					The matrix 4x4.
 *
 *	@result			A vector extracted from a rotation matrix.
 */
NGL_INLINE NGLvec3 nglVec3FromMatrix(NGLmat4 matrix)
{
	NGLvec3 euler;
	
	// North pole.
	if (matrix[1] > 0.98f)
	{
		euler.y = atan2f(matrix[8], matrix[10]);
		euler.z = kNGL_PI2;
		euler.x = 0.0f;
	}
	// South pole
	else if (matrix[1] < -0.98f)
	{
		euler.y = atan2f(matrix[8], matrix[10]);
		euler.z = -kNGL_PI2;
		euler.x = 0.0f;
	}
	// Outside the poles.
	else
	{
		euler.y = atan2f(-matrix[2], matrix[0]);
		euler.z = asinf(matrix[1]);
		euler.x = atan2f(-matrix[9], matrix[5]);
	}
	
	// Converts values into degrees, they are in radians.
	euler.y = nglRadiansToDegrees(euler.y);
	euler.z = nglRadiansToDegrees(euler.z);
	euler.x = nglRadiansToDegrees(euler.x);
	
	return euler;
}

#pragma mark -
#pragma mark Vec4 Functions
//**************************************************
//	Vec4 Functions
//**************************************************

/*!
 *					Checks if informed vector is null.
 *
 *					A vector is considered null if all its values are equal to 0.0.
 *	
 *	@param			vec
 *					A NGLvec4 to check.
 *
 *	@result			A BOOL data type indicating if the vector is null. Returns 1 if it's null.
 */
NGL_INLINE BOOL nglVec4IsZero(NGLvec4 vec)
{
	return (vec.x == 0.0f && vec.y == 0.0f && vec.z == 0.0f && vec.w == 0.0f);
}

/*!
 *					Checks if informed vector A is equal to the vector B.
 *
 *					Two vectors are considered equals if all its values are equals.
 *	
 *	@param			vecA
 *					The vector A.
 *	
 *	@param			vecB
 *					The vector B.
 *
 *	@result			A BOOL data type indicating if the vectors are equals. Returns 1 if they are equals.
 */
NGL_INLINE BOOL nglVec4IsEqual(NGLvec4 vecA, NGLvec4 vecB)
{
	return (vecA.x == vecB.x && vecA.y == vecB.y && vecA.z == vecB.z && vecA.w == vecB.w);
}

/*!
 *					Calculates the length of a vector.
 *
 *					The length of a vector, also known as magnitude, is calculated using the
 *					Pythagorean Theorem and represents the size of a vector.
 *
 *					<pre>
 *					           __  ___
 *					          /      /|
 *					         /      / |
 *					 Length /      / 
 *					       /      /  Vector
 *					      /__    /
 *					             0, 0, 0
 *
 *					</pre>
 *
 *					It's said "unit vector" that which has it's length equal to 1.0.
 *
 *	@param			vec
 *					The vector to extract its length.
 *
 *	@result			A float data type with its length.
 */
NGL_INLINE float nglVec4Length(NGLvec4 vec)
{
	return sqrtf(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z + vec.w * vec.w);
}

/*!
 *					Normalizes the values inside a vector to make it an "unit vector".
 *
 *					It's said "unit vector" that which has it's length equal to 1.0.
 *
 *	@param			vec
 *					The vector to be normalized.
 *
 *	@result			The returning vector normalized.
 */
NGL_INLINE NGLvec4 nglVec4Normalize(NGLvec4 vec)
{
	// Find the magnitude/length. This variable is called inverse magnitude (iMag)
	// because instead divide each element by this magnitude, let's do multiplication, is faster.
	float iMag = nglVec4Length(vec);
	
	// Avoid divisions by 0.
	if (iMag != 0.0f)
	{
		iMag = 1.0f / iMag;
		
		vec.x *= iMag;
		vec.y *= iMag;
		vec.z *= iMag;
		vec.w *= iMag;
	}
	
	return vec;
}

/*!
 *					Indentifies NaN values and set them to 0 (zero).
 *
 *	@param			vec
 *					The vector.
 *
 *	@result			The returning cleared vector.
 */
NGL_INLINE NGLvec4 nglVec4Cleared(NGLvec4 vec)
{
	NGLvec4 cleared;
	cleared.x = nglIsNaN(vec.x) ? 0.0f : vec.x;
	cleared.y = nglIsNaN(vec.y) ? 0.0f : vec.y;
	cleared.z = nglIsNaN(vec.z) ? 0.0f : vec.z;
	cleared.w = nglIsNaN(vec.w) ? 0.0f : vec.w;
	
	return cleared;
}

/*!
 *					Adds two vectors.
 *
 *					The sum of two vectors produces a new vector which has direction and magnitude in
 *					the middle of the originals.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning added vector.
 */
NGL_INLINE NGLvec4 nglVec4Add(NGLvec4 vecA, NGLvec4 vecB)
{
	return (NGLvec4){vecA.x + vecB.x, vecA.y + vecB.y, vecA.z + vecB.z, vecA.w + vecB.w};
}

/*!
 *					Subtracts vector B from the vector A.
 *
 *					The of parameters is important here. The subtraction is also known as distance.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning subtracted vector.
 */
NGL_INLINE NGLvec4 nglVec4Subtract(NGLvec4 vecA, NGLvec4 vecB)
{
	return (NGLvec4){vecA.x - vecB.x, vecA.y - vecB.y, vecA.z - vecB.z, vecA.w - vecB.w};
}

/*!
 *					Multiplies two vectors.
 *
 *					This is not the Cross product neither the Dot product. This function just multiply
 *					their scalar values.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			The returning multiplied vector.
 */
NGL_INLINE NGLvec4 nglVec4Multiply(NGLvec4 vecA, NGLvec4 vecB)
{
	return (NGLvec4){vecA.x * vecB.x, vecA.y * vecB.y, vecA.z * vecB.z, vecA.w * vecB.w};
}

/*!
 *					Multiplies vector by a scalar value.
 *
 *					The scalar value is multiplied by each element of the vector.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			value
 *					The floating number.
 *
 *	@result			The returning multiplied vector.
 */
NGL_INLINE NGLvec4 nglVec4Multiplyf(NGLvec4 vecA, float value)
{
	return (NGLvec4){vecA.x * value, vecA.y * value, vecA.z * value, vecA.w * value};
}

/*!
 *					Finds the dot product of two vectors.
 *
 *					The dot product returns the cosine of the angle formed by two vectors.
 *
 *	@param			vecA
 *					The vector A.
 *
 *	@param			vecB
 *					The vector B.
 *
 *	@result			A float data type with the dot product.
 */
NGL_INLINE float nglVec4Dot(NGLvec4 vecA, NGLvec4 vecB)
{
	return vecA.x * vecB.x + vecA.y * vecB.y + vecA.z * vecB.z + vecA.w * vecB.w;
}

/*!
 *					Multiplies a vector by a matrix.
 *
 *					The matrix is always given as a 4x4 matrix, but the returning vector depends on the
 *					input vector type.
 *
 *	@param			vec
 *					The vector A.
 *
 *	@param			matrix
 *					The matrix 4x4.
 *
 *	@result			A vector altered by the matrix.
 */
NGL_INLINE NGLvec4 nglVec4ByMatrix(NGLvec4 vec, NGLmat4 matrix)
{
	NGLvec4 result;
	
	result.x = vec.x * matrix[0] + vec.y * matrix[1] + vec.z * matrix[2] + vec.w * matrix[3];
	result.y = vec.x * matrix[4] + vec.y * matrix[5] + vec.z * matrix[6] + vec.w * matrix[7];
	result.z = vec.x * matrix[8] + vec.y * matrix[9] + vec.z * matrix[10] + vec.w * matrix[11];
	result.w = vec.x * matrix[12] + vec.y * matrix[13] + vec.z * matrix[14] + vec.w * matrix[15];
	
	return result;
}