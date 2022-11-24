//
//  CommentViewController.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/23.
//

#import "CommentViewController.h"
#import "CommentView.h"
#import "MainManager.h"
#import "CommentModel.h"
@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.commentView = [[CommentView alloc] initWithFrame:self.view.bounds];
    [self getComment];
    self.commentView.delegate = self;
    [self.view addSubview: self.commentView];
    
}
- (void)chuButton:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)getComment {
    [[MainManager sharedManage] NetLongCommentWorkWithData:^(CommentModel * _Nonnull mainViewModel) {
        NSLog(@"请求成功");
        self.commentView.longDictionary = [[NSDictionary alloc] init];
        self.commentView.longDictionary = [mainViewModel toDictionary];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getSecondComment];
        });
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    } date:[NSString stringWithFormat:@"%@", _urlString]];
    
    
}
- (void)getSecondComment {
    [[MainManager sharedManage] NetShortCommentWorkWithData:^(CommentModel * _Nonnull mainViewModel) {
        NSLog(@"请求成功");
        self.commentView.shortDictionary = [[NSDictionary alloc] init];
        self.commentView.shortDictionary = [mainViewModel toDictionary];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentView viewInit];
        });
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    } date:[NSString stringWithFormat:@"%@", _urlString]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
