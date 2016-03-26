//
//  ViewController.m
//  weixin demo
//
//  Created by shangshan on 16/3/24.
//  Copyright © 2016年 shangshan. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//数据来自官方的 demo
- (IBAction)payweichat:(id)sender {
 // 数据 都是动态的 ,所有要向服务器 发送请求 ,请求动态数据
    
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req  = [[PayReq alloc] init];
                req.partnerId = [dict objectForKey:@"partnerid"];
                req.prepayId = [dict objectForKey:@"prepayid"];
                req.nonceStr  = [dict objectForKey:@"noncestr"];
                req.timeStamp  = stamp.intValue;
                req.package   = [dict objectForKey:@"package"];
                req.sign  = [dict objectForKey:@"sign"];
                
                [WXApi sendReq:req];
            }
        }
    
}
}
@end
