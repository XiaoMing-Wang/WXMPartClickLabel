//
//  WXMPartClickLabel.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/17.
//  Copyright © 2019 wq. All rights reserved.
//
/** 部分点击Label 协议 */
#import "WXMPartTextHelper.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WXMPartClickLabel;
@protocol WXMPartClickProtocol <NSObject>
@optional
- (void)wxm_partClick:(WXMPartClickLabel *)label range:(NSRange)range aString:(NSString *)aString;
@end

@interface WXMPartClickLabel : UILabel
@property (nonatomic, strong) WXMPartTextHelper *partTextHelper;
@property (nonatomic, weak) id<WXMPartClickProtocol> delegate;

/** 添加点击区域 */
- (void)wxm_addPartClickWithRange:(NSRange)range;

/** 添加点击字符串 */
- (void)wxm_addPartClickWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
