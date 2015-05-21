//
//  UIView+Blur.m
//  testBlurredUIView
//
//  Created by salah on 2014-05-21.
//  Copyright (c) 2014 Mike All rights reserved.
//
#import <objc/runtime.h>
#import "UIView+Blur.h"

NSString const *blurBackgroundKey = @"blurBackgroundKey";
NSString const *blurVibrancyBackgroundKey = @"blurVibrancyBackgroundKey";
NSString const *blurTintColorKey = @"blurTintColorKey";
NSString const *blurTintColorIntensityKey = @"blurTintColorIntensityKey";
NSString const *blurTintColorLayerKey = @"blurTintColorLayerKey";
NSString const *blurStyleKey = @"blurStyleKey";

@implementation UIView (Blur)

@dynamic blurBackground;
@dynamic blurTintColor;
@dynamic blurTintColorIntensity;
@dynamic isBlurred;
@dynamic blurStyle;

#pragma mark - category methods
-(void)enableBlur:(BOOL) enable
{
    if(enable) {
        if(IOS_MAJOR_VERSION>=8) {
            UIVisualEffectView* view = (UIVisualEffectView*)self.blurBackground;
            UIVisualEffectView* vibrancyView = self.blurVibrancyBackground;
            if(!view || !vibrancyView) {
                [self blurBuildBlurAndVibrancyViews];
            }
            
        } else {
            UIToolbar* view = (UIToolbar*)self.blurBackground;
            if(!view) {
                // use UIToolbar
                view = [[UIToolbar alloc] initWithFrame:self.bounds];
                objc_setAssociatedObject(self, &blurBackgroundKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [view setFrame:self.bounds];
            view.clipsToBounds = YES;
            view.translucent = YES;
            
            // add the toolbar layer as sublayer
            [self.layer insertSublayer:view.layer atIndex:0];
        }
        
        //        view.barTintColor = [self.blurTintColor colorWithAlphaComponent:0.4f];
    } else {
        if(IOS_MAJOR_VERSION>=8) {
            if(self.blurBackground) {
                [self.blurBackground removeFromSuperview];
                objc_setAssociatedObject(self, &blurBackgroundKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        } else {
            if(self.blurBackground) {
                [self.blurBackground.layer removeFromSuperlayer];
            }
        }
    }
}

-(void) blurBuildBlurAndVibrancyViews NS_AVAILABLE_IOS(8_0)
{
    UIBlurEffectStyle style = UIBlurEffectStyleDark;
    
    if(self.blurStyle == UIViewBlurExtraLightStyle) {
        style = UIBlurEffectStyleExtraLight;
    } else if(self.blurStyle == UIViewBlurLightStyle) {
        style = UIBlurEffectStyleLight;
    }
    // use UIVisualEffectView
    UIVisualEffectView* view = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    view.frame = self.bounds;
    [self addSubview:view];
    objc_setAssociatedObject(self, &blurBackgroundKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // save subviews of existing vibrancy view
    NSArray* subviews = self.blurVibrancyBackground.contentView.subviews;
    
    // create vibrancy view
    UIVisualEffectView* vibrancyView = [[UIVisualEffectView alloc]initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect*)view.effect]];
    vibrancyView.frame = self.bounds;
    [view.contentView addSubview:vibrancyView];
    view.contentView.backgroundColor = [self.blurTintColor colorWithAlphaComponent:self.blurTintColorIntensity];
    
    // add back subviews to vibrancy view
    if(subviews) {
        for (UIView* v in subviews) {
            [vibrancyView.contentView addSubview:v];
        }
    }
    objc_setAssociatedObject(self, &blurVibrancyBackgroundKey, vibrancyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getters/setters
-(UIColor*) blurTintColor
{
    UIColor* color = objc_getAssociatedObject(self, &blurTintColorKey);
    if(!color) {
        color = [UIColor clearColor];
        objc_setAssociatedObject(self, &blurTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

-(void) setBlurTintColor:(UIColor *)blurTintColor
{
    objc_setAssociatedObject(self, &blurTintColorKey, blurTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(IOS_MAJOR_VERSION>=8) {
        ((UIVisualEffectView*)self.blurBackground).contentView.backgroundColor = [blurTintColor colorWithAlphaComponent:self.blurTintColorIntensity];
    } else {
        if(self.blurBackground) {
            UIToolbar *toolbar = ((UIToolbar*)self.blurBackground);
            CALayer *colorLayer = objc_getAssociatedObject(self, &blurTintColorLayerKey);
            if(colorLayer==nil) {
                colorLayer = [CALayer layer];
            } else {
                [colorLayer removeFromSuperlayer];
            }
            
            if(self.blurStyle == UIViewBlurDarkStyle) {
                toolbar.barStyle = UIBarStyleBlackTranslucent;
            } else {
                toolbar.barStyle = UIBarStyleDefault;
            }
            colorLayer.frame = toolbar.frame;
            colorLayer.opacity = (float)(0.5*self.blurTintColorIntensity);
            colorLayer.opaque = NO;
            [toolbar.layer insertSublayer:colorLayer atIndex:1];
            colorLayer.backgroundColor = blurTintColor.CGColor;
            
            objc_setAssociatedObject(self, &blurTintColorLayerKey, colorLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
}

-(UIView*)blurBackground
{
    return objc_getAssociatedObject(self, &blurBackgroundKey);
}

-(UIVisualEffectView*) blurVibrancyBackground NS_AVAILABLE_IOS(8_0)
{
    return objc_getAssociatedObject(self, &blurVibrancyBackgroundKey);
}

-(UIViewBlurStyle) blurStyle
{
    NSNumber* style = objc_getAssociatedObject(self, &blurStyleKey);
    if(!style) {
        style = @0;
    }
    return (UIViewBlurStyle)style.integerValue;
}

-(void)setBlurStyle:(UIViewBlurStyle)viewBlurStyle
{
    NSNumber *style = [NSNumber numberWithInteger:viewBlurStyle];
    objc_setAssociatedObject(self, &blurStyleKey, style, OBJC_ASSOCIATION_RETAIN);
    
    if(IOS_MAJOR_VERSION>=8) {
        if(self.blurBackground) {
            [self.blurBackground removeFromSuperview];
            [self blurBuildBlurAndVibrancyViews];
        }
    } else {
        if(self.blurBackground) {
            if(viewBlurStyle == UIViewBlurDarkStyle) {
                ((UIToolbar*)self.blurBackground).barStyle = UIBarStyleBlackTranslucent;
            } else {
                ((UIToolbar*)self.blurBackground).barStyle = UIBarStyleDefault;
            }
        }
    }
}

-(void)setBlurTintColorIntensity:(double)blurTintColorIntensity
{
    NSNumber *intensity = [NSNumber numberWithDouble:blurTintColorIntensity];
    objc_setAssociatedObject(self, &blurTintColorIntensityKey, intensity, OBJC_ASSOCIATION_RETAIN);
    
    if(IOS_MAJOR_VERSION<8) {
        if(self.blurBackground) {
            CALayer *colorLayer = objc_getAssociatedObject(self, &blurTintColorLayerKey);
            if(colorLayer) {
                colorLayer.opacity = 0.5f*intensity.floatValue;
            }
        }
    }
}

-(double)blurTintColorIntensity
{
    NSNumber *intensity = objc_getAssociatedObject(self, &blurTintColorIntensityKey);
    if(!intensity) {
        intensity = @0.3;
    }
    return intensity.doubleValue;
}
@end
