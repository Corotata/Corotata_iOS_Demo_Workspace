//
//  DownloadViewController.m
//  00002-NSOperationQueue
//
//  Created by Corotata on 2017/11/21.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photo2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mergePhotoImageView;

@property (strong, nonatomic) NSOperationQueue *queue;


@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)downloadThenMergePhoto:(UIButton *)sender {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"photo download therad:%@",[NSThread currentThread]);
        NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511262685479&di=680d913521849a5c613f8ebe778518b9&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F016c8d56db1e3632f875520fe79121.jpg%40900w_1l_2o_100sh.jpg"]];
        UIImage *image = [UIImage imageWithData:photoData];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.photoImageView.image = image;
        }];
    }];
    
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"photo2 download therad:%@",[NSThread currentThread]);
        NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511262769342&di=1462580c58ae917352c1501eaa011251&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F46%2Fd%2F198.jpg"]];
        UIImage *image = [UIImage imageWithData:photoData];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.photo2ImageView.image = image;
        }];
    }];
    
    
    NSBlockOperation *mergeOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"merge therad:%@",[NSThread currentThread]);
        
        UIGraphicsBeginImageContext(CGSizeMake(400, 300));
        
        [self.photo2ImageView.image drawInRect:CGRectMake(0, 0, 400, 300)];
        [self.photoImageView.image drawInRect:CGRectMake(0, 0, 100, 100)];
        
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.mergePhotoImageView.image = image;
        }];
    }];
    
    
    [mergeOperation addDependency:operation];
    [mergeOperation addDependency:operation2];
    
    
    [self.queue addOperation:operation];
    [self.queue addOperation:operation2];
    [self.queue addOperation:mergeOperation];
    
}



- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

@end
