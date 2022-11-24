//
//  TimeTableViewCell.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/13.
//

#import "TimeTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@implementation TimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _timeLabel = [[UILabel alloc] init];
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_lineView];
    return self;
}

- (void)layoutSubviews {
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@35);
        make.width.equalTo(@80);
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(20);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@0.3);
        make.width.equalTo(@(SIZE_WIDTH - 100));
        make.top.equalTo(self).offset(21.9);
        make.left.equalTo(self).offset(100);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
