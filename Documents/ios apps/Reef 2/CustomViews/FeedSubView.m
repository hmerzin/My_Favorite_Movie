//
//  FeedSubView.m
//  reef
//
//  Created by iOSDevStar on 1/4/16.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "FeedSubView.h"
#import "Global.h"

@implementation FeedSubView

- (void)awakeFromNib {
    self.m_userImageView.layer.cornerRadius = self.m_userImageView.frame.size.height / 2.f;
    self.m_userImageView.layer.borderColor = GREEN_COLOR.CGColor;
    self.m_userImageView.layer.borderWidth = 0.f;
    self.m_userImageView.clipsToBounds = YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"FeedSubView" owner:self options:nil];
        self=[nibArray objectAtIndex:0];
        
        self.m_progressView.timeLimit = 100;
        self.m_progressView.elapsedTime = 0;
        
        self.m_viewLoading.hidden = YES;
        
        self.m_btnAction.delegate = self;
        
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prevImageView:)];
//        singleTap.numberOfTapsRequired = 1;
//        [self.m_btnAction addGestureRecognizer:singleTap];
        
        UISwipeGestureRecognizer *doubleTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(doubleTapped:)];
        doubleTap.direction = UISwipeGestureRecognizerDirectionDown;
        [self.m_btnAction addGestureRecognizer:doubleTap];
        
//        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionRefresh:(id)sender {
    [self downloadResourceFromServer];
}

- (void)prevImageView:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate touchTapView:self status:true];
    }
    else    {
        [self.delegate touchTapView:self status:false];
    }
}

- (void)didDoubleTapZoomableView:(UIView *)zoomableView state:(bool)bStartTap   {
    [self.delegate touchTapView:self status:bStartTap];
}

- (void)doubleTapped:(UISwipeGestureRecognizer *)gesture  {
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate touchDoubleTapView:self];
    }
}

- (void) downloadResourceFromServer
{
    self.m_viewLoading.hidden = NO;
    
    self.m_progressView.hidden = NO;
    self.m_btnRefresh.hidden = YES;
    
    NSURL *URL = [NSURL URLWithString:self.m_strResourceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [URL lastPathComponent];
    self.m_strResourceLocalPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    NSData *resourceData = [NSData dataWithContentsOfFile:self.m_strResourceLocalPath];
    if (resourceData)
    {
        self.m_progressView.hidden = YES;
        self.m_viewLoading.hidden = YES;

        if ([[self.m_strResourceLocalPath lowercaseString] rangeOfString:@"png"].location != NSNotFound || [[self.m_strResourceLocalPath lowercaseString] rangeOfString:@"jpg"].location != NSNotFound)
        {
            self.m_postImageView.image = [UIImage imageWithContentsOfFile:self.m_strResourceLocalPath];
        }
        
        resourceData = nil;
    }
    else
    {
        AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [downloadRequest setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToRead) {
            float progress = totalBytesWritten / (float)totalBytesExpectedToRead * 100.f;
            self.m_progressView.elapsedTime = progress;
        }];
        
        [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"file downloaded");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                __block NSData *data = [[NSData alloc] initWithData:responseObject];
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [data writeToFile:self.m_strResourceLocalPath atomically:YES];
                    
                    self.m_progressView.hidden = YES;
                    self.m_viewLoading.hidden = YES;

                    if ([[self.m_strResourceLocalPath lowercaseString] rangeOfString:@"png"].location != NSNotFound || [[self.m_strResourceLocalPath lowercaseString] rangeOfString:@"jpg"].location != NSNotFound)
                    {
                        self.m_postImageView.image = [UIImage imageWithContentsOfFile:self.m_strResourceLocalPath];
                    }
                    
                    data = nil;
                });
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"file downloading error : %@", [error localizedDescription]);
            self.m_progressView.hidden = YES;
            self.m_btnRefresh.hidden = NO;

        }];
        [downloadRequest start];
    }
}

@end
