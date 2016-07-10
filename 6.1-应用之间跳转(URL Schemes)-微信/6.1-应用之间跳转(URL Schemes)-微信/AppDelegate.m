//
//  AppDelegate.m
//  6.1-应用之间跳转(URL Schemes)-微信
//
//  Created by 韩贺强 on 16/7/9.
//  Copyright © 2016年 com.baiduniang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

#pragma mark  以下的三个方法都是接受第三方应用传递的信息
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url NS_DEPRECATED_IOS(2_0, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;

//上面两个方法过期了.  这里接受从外界传递的 URL Schemes.判断跳转到那个 界面
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    NSLog(@"%@",url);// 打印结果是是跳转过来的结果>  weixin://session?abcdefg
    
    //
    NSLog(@"%@",url.query);//query只能,是得到一个?后面的结果.abcdefg.
    
    
    NSString *urlStr = url.absoluteString;  //weixin://session?abcdefg 类型,NSString

    
    
    //我们就在这里 给 appdelegate的属性赋值,
    self.scheme = urlStr;
    
    
    
    
    //我现在需要截取 中间的 session 或者 timeline
    // 看 urlstr 中包含  "//" 字符串吗?
    //包含的话,就返回 "//"字符在 urlStr中的范围(位置和长度),不包含的话,就返回一个无穷大的数. 或者写 NSNotFound.
    NSRange range1 = [urlStr rangeOfString:@"//"];
    
    NSRange range2 = [urlStr rangeOfString:@"?"];
    
    //截取字符串
    NSString *VCstr = [urlStr substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length)];
    
    NSLog(@"%@",VCstr);  //就是session 或者是 timeline
    
    
    //想要跳转到对应的控制器?怎么办? 借助导航控制器-->导航控制器可以根据 窗口的跟控制器获得
    
    UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
    
    UIViewController * childVc = nav.childViewControllers[0];
    
    
    // 出现BUG: 就是如果别的 app 多次跳转的话, 那么再 微信APP里返回的话,会一层一层的往回跳,不会立即跳回主界面
    //解决 BUG: 在跳转到 指定的子控制器 session 或者 timeline之前 ,先回到 微信APP的主界面
    [nav popToRootViewControllerAnimated:NO];
    
    
//     方法一: 判断截取后的字符串 VCstr (session 或者 timeline 是否等于 指定的字符串)
    
//    if ([VCstr isEqualToString:@"session"]) {
//        
//        //如果是用故事版拖线,那么 设置标识,  在故事版中选中那条链接的线,进行设置
//        [childVc performSegueWithIdentifier:@"session" sender:nil];
//    }else if([VCstr isEqualToString:@"timeline"]){
//        
//        [childVc performSegueWithIdentifier:@"timeline" sender:nil];
//    }
//    
    
    //方法二: ios 8直接判断字符串中 urlStr (weixin://session?abcdefg 或者 weixin://timeline??mmmmm)是否包含 某字符串.
    //我们还可以 使用 ios8 新的 方法判断字符串中有没有 包含那个 小字符串,那么久不用截字符串了
    if ([urlStr containsString:@"session"]){
                [childVc performSegueWithIdentifier:@"session" sender:nil];
    }else if([urlStr containsString:@"timeline"] ){
                [childVc performSegueWithIdentifier:@"timeline" sender:nil];
    }
    
    
    
    return YES;
}

@end
