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
