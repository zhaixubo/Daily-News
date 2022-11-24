//
//  LongTableViewCell.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LongTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *goodButton;
@property (nonatomic, strong) UILabel *goodLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIButton *expandButton;
@end

NS_ASSUME_NONNULL_END
