//
//  SeshAlertViewController.m
//  CinchApp
//
//  Created by Zachary Saraf on 12/27/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshAlertViewController.h"
#import "UIColor+Sesh.h"
#import "UIFont+Sesh.h"
#import "SeshUtils.h"
#import "UILabel+Sesh.h"
#import "SeshAlertViewItem.h"
#import "SeshButton.h"
#import "UIImage+SeshUtils.h"

@interface SeshAlertViewDefaultContentView : UIView

- (instancetype)initWithImage:(UIImage *)image description:(NSString *)description;

@end

@implementation SeshAlertViewDefaultContentView {
    NSString *_description;
    UIImage *_image;

    UILabel *_descriptionLabel;
    UIImageView *_imageView;
}

- (instancetype)initWithImage:(UIImage *)image description:(NSString *)description
{
    if (self = [super initWithFrame:CGRectZero]) {
        _description = description;
        _image = image;

        if (_image) {
            _imageView = [[UIImageView alloc] initWithImage:_image];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_imageView];
        }

        CGFloat descriptionFontSize = _image ? [SeshUtils scaledFontSizeForFontSize:13.0] : [SeshUtils scaledFontSizeForFontSize:15.0];
        _descriptionLabel = [UILabel seshLabelWithFontType:kSeshLabelFontRegular fontSize:descriptionFontSize color:[UIColor colorWithWhite:.6 alpha:1] text:_description];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_descriptionLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat originY;

    if (_imageView) {
        CGFloat imageViewHeight = self.bounds.size.height/3;

        originY = 30;
        _imageView.frame = CGRectMake(0, originY, self.bounds.size.width, imageViewHeight);

        originY += imageViewHeight;
    } else {
        originY = 0;
    }

    CGSize descriptionSize = [_descriptionLabel.text boundingRectWithSize:CGRectInset(self.bounds, 20.0, 0).size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _descriptionLabel.font} context:nil].size;
    _descriptionLabel.bounds = CGRectMake(0, 0, descriptionSize.width, descriptionSize.height);
    _descriptionLabel.center = CGPointMake(self.bounds.size.width/2, originY + (self.bounds.size.height - originY)/2);
}

@end

@interface SeshAlertViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation SeshAlertViewController  {
    NSString *_fsTitle;
    NSString *_bsTitle;
    
    NSArray *_fsButtonItems;
    NSArray *_bsButtonItems;
    
    UILabel *_fsTitleLabel;
    UILabel *_bsTitleLabel;

    UIView *_fsCustomView;
    UIView *_bsCustomView;

    UIView *_contentView;
    UIView *_bsContentView;
}

- (instancetype)initWithTitle:(NSString *)title
                  buttonItems:(NSArray *)buttonItems
                   customView:(UIView *)customView
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _fsTitle = title;
        _fsButtonItems = buttonItems;
        _fsCustomView = customView;
    }
    return self;
}

