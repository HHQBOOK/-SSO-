//
//  AppDelegate.h
//  6.1-应用之间跳转(URL Schemes)-微信
//
//  Created by 韩贺强 on 16/7/9.
//  Copyright © 2016年 com.baiduniang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) NSString * scheme;  //设置回跳到原来APP 的是scheme. 利用单例传值
@end

