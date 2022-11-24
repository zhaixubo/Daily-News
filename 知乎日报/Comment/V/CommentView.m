//
//  CommentView.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/23.
//

#import "CommentView.h"
#import "Masonry.h"
#import "LongTableViewCell.h"
#import "UIImageView+WebCache.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface CommentView ()
@property (nonatomic, assign) int labelHeight;
@property (nonatomic, strong) NSMutableArray *longLabelHeightArray;
@property (nonatomic, strong) NSMutableArray *shortLabelHeightArray;

@property (nonatomic, strong) NSMutableArray *longBoolArray;
@property (nonatomic, strong) NSMutableArray *shortBoolArray;
@property (nonatomic, strong) NSMutableArray *allBoolArray;
@end

@implementation CommentView

- (void)viewInit {

    [self initComment];
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
    
    _titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld条评论", ([_longDictionary[@"comments"] count] + [_shortDictionary[@"comments"] count])];
    _titleLabel.font = [UIFont systemFontOfSize:22];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(45 - 20);
        } else {
            make.top.equalTo(self).offset(45);
        }
        make.height.equalTo(@30);
        make.width.equalTo(@(0.6 * SIZE_WIDTH));
        //make.top.equalTo(self).offset(45);
        make.left.equalTo(self).offset(SIZE_WIDTH / 2 - 0.3 * SIZE_WIDTH);
    }];
    
    
    [self initTableView];

}

- (void)initComment {
    UILabel *label = [[UILabel alloc] init];
    self.longLabelHeightArray = [[NSMutableArray alloc] init];
    self.shortLabelHeightArray = [[NSMutableArray alloc] init];
    self.longBoolArray = [[NSMutableArray alloc] init];
    self.shortBoolArray = [[NSMutableArray alloc] init];
    self.allBoolArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.longDictionary[@"comments"] count]; i++) {
        label.text = self.longDictionary[@"comments"][i][@"content"];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:18];
        if (self.longDictionary[@"comments"][i][@"reply_to"][@"content"] != nil) {
            [self.longLabelHeightArray addObject:[NSString stringWithFormat:@"%lf", [label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height + 35]];
            label.font = [UIFont systemFontOfSize:17];
            label.text = self.longDictionary[@"comments"][i][@"reply_to"][@"content"];
            [self.longBoolArray addObject:[NSString stringWithFormat:@"%lf", [label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height]];
            if ([label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height < 50) {
                [self.allBoolArray addObject:@"0"];
            } else {
                [self.allBoolArray addObject:@"0"];
            }
            //[_allBoolArray addObject:[NSString stringWithFormat:@"%lf", [label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height]];
        } else {
            [self.longLabelHeightArray addObject:[NSString stringWithFormat:@"%lf", [label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height]];
            [self.longBoolArray addObject:@"0"];
            [self.allBoolArray addObject:@"0"];
        }
        
    }
    for (int i = 0; i < [_shortDictionary[@"comments"] count]; i++) {
        label.text = _shortDictionary[@"comments"][i][@"content"];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:18];
        if (_shortDictionary[@"comments"][i][@"reply_to"][@"content"] != nil) {
            [_shortLabelHeightArray addObject:[NSString stringWithFormat:@"%lf", [label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height + 35]];
            label.font = [UIFont systemFontOfSize:17];
            label.text = _shortDictionary[@"comments"][i][@"reply_to"][@"content"];
            [_shortBoolArray addObject:[NSString stringWithFormat:@"%lf", [label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height]];
            if ([label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height < 50) {
                [_allBoolArray addObject:@"0"];
            } else {
                [_allBoolArray addObject:@"0"];
            }
        } else {
            [_shortLabelHeightArray addObject:[NSString stringWithFormat:@"%lf", [label sizeThatFits:CGSizeMake(0.89 * SIZE_WIDTH - 50, CGFLOAT_MAX)].height]];
            [_shortBoolArray addObject:@"0"];
            [_allBoolArray addObject:@"0"];
        }
    }
    
}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.tag = 666;
    //_tableView.rowHeight = UITableViewAutomaticDimension;
    //_tableView.estimatedRowHeight = 300;
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.height.equalTo(@(SIZE_HEIGHT - 100));
        make.width.equalTo(@(SIZE_WIDTH));
        make.left.equalTo(self).offset(0);
    }];
    [self.tableView registerClass:[LongTableViewCell class] forCellReuseIdentifier:@"long"];
    //[self.tableView registerClass:[ShortTableViewCell class] forCellReuseIdentifier:@"short"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"title"];
}

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_longDictionary[@"comments"] count] == 0 && [_shortDictionary[@"comments"] count] == 0) {
        return 0;
    } else if ([_longDictionary[@"comments"] count] == 0 || [_shortDictionary[@"comments"] count] == 0) {
        return 1;
    } else {
        return 2;
    }
}

