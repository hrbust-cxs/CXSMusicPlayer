//
//  CXSSong+CoreDataProperties.h
//  
//
//  Created by 陈新爽 on 2022/4/14.
//
//

#import "CXSSong+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CXSSong (CoreDataProperties)

+ (NSFetchRequest<CXSSong *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) int32_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *singer;

@end

NS_ASSUME_NONNULL_END