- (instancetype)initWithFrontSideTitle:(NSString *)frontSideTitle
                  frontSideButtonItems:(NSArray *)frontSideButtonItems
                   frontSideCustomView:(UIView *)frontSideCustomView
                         backSideTitle:(NSString *)backSideTitle
                   backSideButtonItems:(NSArray *)backSideButtonItems
                          backSideCustomView:(UIView *)backSideCustomView
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _fsTitle = frontSideTitle;
        _fsButtonItems = frontSideButtonItems;
        _fsCustomView = frontSideCustomView;
        _bsTitle = backSideTitle;
        _bsButtonItems = backSideButtonItems;
        _bsCustomView = backSideCustomView;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
                  buttonItems:(NSArray *)buttonItems
                        image:(UIImage *)image
{
    SeshAlertViewDefaultContentView *customView = [[SeshAlertViewDefaultContentView alloc] initWithImage:image description:description];
    if (self = [self initWithTitle:title buttonItems:buttonItems customView:customView]) {
        // nothing to do
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    _fsTitleLabel = [UILabel seshLabelWithFontType:kSeshLabelFontRegular fontSize:[SeshUtils scaledFontSizeForFontSize:18.0] color:nil/*[UIColor whiteColor]*/ text:_fsTitle];
    _fsTitleLabel.textAlignment = NSTextAlignmentCenter;
    _fsTitleLabel.numberOfLines = 0;
    _fsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:_fsTitleLabel];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (SeshAlertViewItem *item in _fsButtonItems) {
        SeshButton *button = [[SeshButton alloc] initWithFrame:CGRectZero];
        button.layer.cornerRadius = 0;
        if (item.backgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:item.backgroundColor] forState:UIControlStateNormal];
        }
        if (item.selectedBackgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:item.selectedBackgroundColor] forState:UIControlStateHighlighted];
        }
        [button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:item.title forState:UIControlStateNormal];
        [_contentView addSubview:button];
        [array addObject:button];
    }
    
    _buttons = array;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, 2);
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 7;
    self.view.layer.cornerRadius = 4.0;
    self.view.layer.masksToBounds = NO;
    _contentView.layer.cornerRadius = 4.0;
    _contentView.layer.masksToBounds = YES;

    if (_fsCustomView) {
        [_contentView addSubview:_fsCustomView];
    }
    
    if (_bsCustomView) {
        [self setupBSContentView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _contentView.frame = self.view.bounds;
    
    if (_bsContentView) {
        _bsContentView.frame = self.view.bounds;
    }

    CGFloat topPadding = self.view.bounds.size.height/20.0;
    if (_fsTitleLabel.text.length > 0) {
        CGSize titleSize = [_fsTitleLabel.text boundingRectWithSize:CGRectInset(self.view.bounds, 20, 0).size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _fsTitleLabel.font} context:nil].size;
        _fsTitleLabel.frame = CGRectMake(20, topPadding, self.view.frame.size.width - 40, titleSize.height);
    }
    
    if (_bsTitleLabel) {
        CGSize bsTitleSize = [_bsTitleLabel.text boundingRectWithSize:CGRectInset(self.view.bounds, 20, 0).size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _bsTitleLabel.font} context:nil].size;
        _bsTitleLabel.frame = CGRectMake(20, topPadding, self.view.frame.size.width - 40, bsTitleSize.height);
    }
    
    CGFloat originY = _fsTitleLabel.frame.origin.y + _fsTitleLabel.bounds.size.height;
    CGFloat reverseOriginY = self.view.bounds.size.height;
    CGSize typicalButtonSize = [SeshButton typicalSizeForBoundingRect:self.view.bounds.size];

    for (SeshButton *button in _buttons.reverseObjectEnumerator) {
        reverseOriginY -= typicalButtonSize.height;
        button.frame = CGRectMake(0, reverseOriginY, self.view.bounds.size.width, typicalButtonSize.height);
    }
    
    _fsCustomView.frame = CGRectMake(0, originY, self.view.bounds.size.width, reverseOriginY - originY);
    
    if (_bsCustomView) {
        if (_bsButtons) {
            reverseOriginY = self.view.bounds.size.height;
            for (SeshButton *button in _bsButtons.reverseObjectEnumerator) {
                reverseOriginY -= typicalButtonSize.height;
                button.frame = CGRectMake(0, reverseOriginY, self.view.bounds.size.width, typicalButtonSize.height);
            }
        }

        _bsCustomView.frame = CGRectMake(0, originY, self.view.bounds.size.width, reverseOriginY - originY);
    }
    
    [self.view.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.view.bounds] CGPath]];
}

- (void)setupBSContentView
{
    _bsContentView = [[UIView alloc] initWithFrame:CGRectZero];
    _bsContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    _bsTitleLabel = [UILabel seshLabelWithFontType:kSeshLabelFontRegular fontSize:[SeshUtils scaledFontSizeForFontSize:18.0] color:nil/*[UIColor whiteColor]*/ text:_bsTitle];
    _bsTitleLabel.textAlignment = NSTextAlignmentCenter;
    _bsTitleLabel.numberOfLines = 0;
    _bsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_bsContentView addSubview:_bsTitleLabel];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (SeshAlertViewItem *item in _bsButtonItems) {
        SeshButton *button = [[SeshButton alloc] initWithFrame:CGRectZero];
        button.layer.cornerRadius = 0;
        if (item.backgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:item.backgroundColor] forState:UIControlStateNormal];
        }
        if (item.selectedBackgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:item.selectedBackgroundColor] forState:UIControlStateHighlighted];
        }
        [button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:item.title forState:UIControlStateNormal];
        [_bsContentView addSubview:button];
        [array addObject:button];
    }
    
    _bsButtons = array;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, 2);
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 7;
    self.view.layer.cornerRadius = 4.0;
    self.view.layer.masksToBounds = NO;
    _bsContentView.layer.cornerRadius = 4.0;
    _bsContentView.layer.masksToBounds = YES;
    
    if (_bsCustomView) {
        [_bsContentView addSubview:_bsCustomView];
    }
}

- (void)flipContent
{
    NSAssert(_bsCustomView != nil, @"The backside custom view cannot be null");
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [_contentView removeFromSuperview];
                        [self.view addSubview:_bsContentView];
                    } completion:nil];
    
}

- (void)tapped:(UIButton *)button
{
    [self.delegate alertViewController:self didTapButtonAtIndex:[_buttons indexOfObject:button]];
}

- (void)rootViewControllerTouched
{
    if ([self.delegate respondsToSelector:@selector(didClickOutsideBounds)]) {
        [self.delegate didClickOutsideBounds];
    }
}

@end
