# WTThird_Party_Login
新浪微博,微信,qq第三方登录demo

- 1.demo下载以后,请在WTThirdPartyLoginManager里面将自己的个平台的app key写上去.
- 2.URL Schemes 也请各位自己配置好


# 材料准备
首先我们需要调料有 (点击链接下载~)
[新浪微博sdk](https://github.com/sinaweibosdk/weibo_ios_sdk.git)
[腾讯sdk](http://qzonestyle.gtimg.cn/qzone/vas/opensns/res/doc/iOS_SDK_V3.1.0.zip)
[微信sdk](https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/WeChatSDK1.7.1.zip)


[微信登录官方文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN)

[微博获取用户信息接口连接1](http://open.weibo.com/wiki/2/users/show/en)
[微博获取用户信息接口连接2](http://open.weibo.com/wiki/2/users/show)

- 1.首先什么是第三登录?
> 答: 第三方登录就去微博,微信,QQ这些app上,拿用户的信息. 拿到了然后发到自己公司的服务器完成注册.   其实就是去第三方应用上拿用户的信息.

> 微信简单流程:  1.拿code--->2.用code换access_token--->3.用access_token换用户相关信息--->4.登录成功
> 微博: 跳转到微博客户端---->2.拿到accessToken,和userID---->3.拿用户信息
QQ: 跳转到QQ----->2.回来调用代理方法getUserInfo, ---->3.再调用代理方法返回用户信息

> 看着上面的流程是不是优点蒙?, 先别管,先记住,如果是微信的话,你要做两次网络请求让后最终拿到用户信息, 微博的话你只需做一次网络请求就ok, QQ的话你就直接调方法就行了网络请求什么的不用你烦.




- 2.需要哪些配置?  
[详细配置可以参考我的---iOS-新浪微博,QQ,微信分享原生接入记录,登录和分享的这些配置都是一样的, 也可以参考demo,直接! ](http://www.jianshu.com/p/ac977196c422)
> ①.首先添加这三个应用的sdk</br>
   ②.添加白名单 </br>
   ③.添加 -ObjC,编译选项</br>
   ④.添加 URL Tyes</br>
⑤. 为了适配iOS9以上,你需要在info.plist里面再配置允许http访问</br>
⑥.添加依赖库

允许http
```objc
// 主要还微博那家伙,虽然他是https的,证书当然也没问题,不过他的TLS版本太低了,所以拿微博信息的时候,如果不配置,iOS9以上的手机就拿不到信息.
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

![Snip20160704_1.png](http://upload-images.jianshu.io/upload_images/571446-d8e8a83e11aac550.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

[有关HTTPS的相关,证书什么的资料,参考这个](http://my.oschina.net/vimfung/blog/494687)




# 注意点 新浪微博你可能会遇到如下
- 1.redirect_uri_mismatch
  - 你的回调地址错误,
  - 解决办法:去新浪开放平台修改回调地址;
- 2.sso package or sign error 
   - 这个是你app 的Bundle identifier 和新浪开放平台上的Bundle ID不一致.  去开放平台上修改一下就好.

如图注意要一一对齐


 
- Bundle identifier 对应
![Snip20160704_4.png](http://upload-images.jianshu.io/upload_images/571446-bc4bca8a7c75028d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 回调页对应
![Snip20160704_8.png](http://upload-images.jianshu.io/upload_images/571446-c51c6123acd0c602.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- app key 对应
![Snip20160704_5.png](http://upload-images.jianshu.io/upload_images/571446-fe4d38f791c1ab91.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



# 代码简介

和分享一样我提供了一个WTThirdPartyLoginManager管理各个平台的
登录,提供了如下的一个类方法

```objc
+ (void)getUserInfoWithWTLoginType:(WTLoginType)type result:(WTThirdPartyLoginResultBlock)result;
```

> 1.首先你得在WTThirdPartyLoginManager.m配置好了各平台的信息
2.确保你的URL Schemes  也配置好
传入不同的WTLoginType跳转到不同的客户端!

- 下面是WTThirdPartyLoginManager的具体代码

# WTThirdPartyLoginManager.h

```objc
//
//  WTThirdPartyLoginManager.h
//  WTThird_Party_Login
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

typedef NS_ENUM(NSInteger, WTLoginType) {
    WTLoginTypeWeiBo = 0,   // 新浪微博
    WTLoginTypeTencent,      // QQ
    WTLoginTypeWeiXin       // 微信
};

typedef NS_ENUM(NSInteger, WTLoginWeiXinErrCode) {
    WTLoginWeiXinErrCodeSuccess = 0,
    WTLoginWeiXinErrCodeCancel = -2, 
    
};

typedef void(^WTThirdPartyLoginResultBlock)(NSDictionary * LoginResult, NSString * error);

@interface WTThirdPartyLoginManager : NSObject<TencentSessionDelegate, TencentLoginDelegate,WBHttpRequestDelegate,WeiboSDKDelegate,WXApiDelegate>

+ (instancetype)shareWTThirdPartyLoginManager;

+ (void)getUserInfoWithWTLoginType:(WTLoginType)type result:(WTThirdPartyLoginResultBlock)result;

@end

```
# WTThirdPartyLoginManager.m
```objc
//
//  WTThirdPartyLoginManager.m
//  WTThird_Party_Login
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "WTThirdPartyLoginManager.h"

#define kSinaAppKey         @"你自己微博的Appkey"//
#define kSinaRedirectURI    @"你设置的微博回调页"

#define kTencentAppId   @"你的腾讯开放平台的appId"

#define kWeixinAppId    @"微信id"
#define kWeixinAppSecret @"AppSecret"

@interface WTThirdPartyLoginManager () <NSCopying,NSURLSessionTaskDelegate>
{
    
    
}
@property (nonatomic, copy)WTThirdPartyLoginResultBlock resultBlock;
@property (nonatomic, assign)WTLoginType wtLoginType;
@property (nonatomic, strong)NSString * access_token;

@property (nonatomic, strong)TencentOAuth * tencentOAuth;
@property (nonatomic, strong)NSMutableArray * tencentPermissions;

@end

@implementation WTThirdPartyLoginManager

static WTThirdPartyLoginManager * _instance;


+ (void)initialize
{
    [WTThirdPartyLoginManager shareWTThirdPartyLoginManager];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance setRegisterApps];
    });
    return _instance;
}
+ (instancetype)shareWTThirdPartyLoginManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        [_instance setRegisterApps];
    });
    return _instance;
}
- (id)copyWithZone:(nullable NSZone *)zone
{
    return _instance;
}


