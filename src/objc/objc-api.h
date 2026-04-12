//
//  objc-api.h
//  Edge-AI-APP
//
//  Created by Alexandre on 11/04/2026
//  Public API header for EdgeAI Objective-C module
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Protocol Definition

/// Protocolo que define a interface de processamento de dados para EdgeAI
@protocol EdgeAIProcessing <NSObject>
@required
/// Processa dados de entrada e retorna saída via callback
- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion;
@optional
/// Configura o processador com opções adicionais
- (void)configureWithOptions:(NSDictionary *)options;
@end

#pragma mark - Public API Class

/// Classe principal da API EdgeAI
@interface EdgeAIManager : NSObject <EdgeAIProcessing>

/// Nome do modelo carregado
@property (nonatomic, strong) NSString *modelName;

/// Indica se o modelo já foi configurado
@property (nonatomic, assign) BOOL isConfigured;

/// Inicializa o gerenciador com o nome do modelo
- (instancetype)initWithModel:(NSString *)modelName;

/// Carrega o modelo especificado
- (void)loadModel;

/// Processa dados de entrada de forma assíncrona
- (void)process
