OpenCLKit
=========
OpenCLKit is a Objective-C wrapper around the OpenCL C interface.

How To
------
Using OpenCLKit is straightforward if you have worked with OpenCL before. There 
is a small commented sample program in the `Examples` folder. A minimal example
looks like this:
```
// Find the GPU
CLPlatform *platform = [CLPlatform platforms].firstObject;
CLDevice *GPUDevice = [platform devicesOfType:CL_DEVICE_TYPE_GPU].firstObject;

// Compile our OpenCL C source code
CLContext *context = [[CLContext alloc] initWithDevice:GPUDevice];
NSURL *sourceURL = [NSURL fileURLWithPath:@"<#Path to source code#>"];
CLProgram *program = [[CLProgram alloc] initWithContext:context URL:sourceURL];

// Set kernel arguments and run
CLKernel *kernel = [program kernelNamed:@"vector_add"];
CLKernelArgument *arg = [kernel argumentNamed:@"vec_a"]
arg.data = <#Some NSData instance#>;
CLCommandQueue *commandQueue = [context commandQueueForDevice:GPUDevice];
NSArray *dimensions = @[@(vectorSize)];
[commandQueue enqueueKernel:program.kernels.firstObject globalDimensions:dimensions];

// Get results
[commandQueue readDataForArgument:outputArgument];
```