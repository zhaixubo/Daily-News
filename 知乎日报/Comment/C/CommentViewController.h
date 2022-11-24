//
//  CommentViewController.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/23.
//

#import "ViewController.h"
#import "CommentView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentViewController : ViewController <commentButtonDelegate>

@property (nonatomic, strong) CommentView *commentView;
@property (nonatomic, strong) NSMutableString *urlString;


@end

NS_ASSUME_NONNULL_END
