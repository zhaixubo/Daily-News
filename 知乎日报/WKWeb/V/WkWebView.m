//
//  WKWebView.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/21.
//

#import "WkWebView.h"
#import "Masonry.h"
#import "WebKit/WebKit.h"

#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface WkWebView()
@property (nonatomic, assign) int requestFlag;
@end

@implementation WkWebView

- (void)viewInit {
    
    _requestFlag = 0;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.tag = 52;
    _scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(40);
        make.height.equalTo(@(SIZE_HEIGHT * 0.91 - 40));
        make.width.equalTo(@(SIZE_WIDTH));
        make.left.equalTo(self).offset(0);
    }];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_backButton setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    _backButton.tintColor = [UIColor blackColor];
    _backButton.tag = 1;
    [_backButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-0.04 * SIZE_HEIGHT);
        make.height.equalTo(@(0.03 * SIZE_HEIGHT));
        make.width.equalTo(@(0.03 * SIZE_HEIGHT));
        make.left.equalTo(self).offset(0.06 * SIZE_WIDTH);
    }];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_commentButton setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
    _commentButton.tintColor = [UIColor blackColor];
    _commentButton.tag = 2;
    [_commentButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-0.04 * SIZE_HEIGHT);
        make.height.equalTo(@(0.028 * SIZE_HEIGHT));
        make.width.equalTo(@(0.028 * SIZE_HEIGHT));
        make.left.equalTo(self).offset(0.24 * SIZE_WIDTH);
    }];
    
    _commentLabel = [[UILabel alloc] init];
    [self.commentButton addSubview:_commentLabel];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-0.05 * SIZE_HEIGHT);
        make.height.equalTo(@(0.03 * SIZE_HEIGHT));
        make.width.equalTo(@(0.05 * SIZE_HEIGHT));
        make.left.equalTo(self.commentButton).offset(0.07 * SIZE_WIDTH);
    }];
    
    _goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodButton setImage:[UIImage imageNamed:@"dianzan.png"] forState:UIControlStateNormal];
    _goodButton.tintColor = [UIColor blackColor];
    _goodButton.tag = 3;
    [_goodButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_goodButton];
    [_goodButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-0.04 * SIZE_HEIGHT);
        make.height.equalTo(@(0.033 * SIZE_HEIGHT));
        make.width.equalTo(@(0.033 * SIZE_HEIGHT));
        make.left.equalTo(self).offset(0.45 * SIZE_WIDTH);
    }];
    
    _goodLabel = [[UILabel alloc] init];
    [self.goodButton addSubview:_goodLabel];
    [_goodLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-0.05 * SIZE_HEIGHT);
        make.height.equalTo(@(0.03 * SIZE_HEIGHT));
        make.width.equalTo(@(0.05 * SIZE_HEIGHT));
        make.left.equalTo(self.goodButton).offset(0.07 * SIZE_WIDTH);
    }];
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectButton setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
    _collectButton.tintColor = [UIColor blackColor];
    _collectButton.tag = 4;
    [_collectButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collectButton];
    [_collectButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-0.04 * SIZE_HEIGHT);
        make.height.equalTo(@(0.035 * SIZE_HEIGHT));
        make.width.equalTo(@(0.035 * SIZE_HEIGHT));
        make.left.equalTo(self).offset(0.66 * SIZE_WIDTH);
    }];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_shareButton setImage:[UIImage imageNamed:@"fenxiang.png"] forState:UIControlStateNormal];
    _shareButton.tintColor = [UIColor blackColor];
    _shareButton.tag = 5;
    [_shareButton addTarget:self action:@selector(buttonReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self).offset(-0.04 * SIZE_HEIGHT);
        make.height.equalTo(@(0.033 * SIZE_HEIGHT));
        make.width.equalTo(@(0.033 * SIZE_HEIGHT));
        make.left.equalTo(self).offset(0.85 * SIZE_WIDTH);
    }];
    
    _urlString = [[NSMutableString alloc] init];
}

- (void)buttonReturn:(UIButton *)button {
    [_delegate chuButton:button];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 52) {
        int page = scrollView.contentOffset.x / SIZE_WIDTH;
        if (self.pushViewController == 666) {
            [_secondDelegate getId:_allArray[page][@"id"] and:_allArray[page][@"title"] and:_allArray[page][@"image"]];
            _urlString = _allArray[page][@"id"];
        } else if (_clickNumber < 5) {
            [_secondDelegate getId:_allArray[0][@"top_stories"][page][@"id"] and:_allArray[0][@"top_stories"][page][@"title"] and:_allArray[0][@"top_stories"][page][@"image"]];
            _urlString = _allArray[0][@"top_stories"][page][@"id"];
        } else {
            [_secondDelegate getId:_allArray[page / 6][@"stories"][page % 6][@"id"] and:_allArray[page / 6][@"stories"][page % 6][@"title"] and:_allArray[page / 6][@"stories"][page % 6][@"images"][0]];
            _urlString = _allArray[page / 6][@"stories"][page % 6][@"id"];
        }
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX >= SIZE_WIDTH * 6 * _allArray.count - SIZE_WIDTH + 2) {
        if (_requestFlag == 0) {
            [_againDelegate againAllArray:(int)_allArray.count];
            _requestFlag = 1;
        }
        
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.pushViewController == 0) {
        [self scrollViewLocation];
    } else {
        [self collectWebViewLocation];
    }
    
}

