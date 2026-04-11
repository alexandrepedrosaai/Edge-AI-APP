//
//  EdgeAIManager.m
//  Edge-AI-APP
//
//  Created by Alexandre on 11/04/2026.
//  Example extensive Objective-C file
//

#import <Foundation/Foundation.h>
#if __has_include(<UIKit/UIKit.h>)
#import <UIKit/UIKit.h>
#endif

#pragma mark - Protocol Definition

@protocol EdgeAIProcessing <NSObject>
@required
- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion;
@optional
- (void)configureWithOptions:(NSDictionary *)options;
@end

#pragma mark - Category Example

@interface NSString (EdgeAIExtensions)
- (NSString *)edgeAI_trimmed;
@end

@implementation NSString (EdgeAIExtensions)
- (NSString *)edgeAI_trimmed {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end

#pragma mark - Main Class

@interface EdgeAIManager : NSObject <EdgeAIProcessing>

@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, assign) BOOL isConfigured;
@property (nonatomic, strong) dispatch_queue_t processingQueue;

- (instancetype)initWithModel:(NSString *)modelName;
- (void)loadModel;
- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion;
- (void)configureWithOptions:(NSDictionary *)options;

@end

@implementation EdgeAIManager

- (instancetype)initWithModel:(NSString *)modelName {
    if (self = [super init]) {
        _modelName = [modelName edgeAI_trimmed];
        _isConfigured = NO;
        _processingQueue = dispatch_queue_create("com.edgeai.processing", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)loadModel {
    NSLog(@"Loading model: %@", self.modelName);
    // Simulate model loading
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"Model %@ loaded successfully.", self.modelName);
}

- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion {
    dispatch_async(self.processingQueue, ^{
        NSLog(@"Processing input of length: %lu", (unsigned long)[input length]);
        // Simulate inference by reversing bytes
        NSMutableData *output = [NSMutableData dataWithData:input];
        NSUInteger length = [output length];
        uint8_t *bytes = (uint8_t *)[output mutableBytes];
        for (NSUInteger i = 0; i < length / 2; i++) {
            uint8_t temp = bytes[i];
            bytes[i] = bytes[length - i - 1];
            bytes[length - i - 1] = temp;
        }
        NSLog(@"Processing complete.");
        if (completion) {
            completion(output);
        }
    });
}

- (void)configureWithOptions:(NSDictionary *)options {
    NSLog(@"Configuring EdgeAIManager with options: %@", options);
    self.isConfigured = YES;
}

@end

#pragma mark - Usage Example

int main(int argc, char * argv[]) {
    @autoreleasepool {
        EdgeAIManager *manager = [[EdgeAIManager alloc] initWithModel:@" edge_ai_model.onnx "];
        [manager loadModel];
        [manager configureWithOptions:@{@"quantization":@"int8", @"device":@"CPU"}];
        
        NSData *inputData = [@"HelloEdgeAI" dataUsingEncoding:NSUTF8StringEncoding];
        [manager processInput:inputData completion:^(NSData *output) {
            NSString *result = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
            NSLog(@"Output result: %@", result);
        }];
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
    }
    return 0;
}
