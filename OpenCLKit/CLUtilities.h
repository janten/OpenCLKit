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

+ (void)checkError:(cl_int)error message:(NSString *)message;
+ (NSString *)nameOfError:(cl_int)error;
+ (NSDictionary *)errorNames;

@end
