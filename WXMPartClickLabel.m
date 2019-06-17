//
//  WXMPartClickLabel.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/17.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMPartClickLabel.h"

@interface WXMPartClickLabel ()
@property (nonatomic, strong) NSMutableArray *rangeArray;
@end


@implementation WXMPartClickLabel

- (void)setDelegate:(id<WXMPartClickProtocol>)delegate {
    _delegate = delegate;
    [self wxm_addTouchEvents];
}

/** 添加手势 */
- (void)wxm_addTouchEvents {
    self.userInteractionEnabled = YES;
    self.partTextHelper = [[WXMPartTextHelper alloc] init];
    SEL sel = @selector(wxm_tapAction:);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    [self addGestureRecognizer:tap];
}

/** 点击事件 */
- (void)wxm_tapAction:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view];
    if (self.rangeArray.count == 0) return;
    if (self.delegate == nil) return;
    
    __weak typeof(self) weakSelf = self;
    void (^result)(NSInteger,NSAttributedString *) = ^(NSInteger idx, NSAttributedString *atts) {
        [self.rangeArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSRange range = NSRangeFromString(obj);
            if (range.location == NSNotFound || !obj) return;
            
            NSString *aString = [weakSelf.text substringWithRange:range];
            if (aString.length <= 0) return;
            
            if (NSLocationInRange(idx, range)) {
                if (weakSelf.delegate &&
                    [weakSelf.delegate respondsToSelector:@selector(wxm_partClick:range:aString:)]) {
                    [weakSelf.delegate wxm_partClick:weakSelf range:range aString:aString];
                }
                *stop = YES;
            }
        }];
    };
    
    [self.partTextHelper wxm_selectLocation:location ofLabel:self selectedBlock:result];
}

/** 添加点击区域 */
- (void)wxm_addPartClickWithRange:(NSRange)range {
    if (range.location != NSNotFound) {
        [self.rangeArray addObject:NSStringFromRange(range)];
    }
}

/** 添加点击字符串 */
- (void)wxm_addPartClickWithContent:(NSString *)content {
    NSRange range = [self.text rangeOfString:content];
    [self wxm_addPartClickWithRange:range];
}

- (WXMPartTextHelper *)partTextHelper {
    if (!_partTextHelper) {
        _partTextHelper = [[WXMPartTextHelper alloc] init];
    }
    return _partTextHelper;
}

- (NSMutableArray *)rangeArray {
    if (!_rangeArray) _rangeArray = @[].mutableCopy;
    return _rangeArray;
}
@end
