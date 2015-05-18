//
//  WebViewController.m
//  TicTacToe
//
//  Created by Tony Dakhoul on 5/18/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [[NSURL alloc] initWithString:@"http://en.wikipedia.org/wiki/Tic-tac-toe"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    [self.webView loadRequest:request];

}
- (IBAction)onCloseTapped:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
