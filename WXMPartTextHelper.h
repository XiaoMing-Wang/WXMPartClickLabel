//
//  WXMPartTextHelper.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/17.
//  Copyright © 2019 wq. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMPartTextHelper : NSObject

- (void)wxm_selectLocation:(CGPoint)location
                   ofLabel:(UILabel *)label
             selectedBlock:(void (^)(NSInteger, NSAttributedString *atts))block;

@end

NS_ASSUME_NONNULL_END