// 注册app
// 注册appid
- (void)setRegisterApps
{
    // 注册Sina微博
    [WeiboSDK registerApp:kSinaAppKey];
    // 微信注册
    [WXApi registerApp:kWeixinAppId];
    
    // 注册QQ
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:kTencentAppId andDelegate:self];
    // 这个是说到时候你去qq那拿什么信息
    _tencentPermissions = [NSMutableArray arrayWithArray:@[/** 获取用户信息 */
                                                           kOPEN_PERMISSION_GET_USER_INFO,
                                                           /** 移动端获取用户信息 */
                                                           kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                                           /** 获取登录用户自己的详细信息 */
                                                           kOPEN_PERMISSION_GET_INFO]];
}


+ (void)getUserInfoWithWTLoginType:(WTLoginType)type result:(WTThirdPartyLoginResultBlock)result
{
    _instance.resultBlock = result;
    _instance.wtLoginType = type;
    if (type == WTLoginTypeWeiBo) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kSinaRedirectURI;
//        request.scope = @"follow_app_official_microblog";
        
        [WeiboSDK sendRequest:request];
    }else if (type == WTLoginTypeTencent){
        
        [_instance.tencentOAuth authorize:_instance.tencentPermissions];
        
    }else if (type == WTLoginTypeWeiXin){
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }
}

#pragma mark - WXApiDelegate

-(void) onResp:(BaseResp*)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    
    if (resp.errCode == WTLoginWeiXinErrCodeSuccess) {
        NSString *code = aresp.code;
        [[WTThirdPartyLoginManager shareWTThirdPartyLoginManager] getWeiXinUserInfoWithCode:code];
    }else{
        
        if (self.resultBlock)
        {
            self.resultBlock(nil, @"授权失败");
        }
    }
    
    
}


- (void)getWeiXinUserInfoWithCode:(NSString *)code
{
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    
    NSBlockOperation * getAccessTokenOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSString * urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeixinAppId,kWeixinAppSecret,code];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSString *responseStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *responseData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        self.access_token = [dic objectForKey:@"access_token"];
    }];
    
    NSBlockOperation * getUserInfoOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSString *urlStr =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token,kWeixinAppId];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSString *responseStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *responseData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        NSDictionary *paramter = @{@"third_id" : dic[@"openid"],
                                   @"third_name" : dic[@"nickname"],
                                   @"third_image":dic[@"headimgurl"],
                                   @"access_token":self.access_token};
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //                _resultBlock;
            self.resultBlock(paramter, nil);
        }];
    }];
    
    [getUserInfoOperation addDependency:getAccessTokenOperation];
    
    [queue addOperation:getAccessTokenOperation];
    [queue addOperation:getUserInfoOperation];
}

#pragma mark - TencentLoginDelegate
//委托
- (void)tencentDidLogin
{
    [_tencentOAuth getUserInfo];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSLog(@"%@", response.jsonResponse);
        NSLog(@"openID %@", [_tencentOAuth openId]);
        NSDictionary *paramter = @{@"third_id" : [_tencentOAuth openId],
                                   @"third_name" : [response.jsonResponse valueForKeyPath:@"nickname"],
                                   @"third_image":[response.jsonResponse valueForKeyPath:@"figureurl_qq_2"],
                                   @"access_token":[_tencentOAuth accessToken]};
        
        if (self.resultBlock)
        {
            self.resultBlock(paramter, nil);
        }
    }
    else
    {
        NSLog(@"登录失败!");
    }
}

- (void)tencentDidLogout
{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

- (void)tencentDidNotNetWork
{
    
}




#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"token %@", [(WBAuthorizeResponse *) response accessToken]);
    NSLog(@"uid %@", [(WBAuthorizeResponse *) response userID]);
    
    [self getWeiBoUserInfo:[(WBAuthorizeResponse *) response userID] token:[(WBAuthorizeResponse *) response accessToken]];
}

- (void)getWeiBoUserInfo:(NSString *)uid token:(NSString *)token
{
    NSString *url =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@&source=%@",uid,token,kSinaAppKey];
    NSURL *zoneUrl = [NSURL URLWithString:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    // 创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:zoneUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", [NSThread currentThread]);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
    
        NSDictionary *paramter = @{@"third_id" : [dic valueForKeyPath:@"idstr"],
                                   @"third_name" : [dic valueForKeyPath:@"screen_name"],
                                   @"third_image":[dic valueForKeyPath:@"avatar_hd"],
                                   @"access_token":token};
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.resultBlock)
            {
                _resultBlock(paramter, nil);
            }
        }];
        
    }];
    
    // 启动任务
    [task resume];
}

@end

```

- 1.demo下载以后,请在WTThirdPartyLoginManager里面将自己的个平台的app key写上去.
- 2.URL Schemes 也请各位自己配置好