//每组单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_longDictionary[@"comments"] count] == 0) {
        return [_shortDictionary[@"comments"] count] + 1;
    } else if (section == 0){
        return [_longDictionary[@"comments"] count] + 1;
    } else {
        return [_shortDictionary[@"comments"] count] + 1;
    }
}

//每个单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    } else if (indexPath.section == 0){
        if ([_longDictionary[@"comments"] count] != 0) {
            return [_longLabelHeightArray[indexPath.row - 1] intValue] + 90;
        } else {
            return [_shortLabelHeightArray[indexPath.row - 1] intValue] + 90;
        }
        
    } else {
        return [_shortLabelHeightArray[indexPath.row - 1] intValue] + 90;
    }
}

//创建单元格对象函数
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
            cell.textLabel.frame = CGRectMake(0.11 * SIZE_WIDTH, 10, 200, 20);
            if ([_longDictionary[@"comments"] count] == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%ld条短评", [_shortDictionary[@"comments"] count]];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%ld条长评", [_longDictionary[@"comments"] count]];
            }
            cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
            return cell;
        } else {
            LongTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"long" forIndexPath:indexPath];
            cell.expandButton.tag = indexPath.row - 1;
            [cell.expandButton addTarget:self action:@selector(pressExpand:) forControlEvents:UIControlEventTouchUpInside];
            if ([_longDictionary[@"comments"] count] == 0) {
                cell.mainLabel.text = _shortDictionary[@"comments"][indexPath.row - 1][@"content"];
                cell.nameLabel.text = _shortDictionary[@"comments"][indexPath.row - 1][@"author"];
                if (_shortDictionary[@"comments"][indexPath.row - 1][@"likes"] != nil) {
                    cell.goodLabel.text = [NSString stringWithFormat:@"%@", _shortDictionary[@"comments"][indexPath.row - 1][@"likes"]];
                }
                
                if (_shortDictionary[@"comments"][indexPath.row - 1][@"reply_to"] != nil) {
                    cell.replyLabel.text = [NSString stringWithFormat:@"//%@", _shortDictionary[@"comments"][indexPath.row - 1][@"reply_to"][@"content"]];
                    if ([_shortBoolArray[indexPath.row - 1] doubleValue] < 60) {
                        cell.expandButton.tintColor = [UIColor clearColor];
                    } else {
                        cell.expandButton.tintColor = [UIColor grayColor];
                        if ([_allBoolArray[indexPath.row - 1] isEqualToString: @"0"]) {
                            cell.replyLabel.numberOfLines = 2;
                            [cell.expandButton setTitle:@"展开全文" forState:UIControlStateNormal];
                        } else {
                            cell.replyLabel.numberOfLines = 0;
                            [cell.expandButton setTitle:@"收起" forState:UIControlStateNormal];
                        }
                    }
                } else {
                    cell.replyLabel.text = @" ";
                    cell.expandButton.tintColor = [UIColor clearColor];
                }
               
                //如何将数字时间转化为正常时间
                NSString *time = _shortDictionary[@"comments"][indexPath.row - 1][@"time"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"MM-dd HH:mm"];
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                cell.timeLabel.text = confromTimespStr;
                
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[_shortDictionary[@"comments"][indexPath.row - 1][@"avatar"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                } else {
                    cell.mainLabel.text = _longDictionary[@"comments"][indexPath.row - 1][@"content"];
                    cell.nameLabel.text = _longDictionary[@"comments"][indexPath.row - 1][@"author"];
                    if (_longDictionary[@"comments"][indexPath.row - 1][@"likes"] != nil) {
                        cell.goodLabel.text = [NSString stringWithFormat:@"%@", _longDictionary[@"comments"][indexPath.row - 1][@"likes"]];
                    }
                    
                    if (_longDictionary[@"comments"][indexPath.row - 1][@"reply_to"] != nil) {
                        cell.replyLabel.text = [NSString stringWithFormat:@"//%@", _longDictionary[@"comments"][indexPath.row - 1][@"reply_to"][@"content"]];
                        if ([_longBoolArray[indexPath.row - 1] doubleValue] < 50) {
                            cell.expandButton.tintColor = [UIColor clearColor];
                        } else {
                            cell.expandButton.tintColor = [UIColor grayColor];
                            if ([_allBoolArray[indexPath.row - 1] isEqualToString: @"0"]) {
                                cell.replyLabel.numberOfLines = 2;
                                [cell.expandButton setTitle:@"展开全文" forState:UIControlStateNormal];
                            } else {
                                cell.replyLabel.numberOfLines = 0;
                                [cell.expandButton setTitle:@"收起" forState:UIControlStateNormal];
                            }
                        }
                    } else {
                        cell.replyLabel.text = @" ";
                        cell.expandButton.tintColor = [UIColor clearColor];
                    }
                    
                    //如何将数字时间转化为正常时间
                    NSString *time = _longDictionary[@"comments"][indexPath.row - 1][@"time"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"MM-dd HH:mm"];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    cell.timeLabel.text = confromTimespStr;
                    
                    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[_longDictionary[@"comments"][indexPath.row - 1][@"avatar"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                }
                return cell;
        }
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
            cell.textLabel.frame = CGRectMake(0.11 * SIZE_WIDTH, 10, 200, 20);
            cell.textLabel.text = [NSString stringWithFormat:@"%ld条短评", [_shortDictionary[@"comments"] count]];
            cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
            return cell;
        } else {
            LongTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"long" forIndexPath:indexPath];
            cell.expandButton.tag = indexPath.row - 1 + [_longDictionary[@"comments"] count];
            [cell.expandButton addTarget:self action:@selector(pressExpand:) forControlEvents:UIControlEventTouchUpInside];
            cell.expandButton.tag = [_longDictionary[@"comments"] count] - 1 + indexPath.row;
            cell.mainLabel.text = _shortDictionary[@"comments"][indexPath.row - 1][@"content"];
            cell.nameLabel.text = _shortDictionary[@"comments"][indexPath.row - 1][@"author"];
            if (_shortDictionary[@"comments"][indexPath.row - 1][@"likes"] != nil) {
                cell.goodLabel.text = [NSString stringWithFormat:@"%@", _shortDictionary[@"comments"][indexPath.row - 1][@"likes"]];
            }
            
            if (_shortDictionary[@"comments"][indexPath.row - 1][@"reply_to"] != nil) {
                cell.replyLabel.text = [NSString stringWithFormat:@"//%@", _shortDictionary[@"comments"][indexPath.row - 1][@"reply_to"][@"content"]];
                if ([_shortBoolArray[indexPath.row - 1] doubleValue] < 50) {
                    cell.expandButton.tintColor = [UIColor clearColor];
                } else {
                    cell.expandButton.tintColor = [UIColor grayColor];
                    if ([_allBoolArray[indexPath.row - 1 + [_longDictionary[@"comments"] count]] isEqualToString: @"0"]) {
                        cell.replyLabel.numberOfLines = 2;
                        [cell.expandButton setTitle:@"展开全文" forState:UIControlStateNormal];
                    } else {
                        cell.replyLabel.numberOfLines = 0;
                        [cell.expandButton setTitle:@"收起" forState:UIControlStateNormal];
                    }
                }
            } else {
                cell.replyLabel.text = @" ";
                cell.expandButton.tintColor = [UIColor clearColor];
            }
            //如何将数字时间转化为正常时间
            NSString *time = _shortDictionary[@"comments"][indexPath.row - 1][@"time"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            cell.timeLabel.text = confromTimespStr;
            
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[_shortDictionary[@"comments"][indexPath.row - 1][@"avatar"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            return cell;
        }
    }
}
- (void)buttonReturn:(UIButton *)button {
    [_delegate chuButton:button];
}

- (void)pressExpand:(UIButton *)button {
    if (button.tintColor != [UIColor clearColor]) {

        if ([self.allBoolArray[button.tag] isEqualToString: @"0"]) {
            if ([self.longDictionary[@"comments"] count] == 0) {
                self.shortLabelHeightArray[button.tag] = [NSString stringWithFormat:@"%lf", [self.shortBoolArray[button.tag] doubleValue] + [self.shortLabelHeightArray[button.tag] doubleValue]];
            } else {
                if (button.tag < [self.longDictionary[@"comments"] count]) {
                    self.longLabelHeightArray[button.tag] = [NSString stringWithFormat:@"%lf", [self.longBoolArray[button.tag] doubleValue] + [self.longLabelHeightArray[button.tag] doubleValue]];
                } else {
                    self.shortLabelHeightArray[button.tag - [_longDictionary[@"comments"] count]] = [NSString stringWithFormat:@"%lf", [self.shortBoolArray[button.tag - [self.longDictionary[@"comments"] count]] doubleValue] + [self.shortLabelHeightArray[button.tag - [self.longDictionary[@"comments"] count]] doubleValue]];

                }
    
            }
            self.allBoolArray[button.tag] = @"1";
        } else {
            if ([self.longDictionary[@"comments"] count] == 0) {
                self.shortLabelHeightArray[button.tag] = [NSString stringWithFormat:@"%lf", -[self.shortBoolArray[button.tag] doubleValue] + [self.shortLabelHeightArray[button.tag] doubleValue]];
            } else {
                if (button.tag < [self.longDictionary[@"comments"] count]) {
                    self.longLabelHeightArray[button.tag] = [NSString stringWithFormat:@"%lf", -[self.longBoolArray[button.tag] doubleValue] + [self.longLabelHeightArray[button.tag] doubleValue]];
                } else {
                    self.shortLabelHeightArray[button.tag - [self.longDictionary[@"comments"] count]] = [NSString stringWithFormat:@"%lf", -[self.shortBoolArray[button.tag - [self.longDictionary[@"comments"] count]] doubleValue] + [self.shortLabelHeightArray[button.tag - [self.longDictionary[@"comments"] count]] doubleValue]];

                }
            }
            self.allBoolArray[button.tag] = @"0";
        }
        [self.tableView reloadData];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
