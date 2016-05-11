//
//  ScanViewController.h
//  QRCodeSample
//
//  Created by whatywhaty on 16/5/11.
//  Copyright © 2016年 whatywhaty. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^QRCodeScanBlock)(NSString *result);
@interface ScanViewController : UIViewController


@property (nonatomic, strong) UIColor *navColor;/**< 导航栏颜色 */
@property (nonatomic, copy) NSString *navTitle;/**< 导航栏标题 */
@property (nonatomic, copy) QRCodeScanBlock resultBlock;/**< 返回扫描到的结果 */
/**
 *  返回上一级界面
 */
-(void)back;
@end
