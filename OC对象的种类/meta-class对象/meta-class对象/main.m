//
//  main.m
//  meta-class对象
//
//  Created by 赵鹏 on 2019/5/2.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 iOS中OC对象可以分为如下的三种：
 
 1、instance对象（实例对象）：
（1）这种类型的对象是通过类alloc出来的对象，每次调用alloc方法，都会产生一个新的instance对象，然后系统就会给这个新对象分配一块内存空间来存储它；
（2）instance对象可以有多个，每alloc出来一个对象就是一个新的instance对象；
（3）instance对象在内存中存储的信息包括：
 ①isa指针：因为所有的instance对象所在的类都继承自NSObject，NSObject的底层结构中就有isa指针，所以所有的instance对象里面都存储着isa指针； ②instance对象所在类的成员变量的具体值，但是不存储这些成员变量的类型和名称，也不存储实例方法和类方法。

 2、class对象（类对象）：
（1）每个类只有一个class对象；
（2）class对象在内存中存储的信息包括：
 ①isa指针；
 ②superclass指针；
 ③类的属性信息（@property）；
 ④类的协议信息（protocol）；
 ⑤类的对象方法信息（instance method）：即类的实例方法（以减号开头的方法），但是类方法（以加号开头的方法）不存储在class对象中，而是存储在meta-class对象中；
 ⑥类的成员变量信息（ivar）：只存储类的成员变量的类型和名称（这些只需要存储一份而已），不存储这些成员变量的值，值存储在instance对象中。
 
 3、meta-class对象（元类对象）：
（1）每个类在内存中有且只有一个meta-class对象；
（2）meta-class对象在内存中存储的信息包括：
 ①isa指针；
 ②superclass指针；
 ③类的类方法信息（class method）：即以加号开头的方法，但不存储实例方法（以减号开头的方法）。实例方法存储在class对象中。
（3）meta-class对象是一种特殊的class对象。
 
 备注：
 1、instance对象的isa指针指向class对象；
 2、clas对象的isa指针指向meta-class对象；
 3、meta-class对象的isa指针指向NSObject（基类）的meta-class对象。
 */
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//自定义Person类
@interface Person : NSObject
{
    int _age;
    int _height;
    int _no;
}
@end

@implementation Person

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        /**
         获取instance对象：
         下面获取到的两个instance对象是不同的两个对象。
         */
        NSObject *object = [[NSObject alloc] init];
        NSObject *object1 = [[NSObject alloc] init];
        NSLog(@"instance对象：%p, %p", object, object1);
        
        /**
         获取class对象：
         通过下面几种方式获取到的class对象是同一个对象，每个类在内存中有且只有一个类对象。
         */
        Class objectClass = [object class];
        Class objectClass1 = [object1 class];
        Class objectClass2 = [NSObject class];
        Class objectClass3 = object_getClass(object);
        Class objectClass4 = object_getClass(object1);
        NSLog(@"class对象：%p, %p, %p, %p, %p", objectClass, objectClass1, objectClass2, objectClass3, objectClass4);
        
        /**
         获取meta-class对象：
         1、在object_getClass函数中传入的是class对象，则获取到的是meta-class对象，每个类在内存中有且只有一个meta-class对象；
         2、在object_getClass函数中传入的是instance对象，则获取到的是class对象；
         3、在object_getClass函数中传入的是meta-class对象，则获取到的是NSObject（基类）的meta-class对象。
         */
        Class objectMetaClass = object_getClass([NSObject class]);
        NSLog(@"meta-class对象：%p", objectMetaClass);
        
        //用class_isMetaClass函数来判断传进来的参数是不是meta-class对象。
        BOOL isMetaClass = class_isMetaClass(objectMetaClass);
        NSLog(@"%d", isMetaClass);
    }
    
    return 0;
}
