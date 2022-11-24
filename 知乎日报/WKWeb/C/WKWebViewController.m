//
//  WKWebViewController.m
//  知乎日报
//
//  Created by 翟旭博 on 2022/10/21.
//

#import "WKWebViewController.h"
#import "MainViewController.h"
#import "ExtraModel.h"
#import "MainManager.h"
#import "CommentViewController.h"
#import "FMDB.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface WKWebViewController ()

@property (nonatomic, assign) int longCommentNum;
@property (nonatomic, assign) int shortCommentNum;
@property (nonatomic, strong) FMDatabase *collectionDatabase;
@property (nonatomic, strong) FMDatabase *goodDatabase;
@property (nonatomic, strong) NSString *nowID;
@property (nonatomic, strong) NSString *nowMainLabel;
@property (nonatomic, strong) NSString *nowImageUrl;
@property (nonatomic, assign) int day;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.day = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    _wkWebView = [[WkWebView alloc] initWithFrame:self.view.bounds];
    [self.wkWebView viewInit];
    self.wkWebView.pushViewController = self.pushViewController;
    _wkWebView.allArray = [[NSMutableArray alloc] init];
    _wkWebView.allArray = _allArray;
    _wkWebView.clickNumber = _clickNumber;
    _wkWebView.againDelegate = self;
    [self databaseInit];
    self.wkWebView.delegate = self;
    self.wkWebView.secondDelegate = self;
    [self.view addSubview:_wkWebView];
    
}

- (void)chuButton:(UIButton *)button {
    if (button.tag == 1) {   //返回
        [self.navigationController popViewControllerAnimated:YES];
    } else if (button.tag == 2) {   //评论
        CommentViewController *viewController = [[CommentViewController alloc] init];
        viewController.urlString = self.wkWebView.urlString;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (button.tag == 3 || button.tag == 103) {   //点赞
        int goodNum;
        if (button.tag == 3) {
            [button setImage:[UIImage imageNamed:@"dianzan2.png"] forState:UIControlStateNormal];
            button.tag += 100;
            goodNum = [self.wkWebView.goodLabel.text intValue];
            goodNum++;
            [self insertGoodData:self.nowID];
            self.wkWebView.goodLabel.text = [NSString stringWithFormat:@"%d", goodNum];
        } else if (button.tag == 103) {
            [button setImage:[UIImage imageNamed:@"dianzan.png"] forState:UIControlStateNormal];
            button.tag -= 100;
            goodNum = [self.wkWebView.goodLabel.text intValue];
            goodNum--;
            [self deleteGoodData:_nowID];
            self.wkWebView.goodLabel.text = [NSString stringWithFormat:@"%d", goodNum];
        }
    } else if (button.tag == 4 || button.tag == 104) {   //收藏
        if (button.tag == 4) {
            [button setImage:[UIImage imageNamed:@"shoucang3.png"] forState:UIControlStateNormal];
            [self insertCollectionData:self.nowMainLabel and:self.nowImageUrl and:self.nowID];
            button.tag += 100;
        } else if (button.tag == 104) {
            [button setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
            [self deleteCollectionData:_nowID];
            button.tag -= 100;;
        }
    }
    
}
- (void)getId:(id)extraId and:(NSString *)mainLabel and:(NSString *)imageUrl {
    self.nowID = extraId;
    self.nowMainLabel = mainLabel;
    self.nowImageUrl = imageUrl;
    [self getNetworkRequest:extraId];
}


- (void)getNetworkRequest:(id)extraId {
    [[MainManager sharedManage] NetExtraWorkWithData:^(ExtraModel * _Nonnull mainViewModel) {
        //NSLog(@"请求成功666");
        self.wkWebView.extraDictionary = [[NSDictionary alloc] init];
        self.wkWebView.extraDictionary = [mainViewModel toDictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.wkWebView.goodLabel.text = [NSString stringWithFormat:@"%@",self.wkWebView.extraDictionary[@"popularity"]];
            self.wkWebView.commentLabel.text = [NSString stringWithFormat:@"%@",self.wkWebView.extraDictionary[@"comments"]];
            self->_longCommentNum = [[NSString stringWithFormat:@"%@",self.wkWebView.extraDictionary[@"long_comments"]] intValue];
            self->_shortCommentNum = [[NSString stringWithFormat:@"%@",self.wkWebView.extraDictionary[@"short_comments"]] intValue];
            
            //判断点赞和收藏
            [self queryData];
        });
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    } date:[NSString stringWithFormat:@"%@", extraId]];
}

//右滑动继续刷新
- (void)beforeNetworkRequest:(int)continueNum {
    NSDate *senddate = [NSDate dateWithTimeIntervalSinceNow: - 24 * 3600 * (continueNum - 1)];
    NSCalendar *cal = [NSCalendar  currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents *conponent = [cal components:unitFlags fromDate:senddate];
    NSInteger year = [conponent year];
    NSInteger month = [conponent month];
    NSInteger day = [conponent day];
    NSString *nowTimeString = [NSString stringWithFormat:@"%ld%02ld%02ld", year, month, day];
    [[MainManager sharedManage] NetOldWorkWithData:^(MainModel * _Nonnull mainViewModel) {
        NSLog(@"请求成功000");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_allArray addObject:[mainViewModel toDictionary]];
            self.wkWebView.allArray = self->_allArray;
            self.day++;
            [self->_delegate getThereNew:self.day];
            [self.wkWebView scrollViewNextReload];
        });
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    } date:nowTimeString];
}

