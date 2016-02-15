//
//  OpenCLKitTests.m
//  OpenCLKitTests
//
//  Created by Jan-Gerd Tenberge on 15.02.16.
//  Copyright © 2016 Jan-Gerd Tenberge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OpenCLKit/OpenCLKit.h>

@interface OpenCLKitTests : XCTestCase

@end

@implementation OpenCLKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlatformExistence {
	XCTAssert([CLPlatform platforms].count > 0, @"Should return a least one platform.");
}

- (void)testPlatformAdherence {
	CLPlatform *platform = [CLPlatform platforms].firstObject;
	CLDevice *device = platform.devices.firstObject;
	XCTAssert([device.platform isEqual:platform], @"Device should stick to platform.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
