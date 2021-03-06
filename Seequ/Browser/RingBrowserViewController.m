//
//  RingBrowserViewController.m
//  Seequ
//
//  Created by Jose Correa on 2/6/15.
//  Copyright (c) 2015 Seequ. All rights reserved.
//

#import "RingBrowserViewController.h"
#import "RingBrowserNavBarTextfield.h"
#import "RingBrowserButton.h"
#import "RingBrowserRefreshButton.h"
#import <WebKit/WebKit.h>
#import "BookmarkViewController.h"
#import "AddBookmarkViewController.h"
#import "RingRealmManager.h"
#import "Bookmark.h"
#import "Folder.h"
#import "RingStyleKit.h"

static CGFloat const navBarHeight = 66.0f;
static CGFloat const tabBarHeight = 49.0f;

#define kRootAncestorID 0
#define kRootFolderID 1
#define kHistoryFolderID 2

@interface RingBrowserViewController () <UITextFieldDelegate, WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet RingBrowserButton *prevArrowButton;
@property (weak, nonatomic) IBOutlet RingBrowserButton *nextArrowButton;
@property (weak, nonatomic) IBOutlet RingBrowserButton *buddyBrowserButton;
@property (weak, nonatomic) IBOutlet RingBrowserButton *bookmarkButton;
@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet RingBrowserNavBarTextfield *browserURLTextfield;
@property (strong, nonatomic) RingBrowserRefreshButton *refreshButton;

@property (strong, nonatomic) Folder *rootFolder;
@property (strong, nonatomic) Folder *historyFolder;
@property (nonatomic, strong) RingRealmManager *realmManager;

@end

@implementation RingBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // Add a observer
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadBookmarkWithURL:) name:@"SeeNotificationLoadURL" object:nil];
    [self configureHistoryFolder];
    
    self.webView = [[WKWebView alloc] initWithFrame: CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - tabBarHeight)];
    self.webView.navigationDelegate = self;
    
    NSURL *url = [NSURL URLWithString:@"http://cnn.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    self.refreshButton = [[RingBrowserRefreshButton alloc] initWithFrame:CGRectMake(0, 0, 13, 12)];
    [self.refreshButton addTarget:self action:@selector(browserURLTextfieldRefreshButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

    self.browserURLTextfield.rightView = self.refreshButton;
    self.browserURLTextfield.text = @"http://www.cnn.com";
    self.browserURLTextfield.rightViewMode = UITextFieldViewModeAlways;
        
    self.navBarView.backgroundColor = [RingStyleKit seequFoam];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SeeNotificationLoadURL" object:nil];
    
}

#pragma mark -  Observer Method

- (void)loadBookmarkWithURL:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *urlString = userInfo[@"url"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];

    [self.webView stopLoading];
    [self.webView loadRequest:request];
    
    self.browserURLTextfield.text = urlString;
    
}

#pragma mark - HTTP Request Stuff

- (NSURL *)reconstructHTTPRequest:(NSString *)requestString {
    
    if ([requestString hasPrefix:@"http://"]) {
        return [NSURL URLWithString:requestString];
    }
    else {
        
        NSString *httpString = @"http://";
        NSString *reconstructedURLString = [httpString stringByAppendingString:requestString];
        
        return [NSURL URLWithString:reconstructedURLString];
    }
    
}

- (void)saveBookmark {
    
    // Fetch the current date for the bookmark name
    //
    NSString *currentDateString = [self fetchCurrentDate];
        
    // Save historyBookmark
    //
    NSString *urlString = [NSString stringWithFormat:@"%@", self.webView.URL];
    
    Bookmark *bookmark = [[Bookmark alloc]init];
    
    bookmark.name = currentDateString;
    bookmark.url = urlString;
    bookmark._id = [RingRealmManager validIndexFrom:[Bookmark class]];
    bookmark.saveDate = [NSDate date];
    bookmark.folderID = self.historyFolder._id;
    
    [RingRealmManager addObject:bookmark];
    
}

- (NSString *)fetchCurrentDate {
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-hh-mm"];
    
    return [dateFormatter stringFromDate:date];
    
}

- (void)configureHistoryFolder {
    
    _rootFolder = [Folder objectsWhere:@"ancestorID = 0"].lastObject;
    
    // Create the folder when they are not exisr
    //
    if (! self.rootFolder) {
    
        // Create the root folder
        //
        Folder *rootFolder = [[Folder alloc]init];
        
        rootFolder.name = @"Bookmark";
        rootFolder.ancestorName = @"/";
        rootFolder.ancestorID = kRootAncestorID;
        rootFolder.saveDate = [NSDate date];
        rootFolder._id = kRootFolderID;
        [RingRealmManager addObject:rootFolder];
     
        _rootFolder = rootFolder;
        
        // Create the history folder
        //
        Folder *historyFolder = [[Folder alloc]init];
        
        historyFolder.name = @"History";
        historyFolder.ancestorID = rootFolder._id;
        historyFolder.ancestorName = @"Bookmark";
        historyFolder._id = kHistoryFolderID;
        historyFolder.saveDate = [NSDate date];
        [RingRealmManager addObject:historyFolder];
        
        _historyFolder = historyFolder;
        
    }
    
    else {
        
        _historyFolder = [Folder objectsWhere:@"_id = 2"].lastObject;
        
    }
    
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.browserURLTextfield.rightView = nil;
    self.browserURLTextfield.clearButtonMode = UITextFieldViewModeAlways;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.webView stopLoading];
    
    NSURL *url = [self reconstructHTTPRequest:textField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    // Save bookmark
    //
    [self saveBookmark];
    
    self.browserURLTextfield.clearButtonMode = UITextFieldViewModeNever;
    self.browserURLTextfield.rightView = self.refreshButton;
    self.browserURLTextfield.rightViewMode = UITextFieldViewModeAlways;
    
    
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark - Control's Actions

- (void)browserURLTextfieldRefreshButtonTouchUpInside:(id)sender {
    
    [self.webView reload];
    
}

- (IBAction)prevArrowClick:(id)sender {
    [self.webView stopLoading];
    [self.webView goBack];
}

- (IBAction)nextArrowClick:(id)sender {
    [self.webView stopLoading];
    [self.webView goForward];
}

- (IBAction)addBookmarkTouchUpInside:(id)sender {
    
    AddBookmarkViewController *addBookmarkViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addBookmarkView"];
    addBookmarkViewController.urlString = [NSString stringWithFormat:@"%@", self.webView.URL];
    addBookmarkViewController.rootFolder = self.rootFolder;
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addBookmarkViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
