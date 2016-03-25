//
//  DataManager.h
//
//  Copyright (c) 2012 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *writerManagedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

- (NSManagedObjectContext *)childContextWithParentContext:(NSManagedObjectContext *)parentContext;
- (BOOL)resetApplicationModel;
+ (id)sharedInstance;
- (void)saveContext:(NSManagedObjectContext *)context;
- (void)deleteObject:(NSManagedObject *)object context:(NSManagedObjectContext *)context;
- (NSArray *)objectsWithClassName:(NSString *)className predicateString:(NSString *)predicateString context:(NSManagedObjectContext *)context;
- (NSArray *)objectsWithClassName:(NSString *)className predicateString:(NSString *)predicateString;
- (NSManagedObject *)objectWithClassName:(NSString *)className predicateString:(NSString *)predicateString context:(NSManagedObjectContext *)context;
- (NSManagedObject *)objectWithClassName:(NSString *)className predicateString:(NSString *)predicateString;
- (void)deleteAllObjectsWithClassName:(NSString *)className notInSet:(NSSet *)set context:(nonnull NSManagedObjectContext *)context;

@end
