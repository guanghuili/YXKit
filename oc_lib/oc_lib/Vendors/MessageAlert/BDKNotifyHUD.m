#import "BDKNotifyHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "CSNotificationView.h"

#define kBDKNotifyHUDDefaultRoundness    5.0f
#define kBDKNotifyHUDDefaultOpacity      0.85f
#define kBDKNotifyHUDDefaultPadding      10.0f
#define kBDKNotifyHUDDefaultInnerPadding 6.0f

@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end

@interface BDKNotifyHUD ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;

- (void)recalculateHeight;
- (void)adjustTextLabel:(UILabel *)label;
- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion;

@end

@implementation BDKNotifyHUD

#pragma mark - Lifecycle

+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text {
    return [[self alloc] initWithImage:image text:text];
}

+(void)showHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text
{
    [self showHUDInView:inView image:image text:text completion:nil];
}

+(void)showHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text completion:(void (^)(void))completion
{
    BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:image text:text];
    hud.center = CGPointMake(inView.center.x, 250);
    [inView addSubview:hud];
    [inView bringSubviewToFront:hud];
    
    [hud presentWithDuration:0.5f speed:0.5f inView:inView completion:^{
        
        if (completion)
        {
            completion();
        }
        
        [hud removeFromSuperview];
    }];
    

}

+(void)showSmileyHUDInView:(UIView *)inView text:(NSString *)text
{
    [self showSmileyHUDInView:inView text:text completion:nil];
}

+(void)showSmileyHUDInView:(UIView *)inView text:(NSString *)text completion:(void (^)(void))completion
{
    [self showHUDInView:inView image:UIImageForName(@"happy_white") text:text completion:completion];
}


+(void)showCryingHUDInView:(UIView *)inView text:(NSString *)text
{
    [self showCryingHUDInView:inView text:text completion:nil];
}

+(void)showCryingHUDInView:(UIView *)inView text:(NSString *)text completion:(void (^)(void))completion
{
       [self showHUDInView:inView image:UIImageForName(@"sad") text:text completion:completion];
}


+(void) showCryingHUDWithText:(NSString *) text
{
//    [self showCryingHUDWithText:text completion:nil];
    
    [CSNotificationView ShowNotificationViewStyleErrorInWindow:text];
}

+(void) showCryingHUDWithText:(NSString *) text completion:(void (^)(void))completion
{

    [self showCryingHUDInView:[self defaultInView] text:text completion:completion];

}

+(void) showSmileyHUDWithText:(NSString *) text
{
//       [self showSmileyHUDWithText:text completion:nil];
    [CSNotificationView ShowNotificationViewStyleSuccessInWindow:text];
}

+(void) showSmileyHUDWithText:(NSString *) text completion:(void (^)(void))completion
{
        [self showSmileyHUDInView:[self defaultInView] text:text completion:completion];
}

+(void) showVexedlyHUDWithText:(NSString *) text
{
        [self showHUDInView:[self defaultInView] image:UIImageForName(@"awkward") text:text];
}