//原有的webview初始化
- (void)scrollViewLocation {
    if (_clickNumber < 5) {
        _scrollView.contentSize = CGSizeMake(5 * SIZE_WIDTH, 0);
        [_secondDelegate getId:_allArray[0][@"top_stories"][_clickNumber][@"id"] and:_allArray[0][@"top_stories"][_clickNumber][@"title"] and:_allArray[0][@"top_stories"][_clickNumber][@"image"]];
        [self.scrollView setContentOffset:CGPointMake(SIZE_WIDTH * _clickNumber, 0)];
        _urlString = _allArray[0][@"top_stories"][_clickNumber][@"id"];
        for (int i = 0; i < 5; i++) {
            _wkWebView = [[WKWebView alloc] init];
            NSURL *url = [NSURL URLWithString:_allArray[0][@"top_stories"][i][@"url"]];
            _wkWebView.tag = 1011;
            
            _wkWebView.frame = CGRectMake(SIZE_WIDTH * i, 0, SIZE_WIDTH, SIZE_HEIGHT * 0.91 - 40);
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [_wkWebView loadRequest:request];
            [self.scrollView addSubview: _wkWebView];
        }
    } else {
        _scrollView.contentSize = CGSizeMake(_allArray.count * 6 * SIZE_WIDTH + SIZE_WIDTH, 0);
        [self.scrollView setContentOffset:CGPointMake(SIZE_WIDTH * (_clickNumber - 5), 0)];
        [_secondDelegate getId:_allArray[(_clickNumber - 5) / 6][@"stories"][(_clickNumber - 5) % 6][@"id"] and:_allArray[(_clickNumber - 5) / 6][@"stories"][(_clickNumber - 5) % 6][@"title"] and:_allArray[(_clickNumber - 5) / 6][@"stories"][(_clickNumber - 5) % 6][@"images"][0]];
        _urlString = _allArray[(_clickNumber - 5) / 6][@"stories"][(_clickNumber - 5) % 6][@"id"];
        for (int i = 0; i < _allArray.count; i++) {
            for (int j = 0; j < 6; j++) {
                _wkWebView = [[WKWebView alloc] init];
                _wkWebView.tag = 1011;
                NSURL *url = [NSURL URLWithString:_allArray[i][@"stories"][j][@"url"]];
                _wkWebView.frame = CGRectMake(SIZE_WIDTH * i * 6 + SIZE_WIDTH * j, 0, SIZE_WIDTH, SIZE_HEIGHT * 0.91 - 40);
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [_wkWebView loadRequest:request];
                [self.scrollView addSubview: _wkWebView];
            }
        }
    }
}

- (void)collectWebViewLocation {
    _scrollView.contentSize = CGSizeMake(self.allArray.count * SIZE_WIDTH, 0);
    [_secondDelegate getId:_allArray[0][@"id"] and:_allArray[0][@"title"] and:_allArray[0][@"image"]];
    [self.scrollView setContentOffset:CGPointMake(SIZE_WIDTH * _clickNumber, 0)];
    _urlString = _allArray[0][@"id"];
    for (int i = 0; i < self.allArray.count; i++) {
        _wkWebView = [[WKWebView alloc] init];
        NSString *string = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@", _allArray[i][@"id"]];
        NSURL *url = [NSURL URLWithString:string];
        _wkWebView.tag = 1011;
        
        _wkWebView.frame = CGRectMake(SIZE_WIDTH * i, 0, SIZE_WIDTH, SIZE_HEIGHT * 0.91 - 40);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_wkWebView loadRequest:request];
        [self.scrollView addSubview: _wkWebView];
    }

}

//多余滑动刷新
- (void)scrollViewNextReload {
    
    _scrollView.contentSize = CGSizeMake(_allArray.count * 6 * SIZE_WIDTH + SIZE_WIDTH, 0);
    for (int i = 0; i < 6; i++) {
        _wkWebView = [[WKWebView alloc] init];
        _wkWebView.tag = 1011;
        NSURL *url = [NSURL URLWithString:_allArray[_allArray.count - 1][@"stories"][i][@"url"]];
        _wkWebView.frame = CGRectMake((_allArray.count - 1) * SIZE_WIDTH * 6 + i * SIZE_WIDTH, 0, SIZE_WIDTH, SIZE_HEIGHT * 0.91 - 40);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_wkWebView loadRequest:request];
        [self.scrollView addSubview: _wkWebView];
    }
    _requestFlag = 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
