//
//  CXSTableViewCell.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXSTableViewCellModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *singer;

@end

@interface CXSTableViewCell : UITableViewCell

- (instancetype)initWithModel:(CXSTableViewCellModel*)model;

@end

NS_ASSUME_NONNULL_END
