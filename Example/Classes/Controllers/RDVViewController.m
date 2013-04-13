// RDVViewController.m
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVViewController.h"
#import "RDVKeychainWrapper.h"

#define kRDVKeychainDemoEmail @"com.robbdimitrov.keychain:email"
#define kRDVKeychainDemoPassword @"com.robbdimitrov.keychain:password"

@interface RDVViewController () <UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RDVViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *email = nil;
    NSString *password = nil;
    
    email = [[RDVKeychainWrapper sharedKeychainWrapper] objectForKey:kRDVKeychainDemoEmail];
    if (email) {
        [[self emailField] setText:email];
    }
    
    password = [[RDVKeychainWrapper sharedKeychainWrapper] objectForKey:kRDVKeychainDemoPassword];
    if (password) {
        [[self passwordField] setText:password];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)dismissKeyboard:(id)sender {
    if ([self.emailField isFirstResponder]) {
        [self.emailField resignFirstResponder];
    } else if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Clear keychain?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Clear"
                                                        otherButtonTitles:nil,
                                      nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        RDVKeychainWrapper *keychainWrapper = [RDVKeychainWrapper sharedKeychainWrapper];
        [keychainWrapper removeObjectForKey:kRDVKeychainDemoEmail];
        [keychainWrapper removeObjectForKey:kRDVKeychainDemoPassword];
        [[self emailField] setText:@""];
        [[self passwordField] setText:@""];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.emailField) {
        [[RDVKeychainWrapper sharedKeychainWrapper] setObject:self.emailField.text forKey:kRDVKeychainDemoEmail];
    } else {
        [[RDVKeychainWrapper sharedKeychainWrapper] setObject:self.passwordField.text forKey:kRDVKeychainDemoPassword];
    }
}

@end
