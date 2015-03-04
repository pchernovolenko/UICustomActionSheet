//
//  UICustomActionView.m
//  Hashtag
//
//  Created by Pavlo Chernovolenko on 2/27/15.
//  Copyright (c) 2015 Pavlo Chernovolenko. All rights reserved.
//

#import "UICustomActionSheet.h"
#import "UIImageEffects.h"

@implementation UICustomActionSheet {
    
    CGPoint panelCenter;
    float panelHeight;
    
}

-(instancetype)initWithTitle:(NSString *)caption delegate:(id<UICustomActionSheetDelegate>)delegate buttonTitles:(NSArray *)titles {
    
    if (self = [super init]) {
        
        UIView* screenView = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        
        _tintColor = [UIColor grayColor];
        _buttonsTextColor = [UIColor whiteColor];
        _blurredBackground = YES;
        _titleColor = [UIColor whiteColor];
        _subtitleColor = [UIColor lightGrayColor];
        _backgroundColor = [UIColor blackColor];
        _blurTintColor = [UIColor colorWithWhite:0.1 alpha:0.4];;
        _titleFontSize = 22;
        _subtitleFontSize = 14;
        
        _title = caption;
        buttonTitles = titles;
        _delegate = delegate;
        
        self.frame = screenView.frame;
        
        backgroundImage = [UIImageView new];
        backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
        
        panel = [UIView new];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        
        UITapGestureRecognizer *backgroungTap = [[UITapGestureRecognizer alloc]
                         initWithTarget:self
                         action:@selector(hideAlert)];
        
        backgroungTap.cancelsTouchesInView = YES;
        
        [self addGestureRecognizer:backgroungTap];
        
        [self addSubview:backgroundImage];
        [self addSubview:panel];
        
    }
    
    return self;
}

-(void)setButtonTitles:(NSArray *)titles withColors:(NSArray *)colors{
    
    buttonTitles = titles;
    buttonColors = colors;
    
}

-(void)setTitle:(NSString *)caption andSubtitle:(NSString *)subtitle{
    
    _title = caption;
    _subtitle = subtitle;
    
}

-(void)setButtonColors:(NSArray *)colors{
    
    buttonColors = colors;
    
}

