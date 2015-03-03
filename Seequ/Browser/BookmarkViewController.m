//
//  BookmarkViewController.m
//  Seequ
//
//  Created by Paul on 3/2/15.
//  Copyright (c) 2015 Seequ. All rights reserved.
//

#import "BookmarkViewController.h"
#import "BookmarkListViewController.h"
#import "AddFolderViewController.h"
#import "HistoryViewController.h"

@interface BookmarkViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *bookmarkFolders;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addFolderButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bookmarkFolders = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self configureBookmarkFolderList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1 + self.bookmarkFolders.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Bookmark"
                                                                 forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"History";
    }
    else {
        
        cell.textLabel.text = self.bookmarkFolders[indexPath.row - 1];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *bookmarkDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"Bookmarks"];
        
        // Fetch the directory path for the folder which will delete
        //
        NSString *folderName = self.bookmarkFolders[indexPath.row - 1];
        NSString *folderDirectoryPath = [bookmarkDirectoryPath stringByAppendingPathComponent:folderName];
        
        if ([[NSFileManager defaultManager]removeItemAtPath:folderDirectoryPath error:nil]) {
            
            [_bookmarkFolders removeObjectAtIndex:indexPath.row - 1];
            
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (! tableView.editing) {
        
        if (indexPath.row == 0) {
            
            HistoryViewController *historyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyView"];
            [self.navigationController pushViewController:historyViewController animated:YES];
            
        }
        else {
            
            BookmarkListViewController *bookmarkListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bookmarkListView"];
            
            NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *bookmarkDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"Bookmarks"];
            
            NSString *folderName = self.bookmarkFolders[indexPath.row - 1];
            NSString *folderDirectoryPath = [bookmarkDirectoryPath stringByAppendingPathComponent:folderName];
            bookmarkListViewController.currentBookmarkDirectoryPath = folderDirectoryPath;
            
            [self.navigationController pushViewController:bookmarkListViewController animated:YES];
            
        }
    }
    
}

#pragma mark - Bookmark List Stuff

- (void)configureBookmarkFolderList {
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *bookmarkDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"Bookmarks"];
    
    [_bookmarkFolders removeAllObjects];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *currentBookmarkFolders = [fileManager subpathsOfDirectoryAtPath:bookmarkDirectoryPath error:nil];
    for (NSString *folder in currentBookmarkFolders) {
        
        if ([folder componentsSeparatedByString:@"/"].count == 1) {
            
            [_bookmarkFolders addObject:folder];
            
        }
        
    }
    
    [self.tableView reloadData];
    
}

- (void)switchEditMode:(BOOL)finished {
    
    _doneButton.hidden = finished;
    _addFolderButton.hidden = !finished;

    // Switch to the edit mode
    //
    [_tableView setEditing:finished animated:YES];
    [_editButton setTitle:finished? @"Done": @"Edit"
                 forState:UIControlStateNormal];
    
}

#pragma mark - Control's Action

- (IBAction)doneButtonTouchUpInside:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)editButtonTouchUpInside:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    BOOL switched = [button.currentTitle isEqualToString:@"Edit"];
    [self switchEditMode:switched];
    
}

- (IBAction)addFolderTouchUpInside:(id)sender {
    
    AddFolderViewController *addFolderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editFolderView"];
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *bookmarkDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"Bookmarks"];
    
    addFolderViewController.currentBookmarkDirectoryPath = bookmarkDirectoryPath;
    [self.navigationController pushViewController:addFolderViewController animated:YES];
    
}

@end
