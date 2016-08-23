//
//  YJPayManger.h
//  YJPayToolDemo
//
//  Created by simplyou on 2016/8/22.
//  Copyright © 2016年 coderYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YJPayManger : NSObject

+ (instancetype)sharedPayManger;
#pragma mark -  支付宝属性 -- start
@property (nonatomic, copy) NSString *partner;

@property (nonatomic, copy) NSString *seller;
/**
 *  私钥
 */
@property (nonatomic, copy) NSString *privateKey;

/**
 *  支付宝回调URL
 */
@property (nonatomic, copy) NSString *notifyURL;
/**
 *  应用注册scheme,在Info.plist定义URL types
 */
@property (nonatomic, copy) NSString *appScheme;
/**
 *  商品标题
 */
@property (nonatomic, copy) NSString *subject;
/**
 *  商品描述
 */
@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *service;
@property (nonatomic, copy) NSString *paymentType;
@property (nonatomic, copy) NSString *inputCharset;
@property (nonatomic, copy) NSString *itBPay;
@property (nonatomic, copy) NSString *showURL;

/**
 *  支付宝订单
 */
- (void)aliPay;
#pragma mark - 支付宝属性 --end

@end
