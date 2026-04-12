//
//  blocks_runtime.h
//  Edge-AI-APP
//
//  Created by Alexandre on 11/04/2026
//  Simplified Blocks Runtime header
//

#ifndef _BLOCKS_RUNTIME_H_
#define _BLOCKS_RUNTIME_H_

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Estrutura base de um block
struct Block_literal {
    void *isa;                  // ponteiro para a classe
    int flags;                  // flags de execução
    int reserved;               // reservado
    void (*invoke)(void *, ...);// função que executa o block
    struct Block_descriptor *descriptor; // metadados
};

// Metadados do block
struct Block_descriptor {
    unsigned long reserved;
    unsigned long size;
    void (*copy_helper)(void *dst, void *src);
    void (*dispose_helper)(void *src);
};

// Funções da runtime
void *_Block_copy(const void *aBlock);
void _Block_release(const void *aBlock);

#ifdef __cplusplus
}
#endif

#endif /* _BLOCKS_RUNTIME_H_ */
