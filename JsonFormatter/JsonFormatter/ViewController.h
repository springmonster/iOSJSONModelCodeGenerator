//
//  ViewController.h
//  JsonFormatter
//
//  Created by 况昊川 on 16/9/22.
//  Copyright © 2016年 况昊川. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSTextField *OriginalText;
@property (weak) IBOutlet NSTextField *CodeText;
@property (weak) IBOutlet NSButton *FormatterBtn;
//@property (nonatomic,strong) NSString *resultStr;
@property (nonatomic,strong) NSMutableArray *resultArray;
- (IBAction)Formatter:(id)sender;

@end

