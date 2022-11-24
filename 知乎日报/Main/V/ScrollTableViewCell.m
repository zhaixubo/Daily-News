//
//  ScrollTableViewCell.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/13.
//

#import "ScrollTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@implementation ScrollTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_WIDTH)];
    [self.contentView addSubview:_scrollview];
    self.scrollview.contentSize = CGSizeMake(SIZE_WIDTH * 7, 100);
    _scrollview.tag = 0;
    self.pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.contentView addSubview:_pageControl];

    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timeOut:) userInfo:nil repeats:YES];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
    return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@50);
        make.width.equalTo(@170);
        make.bottom.equalTo(self).offset(-10);
        make.right.equalTo(self).offset(0);
    }];
    self.scrollview.pagingEnabled = YES;
    self.scrollview.scrollEnabled = YES;
    self.scrollview.bounces = YES;
    self.scrollview.alwaysBounceHorizontal = NO;
    self.scrollview.alwaysBounceVertical = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
    self.scrollview.backgroundColor = [UIColor whiteColor];
    if (_scrollview.tag == 0){
        [_scrollview setContentOffset:CGPointMake(SIZE_WIDTH, 0) animated:NO];
        _scrollview.tag = 1;
    }
    
}


//当scrollView停止滚动之后调用此方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1) {
        //计算偏移量所对应的页数
        double page = _scrollview.contentOffset.x / SIZE_WIDTH;
        if (page >= 6) {
            _scrollview.contentOffset = CGPointMake(SIZE_WIDTH * 1, 0);
            _pageControl.currentPage = 0;
        } else if (page == 0) {
            _scrollview.contentOffset = CGPointMake(SIZE_WIDTH * 5, 0);
            _pageControl.currentPage = 4;
        } else {
            _pageControl.currentPage = page - 1;
        }
    }
    
}

- (void)timeOut:(NSTimer*)timer {
  /*  if (_scrollview.contentOffset.x >= SIZE_WIDTH * 5) {
        [_scrollview setContentOffset:CGPointMake(SIZE_WIDTH, 0) animated:YES];
    } else {*/
        [_scrollview setContentOffset:CGPointMake(_scrollview.contentOffset.x + SIZE_WIDTH, 0) animated:YES];
   // }


}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == 1) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.tag == 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOut:) userInfo:nil repeats:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1) {
        if (_scrollview.contentOffset.x > SIZE_WIDTH * 6) {
            [_scrollview setContentOffset:CGPointMake(SIZE_WIDTH, 0) animated:NO];
        } else if (_scrollview.contentOffset.x < SIZE_WIDTH) {
            [_scrollview setContentOffset:CGPointMake(SIZE_WIDTH * 6, 0)];
        }
        _pageControl.currentPage = (_scrollview.contentOffset.x) / SIZE_WIDTH - 1;
    }
    if (_scrollview.contentOffset.x >= SIZE_WIDTH * 5) {
        _pageControl.currentPage = 0;
    }
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
