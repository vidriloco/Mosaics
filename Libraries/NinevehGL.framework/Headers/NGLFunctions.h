/*
 *	NGLFunctions.h
 *	
 *	The NinevehGL Engine is a free 3D engine to work with OpenGL programmable pipeline, made with pure
 *	Objective-C for iOS (iPhone, iPad and iPod Touch). NinevehGL is prepared to import 3D file with the
 *	formats:
 *		- WaveFront OBJ file (.obj);
 *		- COLLADA file (.dae).
 *
 *	More information at the official web site: http://nineveh.gl
 *
 *	Created by Diney Bomfim on 2/2/11.
 *	Copyright (c) 2011 DB-Interactively. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "NGLRuntime.h"
#import "NGLGlobal.h"

#pragma mark -
#pragma mark Fixed Variables
#pragma mark -
//**********************************************************************************************************
//
//	Fixed Variables
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Fixed Functions
#pragma mark -
//**********************************************************************************************************
//
//	Fixed Functions
//
//**********************************************************************************************************

/*!
 *					Retrieves the file's name + file's extension.
 *
 *					If the path contains only the file, with its extension or not, itself will be returned.
 *
 *	@param			named
 *					A NSString (name or path) containing the file's name + file's extension.
 *
 *	@result			An autoreleased NSString containing the result.
 */
