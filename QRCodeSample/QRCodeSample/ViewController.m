//
//  ViewController.m
//  QRCodeSample
//
//  Created by whatywhaty on 16/5/10.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//

#import "ViewController.h"
#import "QRCode.h"
#import "Masonry.h"


#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()<UITextFieldDelegate>
{
    UIButton *scanBtn;
    UIButton *generateCodeBtn;
    UITextField *textField;
    UIImageView *imageView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"二维码扫描和生成";
    self.view.backgroundColor = [UIColor colorWithWhite:0.958 alpha:1.000];
    [self initSubViews];
    
    
}

-(void)initSubViews
{
    scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:scanBtn];
    scanBtn.backgroundColor = [UIColor colorWithRed:0.425 green:1.000 blue:0.896 alpha:1.000];
    [scanBtn setTitle:@"二维码扫描" forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(44.0f);
        make.width.mas_equalTo(IPHONE_W/2-10);
    }];
    
    generateCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:generateCodeBtn];
    generateCodeBtn.backgroundColor = [UIColor colorWithRed:0.425 green:1.000 blue:0.896 alpha:1.000];
    [generateCodeBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [generateCodeBtn addTarget:self action:@selector(generateCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [generateCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scanBtn.mas_right).with.offset(20);
        make.right.and.top.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(44.0f);
    }];
    
    textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    textField.placeholder = @"请输入想要显示的文字";
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 0.5f;
    textField.delegate = self;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10.0f);
        make.right.equalTo(self.view).with.offset(-10.0f);
        make.top.equalTo(scanBtn.mas_bottom).with.offset(10.0f);
        make.height.mas_equalTo(44.0f);
    }];
    
    imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    imageView.layer.shadowOffset=CGSizeMake(0.5, 0.5);//设置阴影的偏移量
    imageView.layer.shadowRadius=1;//设置阴影的半径
    imageView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    imageView.layer.shadowOpacity=0.5;
    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView.layer.borderWidth = 0.5f;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).with.offset(10.0f);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.and.height.mas_equalTo(300.f);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
}

-(void)scanBtnClick
{
    ScanViewController * vc = [[ScanViewController alloc] init];
    vc.navTitle = @"二维码扫描";
    __weak ScanViewController *weakVC = vc;
    vc.resultBlock = ^(NSString * result){
        NSLog(@"result----->%@",result);
        [weakVC back];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)generateCodeBtnClick
{
    [textField resignFirstResponder];
    __weak UIImageView *weakImageView = imageView;
    [QRCodeGenerate showGeneratedQRCodeWithString:textField.text FromViewController:self GenerationBlock:^(UIImage *image) {
        weakImageView.image = image;
    }];
    
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
