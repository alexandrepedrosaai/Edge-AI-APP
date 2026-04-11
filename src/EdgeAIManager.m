//
//  EdgeAIManager.m
//  Edge-AI-APP
//
//  Created by Alexandre on 11/04/2026.
//  Self-contained Objective-C file for GNUstep/Linux
//

#import <Foundation/Foundation.h>

// Compatibility macros for non-Apple platforms
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
{
    NSString *_modelName;
    BOOL _isConfigured;
}

@property (nonatomic, retain) NSString *modelName;
@property (nonatomic, assign) BOOL isConfigured;

- (instancetype)initWithModel:(NSString *)modelName;
- (void)loadModel;
- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion;
- (void)configureWithOptions:(NSDictionary *)options;

@end

@implementation EdgeAIManager

@synthesize modelName = _modelName;
@synthesize isConfigured = _isConfigured;

- (instancetype)initWithModel:(NSString *)modelName {
    if ((self = [super init])) {
        _modelName = [[modelName edgeAI_trimmed] retain];
        _isConfigured = NO;
    }
    return self;
}

- (void)dealloc {
    [_modelName release];
    [super dealloc];
}

- (void)loadModel {
    NSLog(@"Loading model: %@", self.modelName);
    // Simulate model loading
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"Model %@ loaded successfully.", self.modelName);
}

- (void)processInput:(NSData *)input completion:(void (^)(NSData *output))completion {
    NSLog(@"Processing input of length: %lu", (unsigned long)[input length]);
    // Simulate inference by reversing bytes synchronously
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
}

- (void)configureWithOptions:(NSDictionary *)options {
    NSLog(@"Configuring EdgeAIManager with options: %@", options);
    self.isConfigured = YES;
}

@end

#pragma mark - Usage Example

int main(int argc, char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    EdgeAIManager *manager = [[EdgeAIManager alloc] initWithModel:@" edge_ai_model.onnx "];
    [manager loadModel];
    [manager configureWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:@"int8", @"quantization", @"CPU", @"device", nil]];
    
    NSData *inputData = [@"HelloEdgeAI" dataUsingEncoding:NSUTF8StringEncoding];
    [manager processInput:inputData completion:^(NSData *output) {
        NSString *result = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
        NSLog(@"Output result: %@", result);
        [result release];
    }];
    
    [manager release];
    [pool release];
    return 0;
}

NS_ASSUME_NONNULL_END
