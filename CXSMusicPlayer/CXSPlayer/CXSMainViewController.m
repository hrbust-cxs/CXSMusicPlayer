//
//  CXSMainViewController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/8.
//

#import "CXSMainViewController.h"
#import "CXSPlayerViewController.h"
#import "CXSCoreDataManager.h"

@interface CXSMainViewController ()

@end

@implementation CXSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    btn.backgroundColor = [UIColor systemPinkColor];
    [btn setTitle:@"进入PlayVC" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(pushPlayMusicViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)pushPlayMusicViewController {
    for(int i = 0; i < 30;i++)
    {
        [[CXSCoreDataManager sharedManager] deleteSongWithId:i];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    NSString *files  = [[NSBundle bundleWithPath:pathDocuments] pathForResource:@"musicInfo" ofType:@"txt"];
    NSString *lines = [NSString stringWithContentsOfFile:files encoding:NSUTF8StringEncoding error:nil];
    NSArray *allMusicNameSingerInfo = [lines componentsSeparatedByString:@"\n"];
    for(int i = 0 ; i < allMusicNameSingerInfo.count;i++) {
        NSString *musicInfo = allMusicNameSingerInfo[i];
        NSArray *musicInfoArray = [musicInfo componentsSeparatedByString:@" - "];
        [[CXSCoreDataManager sharedManager] addSongWithInfo:[musicInfoArray[0] intValue] name:musicInfoArray[2] singer:musicInfoArray[1]];
    }
}

@end
