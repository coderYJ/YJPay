//
//  ViewController.m
//  YJPayToolDemo
//
//  Created by simplyou on 2016/8/22.
//  Copyright © 2016年 coderYJ. All rights reserved.
//

#import "ViewController.h"
#import "YJPayManger.h"


@interface ViewController ()

@end

@implementation ViewController
/**
 *  支付宝支付
 *
 */
- (IBAction)aliPay:(UIButton *)sender {
    [[YJPayManger sharedPayManger] aliPay];
}
/**
 *  微信支付
 *
 */
- (IBAction)weixin:(id)sender {
    
}
/**
 *  银联支付
 *
 */
- (IBAction)unionPay:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
