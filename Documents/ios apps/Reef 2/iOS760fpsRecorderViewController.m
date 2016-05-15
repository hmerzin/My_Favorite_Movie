



#import "iOS760fpsRecorderViewController.h"

@interface iOS760fpsRecorderViewController ()
@end

@implementation iOS760fpsRecorderViewController
@synthesize captureSession;
@synthesize previewLayer, fo, videoDevice, startStopButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.startStopButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 40, 80, 60)];
    [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [startStopButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // 1. session
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // 2. in
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (!error) {
        if ([self.captureSession canAddInput:videoIn])
            [self.captureSession addInput:videoIn];
        else
            NSLog(@"Video input add-to-session failed");
    }
    else
        NSLog(@"Video input creation failed");
    
    // 3. out
    self.fo = [[AVCaptureMovieFileOutput alloc] init];
    [self.captureSession addOutput:self.fo];
    
    
    // 4. display preview
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    previewLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.startStopButton];
    [self.captureSession startRunning];
}

-(NSUInteger)supportedInterfaceOrientations{
    NSLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskPortrait;
}

-(void)startVideoRecording
{
    int    selectedAVCaptureDeviceFormatIdx = 15; // Full HD
    
    [videoDevice lockForConfiguration:nil];
    
    AVCaptureDeviceFormat* currdf = [videoDevice.formats objectAtIndex:selectedAVCaptureDeviceFormatIdx];
    videoDevice.activeFormat = currdf;
    if (selectedAVCaptureDeviceFormatIdx==12 || selectedAVCaptureDeviceFormatIdx==13)
        videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1,60);
    
    NSLog(@"videoMaxZoomFactor: %f", videoDevice.activeFormat.videoMaxZoomFactor);
    NSLog(@"videoZoomFactorUpscaleThreshold: %f", videoDevice.activeFormat.videoZoomFactorUpscaleThreshold);
    
    self.videoDevice.videoZoomFactor = videoDevice.activeFormat.videoZoomFactorUpscaleThreshold;
    //        self.videoDevice.videoZoomFactor = 3;
    
    [videoDevice unlockForConfiguration];
    
    int fileNamePostfix = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = nil;
    do
        filePath =[NSString stringWithFormat:@"/%@/%i.mp4", documentsDirectory, fileNamePostfix++];
    while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    NSURL* fileURL = [NSURL URLWithString:[@"file://" stringByAppendingString:filePath]];
    [self.fo startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{}

- (void)buttonPressed
{
    if ([self.startStopButton.titleLabel.text isEqualToString:@"Start"])
    {
        [startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self startVideoRecording];
    }
    else
    {
        [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.fo stopRecording];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end