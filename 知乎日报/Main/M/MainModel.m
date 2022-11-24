//
//  MainModel.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/15.
//



#import "MainModel.h"

@implementation StoriesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Top_StoriesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MainModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
