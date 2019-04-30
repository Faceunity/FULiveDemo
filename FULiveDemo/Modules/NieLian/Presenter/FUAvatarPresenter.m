//
//  FUAvatarPresenter.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarPresenter.h"
#import "FUAvatarModel.h"
#import "FUWholeAvatarModel.h"
#import "MJExtension.h"
#import "FUManager.h"
#import "FUAvatarModel.h"


@implementation FUAvatarPresenter
static FUAvatarPresenter *shareManager = NULL;

+ (FUAvatarPresenter *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUAvatarPresenter alloc] init];
        
    
    });
    
    return shareManager;
}

-(instancetype)init{
    if (self = [super init]) {
    
    [self restAvatarModelData];
    self.wholeAvatarArray = [NSMutableArray array]; //[self loadWholeAvatarArray];
    UIImage *image  =  [UIImage imageNamed:@"demo_icon_corner_marker"];
    [self addWholeAvatar:self.dataDataArray icon:image];
//    [self addWholeAvatar:self.dataDataArray icon:image];
    [self.wholeAvatarArray addObjectsFromArray:[self loadWholeAvatarArray]];
        
        
    }
    return self;
}

-(void)restAvatarModelData{
    /* 模板 */
    NSString *wholePath=[[NSBundle mainBundle] pathForResource:@"avatar" ofType:@"json"];
    NSData *wholeData=[[NSData alloc] initWithContentsOfFile:wholePath];
    NSDictionary *wholeDic=[NSJSONSerialization JSONObjectWithData:wholeData options:NSJSONReadingMutableContainers error:nil];
    self.dataDataArray = [FUAvatarModel mj_objectArrayWithKeyValuesArray:wholeDic[@"data"]];
}



#pragma  mark -  保存

-(void)dataWriteToFile{//只写入自己创建的道具
    NSArray *arr =  [FUAvatarPresenter shareManager].wholeAvatarArray;
    if (defaultAvatarNum >= arr.count) {
        [[NSFileManager defaultManager] removeItemAtPath:[FUAvatarPresenter dataPath] error:nil];
        return;
    }
    NSMutableArray *writeArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i ++) {
        if (i >= defaultAvatarNum) {
            [writeArr addObject:arr[i]];
        }
    }
    
    NSString *path = [FUAvatarPresenter dataPath];
    [NSKeyedArchiver archiveRootObject:writeArr toFile:path];
}

-(NSMutableArray <FUWholeAvatarModel *> *)loadWholeAvatarArray{
    NSString *path = [FUAvatarPresenter dataPath];
    NSMutableArray *newArr = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] mutableCopy];
    
    return newArr;
}

+(NSString *)dataPath{
    NSString *paths =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [paths stringByAppendingString:@"/wholeAvatar.plist"];
    return path;
}

#pragma  mark -  对外接口

-(void)addWholeAvatar:(NSMutableArray<FUAvatarModel *> *)array icon:(UIImage *)image{
    FUWholeAvatarModel *model = [[FUWholeAvatarModel alloc] init];
    NSMutableArray *newArray = [NSMutableArray array];
    for (FUAvatarModel *model in array) {
        [newArray addObject:[model copy]];
    }
    model.avatarModel = newArray;
    model.image = image;
    
    [self.wholeAvatarArray addObject:model];
    
}

    
-(void)showAProp:(FUWholeAvatarModel *)wholeAvatarModel{

    for (int i = (int)wholeAvatarModel.avatarModel.count - 1; i >= 0; i --) {
        FUAvatarModel *avatarModel = wholeAvatarModel.avatarModel[i];
        int colorIndex = avatarModel.colorsSelIndex;
        int bundleIndex = avatarModel.bundleSelIndex;

        /* bind美发道具 */
        if (avatarModel.avatarType == FUAvatarTypeHair) {
            [[FUManager shareManager] avatarBindHairItem:avatarModel.bundles[bundleIndex].bundleName];
            
            /* 重设置颜色 */
            FUAvatarColor *colorModel = avatarModel.colors[colorIndex];
            [[FUManager shareManager] setAvatarHairColorParam:avatarModel.colorsParam colorWithRed:colorModel.r green:colorModel.g blue:colorModel.b intensity:(int)colorModel.intensity];

            continue;
        }
        
        if (avatarModel.bundles[bundleIndex].params.count > 0) {//参数设置类型
            for (FUAvatarParam *model0 in avatarModel.bundles[bundleIndex].params) {
                if ([model0.paramS isEqualToString:@""]) {
                    continue;
                }
                if (model0.value < 0) {
                    [[FUManager shareManager] setAvatarParam:model0.paramS value:fabsf(model0.value)];
                }else{
                    [[FUManager shareManager] setAvatarParam:model0.paramB value:fabsf(model0.value)];
                }
                
                NSLog(@"参数设置---- %@---%@--Value---%lf \n",model0.title,model0.paramS,model0.value);
            }
                       
        }
        
        if (FUAvatarTypeNose != avatarModel.avatarType) {
            /* 重设置颜色 */
            FUAvatarColor *colorModel = avatarModel.colors[colorIndex];
            [[FUManager shareManager] setAvatarItemParam:avatarModel.colorsParam colorWithRed:colorModel.r green:colorModel.g blue:colorModel.b];
        }
    }
}
    
    
+ (NSString *)saveImg:(UIImage *)image withVideoMid:(NSString *)imgName{
    
    if (!image) {
        return nil;
    }
    if (!imgName) {
        return nil;
    }
    NSData *imagedata=UIImagePNGRepresentation(image);
    //NSData *imagedata=UIImageJEPGRepresentation(m_imgFore,1.0);
    NSString *savedImagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imgName]];
    [imagedata writeToFile:savedImagePath atomically:YES];
    return savedImagePath;
}
    
+(UIImage *)loadImageWithVideoMid:(NSString *)imgName{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imgName]];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}


@end
