//
//  MainManager.h
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/15.
//

#import "JSONModel.h"
#import "MainModel.h"
#import "ExtraModel.h"
#import "CommentModel.h"
//返回主页数据
typedef void (^DataBlock) (MainModel* _Nonnull mainModel);
//返回Extra
typedef void (^secondDataBlock) (ExtraModel* _Nonnull mainModel);
typedef void (^ErrorBlock) (NSError* _Nonnull error);
//返回评论
typedef void (^commentDataBlock) (CommentModel* _Nonnull mainModel);
NS_ASSUME_NONNULL_BEGIN

@interface MainManager : JSONModel

+ (instancetype)sharedManage;
//主页顶部数据
- (void)NetWorkWithData:(DataBlock) dataBlock error:(ErrorBlock) errorBlock;
//往日数据
- (void)NetOldWorkWithData:(DataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString;
//Extra数据
- (void)NetExtraWorkWithData:(secondDataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString;
//长评论
- (void)NetLongCommentWorkWithData:(commentDataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString;
//短评论
- (void)NetShortCommentWorkWithData:(commentDataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString;
@end

NS_ASSUME_NONNULL_END
