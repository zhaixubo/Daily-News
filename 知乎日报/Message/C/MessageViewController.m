//
//  MessageViewController.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.messageView = [[MessageView alloc] initWithFrame:self.view.bounds];
    [self.messageView viewInit];
    self.messageView.delegate = self;
    [self.view addSubview: self.messageView];
}
- (void)chuButton:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];

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
