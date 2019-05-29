//
//  FUYItuSaveManager.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/18.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUYItuSaveManager.h"
#import "FUYituModel.h"

static FUYItuSaveManager *shareManager = NULL;

@implementation FUYItuSaveManager

+ (FUYItuSaveManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUYItuSaveManager alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.dataDataArray = [NSMutableArray array];

//        FUYituModel *model2 = [self loadAYituModlePointJsonStr:@"yitu_shuiguo_target" imageName:@"yitu_shuiguo"];
//        [self.dataDataArray addObject:model2];
        FUYituModel *model1 = [self loadAYituModlePointJsonStr:@"yitu_huli_target" imageName:@"yitu_huli"];
        [self.dataDataArray addObject:model1];
//        FUYituModel *model0 = [self loadAYituModlePointJsonStr:@"yitu_chouxiang_target" imageName:@"yitu_chouxiang"];
//        [self.dataDataArray addObject:model0];
        
//        FUYituModel *model3 = [self loadAYituModlePointJsonStr:@"xieshi_target" imageName:@"xieshi"];
//        [self.dataDataArray addObject:model3];
        FUYituModel *model4 = [self loadAYituModlePointJsonStr:@"manhuanan_target" imageName:@"manhuanan"];
        [self.dataDataArray addObject:model4];
        FUYituModel *model5 = [self loadAYituModlePointJsonStr:@"manhuanv_target" imageName:@"manhuanv"];
        [self.dataDataArray addObject:model5];
        FUYituModel *model6 = [self loadAYituModlePointJsonStr:@"manhuameng_target" imageName:@"manhuameng"];
        [self.dataDataArray addObject:model6];


        NSMutableArray <FUYituModel *>*array =  [[FUYItuSaveManager loadDataArray] mutableCopy];
        if (array.count > 0) {
            [self.dataDataArray addObjectsFromArray:array];;
        }
    }
    return self;
}

-(FUYituModel *)loadAYituModlePointJsonStr:(NSString *)jsonStr imageName:(NSString *)imageName{
    FUYituModel *model0 = [[FUYituModel alloc] init];
    NSString *path1=[[NSBundle mainBundle] pathForResource:jsonStr ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path1];
    //解析成字典
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *g_points = [dic objectForKey:@"group_points"];
    NSArray *g_type = [dic objectForKey:@"group_type"];
    
    float w = [[dic objectForKey:@"width"] floatValue];
    float H = [[dic objectForKey:@"height"] floatValue];
    
    model0.group_type = g_type;
    model0.group_points = g_points;
    model0.width = w;
    model0.height = H;
    model0.imagePathMid = [NSString stringWithFormat:@"yitu%d",(int)self.dataDataArray.count + 1];
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        NSString *imageFile = [NSString stringWithFormat:@"%@/%@.jpg", [[NSBundle mainBundle] resourcePath],imageName];
        image = [UIImage imageWithContentsOfFile:imageFile];
    }

    [FUYItuSaveManager saveImg:image withVideoMid:model0.imagePathMid];
    return model0;
}

+(void)dataWriteToFile{//只写入自己创建的道具
    NSArray *arr =  [FUYItuSaveManager shareManager].dataDataArray;
    if (defaultYiTuNum >= arr.count) {
        [[NSFileManager defaultManager] removeItemAtPath:[FUYItuSaveManager dataPath] error:nil];
        return;
    }
    NSMutableArray *writeArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i ++) {
        if (i >= defaultYiTuNum) {
            [writeArr addObject:arr[i]];
        }
    }
    NSString *path = [FUYItuSaveManager dataPath];
    [NSKeyedArchiver archiveRootObject:writeArr toFile:path];
}

+(NSArray <FUYituModel *>*)loadDataArray{
    NSString *path = [FUYItuSaveManager dataPath];
    NSArray *newArr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return newArr;
}


+(NSString *)dataPath{
    NSString *paths =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [paths stringByAppendingString:@"/personsArr.plist"];
    return path;
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


+ (void)removeImagePath:(NSString *)imagePath{
    
    if (!imagePath) {
        NSLog(@"移除路径为空");
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imagePath]];
    if ([fileManager fileExistsAtPath:Path]) {
        
        [fileManager removeItemAtPath:Path error:nil];
    }
}

+(UIImage *)loadImageWithVideoMid:(NSString *)imgName{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imgName]];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}



@end
