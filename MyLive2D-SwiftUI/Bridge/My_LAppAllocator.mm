//
//  My_LAppAllocator.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/20.
//
#import "My_LAppAllocator.h"
#import <Foundation/Foundation.h>

#import "CubismFramework.hpp"
#import "ICubismAllocator.hpp"

using namespace Csm;

// MARK: Objective-C Bridge Implementation
// Objective-C Bridge Implementation
@interface MyLAppAllocator () {
    LAppAllocator* _allocator;
}
@end

@implementation MyLAppAllocator

- (instancetype)init {
    self = [super init];
    if (self) {
        _allocator = new LAppAllocator();
    }
    return self;
}

- (void)dealloc {
    if (_allocator) {
        delete _allocator;
        _allocator = nullptr;
    }
    [super dealloc];  // MRC 需要这行, 但 ARC 下不需要 [super dealloc]
}

- (void*)allocateWithSize:(NSUInteger)size {
    return _allocator->Allocate(static_cast<csmSizeType>(size));
}

- (void)deallocateWithMemory:(void*)memory {
    _allocator->Deallocate(memory);
}

- (void*)allocateAlignedWithSize:(NSUInteger)size alignment:(uint32_t)alignment {
    return _allocator->AllocateAligned(static_cast<csmSizeType>(size), alignment);
}

- (void)deallocateAlignedWithMemory:(void*)alignedMemory {
    _allocator->DeallocateAligned(alignedMemory);
}
@end



#pragma mark C++ Implementation
// C++ Implementation
void* LAppAllocator::Allocate(const csmSizeType size) {
    return malloc(size);
}

void LAppAllocator::Deallocate(void* memory) {
    free(memory);
}

void* LAppAllocator::AllocateAligned(const csmSizeType size, const csmUint32 alignment)
{
    size_t offset, shift, alignedAddress;
    void* allocation;
    void** preamble;
    
    offset = alignment - 1 + sizeof(void*);
    
    allocation = Allocate(size + static_cast<csmUint32>(offset));
    
    alignedAddress = reinterpret_cast<size_t>(allocation) + sizeof(void*);
    
    shift = alignedAddress % alignment;
    
    if (shift)
    {
        alignedAddress += (alignment - shift);
    }
    
    preamble = reinterpret_cast<void**>(alignedAddress);
    preamble[-1] = allocation;
    
    return reinterpret_cast<void*>(alignedAddress);
}

void LAppAllocator::DeallocateAligned(void* alignedMemory)
{
    void** preamble;
    
    preamble = static_cast<void**>(alignedMemory);
    
    Deallocate(preamble[-1]);
}
