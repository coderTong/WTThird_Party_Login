//
//  BDJLoginRegisterController.m
//  budejie
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "BDJLoginRegisterController.h"
#import "BDJVerticalButton.h"

#import "WTThirdPartyLoginManager.h"

@interface BDJLoginRegisterController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation BDJLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)loginBtnClick:(BDJVerticalButton *)btn {
    
    self.loginView.hidden = YES;
    
    WTLoginType loginType;
    if (btn.tag == WTLoginTypeWeiBo) {
        loginType = WTLoginTypeWeiBo;
    }else if (btn.tag == WTLoginTypeTencent){
        loginType = WTLoginTypeTencent;
    }else if (btn.tag == WTLoginTypeWeiXin){
       loginType = WTLoginTypeWeiXin;
    }
 
    
    [WTThirdPartyLoginManager getUserInfoWithWTLoginType:loginType result:^(NSDictionary *LoginResult, NSString *error) {

        
        NSLog(@"%@",[NSThread currentThread]);
        
        if (LoginResult) {

            NSLog(@"🐒🐒🐒🐒🐒🐒🐒🐒-----%@", LoginResult);
            
            
           
            self.userView.hidden = NO;
            self.userName.text = LoginResult[@"third_name"];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:LoginResult[@"third_image"]]];
            self.userIcon.image = [UIImage imageWithData:data];
            

        }else{
            NSLog(@"%@",error);
        }
        
    }];
}







- (IBAction)backBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
