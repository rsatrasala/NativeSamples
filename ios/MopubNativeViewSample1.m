//
//  MopubNativeView.m
//  Mopub
//
//  Copyright (c) 2014 MoPub, Inc. All rights reserved.
//
//

#import "MopubNativeView.h"
#import <QuartzCore/QuartzCore.h>

static NSInteger const SCEdgeInset = 8;
static NSInteger const SCSponsoredWidth = 24;
static NSInteger const SCGradientHeight = 60;
static NSInteger const SCInstallButtonHeight = 20;
static NSInteger const SCInstallButtonWidth = 64;
static NSInteger const SCTextLabelHeight = 32;
static NSInteger const SCAdImageHeight = 146; // this maintains the 1200x627 aspect ratio required by MoPub

@implementation MopubNativeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIFont *titleFont = [UIFont fontWithName:@"BentonSans-Regular" size:16];
        UIFont *textFont = [UIFont fontWithName:@"BentonSans-Regular" size:12];
        UIFont *sponsoredLabelFont = [UIFont fontWithName:@"BentonSans-Regular" size:10];
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.gradientImage = [[UIImageView alloc] init];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        self.gradientImage.frame = CGRectMake(SCEdgeInset, CGRectGetHeight(self.frame) - SCGradientHeight, CGRectGetWidth(self.frame) - SCEdgeInset * 2, SCGradientHeight);
        gradient.frame = self.gradientImage.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.35f], nil];
        [self.gradientImage.layer insertSublayer:gradient atIndex:0];
        [self addSubview:self.gradientImage];
        
        self.textLabel = [[UILabel alloc]init];
        [self addSubview:self.textLabel];
        [self.textLabel setFont:textFont];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.numberOfLines = 2;
        
        // advertiser name label
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = titleFont;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.shadowColor = [UIColor blackColor];
        self.titleLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
        [self addSubview:self.titleLabel];
        
        // label that says "SPONSORED"
        self.sponsoredLabel = [[UILabel alloc] init];
        self.sponsoredLabel.font = sponsoredLabelFont;
        self.sponsoredLabel.text = @"SPONSORED";
        self.sponsoredLabel.textColor = [UIColor whiteColor];
        self.sponsoredLabel.textAlignment = NSTextAlignmentCenter;
        self.sponsoredLabel.backgroundColor = [UIColor grayColor];
        [self.sponsoredLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        [self addSubview:self.sponsoredLabel];
        
        // "INSTALL" button
        self.installButtonLabel = [[UILabel alloc] init];
        self.installButtonLabel.font = sponsoredLabelFont;
        self.installButtonLabel.text = @"INSTALL";
        self.installButtonLabel.textAlignment = NSTextAlignmentCenter;
        self.installButtonLabel.textColor = [UIColor whiteColor];
        self.installButtonLabel.backgroundColor = [UIColor colorWithRed:81.f/255.f green:177.f/255.f blue:82.f/255.f alpha:1.f];
        self.installButtonLabel.layer.cornerRadius = 3;
        self.installButtonLabel.layer.masksToBounds = YES;
        self.installButtonLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.installButtonLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:self.installButtonLabel];
    }
    
    return self;
}

-(void)layoutSubviews
{
    self.imageView.frame = CGRectMake(SCEdgeInset, 0, CGRectGetWidth(self.frame) - SCEdgeInset * 2 - SCSponsoredWidth, SCAdImageHeight);
    self.sponsoredLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - SCEdgeInset - SCSponsoredWidth, 0, SCSponsoredWidth, CGRectGetHeight(self.frame));
    self.textLabel.frame = CGRectMake(SCEdgeInset * 2, CGRectGetHeight(self.frame) - SCEdgeInset/2 - SCTextLabelHeight, CGRectGetWidth(self.frame) - SCEdgeInset * 3 - CGRectGetWidth(self.sponsoredLabel.frame), SCTextLabelHeight);
    self.titleLabel.frame = CGRectMake(SCEdgeInset * 2, CGRectGetMinY(self.textLabel.frame) - SCInstallButtonHeight, CGRectGetWidth(self.frame) - (SCEdgeInset * 3) - CGRectGetWidth(self.sponsoredLabel.frame), SCInstallButtonHeight);
    self.installButtonLabel.frame = CGRectMake(CGRectGetMinX(self.sponsoredLabel.frame) - SCInstallButtonWidth - (SCEdgeInset/2), CGRectGetMinY(self.titleLabel.frame), SCInstallButtonWidth, SCInstallButtonHeight);
}

- (void)layoutAdAssets:(MPNativeAd *)adObject
{
    [adObject loadTitleIntoLabel:self.titleLabel];
    [adObject loadTextIntoLabel:self.textLabel];
    [adObject loadImageIntoImageView:self.imageView];
    [adObject loadCallToActionTextIntoLabel:self.installButtonLabel];
}

@end