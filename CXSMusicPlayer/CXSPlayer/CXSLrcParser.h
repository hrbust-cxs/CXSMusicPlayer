//
//  CXSLrcParser.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXSLrcParser : NSObject

//时间
@property (nonatomic,strong) NSMutableArray *timerArray;
//歌词
@property (nonatomic,strong) NSMutableArray *wordArray;
//解析歌词
-(NSString *)getLrcFile:(NSString *)path;
//解析歌词
-(void)parseLrc:(NSString*)lrc;
//删除旧的歌词数组
- (void)removeAllArrayObject;

@end

NS_ASSUME_NONNULL_END
