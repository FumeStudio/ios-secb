//
//  AppDelegate.m
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "HomeViewController.h"
#import "SelectLanguageScreenViewController.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "CustomNavigationControllerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:isIPhone? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIViewController* rootViewController = nil;
    
    BOOL didSelectLanguageBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"didSelectLanguageBefore"];
    if(didSelectLanguageBefore)
    {
        [[LocalizationManager sharedInstance] setLanguage:[LocalizationManager sharedInstance].language];
        rootViewController = ([UserManager cookiesExpired])? [SignInViewController new] : [HomeViewController new];
    }
    else
        rootViewController = [SelectLanguageScreenViewController new];

    UINavigationController* navigationController = [[CustomNavigationControllerViewController alloc] initWithRootViewController:rootViewController];
    [navigationController setNavigationBarHidden:YES];

    //self.window.rootViewController = navigationController;
    //[self.window addSubview:navigationController.view];// = navigationController;
    if(isIPhone)
    {
        self.window.rootViewController = navigationController;
    }
    else
    {
        if([rootViewController isKindOfClass:[HomeViewController class]])
        {
            [self setHomeViewController];
        }
        else
            self.window.rootViewController = navigationController;
            
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setHomeViewController
{
    UINavigationController* navigationController = [[CustomNavigationControllerViewController alloc] initWithRootViewController:[HomeViewController new]];
    [navigationController setNavigationBarHidden:YES];

    SuperViewController* windowRoot = [SuperViewController new];
    windowRoot.iPadCustomNavigationController = navigationController;
    CGRect frame = navigationController.view.frame;
    frame.origin.x = 338;
    frame.size.width = 686;
    navigationController.view.frame = frame;
    windowRoot.view.backgroundColor = [UIColor redColor];
    [windowRoot.view addSubview:navigationController.view];
    [windowRoot menuButtonPressed:nil];
    
    self.window.rootViewController = windowRoot;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    SEL sel = NSSelectorFromString(@"firstResponder");
    id firstResponder = [window performSelector:sel];
    
    if([firstResponder isKindOfClass:[XCDYouTubeVideoPlayerViewController class]])
        return UIInterfaceOrientationMaskAll;
    else if(isIPhone)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
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
    // Saves changes in the application's managed object context before the application terminates.
}

@end
