//
//  AboutUsViewController.m
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "AboutUsViewController.h"

#define kLogoLeftRigthMargin 50
#define kLogoTopMargin  100
#define kLabelLeftRigthMargin 20

@interface AboutUsViewController ()

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UILabel     *contentLabel;
@property (nonatomic,strong)UILabel     *versionLabel;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.logoImageView.hidden = NO;
    self.title = NSLocalizedString(@"AboutUs", nil);
    NSString *testStr = NSLocalizedString(@"ABOUT_US_INFO", nil)  ;
    self.contentLabel.text = testStr;
    
    self.versionLabel.text = @"版本 1.0.0";
}

-(UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"billuniob_logo"]];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_logoImageView];
        _logoImageView.sd_layout.topSpaceToView(self.view,kLogoTopMargin).leftSpaceToView(self.view,kLogoLeftRigthMargin).rightSpaceToView(self.view,kLogoLeftRigthMargin).heightIs(120);
    }
    return _logoImageView;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithText:@"" fontSize:14.0f textColor:[UIColor colorWithRGBHex:0x939b9b] alignment:NSTextAlignmentLeft];
        [self.view addSubview:_contentLabel];
        _contentLabel.sd_layout.topSpaceToView(self.logoImageView,30).leftSpaceToView(self.view,kLabelLeftRigthMargin).rightSpaceToView(self.view,kLabelLeftRigthMargin).autoHeightRatio(0);
    }
    return _contentLabel;
}


-(UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [UILabel labelWithText:@"" fontSize:14.0f textColor:[UIColor colorWithRGBHex:0x939b9b] alignment:NSTextAlignmentCenter];
        [self.view addSubview:_versionLabel];
        _versionLabel.sd_layout.bottomSpaceToView(self.view,10).leftSpaceToView(self.view,kLabelLeftRigthMargin).rightSpaceToView(self.view,kLabelLeftRigthMargin).autoHeightRatio(0);
    }
    return _versionLabel;
}

@end
