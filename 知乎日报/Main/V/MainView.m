//
//  MainView.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "MainView.h"
#import "Masonry.h"
#import "ScrollTableViewCell.h"
#import "NormalTableViewCell.h"
#import "TimeTableViewCell.h"
#import "UIImageView+WebCache.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface MainView ()

@end

@implementation MainView

- (void)viewInit {
    [self addNavigationControllerView];
    [self initTableView];
    
}

- (void)addNavigationControllerView {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSArray *montharray = [NSArray arrayWithObjects:@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月",nil];
    
    //状态栏高度
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager = windowScene.statusBarManager;

    
    _dayLabel = [[UILabel alloc] init];
    _monthLabel = [[UILabel alloc] init];
    _dayLabel.text = [NSString stringWithFormat:@"%d",(int)day];
    _dayLabel.font = [UIFont systemFontOfSize:20];
    _monthLabel.text = [NSString stringWithFormat:@"%@",montharray[month - 1]];
    _monthLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_dayLabel];
    [self addSubview:_monthLabel];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(40 - 20);
        } else {
            make.top.equalTo(self).offset(40);
        }
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        
        make.left.equalTo(self).offset(35);
    }];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@30);
        make.width.equalTo(@60);
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(65 - 20);
        } else {
            make.top.equalTo(self).offset(65);
        }
        make.left.equalTo(self).offset(18);
    }];
    UIView *longView = [[UIView alloc] init];
    longView.backgroundColor = [UIColor grayColor];
    [self addSubview:longView];
    [longView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@40);
        make.width.equalTo(@1);
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(46 - 20);
        } else {
            make.top.equalTo(self).offset(46);
        }
        make.left.equalTo(self).offset(70);
    }];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"知乎日报";
    _titleLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@60);
        make.width.equalTo(@150);
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(37 - 20);
        } else {
            make.top.equalTo(self).offset(37);
        }
        make.left.equalTo(self).offset(90);
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_rightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.jpg"]] forState:UIControlStateNormal];
    [_rightButton.layer setMasksToBounds: YES];
    [_rightButton.layer setCornerRadius: 20];
    [self addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(43 - 15);
        } else {
            make.top.equalTo(self).offset(43);
        }
        make.right.equalTo(self).offset(-25);
    }];
    [_rightButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.tag = 666;
    [self addSubview:_tableView];
    //状态栏高度
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (statusBarManager.statusBarFrame.size.height < 30) {
            make.top.equalTo(self).offset(100 - 20);
        } else {
            make.top.equalTo(self).offset(100);
        }
        make.height.equalTo(@(SIZE_HEIGHT - 100));
        make.width.equalTo(@(SIZE_WIDTH));
        //make.top.equalTo(self).offset(100);
        make.left.equalTo(self).offset(0);
    }];
    [self.tableView registerClass:[ScrollTableViewCell class] forCellReuseIdentifier:@"scroll"];
    [self.tableView registerClass:[NormalTableViewCell class] forCellReuseIdentifier:@"normal"];
    [self.tableView registerClass:[TimeTableViewCell class] forCellReuseIdentifier:@"time"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"refresh"];
    
    _beforeDay = 1;
    
}

- (void)buttonReturn:(UIButton *)button {

    [_delegate chuButton:button];
}

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.section;
}

//每组单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 6;
    } else if (section == 2) {
        return 7 * _beforeDay;
    } else {
        return 1;
    }
}

//每个单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SIZE_WIDTH;
    } else if (indexPath.section == 1) {
        return 120;
    } else if (indexPath.section == 2) {
        if (indexPath.row % 7 == 0) {
            return 30;
        } else {
            return 120;
        }
    } else {
        return 50;
    }
    return 0;
}

