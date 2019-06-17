//
//  WXMPartTextHelper.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/17.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMPartTextHelper.h"

@interface WXMPartTextHelper ()
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@end

@implementation WXMPartTextHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textStorage = [NSTextStorage new];
        self.layoutManager = [NSLayoutManager new];
        self.textContainer = [NSTextContainer new];
        [self.textStorage addLayoutManager:self.layoutManager];
        [self.layoutManager addTextContainer:self.textContainer];
    }
    return self;
}

- (void)wxm_selectLocation:(CGPoint)location
                   ofLabel:(UILabel *)label
             selectedBlock:(void (^)(NSInteger, NSAttributedString *))block {
    
    self.textContainer.size = label.bounds.size;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = label.numberOfLines;
    self.textContainer.lineBreakMode = label.lineBreakMode;
    
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    NSRange textRange = NSMakeRange(0, atts.length);
    [atts addAttribute:NSFontAttributeName value:label.font range:textRange];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = label.textAlignment;
    [atts addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];
    [self.textStorage setAttributedString:atts];
    
    CGSize textSize = [self.layoutManager usedRectForTextContainer:self.textContainer].size;
    location.y -= (CGRectGetHeight(label.frame) - textSize.height) / 2;
    
    NSUInteger index = [_layoutManager glyphIndexForPoint:location inTextContainer:_textContainer];
    CGFloat fontPointSize = label.font.pointSize;
    NSRange range = NSMakeRange(index, 1);
    CGSize size = CGSizeMake(fontPointSize, fontPointSize);
    
    [self.layoutManager setAttachmentSize:size forGlyphRange:NSMakeRange(label.text.length - 1, 1)];
    NSAttributedString *attrib = [label.attributedText attributedSubstringFromRange:range];
    CGRect glyphRect = [self.layoutManager boundingRectForGlyphRange:NSMakeRange(index, 1) inTextContainer:self.textContainer];
    if (!CGRectContainsPoint(glyphRect, location)) {
        if (CGRectContainsPoint(CGRectMake(0, 0, textSize.width, textSize.height), location)) {
        }
        /** block(-1,nil); */
        return;
    }
    block(index,attrib);
}


@end
