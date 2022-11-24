//
//  PersonViewController.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "ViewController.h"
#import "PersonView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersonViewController : ViewController <secondButtonDelegate>

@property (nonatomic, strong) PersonView *personView;

@end

NS_ASSUME_NONNULL_END
