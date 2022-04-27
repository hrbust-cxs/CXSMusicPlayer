//
//  CXSCoreDataManager.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/14.
//

#import "CXSCoreDataManager.h"
#import "AppDelegate.h"
#import "CXSSong+CoreDataClass.h"

@interface CXSCoreDataManager ()

@property (nonatomic, strong)NSManagedObjectContext* context;

@end

@implementation CXSCoreDataManager

#pragma mark - instrance
+ (id)sharedManager {
    static CXSCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CXSCoreDataManager new];
    });
    return manager;
}

//add
- (void)addSongWithInfo:(int32_t)Id name:(NSString*)name singer:(NSString*)singer {
    //校验name是否重复
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CXSSong"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %d", Id];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = NO;
    NSArray<CXSSong *> *songs = [self.context executeFetchRequest:request error:nil];
    if(songs.count){
        //去重
        return;
    }
    
    CXSSong *song = [NSEntityDescription insertNewObjectForEntityForName:@"CXSSong" inManagedObjectContext:self.context];
    song.name = name;
    song.singer = singer;
    song.id = Id;
    NSError *error = nil;
    if (self.context.hasChanges) {
        [self.context save:&error];
    }
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
}

//delete
- (void)deleteSongWithId:(int32_t)Id {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CXSSong"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %d", Id];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = NO;
    NSError *error = nil;
    NSArray<CXSSong *> *songs = [self.context executeFetchRequest:request error:&error];
    
    [songs enumerateObjectsUsingBlock:^(CXSSong * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.context deleteObject:obj];
    }];
    
    if (self.context.hasChanges) {
        [self.context save:nil];
    }
    
    if (error) {
        NSLog(@"CoreData Delete Data Error : %@", error);
    }
}

- (NSArray*)getSongInfo{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CXSSong"];
    request.returnsObjectsAsFaults = NO;
    NSError *error = nil;
    NSArray<CXSSong *> *songs = [self.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"查询失败,错误信息:%@",error);
        return nil;
    }else{
        NSLog(@"查询结果如下%@",songs);
        return songs;
    }
}

#pragma mark - getter
- (NSManagedObjectContext *)context {
    if(!_context) {
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _context = myDelegate.persistentContainer.viewContext;
    }
    return _context;
}

@end
