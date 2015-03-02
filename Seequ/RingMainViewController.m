//
//  RingMainViewController.m
//  Seequ
//
//  Created by peng wan on 15-2-10.
//  Copyright (c) 2015 Seequ. All rights reserved.
//

#import "RingMainViewController.h"
#import "App_StyleKit.h"

@interface RingMainViewController ()

@end

@implementation RingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem *itemContact = [self.tabBar.items objectAtIndex:0];
    itemContact.image = [[App_StyleKit imageOfTab_bar_icon_contactsWithPressed:NO notifications:2525.0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemContact.selectedImage = [[App_StyleKit imageOfTab_bar_icon_contactsWithPressed:YES notifications:0.0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *itemMessage = [self.tabBar.items objectAtIndex:1];
    itemMessage.image = [[App_StyleKit imageOfTab_bar_icon_messagesWithPressed:NO notifications:123.0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemMessage.selectedImage = [[App_StyleKit imageOfTab_bar_icon_messagesWithPressed:YES notifications:0.0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *itemBrowser = [self.tabBar.items objectAtIndex:2];
    itemBrowser.image = [[App_StyleKit imageOfTab_bar_icon_browserWithPressed:NO notifications:21.0 buddybrowse:NO] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemBrowser.selectedImage = [[App_StyleKit imageOfTab_bar_icon_browserWithPressed:YES notifications:0.0 buddybrowse:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *itemActivity = [self.tabBar.items objectAtIndex:3];
    itemActivity.image = [[App_StyleKit imageOfTab_bar_icon_activityWithPressed:NO notifications:3.0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemActivity.selectedImage = [[App_StyleKit imageOfTab_bar_icon_activityWithPressed:YES notifications:0.0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *itemTakes = [self.tabBar.items objectAtIndex:4];
    itemTakes.image = [[App_StyleKit imageOfTab_bar_icon_takesWithPressed:NO notifications:4.0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemTakes.selectedImage = [[App_StyleKit imageOfTab_bar_icon_takesWithPressed:YES notifications:0.0]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
