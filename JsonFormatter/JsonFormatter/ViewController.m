//
//  ViewController.m
//  JsonFormatter
//
//  Created by 况昊川 on 16/9/22.
//  Copyright © 2016年 况昊川. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)Formatter:(id)sender {
    _CodeText.stringValue = @"";
    
    NSString* jsonString = _OriginalText.stringValue;
    self.resultArray = [[NSMutableArray alloc] init];
    NSDictionary* result = [self dictionaryWithJsonString:jsonString];
    NSLog(@"result is %@", result);
    
    [self eachNSDictionaryToModel:result];
    
    NSString* resultStr = @"";
    for (NSString* str in self.resultArray) {
        resultStr = [resultStr stringByAppendingString:str];
        resultStr = [resultStr stringByAppendingString:@"\n\n"];
    }
    _CodeText.stringValue = resultStr;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSString *)eachNSDictionaryToModel:(NSDictionary *)input {
    if(input == nil) {
        return nil;
    }
    
    NSArray* keys = [input allKeys];
    NSString* resultStr = @"@interface xxxModel : JSONModel";
    for (int i = 0; i<keys.count; i++) {
        NSLog(@"key is %@", keys[i]);
        NSLog(@"value is %@", input[keys[i]]);
        
        NSString* key = keys[i];
        NSString* value = input[key];
        
        resultStr = [self generateOCCode:value setKey:key setResult:resultStr];
        NSLog(@"combined str is %@",resultStr);
    }
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:@"@end"];
    [self.resultArray addObject:resultStr];
    return resultStr;
}

- (NSString *)getType:(NSObject *)input setNSDictionary:(NSDictionary *)inputDictionary {
    if([input isKindOfClass:[NSString class]]){
        return @"NSString *";
    }else if([input isKindOfClass:[NSNumber class]]){
        return @"NSNumber *";
    }else if([input isKindOfClass:[NSDictionary class]]){
        [self eachNSDictionaryToModel:input];
        return @"";
    }else if([input isKindOfClass:[NSArray class]]){
        [self getFirstElement:input];
        return @"";
    }
    return @"";
}

-(void)getFirstElement:(NSArray *)input {
    [self eachNSDictionaryToModel:input[0]];
}

- (NSString *)eachProperty:(NSString *)type setValue:(NSString *)value {
    NSString *preStr = @"@property (nonatomic, strong) ";
    preStr = [preStr stringByAppendingString:type];
    preStr = [preStr stringByAppendingString:value];
    return preStr;
}

- (NSString *)generateOCCode:(NSString *)value setKey:(NSString *)key setResult:(NSString *)resultStr {
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[self eachProperty:[self getType:value setNSDictionary:nil] setValue:key]];
    resultStr = [resultStr stringByAppendingString:@";"];
    return resultStr;
}

- (NSString *)dealWithNSDictionaryType:(NSDictionary* )value {
    return nil;
}

- (NSString *)concatResultStr:(NSString *)input {
    return nil;
}

@end
