//
//  LongTableViewCell.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/26.
//

#import "LongTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@implementation LongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
    [self.contentView addSubview:_nameLabel];
    
    _mainLabel = [[UILabel alloc] init];
    _mainLabel.textAlignment = NSTextAlignmentLeft;
    _mainLabel.numberOfLines = 0;
    [self.contentView addSubview:_mainLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.numberOfLines = 0;
    [self.contentView addSubview:_timeLabel];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = (SIZE_WIDTH * 0.11) / 2;
    _headImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_headImageView];
    
    _goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodButton setImage:[UIImage imageNamed:@"dianzan3.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_goodButton];
    
    _goodLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_goodLabel];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setImage:[UIImage imageNamed:@"comment3.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_commentButton];
    
    _replyLabel = [[UILabel alloc] init];
    _replyLabel.numberOfLines = 2;
    _replyLabel.font = [UIFont systemFontOfSize:17];
    _replyLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_replyLabel];
    
    _expandButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_expandButton setTitle:@"展开全文" forState:UIControlStateNormal];
    [_expandButton setTintColor:[UIColor grayColor]];
    _expandButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_expandButton];
    

    
    return self;
}

- (void)layoutSubviews {
    [_headImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@10);
        make.left.equalTo(@20);
        make.width.equalTo(@(SIZE_WIDTH * 0.11));
        make.height.equalTo(@(SIZE_WIDTH * 0.11));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(30 + (SIZE_WIDTH * 0.11));
        make.width.equalTo(@(SIZE_WIDTH * 0.7));
        make.height.equalTo(@(SIZE_WIDTH * 0.1));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(30 + (SIZE_WIDTH * 0.11));
        make.height.equalTo(@(SIZE_WIDTH * 0.05));
        make.width.equalTo(@100);
    }];
      
    [_mainLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        //make.bottom.equalTo(self.timeLabel).offset(-30);
        make.top.equalTo(self.nameLabel).offset(35);
        make.left.equalTo(self).offset(30 + (SIZE_WIDTH * 0.11));
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [_goodButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(SIZE_WIDTH * 0.05));
        make.right.equalTo(self).offset(-80);
        make.width.equalTo(@(SIZE_WIDTH * 0.05));
    }];
    
    [_goodLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(SIZE_WIDTH * 0.05));
        make.right.equalTo(self.goodButton).offset(-20);
        make.width.equalTo(@(SIZE_WIDTH * 0.05));
    }];
    
    [_commentButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(SIZE_WIDTH * 0.05));
        make.right.equalTo(self).offset(-20);
        make.width.equalTo(@(SIZE_WIDTH * 0.05));
    }];
    
    [_replyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.timeLabel).offset(-30);
        make.left.equalTo(self).offset(30 + (SIZE_WIDTH * 0.11));
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [_expandButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(SIZE_WIDTH * 0.05));
        make.left.equalTo(self).offset(30 + (SIZE_WIDTH * 0.11) + 110);
        make.width.equalTo(@(80));
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
