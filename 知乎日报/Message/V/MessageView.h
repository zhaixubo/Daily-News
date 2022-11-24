//
//  MessageView.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import <UIKit/UIKit.h>

@protocol fourButtonDelegate <NSObject>

- (void)chuButton:(UIButton *)button;

@end
NS_ASSUME_NONNULL_BEGIN

@interface MessageView : UIView
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (assign, nonatomic) id<fourButtonDelegate> delegate;

- (void)viewInit;
@end

NS_ASSUME_NONNULL_END
