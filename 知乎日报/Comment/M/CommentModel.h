//
//  CommentModel.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/26.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OtherModel : JSONModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long status;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *author;
@end

@interface CommentsModel : JSONModel
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* avatar;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* likes;
@property (nonatomic, strong) OtherModel *reply_to;

@end

@interface CommentModel : JSONModel
@property (nonatomic, copy) NSArray<CommentsModel *> *comments;
@end

NS_ASSUME_NONNULL_END
