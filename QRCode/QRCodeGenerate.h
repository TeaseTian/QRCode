//
//  QRCodeGenerate.h
//  QRCodeSample
//
//  Created by whatywhaty on 16/5/10.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//  二维码生成

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//二维码生成
typedef void (^QRCodeGenerationBlock)(UIImage *image);


@interface QRCodeGenerate : NSObject

/**
 *  显示要生成的二维码
 *
 *  @param string         需要显示的文字
 *  @param viewController 二维码显示的控制器
 *  @param block          
 */
+(void)showGeneratedQRCodeWithString:(NSString *)string
                  FromViewController:(UIViewController *)viewController
                     GenerationBlock:(QRCodeGenerationBlock)block;

@end
