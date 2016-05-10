//
//  QRCodeGenerate.m
//  QRCodeSample
//
//  Created by whatywhaty on 16/5/10.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//

#import "QRCodeGenerate.h"

@interface QRCodeGenerate ()

@end
static QRCodeGenerate *manager = nil;
@implementation QRCodeGenerate


+(void)showGeneratedQRCodeWithString:(NSString *)string
                  FromViewController:(UIViewController *)viewController
                     GenerationBlock:(QRCodeGenerationBlock)block
{
    if (manager == nil) {
        manager = [[QRCodeGenerate alloc] init];
    }
    
    [manager showGeneratedQRCodeWithString:string
                        FromViewController:viewController
                           GenerationBlock:block];
}

-(void)showGeneratedQRCodeWithString:(NSString *)string
                  FromViewController:(UIViewController *)viewController
                     GenerationBlock:(QRCodeGenerationBlock)block
{
    //先判断是否文字为空
    if ([string isEqualToString:@""]) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入二维码生成信息" preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [viewController presentViewController:alertCtrl animated:YES completion:nil];
        return;
    }
    
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    //将字符串转换成NSData
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
    block(image);
}

//改变二维码大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
