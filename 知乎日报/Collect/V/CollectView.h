//
//  CollectView.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol thirdButtonDelegate <NSObject>

- (void)chuButton:(UIButton *)button;

@end

@protocol deleteDelegate <NSObject>

- (void)getDeleteRow:(NSInteger)row;

@end

@protocol PushDelegate <NSObject>

- (void)getPushRow:(NSInteger)row;

@end
@interface CollectView : UIView <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *collectArray;
@property (assign, nonatomic) id<thirdButtonDelegate> delegate;
@property (assign, nonatomic) id<deleteDelegate> secondDelegate;
@property (assign, nonatomic) id<PushDelegate> pushDelegate;
- (void)viewInit;
@end

NS_ASSUME_NONNULL_END
