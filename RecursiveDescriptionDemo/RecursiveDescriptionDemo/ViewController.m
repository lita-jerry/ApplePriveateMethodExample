//
//  ViewController.m
//  RecursiveDescriptionDemo
//
//  Created by Jerry on 2016/12/7.
//  Copyright © 2016年 github.com/JerryLoveRice. All rights reserved.
//

#import "ViewController.h"

@interface UIView (recursiveDescriptionCategory)
- (NSString *)recursiveDescription;
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if([self.view respondsToSelector:@selector(recursiveDescription)]){
        //以下两行代码执行结果相同
        //NSLog(@"%@", [self.view performSelector:@selector(recursiveDescription)]);
        NSLog(@"%@", [self.view recursiveDescription]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
