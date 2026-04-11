/*
 * objc/blocks_runtime.h
 * Edge-AI-APP
 * Created by Alexandre on 11/04/2026
 * Example extensive Objective-C header file
 */

#ifndef _OBJC_BLOCKS_RUNTIME_H_
#define _OBJC_BLOCKS_RUNTIME_H_

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Structure representing a block literal.
 * This is the low-level runtime representation of a block.
 */
struct Block_literal {
    void *isa;                   // Class pointer
    int flags;                   // Flags for block type
    int reserved;                // Reserved
    void (*invoke)(void *, ...); // Function pointer to block code
    struct Block_descriptor *descriptor; // Metadata
};

/*
 * Descriptor for block metadata.
 */
struct Block_descriptor {
    unsigned long reserved;
    unsigned long size;
    void (*copy_helper)(void *dst, void *src);
    void (*dispose_helper)(void *src);
};

/*
 * Functions for block memory management.
 */
void *_Block_copy(const void *aBlock);
void _Block_release(const void *aBlock);

/*
 * Function to check if a block is a global block.
 */
int _Block_isGlobal(const void *aBlock);

#ifdef __cplusplus
}
#endif

#endif /* _OBJC_BLOCKS_RUNTIME_H_ */
