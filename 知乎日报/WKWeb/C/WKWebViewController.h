//
//  WKWebViewController.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/21.
//

#import "ViewController.h"
#import "WkWebView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BackAndGetMoreDelegate <NSObject>

- (void)getThereNew:(int)day;

@end


@interface WKWebViewController : ViewController <wkWebButtonDelegate, extraDelegate, AgainDelegate>

@property (nonatomic, strong) WkWebView *wkWebView;
@property (nonatomic, assign) int clickNumber;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, assign) int beforeDay;
@property (assign, nonatomic) id<BackAndGetMoreDelegate> delegate;

//判断从哪个界面跳转过来的
@property (nonatomic, assign) int pushViewController;
@end

NS_ASSUME_NONNULL_END
