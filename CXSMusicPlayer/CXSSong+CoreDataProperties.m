//
//  CXSSong+CoreDataProperties.m
//  
//
//  Created by 陈新爽 on 2022/4/14.
//
//

#import "CXSSong+CoreDataProperties.h"

@implementation CXSSong (CoreDataProperties)

+ (NSFetchRequest<CXSSong *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CXSSong"];
}

@dynamic id;
@dynamic name;
@dynamic singer;

@end
