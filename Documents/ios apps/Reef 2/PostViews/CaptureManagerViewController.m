//
//  CaptureManagerViewController.m
//  reef
//
//  Created by iOSDevStar on 8/15/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CaptureManagerViewController.h"
#import "PBJCaptureViewController.h"
#import "FilterViewController.h"
#import "Global.h"

@interface CaptureManagerViewController ()

@end

@implementation CaptureManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curNavCon = nil;
    
    [self addPhotoCaptureViewCon];

    [GlobalPool sharedObject].m_curCaptureManagerViewCon = self;
}

- (void) viewWillAppear:(BOOL)animated
{
}

- (void) backToMainView
{
    [GlobalPool sharedObject].m_curCaptureManagerViewCon = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLoadingView
{
    [[GlobalPool sharedObject] showLoadingView:self.view];
}

- (void) hideLoadingView
{
    [[GlobalPool sharedObject] hideLoadingView:self.view];
}

- (void) addPhotoCaptureViewCon
{
    if (curNavCon)
    {
        [curNavCon willMoveToParentViewController:nil];
        [curNavCon.view removeFromSuperview];
        curNavCon = nil;
    }
    
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [container setCameraViewController:cameraController];
    [container setFullScreenMode];
    
    [cameraController setForceQuadCrop:YES];
    cameraController.useCameraSegue = false;
    
    UINavigationController *naviViewCon = [[UINavigationController alloc] initWithRootViewController:container];
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(.0f, .0f);
    naviViewCon.navigationBar.barTintColor = NAVI_COLOR;
    naviViewCon.navigationBar.tintColor = [UIColor whiteColor];
    naviViewCon.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:NAVI_FONT_SIZE], NSFontAttributeName,
                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                     shadow, NSShadowAttributeName,
                                                     nil];
    naviViewCon.navigationBar.translucent = NO;
    naviViewCon.navigationBarHidden = YES;
    
    [self addChildViewController:naviViewCon];
    [self.m_subView addSubview:naviViewCon.view];
    [naviViewCon didMoveToParentViewController:self];
    
    curNavCon = naviViewCon;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) dismissCamera:(id)cameraViewController{
    
    [GlobalPool sharedObject].m_curCaptureManagerViewCon = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    image = [[GlobalPool sharedObject] scaleAndCropImage:image toSize:CGSizeMake(640, 640)];
    
    /*
     [GlobalPool sharedObject].m_bEditFromInbox = false;
     
     CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:img delegate:nil];
     [self.navigationController pushViewController:editor animated:YES];
     */
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];

    
    FilterViewController* viewCon = [storyboard instantiateViewControllerWithIdentifier:@"filterview"];
    viewCon.m_imgPost = image;
    [curNavCon pushViewController:viewCon animated:YES];
}

@end
