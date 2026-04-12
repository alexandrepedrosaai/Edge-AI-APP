//
//  EdgeAIManager.h
//  Edge-AI-APP
//
//  Created by Alexandre on 11/04/2026
//  Header file for EdgeAIManager
//

#ifndef EDGE_AI_MANAGER_H
#define EDGE_AI_MANAGER_H

#import <Foundation/Foundation.h>

#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#endif

#ifndef BOOL
#define BOOL signed char
#endif

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Protocol Definition

@protocol EdgeAIProcessing <NSObject>
@required
- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion;
@optional
- (void)configureWithOptions:(NSDictionary *)options;
@end

#pragma mark - Interface Declaration

@interface EdgeAIManager : NSObject <EdgeAIProcessing>

@property (nonatomic, retain) NSString *modelName;
@property (nonatomic, assign) BOOL isConfigured;

/// Initialize with a model name
- (instancetype)initWithModel:(NSString *)modelName;

/// Load the model (simulated)
- (void)loadModel;

/// Process input data asynchronously
- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion;

/// Configure manager with options
- (void)configureWithOptions:(NSDictionary *)options;

@end

NS_ASSUME_NONNULL_END

#endif /* EDGE_AI_MANAGER_H */
