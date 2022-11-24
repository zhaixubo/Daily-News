//
//  CommentView.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol commentButtonDelegate <NSObject>

- (void)chuButton:(UIButton *)button;

@end

@interface CommentView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (assign, nonatomic) id<commentButtonDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *longDictionary;
@property (nonatomic, strong) NSDictionary *shortDictionary;
- (void)viewInit;
@end

NS_ASSUME_NONNULL_END
