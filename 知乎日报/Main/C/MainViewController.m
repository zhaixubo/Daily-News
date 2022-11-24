//
//  MainViewController.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/12.
//

#import "MainViewController.h"
#import "PersonViewController.h"
#import "MainManager.h"
#import "MainModel.h"
#import "MainView.h"
#import "WKWebViewController.h"
#import "FMDB.h"
@interface MainViewController ()

@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) MainModel *mainModel;
@property (nonatomic, strong) NSMutableDictionary *firstDictionary;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) WKWebViewController *viewController;
@property (nonatomic, strong) FMDatabase *cacheDatabase;
@property (nonatomic, assign) int flag;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.flag = 0;
    _allArray = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainView = [[MainView alloc] initWithFrame:self.view.bounds];
    self.mainView.tableView.tag = 666;
    self.mainView.section = 4;
    _beforeDay = 1;
    self.mainView.oldNewsArray = [[NSMutableArray alloc] init];
    [self databaseInit];
    [self firstNetworkRequest];
    
    self.mainView.delegate = self;
    self.mainView.secondDelegate = self;
    self.mainView.thirdDelegate = self;
    
    [self.view addSubview: self.mainView];
    self.mainModel = [[MainModel alloc] init];
}

- (void)firstNetworkRequest {
    [[MainManager sharedManage] NetWorkWithData:^(MainModel * _Nonnull mainViewModel) {
        NSLog(@"请求成功");
        self->_firstDictionary = [[NSMutableDictionary alloc] init];
        self->_firstDictionary = [mainViewModel toDictionary];
        NSLog(@"%@",self->_firstDictionary);
        [self->_allArray addObject:[mainViewModel toDictionary]];
        // 异步执行任务创建方法
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self beforeNetworkRequest];
            [self deleteCacheData];
            for (int i = 0; i < 5; i++) {
                [self insertCacheData:self->_firstDictionary[@"top_stories"][i][@"title"] and:self->_firstDictionary[@"top_stories"][i][@"image"] and:self->_firstDictionary[@"top_stories"][i][@"hint"]];
            }
            
            for (int i = 0; i < 6; i++) {
                [self insertCacheData:self->_firstDictionary[@"stories"][i][@"title"] and:self->_firstDictionary[@"stories"][i][@"images"][0] and:self->_firstDictionary[@"stories"][i][@"hint"]];
            }
        });
        
        
    } error:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[self.mainView addNavigationControllerView];

            [self queryData];
            self.mainView.firstDictionary = self->_firstDictionary;
            NSLog(@"------%@",self.mainView.firstDictionary);
            self.mainView.section = 2;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通知" message:@"网络出现问题" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:sure];
            [self presentViewController:alertController animated:YES completion:nil];
            [self.mainView viewInit];
        });
        
        NSLog(@"请求失败");
    }];
}
- (void)beforeNetworkRequest {
    NSDate *senddate = [NSDate dateWithTimeIntervalSinceNow: - 1.0 * 24 * 3600 * (_beforeDay - 1)];
    NSCalendar  *cal = [NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents *conponent = [cal components:unitFlags fromDate:senddate];
    NSInteger year = [conponent year];
    NSInteger month = [conponent month];
    NSInteger day = [conponent day];
    NSString *nowTimeString = [NSString stringWithFormat:@"%ld%02ld%02ld", year, month, day];
    if ([nowTimeString isEqualToString:@"20221027"]) {
        nowTimeString = [NSString stringWithFormat:@"20220901"];
    }
    [[MainManager sharedManage] NetOldWorkWithData:^(MainModel * _Nonnull mainViewModel) {
        NSLog(@"请求成功");
        // 异步执行任务创建方法
        NSLog(@"%@",nowTimeString);
        self.mainView.firstDictionary = self->_firstDictionary;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.flag == 0) {
                [self.mainView viewInit];
                self.flag = 1;
            }
            [self.mainView.oldNewsArray addObject:[mainViewModel toDictionary]];
            self.mainView.beforeDay++;
            if (self.mainView.oldNewsArray.count >= self.mainView.beforeDay) {
                [self.mainView.tableView reloadData];
            } else {
                self.mainView.beforeDay--;
                [self.mainView.tableView reloadData];
            }
            NSDictionary *dictionary = [mainViewModel toDictionary];
            [self->_allArray addObject:dictionary];
            if (self.mainView.activityIndicatorView.animating) {
                [self.mainView.activityIndicatorView stopAnimating];
            }
        });
        
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    } date:nowTimeString];
    
}

