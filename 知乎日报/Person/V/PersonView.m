//
//  PersonView.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "PersonView.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@implementation PersonView

- (void)viewInit {
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_backButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fanhui.png"]] forState:UIControlStateNormal];
    _backButton.tag = 0;
    [self addSubview:_backButton];
    
    //状态栏高度
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker* make) {
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(43 - 20);
        } else {
            make.top.equalTo(self).offset(43);
        }
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.top.equalTo(self).offset(43);
        make.left.equalTo(self).offset(20);
    }];
    [_backButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.jpg"]]];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = (0.23 * SIZE_WIDTH) / 2;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(95 - 20);
        } else {
            make.top.equalTo(self).offset(95);
        }
        make.height.equalTo(@(0.23 * SIZE_WIDTH));
        make.width.equalTo(@(0.23 * SIZE_WIDTH));
        //make.top.equalTo(self).offset(95);
        make.left.equalTo(self).offset(SIZE_WIDTH / 2 - 0.115 * SIZE_WIDTH);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"zxb";
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@40);
        make.width.equalTo(@(0.2 * SIZE_WIDTH));
        make.top.equalTo(self).offset(185);
        make.left.equalTo(self).offset(SIZE_WIDTH / 2 - 0.1 * SIZE_WIDTH);
    }];
    
    _firstButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_firstButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_firstButton];
    _firstButton.tag = 1;
    [_firstButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@60);
        make.width.equalTo(@SIZE_WIDTH);
        make.top.equalTo(self).offset(240);
        make.left.equalTo(self).offset(0);
    }];
    
    _secondButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_secondButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_secondButton];
    _secondButton.tag = 2;
    [_secondButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@60);
        make.width.equalTo(@SIZE_WIDTH);
        make.top.equalTo(self).offset(301);
        make.left.equalTo(self).offset(0);
    }];
    
    _firstLabel = [[UILabel alloc] init];
    _firstLabel.text = @"我的收藏";
    _firstLabel.font = [UIFont systemFontOfSize:20];
    [self.firstButton addSubview:_firstLabel];
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@60);
        make.width.equalTo(@100);
        make.top.mas_offset(0);
        make.left.mas_offset(30);
    }];
    
    _secondLabel = [[UILabel alloc] init];
    _secondLabel.text = @"消息中心";
    _secondLabel.font = [UIFont systemFontOfSize:20];
    [self.secondButton addSubview:_secondLabel];
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@60);
        make.width.equalTo(@100);
        make.top.mas_offset(0);
        make.left.mas_offset(30);
    }];
    
    _firstView = [[UIView alloc] init];
    _firstView.backgroundColor = [UIColor colorWithRed:(238.0f / 255.0f) green:(238.0f / 255.0f)blue:(238.0f / 255.0f) alpha:1.0f];
    [self addSubview:_firstView];
    [_firstView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@1);
        make.width.equalTo(@SIZE_WIDTH);
        make.top.mas_offset(239);
        make.left.mas_offset(0);
    }];
    
    _secondView = [[UIView alloc] init];
    _secondView.backgroundColor = [UIColor colorWithRed:(238.0f / 255.0f) green:(238.0f / 255.0f)blue:(238.0f / 255.0f) alpha:1.0f];
    [self addSubview:_secondView];
    [_secondView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@1);
        make.width.equalTo(@SIZE_WIDTH);
        make.top.mas_offset(300);
        make.left.mas_offset(0);
    }];
    
    _firstImageView = [[UIImageView alloc] init];
    [_firstImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"next.png"]]];
    [self.firstButton addSubview:_firstImageView];
    [_firstImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@24);
        make.width.equalTo(@24);
        make.top.mas_offset(18);
        make.right.mas_offset(-30);
    }];
    
    _secondImageView = [[UIImageView alloc] init];
    [_secondImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"next.png"]]];
    [self.secondButton addSubview:_secondImageView];
    [_secondImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@24);
        make.width.equalTo(@24);
        make.top.mas_offset(18);
        make.right.mas_offset(-30);
    }];
}
- (void)buttonReturn:(UIButton *)button {
    [_delegate chuButton:button];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
