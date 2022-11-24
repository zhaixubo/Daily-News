//
//  ExtraModel.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/23.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtraModel : JSONModel

@property (nonatomic, assign) int long_comments;
@property (nonatomic, assign) int popularity;
@property (nonatomic, assign) int short_comments;
@property (nonatomic, assign) int comments;

@end

NS_ASSUME_NONNULL_END