- (void)againAllArray:(int)continueNum {
    [self beforeNetworkRequest:continueNum];
    _beforeDay++;
}

//FMDB初始化
- (void)databaseInit {
    NSString *collectionDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *collectionFileName = [collectionDoc stringByAppendingPathComponent:@"collectionData.sqlite"];
    self.collectionDatabase = [FMDatabase databaseWithPath:collectionFileName];
    if ([self.collectionDatabase open]) {
        BOOL result = [self.collectionDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS collectionData (mainLabel text NOT NULL, imageURL text NOT NULL, id text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    }
    
    NSString *goodDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *goodFileName = [goodDoc stringByAppendingPathComponent:@"goodData.sqlite"];
    self.goodDatabase = [FMDatabase databaseWithPath:goodFileName];
    if ([self.goodDatabase open]) {
        BOOL result = [self.goodDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS goodData (id text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    }
}

// 查询数据
- (void)queryData {
    int good = 0, collect = 0;
    if ([self.collectionDatabase open]) {
        // 1.执行查询语句
        FMResultSet *collectionResultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        // 2.遍历结果
        while ([collectionResultSet next]) {
            NSString *id = [collectionResultSet stringForColumn:@"id"];
            int idInt = [id intValue];
            int nowInt = [_nowID intValue];
            //NSLog(@"`````````%@ %@ %@",id,[collectionResultSet stringForColumn:@"mainLabel"],[collectionResultSet stringForColumn:@"imageURL"]);
            if (nowInt == idInt) {
                self.wkWebView.collectButton.tag = 104;
                [self.wkWebView.collectButton setImage:[UIImage imageNamed:@"shoucang3.png"] forState:UIControlStateNormal];
                collect = 1;
            }
        }
        [self.collectionDatabase close];
    }
    
    if ([self.goodDatabase open]) {
        // 1.执行查询语句
        FMResultSet *goodResultSet = [self.goodDatabase executeQuery:@"SELECT * FROM goodData"];
        // 2.遍历结果
        while ([goodResultSet next]) {
            NSString *nowId = [NSString stringWithFormat:@"%@", [goodResultSet objectForColumn:@"id"]];
            int idInt = [nowId intValue];
            int nowInt = [_nowID intValue];
            if (idInt == nowInt) {
                self.wkWebView.goodButton.tag = 103;
                [self.wkWebView.goodButton setImage:[UIImage imageNamed:@"dianzan2.png"] forState:UIControlStateNormal];
                int goodNum = [self.wkWebView.goodLabel.text intValue];
                goodNum++;
                self.wkWebView.goodLabel.text = [NSString stringWithFormat:@"%d", goodNum];
                //break;
                good = 1;
            }
        }
        [self.goodDatabase close];
    }
    if (good == 0) {
        self.wkWebView.goodButton.tag = 3;
        [self.wkWebView.goodButton setImage:[UIImage imageNamed:@"dianzan.png"] forState:UIControlStateNormal];
        int goodNum = [self.wkWebView.goodLabel.text intValue];
        self.wkWebView.goodLabel.text = [NSString stringWithFormat:@"%d", goodNum];
    }
    if (collect == 0) {
        self.wkWebView.collectButton.tag = 4;
        [self.wkWebView.collectButton setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
    }
}

//插入数据
- (void)insertGoodData:(NSString *)string {
    if ([self.goodDatabase open]) {
        NSLog(@"%@",string);
        BOOL result = [self.goodDatabase executeUpdate:@"INSERT INTO goodData (id) VALUES (?);", string];
        if (!result) {
            NSLog(@"增加数据失败");
        } else {
            NSLog(@"增加数据成功");
        }
        [self.goodDatabase close];
    }
}

//插入数据
- (void)insertCollectionData:(NSString *)mainLabel and:(NSString *)imageURL and:(NSString *)nowId{
    if ([self.collectionDatabase open]) {
       
        BOOL result = [self.collectionDatabase executeUpdate:@"INSERT INTO collectionData (mainLabel, imageURL, id) VALUES (?, ?, ?);", mainLabel, imageURL, nowId];
        if (!result) {
            NSLog(@"增加数据失败");
        } else {
            NSLog(@"增加数据成功");
        }
        [self.collectionDatabase close];
    }
}

// 删除数据
- (void)deleteGoodData:(NSString *)nowId {
    if ([self.goodDatabase open]) {
        NSString *sql = @"delete from goodData WHERE id = ?";
        BOOL result = [self.goodDatabase executeUpdate:sql, nowId];
        if (!result) {
            NSLog(@"数据删除失败");
        } else {
            NSLog(@"数据删除成功");
        }
        [self.goodDatabase close];
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
@end
