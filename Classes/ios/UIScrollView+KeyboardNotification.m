// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import "UIScrollView+KeyboardNotification.h"

@implementation UIView (KeyboardNotification)

+ (void)animateWithKeybordNotification:(NSNotification *)aNotification animations:(void (^)(void))animations
{
    NSDictionary *info = [aNotification userInfo];
    double duration = [(NSNumber *)[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    unsigned int curve = [(NSNumber *)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:animations
                     completion:nil];
}

@end

@implementation UIScrollView (KeyboardNotification)

- (void)setBottomInset:(CGFloat)bottom
{
    UIEdgeInsets contentInset = self.contentInset;
    UIEdgeInsets scrollIndicatorInsets = self.scrollIndicatorInsets;
    
    contentInset.bottom = bottom;
    scrollIndicatorInsets.bottom = bottom;
    
    self.contentInset = contentInset;
    self.scrollIndicatorInsets = scrollIndicatorInsets;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithKeybordNotification:aNotification animations:^{
        [self setBottomInset:kbSize.height];
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithKeybordNotification:aNotification animations:^{
        [self setBottomInset:0];
    }];
}

- (void)addKeyboardNotificationObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotificationObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
