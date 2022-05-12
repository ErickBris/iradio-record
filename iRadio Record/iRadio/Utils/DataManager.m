//
//  DataManager.m
//
//  Created by Bendnaiba Mohamed on 12/12/2016.
//
//

#import "DataManager.h"

@implementation DataManager


+ (void)creatCachFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDirectoryName = @"";
    NSString *os5 = @"5.0";
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedAscending) //lower than 4
    {
        cacheDirectoryName = path;
    }
    else if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedDescending) //5.0.1 and above
    {
        cacheDirectoryName = path;
        cacheDirectoryName = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/RADIO"];
    }
    else // IOS 5
    {
        cacheDirectoryName = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/RADIO"];
    }
    BOOL isDirectory = NO;
    BOOL folderExists = [fileManager fileExistsAtPath:cacheDirectoryName isDirectory:&isDirectory] && isDirectory;
    
    if (!folderExists)
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    
    //NSURL *storeUrl = [NSURL fileURLWithPath:cacheDirectoryName];
    //[self addSkipBackupAttributeToItemAtURL:storeUrl];
}

+ (NSString*) savePath
{
    NSString *os5 = @"5.0";
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedAscending) //lower than 4
    {
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    }
    else if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedDescending) //5.0.1 and above
    {
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/RADIO"];
    }
    else // IOS 5
    {
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/RADIO"];
    }
    
    return path;
}

@end
