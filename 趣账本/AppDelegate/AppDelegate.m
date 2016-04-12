//
//  AppDelegate.m
//  趣账本
//
//  Created by wengYQ on 15/12/13.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <FMDB.h>
#import "IMCNetAPIManager.h"
#import "UserModel.h"
#import "AddRecordViewController.h"
@interface AppDelegate ()
@property (nonatomic,strong) NSString *UserAccount;
@property (nonatomic,strong) NSString *pass;
@property (nonatomic,strong) UINavigationController *NavVC;
@property (nonatomic,strong) UserModel *rootUser;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginViewController *LoginVC = MCInitViewControllerFromStoryboard(@"Main",@"LoginViewController");
    NSString *DocPath = PATH_OF_DOCUMENT;
    NSString * dbpath = [DocPath stringByAppendingPathComponent:@"user.sqlite"];
    FMDatabase * db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        NSString * sql = @"select * from user";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            
            _UserAccount = [rs stringForColumn:@"UserAccount"];
            _pass = [rs stringForColumn:@"password"];
        }
        [db close];
    }
    
    _NavVC = [[UINavigationController alloc]init];
    self.window.rootViewController = _NavVC;

    if (_UserAccount == nil) {
        [_NavVC pushViewController:LoginVC animated:YES];
        DLog(@"数据列表为空");
    }else{
        MCSelf(weakSelf);
        NSDictionary *param = @{
                                @"userAccount" : _UserAccount,
                                };
        [[IMCNetAPIManager share] requestUserWithAccount:nil GetParams:param  andBlock:^(Response *response) {
            if (response.isSuccess) {
                NSError *error = Nil;
                weakSelf.rootUser = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:response.data error:&error];
                if ([_pass isEqualToString:weakSelf.rootUser.password]) {
                    //存储在数据表中的帐号和密码与服务器相匹配，直接跳转到主页面
                    AddRecordViewController *mainVC = [[AddRecordViewController alloc]initWithRootUser:weakSelf.rootUser];
                    [_NavVC pushViewController:mainVC animated:YES];
                }
            }else{
                DLog(@"请求失败");
                 [_NavVC pushViewController:LoginVC animated:YES];
            }
        }];
    }
    [AppDelegate setDefaultNavigationBar];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)setDefaultNavigationBar {
    NSShadow *shadow    = [[NSShadow alloc] init];
    shadow.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor colorWithRed:0.961 green:1.000 blue:0.984 alpha:1.000],
                                                           NSShadowAttributeName : shadow,
                                                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0]}];
    //[UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.494 green:0.757 blue:0.765 alpha:1.000];
    [UINavigationBar appearance].tintColor    = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"LoginBackGround.jpg"] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].barStyle     = UIBarStyleDefault;
}
@end
