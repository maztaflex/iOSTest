//
//  YHGoogleLoginViewController.m
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 31..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHGoogleLoginViewController.h"
#import <GooglePlus/GooglePlus.h>
//#import <GPPURLHandler.h>

@interface YHGoogleLoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YHGoogleLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchedCloseBtn:) name:YHGoogleLoginSuccessNotification object:nil];
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:self.urlForWebView]];
}

#pragma mark - IBAction

- (IBAction)touchedCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    LogGreen(@"CHECK AFTER SHARE : %@", [request URL]);
    
    if ([[[request URL] absoluteString] hasPrefix:@"com.smtown.:/oauth2callback"])
    {
        [GPPURLHandler handleURL:[request URL] sourceApplication:@"com.apple.mobilesafari" annotation:nil];
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    LogRed(@"didFailLoadWithError : %@",error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{}
@end
