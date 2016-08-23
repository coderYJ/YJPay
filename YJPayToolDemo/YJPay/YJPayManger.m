//
//  YJPayManger.m
//  YJPayToolDemo
//
//  Created by simplyou on 2016/8/22.
//  Copyright © 2016年 coderYJ. All rights reserved.
//
/**
 *  privateKey
 */
#define KPRIVATE_KEY_BOTPY @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALHLQH9jPOsrh5Z2gSD+B6goN8LxFBwIdfIZjCR3iPN12xckxcZnDry4et/j/G+OTUKz82bzEiiTgS8WX/+xwpdijlxQ/8kLDl1Qma4TSszUbGvHO43mTle4U78Pv9TesVoMETvMb2hc6BJH4l3rN6KfHHC/W5EWSRUGl4x+tlFVAgMBAAECgYBQ3N990LXRQ+AMF+PNDJyQ55HM8PazdUmnjeUGZPN9v3mhAhGNlivGu6TvFXMnjbIoB05J4X29xLC5qNSKp9+XVlBJDWffyQwF0FbWg2puVrTxYuzR9XcNNgTQxJPW3sELiCicv8Eek59KhbD0Zt4wyE334jLge7BwGKruoOJx1QJBAOId/hNxFu6Dk8sMpJkBGvfYMfRa+jxQcekjH8S44NuIbFXGsJr6WWWMJvi/t6mCMYa8zGDtqWq411Z/fXKhIa8CQQDJSmLhhdJ08AE/+k+VijkSEPlrR6qnOeZ8uw4Og+4xWZsw8Yyxa3QdwoAA46SMj9F0dDf88Txbe/B78Z9PrtI7AkEAgiqf29NLTyzBhK8XhdjkDG8Reshwqw3oNTx6CkYfc2FadBp4Cg86LUH8IVBESzleh2DiCp5l28DifbHQpo9pkwJAFsvD0wKSyQd9PL+eT7Mtr2wYsxuUqgeWoL2WY/JxAUnCl5JjepxOtCgY0wD0265V7DhVNuIjEcFBhOfiQOXtjQJAe0IcbHRylSfxbIVW0w0Rl25iM86N7bXSAkDNs52DqK9eYjbRavhSfaG/p+9iJ/qisDYidlirOnpzkHMZjylIWg=="

/**
 *  parnter
 */
#define KPARTNER_BOTPY @"2088711138542134"
/**
 *  seller
 */
#define KSELLER_BOTPY @"2088711138542134"
/**
 *  支付宝异步通知回调
 */
#define KPAY_NOTIFY_URL_BOTPY @"http://dev.api.hiautocar.com:8061/alipay/notify"

#import "YJPayManger.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@implementation YJPayManger
+ (instancetype)sharedPayManger{
    
    static YJPayManger *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}
#pragma mark - 初始化方法
- (instancetype)init{
    if (self = [super init]) {
        // 需要填写商户app申请的
        _partner = KPARTNER_BOTPY;
        _seller = KSELLER_BOTPY;
        _privateKey = KPRIVATE_KEY_BOTPY;
        // 支付完成后的回调URL
        _notifyURL = KPAY_NOTIFY_URL_BOTPY;
        
        _itBPay = @"30m";
        _showURL = @"m.alipay.com";
        _service = @"mobile.securitypay.pay";
        _paymentType = @"1";
        _showURL = @"m.alipay.com";
        _subject = @"YJAliPayTool";
        _body = @"这是一款十分牛xx的工具类";
    }
    return self;
}
#pragma mark - aliPay---支付宝
- (void)aliPay{
    //商品价格 单位元
    CGFloat price = 0.01;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = _partner;
    order.sellerID = _seller;
    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.subject = _subject; //商品标题
    order.body = _body; //商品描述
    
    // 商品价格
    order.totalFee = [NSString stringWithFormat:@"%.2f",price];
    order.notifyURL = _notifyURL; //回调URL
    
    order.service = _service;
    order.paymentType = _paymentType;
    order.inputCharset = _inputCharset;
    order.itBPay = _itBPay;
    order.showURL = _showURL;
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    _appScheme = @"YJPayToolDemo";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(_privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:_appScheme callback:^(NSDictionary *resultDic) {
            //【callback处理支付结果】
            NSLog(@"reslut = %@",resultDic);
            
            if ([resultDic[@"resultStatus"] integerValue] == 9000 ) {
                // 支付成功
                NSLog(@"--- 支付成功");
            }else{
                NSLog(@"--- 支付失败");
            }
            /*
             resultStatus={9000};memo={};result={partner="2088101568358171"&seller_id= "xxx@alipay.com"&out_trade_no="0819145412-6177"&subject=" 测 试 "&body=" 测 试
             测试
             "&total_fee="0.01"&notify_url="http://notify.msp.hk/notify.htm"&service=" mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay= "30m"&success="true"&sign_type="RSA"&sign="hkFZr+zE9499nuqDNLZEF7W75RFFPs ly876QuRSeN8WMaUgcdR00IKy5ZyBJ4eldhoJ/2zghqrD4E2G2mNjs3aE+HCLiBXrPDNdLKCZ gSOIqmv46TfPTEqopYfhs+o5fZzXxt34fwdrzN4mX6S13cr3UwmEV4L3Ffir/02RBVtU="}
             
             错误代码(error_code)
             
             9000
             订单支付成功
             
             8000
             正在处理中
             
             4000
             订单支付失败
             
             6001
             用户中途取消
             
             6002
             网络连接出错
             */
        }];
    }
}
#pragma mark   ==============产生随机订单号==============
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
