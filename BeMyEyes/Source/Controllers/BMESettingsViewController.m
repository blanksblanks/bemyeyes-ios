//
//  BMESettingsViewController.m
//  BeMyEyes
//
//  Created by Simon Støvring on 09/03/14.
//  Copyright (c) 2014 Be My Eyes. All rights reserved.
//

#import "BMESettingsViewController.h"
#import <MRProgress/MRProgress.h>
#import "BMEClient.h"
#import "BMEUser.h"

#define BMEUnwindSettingsSegue @"UnwindSettings"

@interface BMESettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UISwitch *boostSwitch;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation BMESettingsViewController

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameTextField.text = [BMEClient sharedClient].currentUser.firstName;
    self.lastNameTextField.text = [BMEClient sharedClient].currentUser.lastName;
    self.emailTextField.text = [BMEClient sharedClient].currentUser.email;
    
    NSString *majorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *strVersion = [NSString stringWithFormat:@"%@ (%@)", majorVersion, minorVersion];
    self.versionLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"VERSION_TITLE", @"BMESettingsViewController", @"Version title"), strVersion];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark -
#pragma mark Private Methods

- (IBAction)logOutButtonPressed:(id)sender {
    MRProgressOverlayView *progressOverlayView = [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
    progressOverlayView.mode = MRProgressOverlayViewModeIndeterminate;
    progressOverlayView.titleLabelText = NSLocalizedStringFromTable(@"OVERLAY_LOGGING_OUT_TITLE", @"BMESettingsViewController", @"Title in overlay shown when logging out");
    
    [[BMEClient sharedClient] logoutWithCompletion:^(BOOL success, NSError *error) {
        [progressOverlayView hide:YES];
        
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BMEDidLogOutNotification object:nil];
            
            [self performSegueWithIdentifier:BMEUnwindSettingsSegue sender:self];
        } else {
            NSString *title = NSLocalizedStringFromTable(@"ALERT_LOG_OUT_FAILED_TITLE", @"BMESettingsViewController", @"Title in alert view shown when log out failed");
            NSString *message = NSLocalizedStringFromTable(@"ALERT_LOG_OUT_FAILED_MESSAGE", @"BMESettingsViewController", @"Messaage in alert view shown when log out failed");
            NSString *cancelTitle = NSLocalizedStringFromTable(@"ALERT_LOG_OUT_FAILED_CANCEL", @"BMESettingsViewController", @"Title of cancel button in alert view shown when log out failed");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (IBAction)changePasswordButtonPressed:(id)sender {
    
}

- (IBAction)boostSwitchValueChanged:(id)sender {
    
}

#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

@end
