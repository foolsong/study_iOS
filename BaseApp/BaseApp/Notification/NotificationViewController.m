//
//  NotificationViewController.m
//  Test2
//
//  Created by yjsong on 2025/1/9.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 在主线程接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"MyNotification"
                                               object:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 在后台线程发送通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@", [NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:nil];
    });

}

- (void)handleNotification:(NSNotification *)notification {
    // 确保回调代码在主线程执行
    NSLog(@"%s %@",__func__, [NSThread currentThread]);
}

- (void)test {
    NSLog(@"%s %@",__func__, [NSThread currentThread]);
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
////    NSLog(@"%s", __func__);
//    dispatch_queue_t queue = dispatch_queue_create("ceshi", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
//        NSLog(@"1111   %@",[NSThread mainThread]);
//        sleep(5);
//        NSLog(@"1");
//    });
//    dispatch_sync(queue, ^{
//        NSLog(@"2222   %@",[NSThread mainThread]);
//        sleep(3);
//        NSLog(@"2");
//    });
//    NSLog(@"33333   %@",[NSThread mainThread]);
//    sleep(1);
//    NSLog(@"3");
//}


//- (void) addObserver: (id)observer
//            selector: (SEL)selector
//                name: (NSString*)name
//              object: (id)object {
//    // 前置条件判断
////    ......
//
//    // 创建一个observation对象，持有观察者和SEL，下面进行的所有逻辑就是为了存储它
//    o = obsNew(TABLE, selector, observer);
//
//    /*======= case1： 如果name存在 =======*/
//    if (name) {
//        //-------- NAMED是个宏，表示名为named字典。以name为key，从named表中获取对应的mapTable
//        n = GSIMapNodeForKey(NAMED, (GSIMapKey)(id)name);
//        if (n == 0) { // 不存在，则创建
//            m = mapNew(TABLE); // 先取缓存，如果缓存没有则新建一个map
//            GSIMapAddPair(NAMED, (GSIMapKey)(id)name, (GSIMapVal)(void*)m);
//            ...
//        }
//        else { // 存在则把值取出来 赋值给m
//            m = (GSIMapTable)n->value.ptr;
//        }
//        //-------- 以object为key，从字典m中取出对应的value，其实value被MapNode的结构包装了一层，这里不追究细节
//        n = GSIMapNodeForSimpleKey(m, (GSIMapKey)object);
//        if (n == 0) {// 不存在，则创建
//            o->next = ENDOBS;
//            GSIMapAddPair(m, (GSIMapKey)object, (GSIMapVal)o);
//        }
//        else {
//            list = (Observation*)n->value.ptr;
//            o->next = list->next;
//            list->next = o;
//        }
//    }
//    /*======= case2：如果name为空，但object不为空 =======*/
//    else if (object) {
//        // 以object为key，从nameless字典中取出对应的value，value是个链表结构
//        n = GSIMapNodeForSimpleKey(NAMELESS, (GSIMapKey)object);
//        // 不存在则新建链表，并存到map中
//        if (n == 0) {
//            o->next = ENDOBS;
//            GSIMapAddPair(NAMELESS, (GSIMapKey)object, (GSIMapVal)o);
//        }
//        else { // 存在 则把值接到链表的节点上
//            ...
//        }
//    }
//    /*======= case3：name 和 object 都为空 则存储到wildcard链表中 =======*/
//    else {
//        o->next = WILDCARD;
//        WILDCARD = o;
//    }
//}
@end
