//
//  NormalTableViewCell.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NormalTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *bigLabel;
@property (nonatomic, strong) UILabel *smallLabel;
@property (nonatomic, strong) UIImageView *mainImageView;

@end

NS_ASSUME_NONNULL_END
