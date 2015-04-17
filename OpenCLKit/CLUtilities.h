//
//  CLUtilities.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 16.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@interface CLUtilities : NSObject

/**
 *  Asserts that the given error is CL_SUCCESS. Logs the given error message as
 *  well as the error code and name before triggering the assertion if an error
 *  occured.
 *
 *  @param error   The OpenCL error code
 *  @param message An error message to display if code != CL_SUCCESS.
 */
+ (void)checkError:(cl_int)error message:(NSString *)message;

+ (NSString *)nameOfError:(cl_int)error;
+ (NSDictionary *)errorNames;

@end
