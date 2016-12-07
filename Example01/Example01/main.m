//
//  main.m
//  Example01
//
//  Created by Jerry on 2016/12/7.
//  Copyright © 2016年 github.com/JerryLoveRice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExampleClass.h"

@interface ExampleClass (ExampleClassCategory)
//声明,指向私有方法
+ (void)privateMethod;

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //利用Category调用私有方法
        [ExampleClass publicMethod];
        [ExampleClass privateMethod];
    }
    return 0;
}
