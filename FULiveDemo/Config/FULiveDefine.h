//
//  FULiveDefine.h
//  FULive
//
//  Created by L on 2018/8/1.
//  Copyright © 2018年 L. All rights reserved.
//

#define FUDocumentPath   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define FUStickersPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickers"]

#define FUStickerIconsPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickerIcons"]

#define FUStickerBundlesPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickerBundles"]

#define FUNSLocalizedString(Context,comment)  [NSString stringWithFormat:@"%@", [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(Context) value:nil table:nil]]

