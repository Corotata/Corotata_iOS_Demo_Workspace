//
//  ViewController.m
//  00002-NSOperation
//
//  Created by Corotata on 2017/11/21.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
   
}


- (IBAction)startClick:(UIButton *)sender {
    static NSInteger num = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        num ++ ;
        [self receiveNewMessage:num];
    }];
   
    
}


- (void)receiveNewMessage:(NSInteger)message {
   
    NSLog(@"收到一条新的消息，%@,当前还有%@条消息未处理",@(message),@(self.queue.operationCount));
    if (self.queue.operationCount > 10) {
        [self.timer invalidate];
        NSLog(@"由于库存积累,停止接收消息");
    }
    //模拟消费者
    if (message % 2 == 0) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            sleep(5);
            NSLog(@"---------- 消息，%@处理完毕 -----------",@(message));
        }];
        [self.queue addOperation:operation];
    }else {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"---------- 消息，%@处理完毕 -----------",@(message));
        }];
        [self.queue addOperation:operation];
    }
}


- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    
}

@end
