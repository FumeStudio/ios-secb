//
//  CacheManager.h
//  TechnicalTest
//
//  Created by Peter Mosaad on 1/14/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CacheManager : NSObject
{
	NSString *cachedImagesDirectoryPath;
}

+(CacheManager *)sharedInstance;

-(void)clearCaches;

#pragma mark - Cached images
//jpgQuality should be between 0.0 to 1.0 else will use 0.5
-(bool)saveImage:(UIImage *)image withUrl:(NSString *)imageUrl andShouldSaveItAsJPG:(bool)saveAsJPG andJPGQuality:(float)jpgQuality;
-(bool)saveImage:(UIImage *)image withUrl:(NSString *)imageUrl andShouldSaveItAsJPG:(bool)saveAsJPG;
-(void)removeImageWithURL:(NSString *)imageURL;
-(NSString *)cachedImagePathWithImageUrl:(NSString *)imageUrl;
-(UIImage *)getImageOfUrl:(NSString *)imageUrl;
-(void)clearAllCachedImages;

/**
Create folder in Documnets path
@param folderName.
@return fullPath of folder
 */
-(NSString *)createFolderInDocumnetsDirectoryWithName:(NSString *)folderName;

/**
 Create folder in Caches path
 Data in caches directory may be deleted if iOS needs space/updates/....
 @param folderName.
 @return fullPath of folder
 */
-(NSString *)createFolderInCacheDirectoryWithName:(NSString *)folderName;

/**
 If file exists return true.
 */
-(bool)isFileExistsWithFullPath:(NSString *)fullPath;

/**
Return true if file removed
*/
-(bool)removeFileWithFullPath:(NSString *)fullPath;

/**
 Method to cache object (object implements NSCoding).
 @param object : object to be cached, this object should implement NSCoding.
 @param directory : full directory to save the object.
 @param key : used to identify the object (should be a unique value per directory).
 */
-(bool)saveObject:(NSObject<NSCoding> *)object atDirectory:(NSString *)directory andKey:(NSString *)key;

/**
 @param directory : full directory to save the object.
 @param key : used to identify the object.
 */
-(bool)removeObjectAtDirectory:(NSString *)directory andKey:(NSString *)key;

/**
 Method to get cached object.
 @param directory : full directory of cached object.
 @param key : the key used when object saved.
 @returns Cached object
 */
-(NSObject *)loadObjectAtDirectory:(NSString *)directory andKey:(NSString *)key;

/**
 Clear cached objects in specific directory.
 @param directory : directory to be cleared.
 */
-(void)clearObjectsOfDirectory:(NSString *)directory;

/**
 Check if cached object expired or still can be used.
 */
-(bool)isObjectExpiredWithDirectory:(NSString *)directory andKey:(NSString *)key andExpireDurationInHours:(int)hours;

@end