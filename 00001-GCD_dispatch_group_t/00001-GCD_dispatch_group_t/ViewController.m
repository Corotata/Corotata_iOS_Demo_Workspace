//
//  ViewController.m
//  00001-GCD_dispatch_group_t
//
//  Created by Corotata on 2017/11/21.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photo2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mergePhotoImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)downloadThenMergePhoto:(UIButton *)sender {

    [self method2];
    
}

- (void)method {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"photo download therad:%@",[NSThread currentThread]);
        NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511262685479&di=680d913521849a5c613f8ebe778518b9&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F016c8d56db1e3632f875520fe79121.jpg%40900w_1l_2o_100sh.jpg"]];
        UIImage *image = [UIImage imageWithData:photoData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoImageView.image = image;
        });
        
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"photo2 download therad:%@",[NSThread currentThread]);
        NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511262769342&di=1462580c58ae917352c1501eaa011251&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F46%2Fd%2F198.jpg"]];
        UIImage *image = [UIImage imageWithData:photoData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photo2ImageView.image = image;
        });
        
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"merge therad:%@",[NSThread currentThread]);
        
        UIGraphicsBeginImageContext(CGSizeMake(400, 300));
        
        [self.photo2ImageView.image drawInRect:CGRectMake(0, 0, 400, 300)];
        [self.photoImageView.image drawInRect:CGRectMake(0, 0, 100, 100)];
        
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mergePhotoImageView.image = image;
        });
    });
    
}


- (void)method2 {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
 
    dispatch_group_enter(group);
    
    dispatch_async(queue, ^{
   
        NSLog(@"photo download therad:%@",[NSThread currentThread]);
        NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511262685479&di=680d913521849a5c613f8ebe778518b9&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F016c8d56db1e3632f875520fe79121.jpg%40900w_1l_2o_100sh.jpg"]];
        UIImage *image = [UIImage imageWithData:photoData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoImageView.image = image;
        });
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"photo2 download therad:%@",[NSThread currentThread]);
        NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511262769342&di=1462580c58ae917352c1501eaa011251&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F46%2Fd%2F198.jpg"]];
        UIImage *image = [UIImage imageWithData:photoData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photo2ImageView.image = image;
        });
        
        dispatch_group_leave(group);
    });
    
   
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"merge therad:%@",[NSThread currentThread]);
        
        UIGraphicsBeginImageContext(CGSizeMake(400, 300));
        
        [self.photo2ImageView.image  drawInRect:CGRectMake(0, 0, 400, 300)];
        [self.photoImageView.image  drawInRect:CGRectMake(0, 0, 100, 100)];
        
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mergePhotoImageView.image = image;
        });
    });
    
    
    
}
@end
