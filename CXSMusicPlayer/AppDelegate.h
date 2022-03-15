//
//  AppDelegate.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/15.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong)UIWindow *window;

- (void)saveContext;


@end