-(void)showInView:(UIView *)view{
    
    [view addSubview:self];
    
    panel.backgroundColor = _backgroundColor;
    
    NSDictionary *mainViews = @{@"bg":backgroundImage,@"panel":panel};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[bg]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:mainViews]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bg]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:mainViews]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[panel]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:mainViews]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[panel]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:mainViews]];
    
    if (_blurredBackground) {
        
        UIGraphicsBeginImageContext([view.layer frame].size);
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *inImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIImage *outImage = [UIImageEffects imageByApplyingBlurToImage:inImage withRadius:5.0 tintColor:_blurTintColor saturationDeltaFactor:1.2 maskImage:nil];
        
        UIGraphicsBeginImageContext(outImage.size);
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, outImage.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, outImage.size.width, outImage.size.height), outImage.CGImage);
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, outImage.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
        
        CGRect circlePoint = (_clearArea);
        CGContextSetFillColorWithColor( UIGraphicsGetCurrentContext(), [UIColor clearColor].CGColor );
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        CGContextFillRect(UIGraphicsGetCurrentContext(), circlePoint);
        
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        backgroundImage.image = finalImage;
        
    }
    
    
    NSMutableDictionary *views = [NSMutableDictionary new];
    
    [views setObject:panel forKey:@"panelView"];
    
    for (NSString *buttonTitle in buttonTitles) {
        
        UIButton *button = [[UIButton alloc] init];
        
        NSUInteger indexOfButton = [buttonTitles indexOfObject:buttonTitle];
        NSString *buttonHash = [NSString stringWithFormat:@"_%lu",(unsigned long)[buttonTitle hash]];
        
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:_buttonsTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:([buttonColors count] > indexOfButton)?[buttonColors objectAtIndex:indexOfButton]:_tintColor];
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button.layer setCornerRadius:3.0];
        
        [panel addSubview:button];
        
        [views setObject:button forKey:buttonHash];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        if ([buttonTitles indexOfObject:buttonTitle] == 0) {
            
            [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(45)]-10-|",buttonHash]
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        } else {
            
            NSString *nextButtonHash = [NSString stringWithFormat:@"_%lu",(unsigned long)[[buttonTitles objectAtIndex:[buttonTitles indexOfObject:buttonTitle]-1] hash]];
            
            if ([buttonTitles indexOfObject:buttonTitle] != [buttonTitles count]-1) {
                
                
                [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(45)]-8-[%@]",buttonHash,nextButtonHash]
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
                
            } else {
                
                NSString *mask = (!_title && !_subtitle)?@"V:|-10-[%@(45)]-8-[%@]":@"V:[%@(45)]-8-[%@]";
                
                [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:mask,buttonHash,nextButtonHash]
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
                
            }
            
            
        }
        
        [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-10-[%@]-10-|",buttonHash]
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
        
    }
    
    
    if ([buttonTitles count] > 0) {
        
        NSString *subtitleHash = @"";
        
        if (_subtitle) {
            
            UILabel *subtitle = [[UILabel alloc] init];
            subtitle.translatesAutoresizingMaskIntoConstraints = NO;
            subtitle.font = [UIFont systemFontOfSize:_subtitleFontSize];
            subtitle.text = _subtitle;
            subtitle.numberOfLines = 4;
            subtitle.textAlignment = NSTextAlignmentCenter;
            subtitle.textColor = _subtitleColor;
            [panel addSubview:subtitle];
            
            subtitleHash = [NSString stringWithFormat:@"_%lu",(unsigned long)[_subtitle hash]];
            
            [views setObject:subtitle forKey:subtitleHash];
            
            NSString *mask = (!_title)?@"V:|-12-[%@]-12-[%@]":@"V:[%@]-12-[%@]";
            
            NSString *lastButtonHash = [NSString stringWithFormat:@"_%lu",(unsigned long)[[buttonTitles objectAtIndex:[buttonTitles count]-1] hash]];
            
            [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-10-[%@]-10-|",subtitleHash]
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
            
            [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:mask,subtitleHash,lastButtonHash]
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
            
        }
        
        if (_title) {
            
            UILabel *mainTitle = [[UILabel alloc] init];
            mainTitle.numberOfLines = 4;
            mainTitle.translatesAutoresizingMaskIntoConstraints = NO;
            mainTitle.textAlignment = NSTextAlignmentCenter;
            mainTitle.text = _title;
            mainTitle.font = [UIFont systemFontOfSize:_titleFontSize];
            mainTitle.textColor = _titleColor;
            [panel addSubview:mainTitle];
            
            NSString *mainTitleHash = [NSString stringWithFormat:@"_%lu",(unsigned long)[_title hash]];
            
            [views setObject:mainTitle forKey:mainTitleHash];
            
            NSString *lastButtonHash = [NSString stringWithFormat:@"_%lu",(unsigned long)[[buttonTitles objectAtIndex:[buttonTitles count]-1] hash]];
            
            NSString *lastElementHash = (!_subtitle)?lastButtonHash:subtitleHash;
            NSString *mask = (!_subtitle)?@"V:|-12-[%@]-12-[%@]":@"V:|-12-[%@]-0-[%@]";
            
            [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-10-[%@]-10-|",mainTitleHash]
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
            
            [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:mask,mainTitleHash,lastElementHash]
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
            
        }
        
    }
    
    [self layoutSubviews];
    
    backgroundImage.alpha = 0;
    panelCenter = panel.center;
    panelHeight = panel.frame.size.height / 2;
    
    panel.center = CGPointMake(panelCenter.x, panelCenter.y + panelHeight*2);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:7<<16
                     animations:^{
                         backgroundImage.alpha = 1;
                         panel.center = panelCenter;
                     } completion:nil];
}

- (void)actionButtonPressed:(UIButton *)button {
    
    [_delegate customActionSheet:self clickedButtonAtIndex:[buttonTitles indexOfObject:button.currentTitle]];
    [self hideAlert];
    
}

- (void) hideAlert
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:7<<16
                     animations:^{
                         backgroundImage.alpha = 0;
                         panel.frame = CGRectMake(0, panel.frame.origin.y + panel.frame.size.height, panel.frame.size.width, panel.frame.size.height);
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
