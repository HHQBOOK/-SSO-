//
//  ViewController.m
//  6-应用之间跳转
//
//  Created by 韩贺强 on 16/7/9.
//  Copyright © 2016年 com.baiduniang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSString * appSchemeString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButton];
}

-(void)setupButton{
    //按钮.跳转到 微信 session 的按钮
    UIButton *sessionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sessionBtn setTitle:@" 跳session" forState:UIControlStateNormal];
    sessionBtn.frame = CGRectMake(10, 10, 100, 50);
    sessionBtn.backgroundColor = [UIColor purpleColor];
    [sessionBtn addTarget:self action:@selector(jumetoWeixinSessionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sessionBtn];
    
    //添加 跳转到 微信 timeline 的按钮
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setTitle:@" 跳timeline" forState:UIControlStateNormal];
    aBtn.frame = CGRectMake(10, 70, 100, 50);
    aBtn.backgroundColor = [UIColor purpleColor];
    [aBtn addTarget:self action:@selector(jumetoWeixinTimelineBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aBtn];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //跳转 APP 应用, 是需要遵守协议的. 协议头,是根据要跳转到的应用来写的.
    //跳转 APP 应用 是应用级别的跳转,  需要用 UIApplication 来跳转
    
    //跳转的话,在 ios9 之后,使用 canOpenURL 需要设置白名单,才能跳转. 因为这个方法依赖于 info.plist文件的白名单

    /* http://dev.umeng.com/social/ios/ios9
     如果你的应用使用了如SSO授权登录或跳转分享功能，在iOS9下就需要增加一个可跳转的白名单，指定对应跳转App的URL Scheme，否则将在第三方平台判断是否跳转时用到的canOpenURL时返回NO，进而只进行webview授权或授权/分享失败
     
     <key>LSApplicationQueriesSchemes</key>
     <array>
     <!-- 微信 URL Scheme 白名单-->
     <string>wechat</string>
     <string>weixin</string>
     
     
     
     </array>
     */
    
    //正常的逻辑判断 (方法一) (白名单配置)
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
//    }else {
//        NSLog(@"不能跳转到微信,请配置名称和密码");
//    }
    
    
    
    // 偷懒的写法 (方法二) (亲测:不需要设置白名单,因为没有用的 canOpenURL方法)
//        if(![[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]]){
//    
//            NSLog(@"不能跳转到微信,请配置名称和密码");
//    
//        }
    
}


- (NSString *)getAppSchemeString {
    
    //---------------------- 如微信,分享跳转到不同的界面,一个是分享到朋友圈,一个是分享到朋友列表---------
    
    //思考: 微信跳转到不同的界面,我们这个程序 新闻程序不能跳转,是微信根据我们传递的信息,而跳转到不同的界面(列表和朋友圈)  ---->我们需要借助协议 URL Schemes 来传递参数
    
    //如果能跳转就跳转,不能跳转就返回打印信息.
    //weixin://保证能跳到 微信. 后面session 保证能跳转到响应界面. 微信端 根据 session 进行判断跳转到对应的界面
    
    
    
    //话说,我们不该写死,传入的参数.而是应该写进去info.plist里,在bundle取
    
    
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    
    //取出infoDict中的 urltyps 数组
    NSArray * urlTypesArr = infoDict[@"CFBundleURLTypes"];
    
    //再取出 urlTypesArr 数组中 的 URL schemes字典. 我们现在只设置了一个
    NSDictionary *urlSchemesDic = urlTypesArr[0];
    
    //在取出 urlSchemesDic 字典中的 scheme 协议头
    NSArray * schemesArr = urlSchemesDic[@"CFBundleURLSchemes"];
    
    //再取出 schemesArr 中的字典
    NSString * scheme = schemesArr[0];
    NSLog(@"%@",scheme);
    
    NSString * headerStr = @"weixin://session?";
    
    // 方法一: 格式化字符串
    NSString * schemeString = [NSString stringWithFormat:@"%@%@",headerStr,scheme];
    
    //方法二: 拼接字符串
    //    NSString *string = [headerStr stringByAppendingString:scheme];

    NSLog(@"%@",schemeString);
    
    return schemeString;
}



-(void)jumetoWeixinSessionBtnClick{
    
    NSString *appSchemeStr = [self getAppSchemeString];

    
    if(![[UIApplication sharedApplication] openURL:[NSURL URLWithString:appSchemeStr]]){
        
        NSLog(@"不能跳转到微信,请配置名称和密码");
        
    }
    
}

-(void)jumetoWeixinTimelineBtnClick{
    
    
    //这里和上面一样的.
    if(![[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://timeline?mmmmmmm"]]){
        
        NSLog(@"请配置密码等信息,不能跳转到timeline界面");
        
    }
}


@end
