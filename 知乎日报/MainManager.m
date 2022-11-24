//
//  MainManager.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/15.
//

#import "MainManager.h"
#import "MainModel.h"
#import "ExtraModel.h"
static MainManager *manager;

@implementation MainManager

//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    return YES;
//}
//

+ (instancetype)sharedManage {
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[MainManager alloc] init];
        });
    }
    return manager;
}

- (void)NetWorkWithData:(DataBlock)dataBlock error:(ErrorBlock)errorBlock {
    NSString *string = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/latest"];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            MainModel *country = [[MainModel alloc] initWithData:data error:nil];
            NSArray<Top_StoriesModel> *arr = [country top_stories];
            Top_StoriesModel *tM = arr[0];
            [tM hint];
            [tM title];
            dataBlock(country);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

- (void)NetOldWorkWithData:(DataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString {
    NSString *string = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/before/%@", dateString];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            MainModel *country = [[MainModel alloc] initWithData:data error:nil];
            dataBlock(country);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

- (void)NetExtraWorkWithData:(secondDataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString {
    NSString *string = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story-extra/%@", dateString];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            ExtraModel *country = [[ExtraModel alloc] initWithData:data error:nil];
            dataBlock(country);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}
//长评论
- (void)NetLongCommentWorkWithData:(commentDataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString {
    NSString *string = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story/%@/long-comments", dateString];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            CommentModel *country = [[CommentModel alloc] initWithData:data error:nil];
            dataBlock(country);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}
//短评论
- (void)NetShortCommentWorkWithData:(commentDataBlock) dataBlock error:(ErrorBlock) errorBlock date:(NSString*)dateString {
    NSString *string = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story/%@/short-comments", dateString];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            CommentModel *country = [[CommentModel alloc] initWithData:data error:nil];
            dataBlock(country);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}
@end
