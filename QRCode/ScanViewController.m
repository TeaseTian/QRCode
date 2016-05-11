//
//  ScanViewController.m
//  QRCodeSample
//
//  Created by whatywhaty on 16/5/11.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>


//视图的宽度
#define selfViewW ([UIScreen mainScreen].bounds.size.width)
//视图的高度
#define selfViewH ([UIScreen mainScreen].bounds.size.height)
#define width(x)  (((x)/320.0)*(selfViewW))
#define height(y) (((y)/568.0)*(selfViewH))
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    UIButton * _scanButton;
    UIImageView *_headImageView;
    
    UIImageView *_logoImageView;
    UILabel * _labIntroudction;
    
    UIImageView * _backImageView;
    
    UIImageView *_bottomImageView;
    UIImageView *_bottom_logo;
    UILabel *_lbl_bottom;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initNav];
    [self initSubView];
    
    
    upOrdown = NO;
    num =0;
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self adjustView:self.view.frame];
}

/**
 *  加载导航栏
 */
-(void)initNav
{
    self.title = _navTitle;
    
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

/**
 *  返回上一级
 */
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  加载子控件
 */
-(void)initSubView
{
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _backImageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:_backImageView];
    
    _scanButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanButton setBackgroundImage:[UIImage imageNamed:@"pick_back.png"] forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanButton];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImageView.image = [UIImage imageNamed:@"sao_bg.png"];
    [self.view addSubview:_headImageView];
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _logoImageView.image = [UIImage imageNamed:@"sao_logo.png"];
    [_headImageView addSubview:_logoImageView];
    
    _labIntroudction= [[UILabel alloc] initWithFrame:CGRectZero];
    _labIntroudction.backgroundColor = [UIColor clearColor];
    _labIntroudction.textColor=[UIColor whiteColor];
    _labIntroudction.font = [UIFont systemFontOfSize:16.0f];
    _labIntroudction.textAlignment = NSTextAlignmentCenter;
    _labIntroudction.text=@"二维码图像扫描";
    [_headImageView addSubview:_labIntroudction];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectZero];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sao-ing_bg.png"]];
    [self.view addSubview:_bottomImageView];
    
    _bottom_logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sao-ing.png"]];
    [_bottomImageView addSubview:_bottom_logo];
    
    _lbl_bottom = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbl_bottom.backgroundColor = [UIColor clearColor];
    _lbl_bottom.textColor=[UIColor whiteColor];
    _lbl_bottom.font = [UIFont systemFontOfSize:14.0f];
    _lbl_bottom.textAlignment = NSTextAlignmentCenter;
    _lbl_bottom.text=@"正在扫描二维码";
    [_bottomImageView addSubview:_lbl_bottom];
}

#pragma mark UIInterfaceOrientationMaskPortrait

// 禁掉横屏
-(UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//ios4, ios5支持
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark Adjust View

- (void)adjustView:(CGRect)frame{
    CGFloat top = 25.0f;
    _backImageView.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    _headImageView.frame = CGRectMake((frame.size.width-171.5f)/2,top+(44.0f-33.0f)/2 , 171.5f, 33.0f);
    _logoImageView.frame = CGRectMake(10.0f, 5.5f, 22.0f, 22.0f);
    _labIntroudction.frame = CGRectMake(32.0f, 0.0f, 171.5f-32.0f, 33.0f);
    _scanButton.frame = CGRectMake(10.0f, top, 44.0f, 44.0f);
    
    _line.frame = CGRectMake(self.view.center.x-110,110, 220,2);
    _bottomImageView.frame = CGRectMake((frame.size.width-185.0f)/2,400.0f, 185.0f, 30.0f);
    _bottom_logo.frame = CGRectMake(20.0f, 5.0f, 20.0f, 20.0f);
    _lbl_bottom.frame = CGRectMake(30.0f, 0.0f, 140.0f, 30.0f);
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(self.view.center.x-110,height(110)+2*num, 220,2);
        
        if (2*num == 240) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(self.view.center.x-110,height(110)+2*num, 220,2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(0.0f,0.0f,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        [timer invalidate];
        _resultBlock(stringValue);
    }
    
    [_session stopRunning];
    
}

@end
