//
//  AppDelegate.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/15.
//

#import "AppDelegate.h"
#import "CXSTabBarController.h"
#import <AVFoundation/AVFoundation.h>
#import "CXSPlayerViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong)CXSPlayerViewController *playVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[CXSTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

#pragma mark - backgroud play info setting
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
                [self.playVC playPauseMusic:NO];
                NSLog(@"接受到远程控制 - 播放");
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.playVC playPauseMusic:YES];
                NSLog(@"接受到远程控制 - 暂停");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self.playVC playNextMusic];
                NSLog(@"接受到远程控制 - 下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.playVC playLastMusic];
                NSLog(@"接受到远程控制 - 上一首 ");
                break;
            default:
                break;
        }
    }
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CXSMusicPlayer"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - setter getter
- (CXSPlayerViewController *)playVC {
    if(!_playVC){
        _playVC = [CXSPlayerViewController shareViewController];
    }
    return _playVC;
}

@end
