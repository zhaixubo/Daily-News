//
//  CollectTableViewCell.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/11/3.
//

#import "CollectTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@implementation CollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.bigLabel = [[UILabel alloc] init];
    self.bigLabel.numberOfLines = 0;
    self.bigLabel.text = @"为什么土豆没成为中国人的一种主食？";
    self.bigLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:19];
    [self.contentView addSubview:_bigLabel];
    
    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.layer.masksToBounds = YES;
    self.mainImageView.layer.cornerRadius = 5;
    [self.mainImageView setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.contentView addSubview:_mainImageView];
    return self;
}

- (void)layoutSubviews {
    [self.bigLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@80);
        make.width.equalTo(@(0.68 * SIZE_WIDTH));
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(20);
    }];

    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.width.equalTo(@80);
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
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
