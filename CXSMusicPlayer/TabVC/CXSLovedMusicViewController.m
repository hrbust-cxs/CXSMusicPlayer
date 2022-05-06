//
//  CXSLovedMusicViewController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/5/5.
//

#import "CXSLovedMusicViewController.h"
#import "CXSTableViewCell.h"
#import "CXSPlayerViewController.h"
#import "CXSCoreDataManager.h"
#import "CXSSong+CoreDataClass.h"

@interface CXSLovedMusicViewController ()
//数据库-所有数据
@property (nonatomic, strong)NSArray *infoArray;
//播放歌单
@property (nonatomic, strong)NSMutableArray *idArray;

@end

@implementation CXSLovedMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCoreDataInfo];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    label.text = @"喜欢音乐";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor grayColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    [headerView addSubview:label];
    self.tableView.tableHeaderView = headerView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self initIDArrayData];
    [self.tableView reloadData];
}

#pragma mark - getInfo
- (void)getCoreDataInfo {
    _infoArray = [[CXSCoreDataManager sharedManager] getSongInfo];
}

- (void)initLovedMusicDic {
    NSMutableDictionary *lovedDic = [NSMutableDictionary dictionary];
    for(int i = 0; i < _infoArray.count;i++)
    {
        [lovedDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:lovedDic forKey:@"CXSLovedDictionary"];
}

- (void)initIDArrayData {
    NSDictionary *lovedDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CXSLovedDictionary"];
    if(!lovedDic){
        [self initLovedMusicDic];
        lovedDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CXSLovedDictionary"];
    }
    for(int i = 0; i < lovedDic.count;i++)
    {
        BOOL isLoved = [[lovedDic objectForKey:[NSString stringWithFormat:@"%d",i]] boolValue];
        CXSSong *song = _infoArray[i];
        if(isLoved){
            if(![self.idArray containsObject:@(song.id)]){
                [self.idArray addObject:@(song.id)];
            }
        }else{
            if([self.idArray containsObject:@(song.id)]){
                [self.idArray removeObject:@(song.id)];
            }
        }
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
    return _idArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXSTableViewCellModel *model = [[CXSTableViewCellModel alloc] init];
    int Id = [_idArray[indexPath.row] intValue];
    CXSSong *song = _infoArray[Id];
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
