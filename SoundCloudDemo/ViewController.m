//
//  ViewController.m
//  SoundCloudDemo
//
//  Created by Sanjeev Kumar Gautam on 01/08/13.
//  Copyright (c) 2013 sanjeev kumar Gautam. All rights reserved.
//

#import "SCUI.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) login:(id) sender
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Done!");
            
            SCAccount *account = [SCSoundCloud account];
            
            if (account) {
                [SCRequest performMethod:SCRequestMethodGET
                              onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me.json"]
                         usingParameters:nil
                             withAccount:account
                  sendingProgressHandler:nil
                         responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                             // Update the user info
                             NSLog(@"%@",data);
                         }];
            } else {
                // Maybe you would like to update your user interface to show that ther is no account.
                NSLog(@"No account");
            }
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        [self presentModalViewController:loginViewController animated:YES];
    }];
}
@end
