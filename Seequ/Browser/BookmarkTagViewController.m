//
//  BookmarkTagViewController.m
//  Seequ
//
//  Created by Peng Wan on 3/3/15.
//  Copyright (c) 2015 Seequ. All rights reserved.
//

#import "BookmarkTagViewController.h"

@interface BookmarkTagViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BookmarkTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonTouchUpInside:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
