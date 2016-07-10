//
//  HQsessionController.m
//  6.1-应用之间跳转(URL Schemes)-微信
//
//  Created by 韩贺强 on 16/7/9.
//  Copyright © 2016年 com.baiduniang. All rights reserved.
//

#import "HQsessionController.h"
#import "AppDelegate.h"

@interface HQsessionController ()
@property (nonatomic, strong) UIButton * button;
@end

@implementation HQsessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBackButton setTitle:@"回原app" forState:UIControlStateNormal];
    goBackButton.frame = CGRectMake(10, 70, 100, 50);
    goBackButton.backgroundColor = [UIColor grayColor];
    [goBackButton addTarget:self action:@selector(gobackVCBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.button = goBackButton;
    [self.view addSubview:self.button];
}

//跳回其他原来 APP的方法. 不能写死.因为微信是大应用,那么多应用都分享到微信,我不能在大App写死每一个跳转的小app的 schem .我需要让 别的 APP跳转到 微信APP的时候,把信息一并传递过来

// 其他app跳转到微信的时候传递参数: weixin://session?abcdefg
// 其他app根据weixin:// 跳到微信app,(需要 微信app设置 URL schemes 为 weixin)
// 微信APP根据其他app传递的   session 参数 跳转到 session控制器.
//  微信app 再根据 其他app传递过来的abcdefg (这个参数是在其他APP的 URL schemes中设置:abcdef),让微信根据这个返回到原来的APP.  但是abcdefg 是可以乱写的,只要保证.在其他APP中根据 bundle拿到就行,不能写死

-(void)gobackVCBtnClick{
    
    //我回跳到 原来的小app, 需要原来小 APP bundle里的 scheme..
    //在别的方法把scheme传进来的时候, 使用单例定义一个属性接受一下,这里我们再利用单例取一下刚刚接受的scheme值
    
//    NSString * schem = [UIApplication sharedApplication].scheme;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    NSString *schem = delegate.scheme;  // weixin://session?abcdefg 类型,NSString
    
    NSRange range = [schem rangeOfString:@"?"];
    
    //截取 最后的abcdeef
    NSString *string = [schem substringFromIndex:range.location + range.length];
    NSLog(@"%@",string);
    
    
    // 记得这个简便写法, openURL 不用配置白名单,但是记得写 !
    // **** 这里 跳回其他的原来的小APP 的时候, 也需要协议  xxx://.  所以这里也需要拼接
    if(![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://",string]]]){
        NSLog(@"不能回跳到原来的app,哪里出错了?检查一下吧");
    }
    
}
@end
