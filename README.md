# iOS如何在不越狱的情况下,调用私有API
iOS开发中，我们接触到的API都是苹果公开的，那么还有一些私有API是苹果不予公开的，这些私有API中，有很多公开API无法达到的功能，利用这些API可以实现很多黑魔法，最常见莫过于**[UIView recursiveDescription]**。这是一个神奇的方法，在API DOC是找不到的，功能是打印View的层次关系和View的Description，效果如下图：

PS：一旦显示的使用这些私有API，将不能上架AppStore，今后有时间可以聊一聊怎么规避审核，使用私有API的方法。

使用常规调用方法
```objective-c
//.....
[self.view recursiveDescription];
//.....
```
编译器会报如下错误：
++No visible @interface for 'UIView' declares the selector 'recursiveDescription'++
可见常规调用方法是不能调用私有API的，我下面将使用两种方式调用私有API，创建一个Class，实现公开方法和私有方法：
```objective-c
//ExampleClass.h
@interface ExampleClass : NSObject
+ (void)publicMethod;
@end

//ExampleClass.m
@implementation ExampleClass
+ (void)publicMethod {
    NSLog(@"This public method");
}
+ (void)privateMethod {
    NSLog(@"This private method");
}
@end
```


### 利用Category调用私有API
首先在main.m中添加ExampleClass的Category，声明ExampleClass.m中的私有方法
```objective-c
@interface ExampleClass (ExampleClassCategory)
+ (void)privateMethod;
@end
```
这样即指向了该类的私有方法，变相的将私有方法“变”成了公开方法
![代码参考Example01](https://github.com/JerryLoveRice/ApplePriveateMethodExample/blob/master/Source/Example1.png)
代码参考Example01


### 利用Runtime调用私有API
首先介绍两个方法：
**[NSObject respondsToSelector:]** 返回布尔值，判断类及父类是否实现了该方法。
**[NSObject performSelector:]** 向类发送消息，返回的值就是执行完消息后的结果。

可以先判断类是否实现了某个方法，再去执行
```objective-c
[ExampleClass publicMethod];
if([ExampleClass respondsToSelector:@selector(privateMethod)]){
	[ExampleClass performSelector:@selector(privateMethod)];
}
```
![代码参考Example02](https://github.com/JerryLoveRice/ApplePriveateMethodExample/blob/master/Source/Example1.png)
代码参考Example02

套用如上两种方法，实现**[UIView recursiveDescription]**
![代码参考RecursiveDescriptionDemo](https://github.com/JerryLoveRice/ApplePriveateMethodExample/blob/master/Source/demo.png)
代码参考RecursiveDescriptionDemo

### 关于 @selector() 你需要知道的
因为在 Objective-C 中，所有的消息传递中的“消息”都会被转换成一个 selector 作为 objc_msgSend 函数的参数：
`[object message] -> objc_msgSend(object, @selector(message))`
所以刚才的代码可以转化为：
`objc_msgSend(objc_msgSend(self,@selector(view)),@selector(recursiveDescription))`
Objective-C 为我们维护了一个巨大的选择子表，在使用 @selector() 时会从这个选择子表中根据选择子的名字查找对应的 SEL。如果没有找到，则会生成一个 SEL 并添加到表中。

在编译期间会扫描全部的头文件和实现文件将其中的方法以及使用 @selector() 生成的选择子加入到选择子表中。

.h与.m所有的方法，编译后都会将所有的@selector加入选择子表中，在发送**recursiveDescription**消息后，系统会在选择子中查找该SEL，并执行。

然而第一种方法，只是显示的告诉编译器，类中有该方法，变相的达到欺骗编译器的目的，两种方法其原理相同。

**剩下的就全靠想象力了。**