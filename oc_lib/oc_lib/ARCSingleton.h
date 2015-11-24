//
//  ARCSingleton.h
//  在ARC模式下创建单例对象
//
//  Created by ligh on 15/10/13.
//
//

#ifndef ARCSingleton_h
#define ARCSingleton_h

//在h文件中调用
#define SINGLETON_H_ARC(className) \
\
+ (className *)shared##className;


//在m文件中调用
#define SINGLETON_M_ARC(className) \
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}


#endif /* ARCSingleton_h */