NGL_INLINE NSString *nglGetFile(NSString *named)
{
	NSRange range;
	
	// Prevent Microsoft Windows path file format.
	named = [named stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
	
	range = [named rangeOfString:@"/" options:NSBackwardsSearch];
	
	if (range.length > 0)
	{
		named = [named substringFromIndex:range.location + 1];
	}
	
	return named;
}

/*!
 *					Retrieves the file's extension only.
 *
 *					If there is no extension, a blank value will be returned (@"").
 *
 *	@param			named
 *					A NSString (name or path) containing the file's extension.
 *
 *	@result			An autoreleased NSString containing the result.
 */
NGL_INLINE NSString *nglGetFileExtension(NSString *named)
{
	NSRange range;
	NSString *type = @"";
	
	// Isolates the file extension.
	range = [named rangeOfString:@"." options:NSBackwardsSearch];
	
	if (range.length > 0)
	{
		type = [named substringFromIndex:range.location + 1];
	}
	
	return type;
}

/*!
 *					Retrieves the file's name only.
 *
 *					This function ignores the file's extension if it exists.
 *
 *	@param			named
 *					A NSString (name or path) containing the file's name.
 *
 *	@result			An autoreleased NSString containing the result.
 */
NGL_INLINE NSString *nglGetFileName(NSString *named)
{
	NSRange range;
	
	// Gets the file name + extension.
	named = nglGetFile(named);
	
	// Using range and substringToIndex: is around 70% faster than stringByDeletingPathExtension: method
	range = [named rangeOfString:@"." options:NSBackwardsSearch];
	
	if (range.length > 0)
	{
		named = [named substringToIndex:range.location];
	}
	
	return named;
}

/*!
 *					Retrieves the path only.
 *
 *					This function ignores any file in the path and returns only the path. If there's
 *					only the file, without a path, in the input parameter, a blank string will be
 *					returned (@"").
 *
 *	@param			named
 *					A NSString (name or path) containing a system path to be isolated.
 *
 *	@result			An autoreleased NSString containing the result.
 */
NGL_INLINE NSString *nglGetPath(NSString *named)
{
	NSString *pathOnly;
	NSRange range = [named rangeOfString:nglGetFile(named)];
	
	// Checks if the path contains a file at the end to extract it, if necessary.
	if (range.length > 0)
	{
		pathOnly = [named substringToIndex:range.location];
	}
	
	return pathOnly;
}

/*!
 *					Makes the real path based on the input path.
 *
 *					If the file is found with the input path, itself will be returned, without
 *					changes. But if the file was not found in the input path, the NinevehGL Global Path
 *					will be returned in place.
 *
 *	@param			named
 *					A NSString (name or path) containing the file's name.
 *
 *	@result			An autoreleased NSString containing the result.
 */
NGL_INLINE NSString *nglMakePath(NSString *named)
{
	NSString *fullPath;
	
	// Prevent Microsoft Windows path files.
	named = [named stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
	
	// Assuming the path already contains the file path, checks if the file exist,
	// in afirmative case use it, otherwise, uses the default file path.
	if ([[NSFileManager defaultManager] fileExistsAtPath:named])
	{
		fullPath = named;
	}
	else
	{
		// Initializes the default path once.
		if (nglDefaultPath == nil)
		{
			nglGlobalFilePath([[NSBundle mainBundle] bundlePath]);
		}
		
		fullPath = [nglDefaultPath stringByAppendingPathComponent:nglGetFile(named)];
	}
	
	return fullPath;
}

/*!
 *					Loads the source from a file using the NinevehGL Global Path API.
 *
 *					This function doesn't use NSData, so it can't load binary files.
 *
 *	@param			named
 *					A NSString (name or path) containing the file's name.
 *
 *	@result			An autoreleased NSString containing the result.
 */
NGL_INLINE NSString *nglSourceFromFile(NSString *named)
{
	return [NSString stringWithContentsOfFile:nglMakePath(named) encoding:NSUTF8StringEncoding error:nil];
}

/*!
 *					Loads the source from a file using the NinevehGL Global Path API.
 *
 *					This function returns an autoreleased instance of NSData. This function is indicated
 *					to load binary files.
 *
 *	@param			named
 *					A NSString (name or path) containing the file's name.
 *
 *	@result			An autoreleased NSData containing the result.
 */
NGL_INLINE NSData *nglDataFromFile(NSString *named)
{
	return [NSData dataWithContentsOfFile:nglMakePath(named)];
}

/*!
 *					Extracts a content from a NSString without including the pattern.
 *
 *					This function extracts the string between two patterns without including them in the
 *					result. For example:
 *
 *					<pre>
 *
 *					nglRangeWithout(@"is", @"string", @"This is a test string");
 *
 *					// The line above will result in @" a test "
 *
 *					</pre>
 *
 *					If there is more than one pattern, just the first match will be used.
 *
 *	@param			init
 *					A NSString containing the initial pattern.
 *
 *	@param			end
 *					A NSString containing the end pattern.
 *
 *	@param			source
 *					A NSString containing the source string.
 *
 *	@result			A NSRange containing the result.
 */
NGL_INLINE NSRange nglRangeWithout(NSString *init, NSString *end, NSString *source)
{
	int start;
	NSRange range;
	
	range = [source rangeOfString:init];
	
	start = range.location + range.length;
	source = [source substringFromIndex:start];
	
	range.location = start;
	range.length = [source rangeOfString:end].location;
	
	return range;
}

/*!
 *					Extracts content from a NSString including the final pattern.
 *
 *					This function extracts the string between two patterns including the last pattern in
 *					the result. For example:
 *					<pre>
 *
 *					nglRangeWithout(@"is", @"string", @"This is a test string");
 *
 *					// The line above will result in @" a test string"
 *
 *					</pre>
 *
 *					If there is more than one pattern, just the first match will be used.
 *
 *	@param			init
 *					A NSString containing the initial pattern.
 *
 *	@param			end
 *					A NSString containing the end pattern.
 *
 *	@param			source
 *					A NSString containing the source string.
 *
 *	@result			A NSRange containing the result.
 */
NGL_INLINE NSRange nglRangeWith(NSString *init, NSString *end, NSString *source)
{
	int start;
	NSRange range, rangeEnd;
	
	range = [source rangeOfString:init];
	
	start = range.location + range.length;
	source = [source substringFromIndex:start];
	
	rangeEnd = [source rangeOfString:end];
	
	range.length += rangeEnd.location + rangeEnd.length;
	
	return range;
}

/*!
 *					Converts a NSString to NSArray
 *
 *					This function extracts an array from a string, separating the elements only by
 *					white spaces or new lines. The values in the NSArray still being NSString instances.
 *
 *	@param			string
 *					A NSString containing the input string.
 *
 *	@result			A NSRange containing the result.
 */
NGL_INLINE NSArray *nglGetArray(NSString *string)
{
	NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSMutableArray *array = [NSMutableArray arrayWithArray:
							 [string componentsSeparatedByCharactersInSet:charSet]];
	
	[array removeObject:@""];
	
	return array;
}

/*!
 *					Replaces a pattern inside a C string by another.
 *
 *					This function searches for a pattern inside a C string and replaces all the matching
 *					results by another C string.
 *
 *	@param			string
 *					A C string containing the input string.
 *
 *	@param			searchFor
 *					A C string containing the input string.
 *
 *	@param			replaceFor
 *					A C string containing the input string.
 */
NGL_INLINE void nglCStringReplaceChar(char *string, char searchFor, char replaceFor)
{
	char *pointer;
	
	pointer = strchr(string,searchFor);
	while (pointer != NULL)
	{
		string[pointer - string] = replaceFor;
		pointer = strchr(pointer + 1, searchFor);
	}
}