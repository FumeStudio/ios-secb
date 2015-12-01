//
//  LocalizationManager.m
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "LocalizationManager.h"


static LocalizationManager *_s_sharedInstance = nil;

@implementation LocalizationManager {
    
    NSBundle *_bundle;
    NSDictionary *_languageSet;
}

+ (LocalizationManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _s_sharedInstance = [LocalizationManager new];
    });
    return _s_sharedInstance;
}

- (id) init
{
    if (self = [super init]) {
        _bundle = [NSBundle mainBundle];
        _languageSet = @{
                         @(UILanguageEnglish) : @"en",
                         @(UILanguageArabic) : @"ar"
                         };
    }
    return self;
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment
{
    return [_bundle localizedStringForKey:key value:comment table:nil];
}

- (BOOL) setLanguage:(UILanguage) lang
{
    UILanguage activeLang = [self language];
    if (lang == UILanguageUnknown) {
        _bundle = [NSBundle mainBundle];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDKeyAppLanguage];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:_languageSet[@(lang)] ofType:@"lproj"];
        
        _bundle = [NSBundle bundleWithPath:path];
        [[NSUserDefaults standardUserDefaults] setInteger:lang forKey:UDKeyAppLanguage];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:(lang == UILanguageArabic)? @"AR":@"EN", nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return activeLang != lang;
}

- (UILanguage) language
{
    UILanguage lang = (UILanguage)[[NSUserDefaults standardUserDefaults] integerForKey:UDKeyAppLanguage];
    if (lang == UILanguageUnknown) {
        NSString* preferredLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
        for (NSNumber *key in _languageSet) {
            if ([_languageSet[key] isEqualToString:preferredLang]) {
                lang = (UILanguage)[key integerValue];
                break;
            }
        }
    }
    return lang;
}

@end