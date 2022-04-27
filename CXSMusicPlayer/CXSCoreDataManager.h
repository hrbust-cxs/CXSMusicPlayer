//
//  CXSCoreDataManager.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXSCoreDataManager : NSObject
//单例
+ (id)sharedManager;
//添加对象
- (void)addSongWithInfo:(int32_t)Id name:(NSString*)name singer:(NSString*)singer;
//删除对象
- (void)deleteSongWithId:(int32_t)Id;
//获取数据
- (NSArray*)getSongInfo;

@end

NS_ASSUME_NONNULL_END

