// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import <UIKit/UIKit.h>

@interface UIView (KeyboardNotification)

+ (void)animateWithKeybordNotification:(NSNotification *)aNotification animations:(void (^)(void))animations;

@end

@interface UIScrollView (KeyboardNotification)

- (void)setBottomInset:(CGFloat)bottom;

- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;

- (void)addKeyboardNotificationObserver;
- (void)removeKeyboardNotificationObserver;

@end
