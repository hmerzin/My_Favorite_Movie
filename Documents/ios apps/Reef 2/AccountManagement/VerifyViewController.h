//
//  VerifyViewController.h
//  Reef
//
//  Created by Ant on 2/23/16.
//  Copyright © 2016 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *verification_code;
- (IBAction)verifyAction:(id)sender;

@end
