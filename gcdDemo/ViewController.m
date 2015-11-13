//
//  ViewController.m
//  gcdDemo
//
//  Created by chenfeng on 15/11/9.
//  Copyright © 2015年 chenfeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //1. 新建后台进程  执行完回主线程
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
//        NSError * error;
//        NSString * data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//        if (data != nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"call back, the data is: %@", data);
//            });
//        } else {
//            NSLog(@"error when download:%@", error);
//        }
//    });
    
    
    //2.
    // 调用前，查看下当前线程
    NSLog(@"当前调用线程：%@", [NSThread currentThread]);
    // 创建一个串行queue
    dispatch_queue_t queue = dispatch_queue_create("cn.itcast.queue", NULL);
    dispatch_async(queue, ^{
        NSLog(@"开启了一个异步任务，当前线程：%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"开启了一个同步任务，当前线程：%@", [NSThread currentThread]);
    });
    // 销毁队列
//    dispatch_release(queue);

    
    //3.
    // 获得全局并发queue
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    size_t count = 10;
    dispatch_apply(count, queue1, ^(size_t i) {
        printf("%zd ", i);
    });

    //4.
    // 异步下载图片
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *url = [NSURL URLWithString:@"http://car0.autoimg.cn/upload/spec/9579/u_20120110174805627264.jpg"];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//        
//        // 回到主线程显示图片
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageView.image = image;
//        });
//    });
    
    
    
    //5. 同步
//    [self downloadImages];
    
    //6. 并行执行  最后通知
//    [self downloadImagesSameTime];
    
    //7. 各种执行
    [self loadImagesBoth];
    
    
    //8. 2秒后执行
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hi~" message:@"message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    });
    
    
}


// 根据url获取UIImage
- (UIImage *)imageWithURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

- (void)downloadImages {
    // 异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 下载第一张图片
//        NSString *url1 = @"http://car0.autoimg.cn/upload/spec/9579/u_20120110174805627264.jpg";
        
    NSString *url1 = @"http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fimg14.poco.cn%2Fmypoco%2Fmyphoto%2F20130403%2F14%2F65939719201304031356532142558851773_030.jpg&thumburl=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D3039588923%2C2498846591%26fm%3D21%26gp%3D0.jpg";
        UIImage *image1 = [self imageWithURLString:url1];
        
        
        // 下载第二张图片
        NSString *url2 = @"http://hiphotos.baidu.com/lvpics/pic/item/3a86813d1fa41768bba16746.jpg";
        UIImage *image2 = [self imageWithURLString:url2];
        
        // 回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView1.image = image1;
            
            self.imageView2.image = image2;
        });
    });
}



- (void)downloadImagesSameTime {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 异步下载图片
    dispatch_async(queue, ^{
        // 创建一个组
        dispatch_group_t group = dispatch_group_create();
        
        __block UIImage *image1 = nil;
        __block UIImage *image2 = nil;
        
        // 关联一个任务到group
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 下载第一张图片
//            NSString *url1 = @"http://car0.autoimg.cn/upload/spec/9579/u_20120110174805627264.jpg";
            NSString *url1 = @"http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fimg14.poco.cn%2Fmypoco%2Fmyphoto%2F20130403%2F14%2F65939719201304031356532142558851773_030.jpg&thumburl=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D3039588923%2C2498846591%26fm%3D21%26gp%3D0.jpg";
            image1 = [self imageWithURLString:url1];
            
        });
        
        // 关联一个任务到group
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 下载第一张图片
            NSString *url2 = @"http://hiphotos.baidu.com/lvpics/pic/item/3a86813d1fa41768bba16746.jpg";
            image2 = [self imageWithURLString:url2];
        });
        
        // 等待组中的任务执行完毕,回到主线程执行block回调
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
             self.imageView1.image = image1;
             self.imageView2.image = image2;
             });
    });
}


-(void) loadImagesBoth
{
    dispatch_async(dispatch_get_global_queue(0,0),^{
        __block UIImage *image1 = nil;
        NSString *url1 = @"http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fimg14.poco.cn%2Fmypoco%2Fmyphoto%2F20130403%2F14%2F65939719201304031356532142558851773_030.jpg&thumburl=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D3039588923%2C2498846591%26fm%3D21%26gp%3D0.jpg";
        image1 = [self imageWithURLString:url1];
        dispatch_async(dispatch_get_main_queue(),^{
            self.imageView1.image = image1;
        });
    });
    
    dispatch_async(dispatch_get_global_queue(0,0),^{
        __block UIImage *image2 = nil;
        NSString *url2 = @"http://hiphotos.baidu.com/lvpics/pic/item/3a86813d1fa41768bba16746.jpg";
        image2 = [self imageWithURLString:url2];
        dispatch_async(dispatch_get_main_queue(),^{
            self.imageView2.image = image2;
        });
    });

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



/*
 //  后台执行：
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 // something
 });
 
 // 主线程执行：
 dispatch_async(dispatch_get_main_queue(), ^{
 // something
 });
 
 // 一次性执行：
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 // code to be executed once
 });
 
 // 延迟2秒执行：
 double delayInSeconds = 2.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 // code to be executed on the main queue after delay
 });
 
 // 自定义dispatch_queue_t
 dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", NULL);
 dispatch_async(urls_queue, ^{
 　 　// your code
 });
 dispatch_release(urls_queue);
 
 // 合并汇总结果
 dispatch_group_t group = dispatch_group_create();
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
 // 并行执行的线程一
 });
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
 // 并行执行的线程二
 });
 dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
 // 汇总结果
 });
*/