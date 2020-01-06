//
//  ConfirmOTPViewController.m
//  HappyLuckySale
//
//  Created by Macbook on 5/17/19.
//  Copyright © 2019 HuCuBi. All rights reserved.
//

#import "ConfirmOTPViewController.h"
#import "RegisterViewController.h"
#import "Utils.h"
#import "CallAPI.h"

@interface ConfirmOTPViewController ()

@end

@implementation ConfirmOTPViewController {
    AKFAccountKit * accountKit;
    BOOL isShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserDefaultShopInfo];
    
    NSString *linkAvatar = [Utils convertStringUrl:dict[@"AVATAR"]];
    NSURL *urlAvatar = [NSURL URLWithString:linkAvatar];
    [self.imageAvatarShop sd_setImageWithURL:urlAvatar placeholderImage:[UIImage imageNamed:@"logo_main"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([accountKit currentAccessToken] && !isShow) {
        [accountKit requestAccount:^(id<AKFAccount> account, NSError *error) {
            // account ID
            if ([account phoneNumber] != nil) {
                NSString *phone = [[[account phoneNumber] stringRepresentation] stringByReplacingOccurrencesOfString:@"+84" withString:@"0"];
                NSString *content = [NSString stringWithFormat:@"Bạn muốn dùng số điện thoại %@ để đăng ký không?",phone];
                self->isShow = YES;
                [Utils alert:@"Đăng ký tài khoản" content:content titleOK:@"Đồng ý" titleCancel:@"Dùng số khác" viewController:self completion:^{
                    RegisterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
                    vc.phoneNumber = phone;
                    [self presentViewController:vc animated:YES completion:nil];
                }];
            }
        }];
    } else {
        
    }
}

- (IBAction)active:(id)sender {
    NSString *inputState = [[NSUUID UUID] UUIDString];
    AKFPhoneNumber *phone = [[AKFPhoneNumber alloc] initWithCountryCode:@"+84" phoneNumber:@""];
    UIViewController<AKFViewController> *viewController = [accountKit viewControllerForPhoneLoginWithPhoneNumber:phone state:inputState];
    [self _prepareLoginViewController:viewController]; // see above
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (IBAction)goBack:(id)sender {
    [[self appDelegate].window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
    [[self appDelegate].window makeKeyAndVisible];
}

- (IBAction)enterShopID:(id)sender {
    [[self appDelegate].window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"EnterShopCodeViewController"]];
    [[self appDelegate].window makeKeyAndVisible];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark FB OTP
- (void)_prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController {
    loginViewController.delegate = self; // Optionally, you may set up backup verification methods.
    loginViewController.enableSendToFacebook = YES;
    loginViewController.enableGetACall = YES;
    
    //    viewController.uiManager = [[AKFSkinManager alloc] initWithSkinType:AKFSkinTypeClassic primaryColor:[UIColor blueColor]];
}

// handle callbacks on successful login to show account
- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state {
    //    [self proceedToMainScreen];
    
    [self processAcc];
    NSLog(@"=============== OK ==================");
}


// handle callback on successful login to show authorization code
- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAuthorizationCode:(NSString *)code state:(NSString *)state {
    // Pass the code to your own server and have your server exchange it for a user access token.
    // You should wait until you receive a response from your server before proceeding to the main screen.
    //    [self sendAuthorizationCodeToServer:code];
    //    [self proceedToMainScreen];
    [self processAcc];
    NSLog(@"=============== OK 2 ==================");

}


- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error {
    // ... implement appropriate error handling ...
    NSLog(@"%@ did fail with error: %@", viewController, error);
}


- (void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController {
    // ... handle user cancellation of the login process ...
    NSLog(@"=============== cancel ==================");
}

- (void)processAcc {
    [accountKit requestAccount:^(id<AKFAccount> account, NSError *error) {
        // account ID
        if ([account phoneNumber] != nil) {
//            self.labelPhoneNumber.text = [[account phoneNumber] stringRepresentation];
            RegisterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
            vc.phoneNumber = [[[account phoneNumber] stringRepresentation] stringByReplacingOccurrencesOfString:@"+84" withString:@"0"];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];

}

@end
