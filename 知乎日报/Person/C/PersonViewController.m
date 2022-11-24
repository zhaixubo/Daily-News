//
//  PersonViewController.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "PersonViewController.h"
#import "CollectViewController.h"
#import "MessageViewController.h"
@interface PersonViewController ()

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.personView = [[PersonView alloc] initWithFrame:self.view.bounds];
    [self.personView viewInit];
    self.personView.delegate = self;
    [self.view addSubview: self.personView];
}
- (void)chuButton:(UIButton *)button {
    if (button.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (button.tag == 1) {
        CollectViewController *viewcontroller = [[CollectViewController alloc] init];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    } else if (button.tag == 2) {
        MessageViewController *viewcontroller = [[MessageViewController alloc] init];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
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
