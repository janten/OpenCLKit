//
//  main.m
//  clicl
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenCLKit/OpenCLKit.h>

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		// Get the OpenCL platform. Multiple platforms may be availabe if more
		// than one OpenCL implementation is installed on this computer. The
		// same hardware device may also be availabe on multiple platforms.
		CLPlatform *platform = [CLPlatform platforms].firstObject;

		// Find a computing device. We will just choose the first OpenCL
		// compatible GPU that we can find in the platform. Other available
		// options include CL_DEVICE_TYPE_CPU and CL_DEVICE_TYPE_ALL. Note that
		// we should usually check if we actually found a device before using it
		// but this (like all error handling) is skipped here for brevity.
		CLDevice *GPUDevice = [platform devicesOfType:CL_DEVICE_TYPE_GPU].firstObject;
		
		// Create a context for our device. Contexts spanning multiple devices
		// are also possible.
		CLContext *context = [[CLContext alloc] initWithDevice:GPUDevice];
		
		// Load our OpenCL source code from a file and create an OpenCL program
		// from it. This will implicitly compile the program and create the
		// kernels.
		NSURL *sourceURL = [NSURL fileURLWithPath:@"test.cl"];
		CLProgram *program = [[CLProgram alloc] initWithContext:context
															URL:sourceURL];
		
		// A program consists of one or more kernels. While we can get a list of
		// all kernels of a program through its kernels property, we can also
		// access a kernel by its name.
		CLKernel *kernel = [program kernelNamed:@"vector_add"];
		
		// Get the kernel arguments. All arguments need to be passed explicitly
		// before the kernel can be run. Arguments can be accessed by name or
		// through the arguments property of the kernel. We will have a look at
		// all the arguments for our kernel.
		NSLog(@"Arguments: %@", kernel.arguments);
		
		// Our kernel sums two vectors and writes the result to a third one.
		// The source and target vectors are just plain C arrays of floats and
		// must all be of the same size. Note that a float on the device is a
		// cl_float on the host.
		const NSUInteger vectorSize = 1e6;
		const size_t vector_length = sizeof(cl_float) * vectorSize;
		
		// We just allocate enough memory and initialize it with random numbers
		// for this example. Data would usually be read in from a file anyway.
		cl_float *input_vector_a = malloc(vector_length);
		cl_float *input_vector_b = malloc(vector_length);
		srand48(arc4random());
		
		for (NSUInteger i = 0; i < vectorSize; i++) {
			input_vector_a[i] = drand48();
			input_vector_b[i] = drand48();
		}
		
		// For use with OpenCLKit, data must be wrapped in a NSData container.
		NSData *inputVectorA = [NSData dataWithBytesNoCopy:input_vector_a
                                                    length:vector_length
                                              freeWhenDone:YES];
        [[kernel argumentNamed:@"vec_a"] setValueWithData:inputVectorA];

		NSData *inputVectorB = [NSData dataWithBytesNoCopy:input_vector_b
													length:vector_length
											  freeWhenDone:YES];
        [[kernel argumentNamed:@"vec_b"] setValueWithData:inputVectorB];
        
        // Create an empty output buffer for the results.
        CLBuffer *outputBuffer = [[CLBuffer alloc] initWithContext:context
                                                            length:vector_length];
        [[kernel argumentNamed:@"res"] setValueWithBuffer:outputBuffer];
		
		// Get the command queue for our device. While a context can contain
		// multiple devices, each device still has its own command queue. All
		// operations in a queue will be carried out in the same order they were
		// enqueued. This will ensure that we do not read results before the
		// calculations of a kernel are finished.
		CLCommandQueue *commandQueue = [context commandQueueForDevice:GPUDevice];

		// Run our kernel one million times, OpenCL will automatically determine
		// the parallelization. Enqueueing the kernel will also upload the
        // values of its arguments to the device.
		NSArray *dimensions = @[@(vectorSize)];
		[commandQueue enqueueKernel:kernel
				   globalDimensions:dimensions];
		
		// Read the output data. This method will not return until all kernels
		// in the queue have finished execution and data has been copied back to
		// the arguments backing NSData object.
		NSData *outputData = [commandQueue dataFromBuffer:outputBuffer];
		
		// Output data should now be available. We will just print out every
		// 10,000th entry of the vectors to check the sanity of our results.
		for (NSUInteger i = 0; i < vectorSize; i += 10000) {
			NSLog(@"%.2f + %.2f = %.2f", input_vector_a[i], input_vector_b[i], ((cl_float *)outputData.bytes)[i]);
		}

    }
	
    return 0;
}
