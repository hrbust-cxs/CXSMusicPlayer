//
//  CXSLrcParser.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/5/4.
//

#import "CXSLrcParser.h"

@implementation CXSLrcParser

-(instancetype) init{
    self=[super init];
    if(self!=nil){
        self.timerArray = [[NSMutableArray alloc] init];
        self.wordArray = [[NSMutableArray alloc] init];
    }
    return self;
    
}

-(NSString *)getLrcFile:(NSString *)path{
    NSString *lrcContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return lrcContent;
}

-(void)parseLrc:(NSString *)lrc{
    if(![lrc isEqual:nil]) {
        [self removeAllArrayObject];
        NSArray *sepArray = [lrc componentsSeparatedByString:@"["];
        NSArray *lineArray = [[NSArray alloc] init];
        for(int i = 0; i < sepArray.count; i++) {
            if([sepArray[i] length] > 0){
                lineArray = [sepArray[i] componentsSeparatedByString:@"]"];
                if(![lineArray[0] isEqualToString:@"\n"]){
                    [self.timerArray addObject:lineArray[0]];
                    [self.wordArray addObject:lineArray.count > 1 ? lineArray[1]:@""];
                }
            }
        }
    }
}

- (void)removeAllArrayObject {
    [self.wordArray removeAllObjects];
    [self.timerArray removeAllObjects];
}

@end
