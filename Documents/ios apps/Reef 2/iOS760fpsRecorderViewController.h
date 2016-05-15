

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface iOS760fpsRecorderViewController : UIViewController  <AVCaptureFileOutputRecordingDelegate>
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureDevice *videoDevice;
@property (retain) AVCaptureMovieFileOutput* fo;
@property (retain) UIButton* startStopButton;
@end