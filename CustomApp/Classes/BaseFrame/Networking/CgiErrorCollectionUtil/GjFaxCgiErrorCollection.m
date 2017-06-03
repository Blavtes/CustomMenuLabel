//
//  GjFaxCgiErrorCollection.m
//  GjFax
//
//  Created by litao on 16/9/14.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "GjFaxCgiErrorCollection.h"
#import "GjFaxCgiErrorModel.h"

static int const kMaxSubmitLimit = 30;

@implementation GjFaxCgiErrorCollection

#pragma mark - 单例

+ (GjFaxCgiErrorCollection *)manager
{
    static GjFaxCgiErrorCollection *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GjFaxCgiErrorCollection alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - 采集、取出用户行为数据

- (NSString *)CgiErrorFilePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *detailFilePath = [path stringByAppendingString:@"/CgiError.data"];
    //DLog(@"CgiError Caches: %@", detailFilePath);
    
    return detailFilePath;
}

- (void)collectCgiErrorWithCgiName:(NSString *)cgiName
                           andCode:(NSString *)retCode
                           andInfo:(NSString *)retInfo
{
#pragma mark - 过滤掉接口错误上报错误的采集

}

- (void)collectCgiError:(GjFaxCgiErrorModel *)dataModel
{
    //  1.先取出已保存数据
    NSMutableArray *savedCgiErrorDataArray = [NSMutableArray array];
    if ([self fetchSavedCgiError].count > 0) {
        [savedCgiErrorDataArray addObjectsFromArray:[self fetchSavedCgiError]];
    }
    
    //  2.把当前数据合并到已保存数据
    [savedCgiErrorDataArray addObject:dataModel];
    
    //  3.重新保存数据
    [NSKeyedArchiver archiveRootObject:savedCgiErrorDataArray toFile:[self CgiErrorFilePath]];
    
#pragma mark - 采集的时候顺带发送请求
    [self submitCollectionData];
}

- (NSArray *)fetchSavedCgiError
{
    //  1.先取出已保存数据
    NSArray *retArray = [NSArray array];
    
    NSArray *savedCgiErrorDataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self CgiErrorFilePath]];
    
    if (savedCgiErrorDataArray && [savedCgiErrorDataArray count] > 0) {
        retArray = [NSArray arrayWithArray:savedCgiErrorDataArray];
    }
    
    return retArray;
}

- (NSArray *)fetchSavedCgiErrorWithMaxLength:(int)maxLength
{
    //  1.所有数据先取出来
    NSArray *savedCgiErrorDataArray = [self fetchSavedCgiError];
    
    NSMutableArray *retArray = [NSMutableArray array];
    NSMutableArray *keepSaveArray = [NSMutableArray array];
    
    //  maxLength之前的取出来，剩余的继续保存
    for (int idx = 0; idx < savedCgiErrorDataArray.count; idx++) {
        if (idx < maxLength) {
            [retArray addObject:savedCgiErrorDataArray[idx]];
        } else {
            [keepSaveArray addObject:savedCgiErrorDataArray[idx]];
        }
    }
    
    //  保存需要继续保存的
    [NSKeyedArchiver archiveRootObject:keepSaveArray toFile:[self CgiErrorFilePath]];
    
    return retArray;
}

//  删除数据
- (NSArray *)deleteData:(NSInteger)lengthOfData
{
    //  1.所有数据先取出来
    NSArray *savedCgiErrorDataArray = [self fetchSavedCgiError];
    
    NSMutableArray *deletedArray = [NSMutableArray array];
    NSMutableArray *keepSaveArray = [NSMutableArray array];
    
    //  maxLength之前的取出来，剩余的继续保存
    for (int idx = 0; idx < savedCgiErrorDataArray.count; idx++) {
        if (idx < lengthOfData) {
            [deletedArray addObject:savedCgiErrorDataArray[idx]];
        } else {
            [keepSaveArray addObject:savedCgiErrorDataArray[idx]];
        }
    }
    
    //  保存需要继续保存的
    [NSKeyedArchiver archiveRootObject:keepSaveArray toFile:[self CgiErrorFilePath]];
    
    return deletedArray;
}

- (void)clearCgiError
{
    //  1.定义空数据
    NSMutableArray *savedCgiErrorDataArray = [NSMutableArray array];
    
    //  2.重新保存数据
    [NSKeyedArchiver archiveRootObject:savedCgiErrorDataArray toFile:[self CgiErrorFilePath]];
}

#pragma mark - 上传数据
/**
 *  上传数据
 */
- (void)submitCollectionData
{
//    //  用户id【取不到为@“”】
//    NSString *userId;
//    //  app版本号
//    NSString *appVersion;
//    //  发生时间
//    NSString *curTime;
//    //  显示页面
//    NSString *pageId;
//    //  错误码
//    NSString *errorCode;
//    //  错误信息
//    NSString *errorMsg;
    
    NSMutableArray *dicArray = [NSMutableArray array];
    
    NSArray *collectionDataArray = [self fetchSavedCgiError];
    
    //  无数据直接返回
    if (collectionDataArray.count <= 0) {
        DLog(@"无采集CgiError数据");
        return;
    }
    
    NSInteger submitLength = collectionDataArray.count;
    
    for (int idx = 0; idx < collectionDataArray.count; idx++) {
        //  取出来的采集数据
        GjFaxCgiErrorModel *model = collectionDataArray[idx];
        //  转换成参数
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        
        [dataDic setObjectJudgeNil:model.cgiName forKey:@"apiName"];
        [dataDic setObjectJudgeNil:model.userId forKey:@"userId"];
        [dataDic setObjectJudgeNil:model.pageId forKey:@"pageId"];
        [dataDic setObjectJudgeNil:model.curTime forKey:@"time"];
        [dataDic setObjectJudgeNil:model.appVersion forKey:@"appVersion"];
        [dataDic setObjectJudgeNil:model.errorCode forKey:@"errorCode"];
        [dataDic setObjectJudgeNil:model.errorMsg forKey:@"errorMsg"];
        //  加入参数数组
        [dicArray addObject:dataDic];
    }
    
}

- (void)reqSubmitCollectionData_callBack:(id)data withLength:(NSInteger)lengthOfData
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
    
    NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
    NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"errorCode"]);
    NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
    
#pragma mark - 上传成功
    if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccess]) {
        
        //  success
        DLog(@"[CgiError数据]-->上传成功");
        //  清空数据
        NSArray *collectionDataArray = [self fetchSavedCgiError];
        if (lengthOfData == collectionDataArray.count) {
            [self clearCgiError];
        } else {
            [self deleteData:lengthOfData];
        }
        
    } else {
        //
        DLog(@"[CgiError数据]-->上传失败[%@][%@]", retCodeStr, retNoteStr);
    }
}

@end
