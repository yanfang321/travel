//
//  AppDelegate.h
//  Travel_W
//
//  Created by WM on 15/9/19.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "HeadFile.h"
#import "AFHTTPRequestOperationManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong)  AFHTTPRequestOperationManager* manager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

