//
//  UITextField+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UITextField+QBExtension.h"
#import <objc/runtime.h>

@implementation UITextField (QBExtension)

#pragma mark - Select
- (void)qbSelectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)qbSetSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (NSRange)qbSelectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (NSNumber *)limitNumber {
    return objc_getAssociatedObject(self, @selector(limitNumber));
}

- (void)setLimitNumber:(NSNumber *)limitNumber {
    objc_setAssociatedObject(self, @selector(limitNumber), limitNumber, OBJC_ASSOCIATION_COPY);
}

- (void)textFieldEditChanged:(id)sender {
    NSString *toBeString = self.text;
    NSInteger limitLength = [self.limitNumber integerValue];
    // 获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    if(!position) {
        if(toBeString.length > limitLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:limitLength];
            if(rangeIndex.length == 1){
                self.text = [toBeString substringToIndex:limitLength];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, limitLength)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)limitTextLength:(NSInteger)length {
    self.limitNumber = @(length);
    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

@end
