//
//  VerifyViewController.m
//  Reef
//
//  Created by Ant on 2/23/16.
//  Copyright © 2016 iOSDevStar. All rights reserved.
//

#import "VerifyViewController.h"
#import "Global.h"
#import "SingUpViewController.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    FAKFontAwesome *iconBack = [FAKFontAwesome chevronCircleLeftIconWithSize:NAVI_ICON_SIZE];
    [iconBack addAttribute:NSForegroundColorAttributeName value:DARK_GRAY_COLOR];
    UIImage *imgBack = [iconBack imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
    
    UIBarButtonItem* naviBackItem = [[UIBarButtonItem alloc] initWithImage:imgBack style:UIBarButtonItemStylePlain target:self action:@selector(backToMainView)];
    self.navigationItem.leftBarButtonItem = naviBackItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated   {
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Invite Code";
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verifyAction:(id)sender {
    
    NSString * verificationCode = self.verification_code.text;
    
    if (verificationCode == nil || verificationCode.length == 0) {
        [self showAlert:@"Please enter invite code"];
        [self.verification_code setText:@""];
        return;
    }
    
    if (![verificationCode isEqualToString:@"mrr2sjduxi"]) {
        [self showAlert:@"Incorrect code"];
        [self.verification_code setText:@""];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SingUpViewController* viewCon = [storyboard instantiateViewControllerWithIdentifier:@"signupview"];
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void)showAlert:(NSString*) message   {
    
    UIAlertView * alerview = [[UIAlertView alloc] initWithTitle:APP_FULL_NAME message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alerview show];
}
@end
