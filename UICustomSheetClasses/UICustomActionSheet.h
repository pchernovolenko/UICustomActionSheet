//
//  UICustomActionView.h
//  Hashtag
//
//  Created by Pavlo Chernovolenko on 2/27/15.
//  Copyright (c) 2015 Pavlo Chernovolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UICustomActionSheet;

@protocol UICustomActionSheetDelegate <NSObject>

-(void)customActionSheet:(UICustomActionSheet *)customActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface UICustomActionSheet : UIView {
    
    NSArray *buttonTitles;
    NSArray *buttonColors;
    
    UIImageView *backgroundImage;
    UIView *panel;
    
}

@property (nonatomic, weak) id<UICustomActionSheetDelegate> delegate;

@property (nonatomic, readwrite) CGRect clearArea;
@property (nonatomic, readwrite) BOOL blurredBackground;
@property (nonatomic, readwrite) float titleFontSize;
@property (nonatomic, readwrite) float subtitleFontSize;
@property (nonatomic, strong) UIColor* tintColor;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, strong) UIColor* blurTintColor;
@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) UIColor* subtitleColor;
@property (nonatomic, strong) UIColor* buttonsTextColor;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, strong) NSString* title;



-(instancetype)initWithTitle:(NSString *)caption delegate:(id<UICustomActionSheetDelegate>)delegate buttonTitles:(NSArray *)buttonTitles;

-(void)setButtonColors:(NSArray *)colors;
-(void)setTitle:(NSString *)caption andSubtitle:(NSString *)subtitle;

-(void)showInView:(UIView *)view;

@end