//到个人界面
- (void)chuButton:(UIButton *)button {
    PersonViewController *viewcontroller = [[PersonViewController alloc] init];
    viewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
    
- (void)getBeforeDay {
    _beforeDay++;
    [self beforeNetworkRequest];
}
//cell点进去
- (void)getClickNumber:(int)clickNumber {
    if (self.mainView.section == 4) {
        _viewController = [[WKWebViewController alloc] init];
        _viewController.delegate = self;
        if (_allArray[0][@"top_stories"] == nil) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            dictionary = _allArray[0];
            _allArray[0] = _allArray[1];
            _allArray[1] = dictionary;
        }
        _viewController.clickNumber = clickNumber;
        _viewController.allArray = _allArray;
        _viewController.beforeDay = _beforeDay;
        _viewController.pushViewController = 0;
        [self.navigationController pushViewController:_viewController animated:YES];
    }
    
}

- (void)getThereNew:(int)day {
    _beforeDay += day;
    [self beforeNetworkRequest];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//FMDB初始化
- (void)databaseInit {
    NSString *cacheDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cacheFileName = [cacheDoc stringByAppendingPathComponent:@"cacheData.sqlite"];
    self.cacheDatabase = [FMDatabase databaseWithPath:cacheFileName];
    if ([self.cacheDatabase open]) {
        BOOL result = [self.cacheDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS cacheData (title text NOT NULL, imageURL text NOT NULL, hint text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    }
}

// 查询数据
- (void)queryData {
    if ([self.cacheDatabase open]) {
        // 1.执行查询语句
        FMResultSet *cacheResultSet = [self.cacheDatabase executeQuery:@"SELECT * FROM cacheData"];
        // 2.遍历结果
        
        int i = 0;
        NSMutableArray *stories = [[NSMutableArray alloc] init];
        NSMutableArray *top_stories = [[NSMutableArray alloc] init];
        while ([cacheResultSet next]) {
            if (i < 5) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[cacheResultSet objectForColumn:@"title"],@"title",[cacheResultSet objectForColumn:@"imageURL"],@"image",[cacheResultSet objectForColumn:@"hint"],@"hint", nil];
                [top_stories addObject:dictionary];
                i++;
            } else {
                NSArray *array = [NSArray arrayWithObject:[cacheResultSet objectForColumn:@"imageURL"]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[cacheResultSet objectForColumn:@"title"],@"title",array,@"images",[cacheResultSet objectForColumn:@"hint"],@"hint", nil];
                [stories addObject:dictionary];
            }

        }
        NSLog(@"++++%@",top_stories);
        NSLog(@"****%@",stories);
        self.firstDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:top_stories,@"top_stories",stories,@"stories", nil];
        [self.cacheDatabase close];
    }
}

//插入数据
- (void)insertCacheData:(NSString *)title and:(NSString *)imageURL and:(NSString *)hint {
    if ([self.cacheDatabase open]) {
        BOOL result = [self.cacheDatabase executeUpdate:@"INSERT INTO cacheData (title, imageURL, hint) VALUES (?, ?, ?);", title, imageURL, hint];
        if (!result) {
            NSLog(@"增加数据失败");
        } else {
            NSLog(@"增加数据成功");
        }
        [self.cacheDatabase close];
    }
}

// 删除数据
- (void)deleteCacheData {
    if ([self.cacheDatabase open]) {
        NSString *sql = @"DELETE FROM cacheData";
        BOOL result = [self.cacheDatabase executeUpdate:sql];
        if (!result) {
            NSLog(@"数据删除失败");
        } else {
            NSLog(@"数据删除成功");
        }
        [self.cacheDatabase close];
    }
}
@end
