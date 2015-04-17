OpenCLKit
=========
OpenCLKit is a Objective-C wrapper around the OpenCL C interface. This Mac OS X framework is being developed as part of my PhD thesis on parallel algorithms in medical imaging.

How To
------
Using OpenCLKit is straightforward if you have worked with OpenCL before. There 
is a small commented sample program in the `Examples` folder. A minimal example
looks like this:
```ObjC
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
[commandQueue enqueueKernel:kernel globalDimensions:dimensions];

// Get results
[commandQueue readDataForArgument:arg];

// Results are now in arg.data
```

Documentation
-------------
If [appledoc](https://github.com/tomaz/appledoc) is installed on your system in `/usr/local/bin/appledoc` you can use the `Documentation` build target to create a docset from the header files and install them for Xcode to use. Documentation is largely incomplete but should cover the most important bits to get started.

Limitations
-----------
There is only some basic functionality at the moment. Kernels taking constant values are currently not supported, neither are image data types or events. If you want to rely on OpenCLKit in your own applications, you will almost certainly need to add some functionality before being able to use it. Pull requests and issues are alway welcome.