//创建单元格对象函数
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ScrollTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"scroll" forIndexPath:indexPath];
        for (int i = 0; i < 7; i++) {
            UIImageView *mainImageView = [[UIImageView alloc] init];
            [cell.scrollview addSubview:mainImageView];
            //设置imageView的点击事件
            mainImageView.userInteractionEnabled = YES;
            mainImageView.tag = i;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressImage:)];
            [mainImageView addGestureRecognizer:singleTap];
            
            UILabel *bigLabel = [[UILabel alloc] init];
            bigLabel.numberOfLines = 0;
            bigLabel.font = [UIFont systemFontOfSize:25];
            bigLabel.textColor = [UIColor whiteColor];
            bigLabel.tag = i;
            bigLabel.backgroundColor = [UIColor clearColor];

            
            UILabel *smallLabel = [[UILabel alloc] init];
            smallLabel.numberOfLines = 0;
            smallLabel.textColor = [UIColor grayColor];
            smallLabel.font = [UIFont systemFontOfSize:15];
            smallLabel.tag = i;
            
            mainImageView.frame = CGRectMake(0 + SIZE_WIDTH * i, 0, SIZE_WIDTH, SIZE_WIDTH);
            bigLabel.frame = CGRectMake(20 + i * SIZE_WIDTH, SIZE_WIDTH - 140, SIZE_WIDTH - 20 - 50, 100);
            smallLabel.frame = CGRectMake(20 + i * SIZE_WIDTH, SIZE_WIDTH - 60, SIZE_WIDTH - 20 - 50, 50);
            
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0 + SIZE_WIDTH * i, SIZE_WIDTH / 2, SIZE_WIDTH, SIZE_WIDTH / 2);
            [mainImageView addSubview:view];
            [cell.scrollview addSubview:bigLabel];
            [cell.scrollview addSubview:smallLabel];
            UIColor *firstColor;
            UIColor *secondColor;
            if (i > 0 && i < 6) {
                bigLabel.text =_firstDictionary[@"top_stories"][i - 1][@"title"];
                smallLabel.text =_firstDictionary[@"top_stories"][i - 1][@"hint"];
                [mainImageView sd_setImageWithURL:[NSURL URLWithString:[_firstDictionary[@"top_stories"][i - 1][@"image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                firstColor = [[[self class] mostColor:mainImageView] colorWithAlphaComponent:1.0];
                secondColor = [[[self class] mostColor:mainImageView] colorWithAlphaComponent:0.0];
            } else if (i == 0) {
                bigLabel.text =_firstDictionary[@"top_stories"][4][@"title"];
                smallLabel.text =_firstDictionary[@"top_stories"][4][@"hint"];
                [mainImageView sd_setImageWithURL:[NSURL URLWithString:[_firstDictionary[@"top_stories"][4][@"image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                firstColor = [[[self class] mostColor:mainImageView] colorWithAlphaComponent:1.0];
                secondColor = [[[self class] mostColor:mainImageView] colorWithAlphaComponent:0.0];
            } else if (i == 6) {
                bigLabel.text =_firstDictionary[@"top_stories"][0][@"title"];
                smallLabel.text =_firstDictionary[@"top_stories"][0][@"hint"];
                [mainImageView sd_setImageWithURL:[NSURL URLWithString:[_firstDictionary[@"top_stories"][0][@"image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                firstColor = [[[self class] mostColor:mainImageView] colorWithAlphaComponent:1.0];
                secondColor = [[[self class] mostColor:mainImageView] colorWithAlphaComponent:0.0];
            }
            NSArray *colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, secondColor.CGColor, nil];
            CAGradientLayer *gradient = [CAGradientLayer layer];
            //设置开始和结束位置(设置渐变的方向)
            gradient.startPoint = CGPointMake(0, 0.5);
            gradient.endPoint = CGPointMake(0, 0);
            gradient.colors = colors;
            gradient.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_WIDTH / 2);
            [view.layer insertSublayer:gradient atIndex:0];

        }
        return cell;
    } else if (indexPath.section == 1) {
        NormalTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"normal" forIndexPath:indexPath];
        cell.bigLabel.text = _firstDictionary[@"stories"][indexPath.row][@"title"];
        cell.smallLabel.text = _firstDictionary[@"stories"][indexPath.row][@"hint"];
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[_firstDictionary[@"stories"][indexPath.row][@"images"][0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row % 7 == 0) {
            TimeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
            
            NSDate *senddate = [NSDate dateWithTimeIntervalSinceNow: - 24 * 3600 * (indexPath.row / 7 + 1)];
            NSCalendar  *cal = [NSCalendar  currentCalendar];
            NSUInteger  unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
            NSDateComponents *conponent = [cal components:unitFlags fromDate:senddate];
            NSInteger month = [conponent month];
            NSInteger day = [conponent day];
            cell.timeLabel.text = [NSString stringWithFormat:@"%ld月%ld日", (NSInteger)month, (NSInteger)day];
            
            return cell;
        } else {
            NormalTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"normal" forIndexPath:indexPath];
            if (_oldNewsArray.count != 0) {
                cell.bigLabel.text = _oldNewsArray[indexPath.row / 7][@"stories"][indexPath.row % 7 - 1][@"title"];
                cell.smallLabel.text = _oldNewsArray[indexPath.row / 7][@"stories"][indexPath.row % 7 - 1][@"hint"];
                [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[_oldNewsArray[indexPath.row / 7][@"stories"][indexPath.row % 7 - 1][@"images"][0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            }
            
            return cell;
        }
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"refresh" forIndexPath:indexPath];
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        _activityIndicatorView.backgroundColor = [UIColor whiteColor];
        //启动动画显示
        [_activityIndicatorView startAnimating];
        //停止等待对话框
        //[_activityIndicatorView stopAnimating];
        [cell addSubview: _activityIndicatorView];
        _activityIndicatorView.frame = CGRectMake(SIZE_WIDTH / 2 - 8, 25, 15, 15);
        return cell;
    }
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int clickNumber;
    if (indexPath.section == 1 || (indexPath.section == 2 && indexPath.row % 7 != 0)) {
        if (indexPath.section == 1) {
            clickNumber = (int)indexPath.row + 5;
        } else {
            clickNumber = (int)(indexPath.row / 7 + 1) * 6 + indexPath.row % 7 + 4;
        }
        [_thirdDelegate getClickNumber:clickNumber];
    }
}

//scrollView点击
- (void)pressImage:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"%ld",gestureRecognizer.view.tag - 1);
    int clickNumber;
    if (gestureRecognizer.view.tag == 0) {
        clickNumber = 4;
    } else if (gestureRecognizer.view.tag == 6){
        clickNumber = 0;
    } else {
        clickNumber = (int)gestureRecognizer.view.tag - 1;
    }
    
    [_thirdDelegate getClickNumber:clickNumber];
}

//停止拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    /*if (scrollView.tag == 666) {
        CGFloat height = scrollView.bounds.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        if (bottomOffset <= 1 * height || _activityIndicatorView.animating) {
            [_secondDelegate getBeforeDay];
        }
    }*/
    
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"%lf %lf", contentOffsetY, SIZE_WIDTH + 6 * 120 + (self.oldNewsArray.count - 1) * 720);
    if (scrollView.tag == 666) {
        if (contentOffsetY >= SIZE_WIDTH + 6 * 120 + (self.oldNewsArray.count - 1) * 720 - 40) {
            
            /*if (_requestFlag == 0) {
                [_againDelegate againAllArray:(int)_allArray.count];
                _requestFlag = 1;
            }*/
             
            if (_activityIndicatorView.animating) {
                [_secondDelegate getBeforeDay];
            }
        }
    }
}
//获取主色调
+ (UIColor *)mostColor:(UIImageView*)imageView {
    
    UIImage *image = imageView.image;
    NSLog(@"%@",image);
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    
    //缩小图片，加快计算速度
    CGSize thumbSize = CGSizeMake(image.size.width/20, image.size.height/20);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, thumbSize.width, thumbSize.height, 8, thumbSize.width * 4, colorSpace,bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //统计每个点的像素值
    unsigned char *data = CGBitmapContextGetData(context);
    if (data == NULL) {
        return nil;
    }
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = image.size.height / 30; y < thumbSize.height; y++) {
            int offset = 4 * (x * y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha = data[offset+3];
            //去除透明
            if (alpha > 0) {
                //去除白色
                if (red >= 180 || green >= 180 || blue >= 180) {
                    
                } else {
                    NSArray *clr = @[@(red), @(green), @(blue), @(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    //找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) {
            continue;
        }
        MaxCount = tmpCount;
        MaxColor = curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
