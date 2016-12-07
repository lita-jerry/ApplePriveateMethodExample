//
//  main.m
//  Example02
//
//  Created by Jerry on 2016/12/7.
//  Copyright © 2016年 github.com/JerryLoveRice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExampleClass.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //使用Runtime调用私有方法
        [ExampleClass publicMethod];
        if([ExampleClass respondsToSelector:@selector(privateMethod)]){
            [ExampleClass performSelector:@selector(privateMethod)];
        }
    }
    return 0;
}
