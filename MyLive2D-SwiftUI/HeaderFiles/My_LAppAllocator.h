//
//  My_LAppAllocator.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/20.
//

#ifndef My_LAppAllocator_h
#define My_LAppAllocator_h

// Apple
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "CubismFramework.hpp"
#import "ICubismAllocator.hpp"
#endif



// MARK: Objective-C Interface
NS_ASSUME_NONNULL_BEGIN
@interface MyLAppAllocator : NSObject

/**
 * Initialize the allocator
 * @return Instance of LAppAllocatorBridge
 */
- (instancetype)init;

/**
 * Allocate memory with given size
 * @param size Size to allocate
 * @return Pointer to allocated memory
 */
- (void*)allocateWithSize:(NSUInteger)size;

/**
 * Deallocate memory
 * @param memory Pointer to memory to deallocate
 */
- (void)deallocateWithMemory:(void*)memory;

/**
 * Allocate aligned memory
 * @param size Size to allocate
 * @param alignment Memory alignment requirement
 * @return Pointer to allocated aligned memory
 */
- (void*)allocateAlignedWithSize:(NSUInteger)size alignment:(uint32_t)alignment;

/**
 * Deallocate aligned memory
 * @param alignedMemory Pointer to aligned memory to deallocate
 */
- (void)deallocateAlignedWithMemory:(void*)alignedMemory;

@end

NS_ASSUME_NONNULL_END



// MARK: C++ Class
#ifdef __cplusplus
class LAppAllocator : public Csm::ICubismAllocator {
public:
    void* Allocate(const Csm::csmSizeType size) override;
    void Deallocate(void* memory) override;
    void* AllocateAligned(const Csm::csmSizeType size, const Csm::csmUint32 alignment) override;
    void DeallocateAligned(void* alignedMemory) override;
};
#endif

#endif /* My_LAppAllocator_h */
