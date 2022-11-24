//
//  MessageViewController.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import <UIKit/UIKit.h>
#import "MessageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController <fourButtonDelegate>

@property (nonatomic, strong) MessageView *messageView;

@end

NS_ASSUME_NONNULL_END
