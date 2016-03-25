//
//  DataManager.m
//
//  Copyright (c) 2012 Zachary Waleed Saraf. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize writerManagedObjectContext = _writerManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static DataManager *sharedInstance = nil;

+ (DataManager *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    
    return sharedInstance;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.parentContext = [self writerManagedObjectContext];

    return _managedObjectContext;
}

- (NSManagedObjectContext *)writerManagedObjectContext {
    if (_writerManagedObjectContext != nil) {
        return _writerManagedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _writerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_writerManagedObjectContext setPersistentStoreCoordinator: coordinator];
    }

    return _writerManagedObjectContext;
}

- (NSManagedObjectContext *)childContextWithParentContext:(NSManagedObjectContext *)parentContext
{
    if (parentContext == nil) {
        parentContext = [self managedObjectContext];
    }
    
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = parentContext;

    return childContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Database.sqlite"]];
    
    NSError *error;
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle the error.
    }
    
    return _persistentStoreCoordinator;
}

- (BOOL)resetApplicationModel {
    
    // ----------------------
    // This method removes all traces of the Core Data store and then resets the application defaults
    // ----------------------
    NSError *_error = nil;
    NSURL *_storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Database.sqlite"]];
    NSPersistentStore *_store = [self.persistentStoreCoordinator persistentStoreForURL:_storeURL];
    
    //
    // Remove the SQL store and the file associated with it
    //
    if ([self.persistentStoreCoordinator removePersistentStore:_store error:&_error]) {
        [[NSFileManager defaultManager] removeItemAtPath:_storeURL.path error:&_error];
    }
    
    if (_error) {
        NSLog(@"Failed to remove persistent store: %@", [_error localizedDescription]);
        NSArray *_detailedErrors = [[_error userInfo] objectForKey:NSDetailedErrorsKey];
        if (_detailedErrors != nil && [_detailedErrors count] > 0) {
            for (NSError *_detailedError in _detailedErrors) {
                NSLog(@" DetailedError: %@", [_detailedError userInfo]);
            }
        }
        else {
            NSLog(@" %@", [_error userInfo]);
        }
        return NO;
    }
    
    _managedObjectContext = nil;
    _persistentStoreCoordinator = nil;
    _writerManagedObjectContext = nil;
    _managedObjectModel = nil;
    
    return YES;
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }
    
    // Save the managedobjectcontext
    NSError *saveError = nil;
    if (![context save:&saveError]) NSLog(@"Error saving managedobjectcontext: %@", saveError.localizedDescription);

    // Save to disk in private queue
    if (context == self.managedObjectContext) {
        if (![self.writerManagedObjectContext save:&saveError]) NSLog(@"Error saving managedobjectcontext: %@", saveError.localizedDescription);
    } else if (context.parentContext == self.managedObjectContext) {
        [self saveContext:self.managedObjectContext];
    }
}

- (void)deleteObject:(NSManagedObject *)object context:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }

    if (object) {
        [context deleteObject:object];
    }
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths objectAtIndex:0];
    return basePath;
}

- (NSArray *)objectsWithClassName:(NSString *)className predicateString:(NSString *)predicateString context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    request.predicate = predicate;
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    return results;
}

- (NSArray *)objectsWithClassName:(NSString *)className predicateString:(NSString *)predicateString
{
    NSManagedObjectContext *moc = [[DataManager sharedInstance] managedObjectContext];
    return [self objectsWithClassName:className predicateString:predicateString context:moc];
}

- (NSManagedObject *)objectWithClassName:(NSString *)className predicateString:(NSString *)predicateString context:(NSManagedObjectContext *)context
{
    return [self objectsWithClassName:className predicateString:predicateString context:context].firstObject;
}

- (NSManagedObject *)objectWithClassName:(NSString *)className predicateString:(NSString *)predicateString
{
    return [self objectsWithClassName:className predicateString:predicateString].firstObject;
}

- (void)deleteAllObjectsWithClassName:(NSString *)className notInSet:(NSSet *)set context:(nonnull NSManagedObjectContext *)context
{
    NSFetchRequest *allObjectsRequest = [[NSFetchRequest alloc] init];
    [allObjectsRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:context]];
    [allObjectsRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:allObjectsRequest error:&error];

    for (NSManagedObject *object in objects) {
        if (![set containsObject:object]) {
            [context deleteObject:object];
        }
    }
}

@end
