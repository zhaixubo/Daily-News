//
//  PersonView.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import <UIKit/UIKit.h>

@protocol secondButtonDelegate <NSObject>

- (void)chuButton:(UIButton *)button;

@end
NS_ASSUME_NONNULL_BEGIN

@interface PersonView : UIView 

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;

@property (assign, nonatomic) id<secondButtonDelegate> delegate;

- (void)viewInit;
@end

NS_ASSUME_NONNULL_END
