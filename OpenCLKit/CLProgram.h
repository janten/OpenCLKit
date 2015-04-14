//
//  CLProgram.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLContext;

@interface CLProgram : NSObject

@property (readonly) CLContext *context;
@property (readonly) NSArray *kernelNames;

- (instancetype)initWithContext:(CLContext *)context source:(NSString *)source NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithContext:(CLContext *)context URL:(NSURL *)URL;

@end