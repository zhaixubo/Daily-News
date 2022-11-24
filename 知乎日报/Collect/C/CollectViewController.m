//
//  CollectViewController.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "CollectViewController.h"
#import "FMDB.h"
#import "WKWebViewController.h"
@interface CollectViewController ()

@property (nonatomic, strong) FMDatabase *collectionDatabase;
@property (nonatomic, strong) NSMutableArray *collectArray;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.collectview = [[CollectView alloc] initWithFrame:self.view.bounds];
    self.collectview.delegate = self;
    self.collectview.secondDelegate = self;
    self.collectview.pushDelegate = self;
    [self.view addSubview: self.collectview];

    [self databaseInit];
    [self queryData];
    [self.collectview viewInit];
}
- (void)chuButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)databaseInit {
    NSString *collectionDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *collectionFileName = [collectionDoc stringByAppendingPathComponent:@"collectionData.sqlite"];
    self.collectionDatabase = [FMDatabase databaseWithPath:collectionFileName];
}

// 查询数据
- (void)queryData {
    self.collectArray = [[NSMutableArray alloc] init];
    if ([self.collectionDatabase open]) {
        // 1.执行查询语句
        FMResultSet *collectionResultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        // 2.遍历结果
        while ([collectionResultSet next]) {
            NSString *id = [collectionResultSet stringForColumn:@"id"];
            NSString *mainLabel = [collectionResultSet stringForColumn:@"mainLabel"];
            NSString *imageUrl = [collectionResultSet stringForColumn:@"imageURL"];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:id, @"id", mainLabel, @"mainLabel", imageUrl, @"imageUrl", nil];
            [self.collectArray addObject:dictionary];
            self.collectview.collectArray = self.collectArray;
            }
        [self.collectionDatabase close];
    }
}
// 删除数据
- (void)deleteCollectionData:(NSString *)nowId {
    if ([self.collectionDatabase open]) {
        NSString *sql = @"delete from collectionData WHERE id = ?";
        BOOL result = [self.collectionDatabase executeUpdate:sql, nowId];
        if (!result) {
            NSLog(@"数据删除失败");
        } else {
            NSLog(@"数据删除成功");
        }
        [self.collectionDatabase close];
    }
}

- (void)getDeleteRow:(NSInteger)row {
    [self deleteCollectionData:self.collectArray[row][@"id"]];
    [self.collectArray removeObjectAtIndex:row];
    self.collectview.collectArray = self.collectArray;
    [self.collectview.tableView reloadData];
}

- (void)getPushRow:(NSInteger)row {
    WKWebViewController *wkWebViewController = [[WKWebViewController alloc] init];
    wkWebViewController.pushViewController = 666;
    wkWebViewController.clickNumber = (int)row;
    wkWebViewController.allArray = self.collectArray;
    [self.navigationController pushViewController:wkWebViewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self queryData];
    [self.collectview.tableView reloadData];
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
