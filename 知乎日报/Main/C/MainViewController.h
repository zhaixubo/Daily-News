//
//  MainViewController.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "ViewController.h"
#import "MainModel.h"
#import "MainView.h"
#import "WkWebView.h"
#import "WKWebViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : ViewController <buttonDelegate, beforeDayDelegate, WKDelegate, BackAndGetMoreDelegate>

@property (nonatomic, assign) int beforeDay;
- (void)getBeforeDay;
@end

NS_ASSUME_NONNULL_END
