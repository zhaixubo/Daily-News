//
//  CollectViewController.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "ViewController.h"
#import "CollectView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectViewController : ViewController <thirdButtonDelegate, deleteDelegate, PushDelegate>

@property (nonatomic, strong) CollectView *collectview;

@end

NS_ASSUME_NONNULL_END
