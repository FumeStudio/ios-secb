//
//  CacheManager.m
//  TechnicalTest
//
//  Created by Peter Mosaad on 1/14/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "CacheManager.h"
#import "NSDate-Utilities.h"
#import "NSStringCategories.h"
#import "Constants.h"

#define CachedImagesFolderName  @"cachedImages"

#define Maximum_ImagesCachingSize   104857600 //in bytes

@implementation CacheManager

- (id)init
{
	self = [super init];
	if (self)
	{
		[self createImagesFolder];
	}
	return self;
}

+(CacheManager *)sharedInstance
{
	static CacheManager* sharedInstance;
	
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

-(bool)saveObject:(NSObject<NSCoding> *)object atDirectory:(NSString *)directory andKey:(NSString *)key
{
	NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory , key];
	return [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

-(bool)removeObjectAtDirectory:(NSString *)directory andKey:(NSString *)key
{
	NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory , key];
	return [self removeFileOrDirectoryAtPath:filePath];
}

-(NSObject *)loadObjectAtDirectory:(NSString *)directory andKey:(NSString *)key
{
	NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory , key];
	NSObject *object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	if (object)
	{
		//update modified date -> to use it as last access date
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
		NSMutableDictionary *newAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
		[newAttributes setObject:[NSDate date] forKey:NSFileModificationDate];
		[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:filePath error:nil];
	}
	
	return object;
}

-(void)clearObjectsOfDirectory:(NSString *)directory
{
	NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
	[myQueue addOperationWithBlock:^{
		// Background work
		NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
		for (NSString *filename in fileArray)
			[[NSFileManager defaultManager] removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:nil];
	}];
}

-(bool)isObjectExpiredWithDirectory:(NSString *)directory andKey:(NSString *)key andExpireDurationInHours:(int)hours
{
	NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory , key];
	
	//check if expired
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
	NSDate *creationDate = [attributes fileCreationDate];
	return ([[creationDate dateByAddingHours:hours] isEarlierThanDate:[NSDate date]]);
}

-(void)createImagesFolder
{
	cachedImagesDirectoryPath = [self createFolderInDocumnetsDirectoryWithName:CachedImagesFolderName];
}

-(NSString *)createFolderInDocumnetsDirectoryWithName:(NSString *)folderName
{
	return [self createFolderInSearchPathDirectory:NSDocumentDirectory andFolderName:folderName];
}

-(NSString *)createFolderInCacheDirectoryWithName:(NSString *)folderName
{
	return [self createFolderInSearchPathDirectory:NSCachesDirectory andFolderName:folderName];
}

-(NSString *)createFolderInSearchPathDirectory:(NSSearchPathDirectory)directory andFolderName:(NSString *)folderName
{
	NSString *fullPath = nil;
	if (directory && folderName)
	{
		//create Cache directory
		NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		//cached bookmarks
		fullPath = [documentsDirectory stringByAppendingPathComponent:folderName];
		if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
			[[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	return fullPath;
}

-(bool)isFileExistsWithFullPath:(NSString *)fullPath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
}

-(bool)removeFileWithFullPath:(NSString *)fullPath
{
	return [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
}

-(void)clearCaches
{
	//clean cached data if more than Maximum_ImagesCachingSize
	[self cleanOldCachedFilesToMatchMaxSize];
}

-(NSArray *)filesInDirectory:(NSString *)directory
{
	NSError *error;
	NSArray *filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
	
	if (error || filesArray == nil)
		filesArray = [NSArray array];
	
	return filesArray;
}

#pragma mark - manage cache size

-(unsigned long long)cachedImagesDirectorySize
{
	return [[self attributesOfFileOrDirectoryAtPath:cachedImagesDirectoryPath] fileSize];
}

-(NSDictionary *)attributesOfFileOrDirectoryAtPath:(NSString *)path
{
	return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
}

-(bool)removeFileOrDirectoryAtPath:(NSString *)path
{
	return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

-(void)cleanOldCachedFilesToMatchMaxSize
{
	NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
	[myQueue addOperationWithBlock:^{
		// Background work
		long totalMaxSize = Maximum_ImagesCachingSize;
		unsigned long long currentCachedFilesSize = [self cachedImagesDirectorySize];
				
		if (currentCachedFilesSize > totalMaxSize)
		{
			NSArray *filesImages = [self filesInDirectory:cachedImagesDirectoryPath];
			
			int indexOfImages = 0;
			
			//remove files till reach max size
			while (currentCachedFilesSize > totalMaxSize)
			{
				NSString *oldestModifiedImagesPath = (indexOfImages < filesImages.count) ? [cachedImagesDirectoryPath stringByAppendingPathComponent:[filesImages objectAtIndex:indexOfImages]] : nil;
				
				if (oldestModifiedImagesPath) {
					[self removeFileOrDirectoryAtPath:oldestModifiedImagesPath];
					indexOfImages++;
				}
				
				currentCachedFilesSize = [self cachedImagesDirectorySize];
			}
		}
	}];
}

//======================================================================================//
#pragma mark - Cached images
-(NSString *)cachedImagePathWithImageUrl:(NSString *)imageUrl
{
	return [cachedImagesDirectoryPath stringByAppendingPathComponent:[NSString alphanumericCharsOfString:imageUrl andKeepAdditionalChars:@""]];
}

-(bool)saveImage:(UIImage *)image withUrl:(NSString *)imageUrl andShouldSaveItAsJPG:(bool)saveAsJPG
{
	return [self saveImage:image withUrl:imageUrl andShouldSaveItAsJPG:saveAsJPG andJPGQuality:1.0];
}

-(bool)saveImage:(UIImage *)image withUrl:(NSString *)imageUrl andShouldSaveItAsJPG:(bool)saveAsJPG andJPGQuality:(float)jpgQuality
{

	if (image && imageUrl)
	{
		NSString *filePath = [[CacheManager sharedInstance] cachedImagePathWithImageUrl:imageUrl];
		if ([imageUrl hasSuffix:@".png"] && (!saveAsJPG)) {
			return [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
		} else {
			return [UIImageJPEGRepresentation(image, jpgQuality) writeToFile:filePath atomically:YES];
		}
	}
	else
	{
		return false;
	}
}

-(void)removeImageWithURL:(NSString *)imageURL
{
	NSString *filePath = [[CacheManager sharedInstance] cachedImagePathWithImageUrl:imageURL];
	[self removeFileOrDirectoryAtPath:filePath];
}

-(UIImage *)getImageOfUrl:(NSString *)imageUrl
{
	if (imageUrl) {
		NSString *filePath = [[CacheManager sharedInstance] cachedImagePathWithImageUrl:imageUrl];
		NSData *img = [NSData dataWithContentsOfFile:filePath];
		return [UIImage imageWithData:img];
	}
	else
		return [UIImage imageNamed:@""];
}

-(void)clearAllCachedImages
{
	NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
	[myQueue addOperationWithBlock:^{
		// Background work
		NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachedImagesDirectoryPath error:nil];
		for (NSString *filename in fileArray)
			[[NSFileManager defaultManager] removeItemAtPath:[cachedImagesDirectoryPath stringByAppendingPathComponent:filename] error:nil];
	}];
}

@end