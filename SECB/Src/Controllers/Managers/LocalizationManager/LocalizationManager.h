//
//  LocalizationManager.h
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SetAppLanguage(language) [[LocalizationManager sharedInstance] setLanguage:language]
#define GetAppLanguage() [[LocalizationManager sharedInstance] language]
#define LocalizedString(key, comment) [[LocalizationManager sharedInstance] localizedStringForKey:(key) value:(@"")]
#define UDKeyAppLanguage @"UDKeyAppLanguage"

typedef enum {
    UILanguageUnknown,
    UILanguageEnglish,
    UILanguageArabic,
} UILanguage;

@interface LocalizationManager : NSObject

+ (LocalizationManager *)sharedInstance;
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment;
- (BOOL) setLanguage:(UILanguage) lang;
- (UILanguage) language;

@end
