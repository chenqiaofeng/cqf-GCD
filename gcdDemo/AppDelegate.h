//
//  AppDelegate.h
//  gcdDemo
//
//  Created by chenfeng on 15/11/9.
//  Copyright © 2015年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;


@property (strong,nonatomic) NSString *cqfStr;

@end

