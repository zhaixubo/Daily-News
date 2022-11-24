//
//  MainView.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol buttonDelegate <NSObject>

- (void)chuButton:(UIButton *)button;

@end

@protocol beforeDayDelegate <NSObject>

- (void)getBeforeDay;

@end

@protocol WKDelegate <NSObject>

- (void)getClickNumber:(int)clickNumber;

@end

@interface MainView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *firstDictionary;
@property (nonatomic, strong) NSMutableArray *oldNewsArray;
@property (nonatomic, assign) int beforeDay;
@property (nonatomic, strong)  UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) int section;

- (void)viewInit;
- (void)addNavigationControllerView;
@property (weak, nonatomic) id<buttonDelegate> delegate;
@property (assign, nonatomic) id<beforeDayDelegate> secondDelegate;
@property (assign, nonatomic) id<WKDelegate> thirdDelegate;

@end

NS_ASSUME_NONNULL_END
