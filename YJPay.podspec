# coding: utf-8
Pod::Spec.new do |s|
    s.name			= "YJPay"
    s.version			= "0.0.1"
    s.ios.deployment_target = '7.0'
    s.summary			= "An payment tools for iOS, based on Alibaba AliPaySDK."

    s.description			= <<-DESC
    YJPay is a very lightweight utility class, you don't need to pay attention to integration framework, pour into link libraries, direct call API with respect to OK, make you more relaxed and happy the implementation of the payment
    DESC

    s.homepage			= "https://github.com/coderYJ/YJPay"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author			= { "coderYJ" => "wenyanjun1314@163.com"}

    s.social_media_url   = "http://weibo.com/u/5348162268"
    s.source			= { :git => "https://github.com/coderYJ/YJPay.git", :tag => s.version }
    s.source_files		= "YJPay/*.{h,m}"
    s.resources          = "YJPay/AlipaySDK.bundle"
    s.requires_arc		= true

#   s.preserve_paths = "Pod"
#   s.ios.vendored_frameworks =  "Pod/YJPay.framework"

    s.frameworks = "SystemConfiguration","CoreTelephony","CoreText","QuartzCore","CoreGraphics","CFNetwork","CoreMotion"

    s.libraries = "z","c++"
    s.xcconfig = {
        "FRAMEWORK_SEARCH_PATHS" => "\"$(PODS_ROOT)/YJPay/AlipaySDK/**\"",
# "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/YJPay/YJPay.framework\"",
    }
end