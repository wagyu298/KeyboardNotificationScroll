// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import "UIScrollView+KeyboardNotification.h"

@implementation NSNotification (KeyboardNotification)

- (NSNumber *)keyboardAnimationDuration
{
    NSDictionary *info = [self userInfo];
    return (NSNumber *)[info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
}

- (NSNumber *)keyboardAnimationCurve
{
    NSDictionary *info = [self userInfo];
    return (NSNumber *)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
}

- (CGRect)keyboardRect
{
    NSDictionary *info = [self userInfo];
    return [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (CGSize)keyboardSize
{
    return [self keyboardRect].size;
}

@end

@implementation UIView (KeyboardNotification)

+ (void)animateWithKeybordNotification:(NSNotification *)aNotification animations:(void (^)(void))animations
{
    double duration = [[aNotification keyboardAnimationDuration] doubleValue];
    unsigned int curve = [[aNotification keyboardAnimationCurve] unsignedIntValue];

    [UIView animateWithDuration:duration delay:0.0 options:curve animations:animations completion:nil];
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
    [UIView animateWithKeybordNotification:aNotification animations:^{
        [self setBottomInset:[aNotification keyboardSize].height];
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