+ (CGRect)defaultFrameWithText:(NSString *) text
{
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(kBDKNotifyHUDDefaultMaxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    return CGRectMake(0, 0, MAX(size.width, kBDKNotifyHUDDefaultWidth), MAX(size.height, kBDKNotifyHUDDefaultHeight));
}

+(UIView *)defaultInView
{
    NSArray *windowArray = [[UIApplication sharedApplication] windows];
    UIWindow* keyboardWindow = windowArray[windowArray.count-1];
    return keyboardWindow;
}

- (id)initWithImage:(UIImage *)image text:(NSString *)text {
    
    if ((self = [self initWithFrame:[self.class defaultFrameWithText:text]]))
    {
        
        self.image = image;
        self.text = text;
        self.roundness = kBDKNotifyHUDDefaultRoundness;
        self.borderColor = [UIColor clearColor];
        self.destinationOpacity = kBDKNotifyHUDDefaultOpacity;
        self.currentOpacity = 0.0f;
        [self addSubview:self.backgroundView];
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        [self recalculateHeight];
    }
    return self;
}

- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion {
    self.isAnimating = YES;
    [UIView animateWithDuration:speed animations:^{
        [self setCurrentOpacity:self.destinationOpacity];
    } completion:^(BOOL finished)
    {
//        if (finished)
            [self fadeAfter:duration speed:speed completion:completion];
    }];
}

- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion {
    [self performBlock:^{
        [UIView animateWithDuration:speed animations:^{
            [self setCurrentOpacity:0.0];
        } completion:^(BOOL finished) {
            //if (finished) {
                self.isAnimating = NO;
                if (completion != nil) completion();
          //  }
        }];
    } afterDelay:duration];
}

#pragma mark - Setters

- (void)setRoundness:(CGFloat)roundness {
    if (_backgroundView != nil) self.backgroundView.layer.cornerRadius = roundness;
    _roundness = roundness;
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (_backgroundView != nil) self.backgroundView.layer.borderColor = [borderColor CGColor];
    _borderColor = borderColor;
}

- (void)setText:(NSString *)text {
    if (_textLabel != nil) {
        self.textLabel.text = text;
        [self adjustTextLabel:self.textLabel];
    }
    _text = text;
}

- (void)setImage:(UIImage *)image {
    if (_imageView != nil) self.imageView.image = image;
    _image = image;
}

- (void)setCurrentOpacity:(CGFloat)currentOpacity {
    self.imageView.alpha = currentOpacity > 0 ? 1.0f : 0.0f;
    self.textLabel.alpha = currentOpacity > 0 ? 1.0f : 0.0f;
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:currentOpacity];
    _currentOpacity = currentOpacity;
}

#pragma mark - Getters

- (UIView *)backgroundView {
    if (_backgroundView != nil) return _backgroundView;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.layer.cornerRadius = self.roundness;
    _backgroundView.layer.borderWidth = 1.0f;
    _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    _backgroundView.layer.borderColor = [self.borderColor CGColor];
    
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (_imageView != nil) return _imageView;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeCenter;
    if (self.image != nil) { 
        _imageView.image = self.image;
        CGRect frame = _imageView.frame;
        frame.size = self.image.size;
        frame.origin = CGPointMake((self.backgroundView.frame.size.width - frame.size.width) / 2, kBDKNotifyHUDDefaultPadding);
        _imageView.frame = frame;
        _imageView.alpha = 0.0f;
    }
    
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel != nil) return _textLabel;
    
    CGRect frame = CGRectMake(0, floorf(CGRectGetMaxY(self.imageView.frame) + kBDKNotifyHUDDefaultInnerPadding),
                              floorf(self.backgroundView.frame.size.width),
                              floorf(self.backgroundView.frame.size.height / 2.0f));
    _textLabel = [[UILabel alloc] initWithFrame:frame];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.alpha = 0.0f;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    if (self.text != nil) _textLabel.text = self.text;
    [self adjustTextLabel:_textLabel];
    [self recalculateHeight];
    
    return _textLabel;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [self recalculateHeight];
}

- (void)adjustTextLabel:(UILabel *)label {
    CGRect frame = _textLabel.frame;
    frame.size.width = self.backgroundView.frame.size.width;
    _textLabel.frame = frame;
    [label sizeToFit];
    frame = _textLabel.frame;
    frame.origin.x = floorf((self.backgroundView.frame.size.width - _textLabel.frame.size.width) / 2);
    _textLabel.frame = frame;
}

- (void)recalculateHeight {
    CGRect frame = self.backgroundView.frame;
    frame.size.height = CGRectGetMaxY(self.textLabel.frame) + kBDKNotifyHUDDefaultPadding;
    self.backgroundView.frame = frame;
}

@end
