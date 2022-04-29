//
//  CXSMainMusicViewController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/21.
//

#import "CXSMainMusicViewController.h"
#import "CXSTableViewCell.h"
#import "CXSPlayerViewController.h"
#import "CXSCoreDataManager.h"
#import "CXSSong+CoreDataClass.h"

@interface CXSMainMusicViewController ()

@property (nonatomic, strong)NSArray *infoArray;
@property (nonatomic, strong)NSMutableArray *idArray;

@end

@implementation CXSMainMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCoreDataInfo];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    label.text = @"主歌单";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor grayColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    [headerView addSubview:label];
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark - getInfo
- (void)getCoreDataInfo {
    _infoArray = [[CXSCoreDataManager sharedManager] getSongInfo];
    [self initIDArrayData];
}

- (void)initIDArrayData {
    for(int i = 0; i < _infoArray.count;i++)
    {
        CXSSong *song = _infoArray[i];
        [self.idArray addObject:@(song.id)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.idArray forKey:@"CXSIDArray"];
}


#pragma mark - click
- (void)pushPlayMusicViewController {
    CXSPlayerViewController *vc = [CXSPlayerViewController shareViewController];
    [self presentViewController:vc animated:YES completion:^{
        [vc playOnlineMusic];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXSTableViewCellModel *model = [[CXSTableViewCellModel alloc] init];
    CXSSong *song = _infoArray[indexPath.row];
    model.name = song.name;
    model.singer = song.singer;
    CXSTableViewCell *cell = [[CXSTableViewCell alloc] initWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"CXSIndex"];
    [self pushPlayMusicViewController];
}

#pragma mark - setter getter
- (NSMutableArray *)idArray {
    if(!_idArray){
        _idArray = [NSMutableArray array];
    }
    return _idArray;
}
@end
