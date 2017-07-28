//
//  RMTBdReportBufferManager.m
//  RemoteControl
//
//  Created by runmit_HLC on 15/10/20.
//  Copyright © 2015年 runmit.com. All rights reserved.
//
/*
    表格设置：ID INTEGER PRIMARY , tableInfoSeqKey TEXT, tableInfoKey VARCHAR(255), BdReportReportType VARCHAR(255)
    暂时统一就一张表格，分别是：上报主键id   信息seq   上报信息   上报信息类型（启动事件，打开时间事件等类型）
 */

#import "RMTBdReportBufferManager.h"
#import "FMDB.h"
#import "RMTFileUtils.h"


// 定义好的table中key值
NSString *const BdReportPrimaryKey = @"ID";

NSString *const BdReportInfoKey = @"STARTUPDATA";
NSString *const BdReportInfoSeqKey = @"STARTUPSEQ";

//NSString *const BdReportOpenDurationInfoSeqKey = @"OPENDURSEQ";
//NSString *const BdReportOpenDurationInfoKey = @"OPENDURDATA";
NSString *const BdReportReportType = @"REPROTTYPE";

// 定义好的table名
NSString *const BdReportTableNameStartUp = @"BdStartUpsTable";
//NSString *const BdReportTableNameOpenDuration = @"BdOpenDurTabel";


NSString *const BdTableName = @"BDMenuTable";
NSString *const BdTableMenuName = @"BDMenuNameTable";
NSString *const BdTableMenuLabelName = @"BDMenuNameLabelTable";
NSString *const BdTableTypeName = @"BDMenuTypeTable";

NSString *const BdOldTableName = @"BDOldMenuTable";
NSString *const BDOleMenuTimeTable = @"BDOleMenuTimeTable";

NSString *const BdNotificationTableName = @"BdNotificationTableName";
NSString *const BdNotificationConstentName = @"BdNotificationConstentName";
NSString *const BdNotificationKeyName = @"BdNotificationKeyName";

NSString *const BdNotificationHistoryTableName = @"BdNotificationHistoryTableName";
NSString *const BdNotificationHistoryConstentName = @"BdNotificationHistoryConstentName";
NSString *const BdNotificationHistoryKeyName = @"BdNotificationHistoryKeyName";

@interface RMTBdReportBufferManager ()
@property (nonatomic, strong)FMDatabase *dataBase;

@end

@implementation RMTBdReportBufferManager

- (id)initSingle
{
    self = [super init];
    if (self)
    {
        // 创建数据库
        NSString *databasePath = [RMTFileUtils getDatabaseDirectory];
        
        NSString *dataBasePath = [NSString stringWithFormat:@"%@/menu.sqlite", databasePath];
        NSLog(@"(:<   >:) %@", dataBasePath);
        _dataBase = [FMDatabase databaseWithPath:dataBasePath];
        
    }
    return self;
}

- (id)init
{
    return [[self class] sharedInstance];
}

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initSingle];
    });
    return instance;
}


- (void)insertMenuIntoTable:(NSString *)tableName
                   menuName:(NSString *)menuName
             menuMutilpeStr:(NSString *)menuLabel
                   menuType:(NSString *)type
                     result:(void (^)(id result))block
{
    if([_dataBase open])
    {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", tableName, BdReportPrimaryKey,BdTableTypeName, BdTableMenuName, BdTableMenuLabelName];
        if([_dataBase executeUpdate:sqlCreateTable])
        {
            // 创建表成功
            
            NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')", tableName, BdTableTypeName, BdTableMenuName, BdTableMenuLabelName, type, menuName,menuLabel];
            
            
            if(menuName != nil && menuLabel != nil)
            {
                if([_dataBase executeUpdate:sqlInsert])
                {
                    // 插入表格成功
                    block(nil);
                }
                else
                {
                    NSLog(@"insert into bdreport table %@ failed %@", tableName, [_dataBase lastError]);
                    block([_dataBase lastError]);
                }
            }
            else
            {
                block([NSError errorWithDomain:@"nil error" code:-1 userInfo:@{@"userInfo":@"bdreport try to insert nil"}]);
            }
        }
        else
        {
            NSLog(@"创建 %@ failed %@", tableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
}

- (void)queryDBMenuFromTable:(NSString *)tableName
                 menuNameKey:(NSString *)menuNameKey
                menuLabelKey:(NSString *)menuLabelKey
                menuTypeKey:(NSString *)menuTypeKey
                      result:(void (^)(NSArray* seqsArray, NSArray* infoArray, NSArray *reportTypeArray, id result))block
{
    // 必须将sid数组和对应的dictionary数组一期返回
    if([_dataBase open])
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %@", tableName, @(5000)];
        NSMutableArray *seqsArray = [NSMutableArray array];
        NSMutableArray *reportsInfoArray = [NSMutableArray array];
        NSMutableArray *reportTypeArray = [NSMutableArray array];
        FMResultSet *resultSets = [_dataBase executeQuery:sqlQuery];
        
        NSInteger cachedReportNumber = 0;
        while ([resultSets next])
        {
            cachedReportNumber++;
            
            NSString *seqString = [resultSets stringForColumn:menuNameKey];
            NSString *reportInfoDataString = [resultSets stringForColumn:menuLabelKey];
            NSString *typeString = [resultSets stringForColumn:menuTypeKey];
            
            NSString *idNumber = [resultSets stringForColumn:BdReportPrimaryKey];
           NSString *seqStringF8 = [NSString stringWithString:[seqString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
              NSString *reportInfoDataStringF8 = [NSString stringWithString:[reportInfoDataString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
                [dict setObject:idNumber forKey:BdReportPrimaryKey];
                [dict setObject:seqStringF8 forKey:menuNameKey];
                [dict setObject:reportInfoDataStringF8 forKey:menuLabelKey];
                [dict setObject:typeString forKey:menuTypeKey];
                
                [seqsArray addObject:dict];
                [reportsInfoArray addObject:reportInfoDataStringF8];
                
            }
        }
        
        NSLog(@"query bdrepport %ld  %ld", (unsigned long)seqsArray.count, (unsigned long)reportsInfoArray.count);
        
        
        block(seqsArray, reportsInfoArray, reportTypeArray, nil);
        
        
        
        [_dataBase close];
    }
    
}

- (void)deleteMenuFromTable:(NSString *)tableName
                   tableKey:(NSString *)key
                      value:(NSString *)value // 插入table的信息对应的key值
                     result:(void (^)(id result))block// 插入table的seq对应key值
{
    if([_dataBase open])
    {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", tableName, key, value];
        if([_dataBase executeUpdate:sqlDelete])
        {
            // 删除成功
            block(nil);
        }
        else
        {
            NSLog(@"delete from bdreport table %@ single failed %@", tableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
}

- (void)insertOldMenuIntoTable:(NSString *)tableName
                   menuName:(NSString *)menuName
             menuMutilpeStr:(NSString *)menuLabel
                   menuType:(NSString *)type
                          time:(NSString *)time
                     result:(void (^)(id result))block
{
    if([_dataBase open])
    {
        // 以后增加字段
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", tableName, BdReportPrimaryKey,BdTableTypeName, BdTableMenuName, BdTableMenuLabelName ,BDOleMenuTimeTable];
        if([_dataBase executeUpdate:sqlCreateTable])
        {
            // 创建表成功
            
            NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')", tableName, BdTableTypeName, BdTableMenuName, BdTableMenuLabelName,BDOleMenuTimeTable, type, menuName,menuLabel, time];
            
            
            if(menuName != nil && menuLabel != nil)
            {
                if([_dataBase executeUpdate:sqlInsert])
                {
                    // 插入表格成功
                    block(nil);
                }
                else
                {
                    NSLog(@"insert into bdreport table %@ failed %@", tableName, [_dataBase lastError]);
                    block([_dataBase lastError]);
                }
            }
            else
            {
                block([NSError errorWithDomain:@"nil error" code:-1 userInfo:@{@"userInfo":@"bdreport try to insert nil"}]);
            }
        }
        else
        {
            NSLog(@"创建 %@ failed %@", tableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
}

- (void)queryOldDBMenuFromTable:(NSString *)tableName
                 menuNameKey:(NSString *)menuNameKey
                menuLabelKey:(NSString *)menuLabelKey
                 menuTypeKey:(NSString *)menuTypeKey
                      result:(void (^)(NSArray* seqsArray, NSArray* infoArray, NSArray *reportTypeArray, id result))block
{
    // 必须将sid数组和对应的dictionary数组一期返回
    if([_dataBase open])
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %@", tableName, @(5000)];
        NSMutableArray *seqsArray = [NSMutableArray array];
        NSMutableArray *reportsInfoArray = [NSMutableArray array];
        NSMutableArray *reportTypeArray = [NSMutableArray array];
        FMResultSet *resultSets = [_dataBase executeQuery:sqlQuery];
        
        NSInteger cachedReportNumber = 0;
        while ([resultSets next])
        {
            cachedReportNumber++;
            
            NSString *seqString = [resultSets stringForColumn:menuNameKey];
            NSString *reportInfoDataString = [resultSets stringForColumn:menuLabelKey];
            NSString *typeString = [resultSets stringForColumn:menuTypeKey];
            NSString *time = [resultSets stringForColumn:BDOleMenuTimeTable];
            
            NSString *idNumber = [resultSets stringForColumn:BdReportPrimaryKey];
            NSString *seqStringF8 = [NSString stringWithString:[seqString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *reportInfoDataStringF8 = [NSString stringWithString:[reportInfoDataString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
                [dict setObject:idNumber forKey:BdReportPrimaryKey];
                [dict setObject:seqStringF8 forKey:menuNameKey];
                [dict setObject:reportInfoDataStringF8 forKey:menuLabelKey];
                [dict setObject:typeString forKey:menuTypeKey];
                [dict setObject:time forKey:BDOleMenuTimeTable];
                [seqsArray addObject:dict];
                [reportsInfoArray addObject:reportInfoDataStringF8];
                
            }
        }
        
        NSLog(@"query bdrepport %ld  %ld", (unsigned long)seqsArray.count, (unsigned long)reportsInfoArray.count);
        
        
        block(seqsArray, reportsInfoArray, reportTypeArray, nil);
        
        
        
        [_dataBase close];
    }
    
}

- (void)deleteOldMenuFromTable:(NSString *)tableName
                   tableKey:(NSString *)key
                      value:(NSString *)value // 插入table的信息对应的key值
                     result:(void (^)(id result))block// 插入table的seq对应key值
{
    if([_dataBase open])
    {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", tableName, key, value];
        if([_dataBase executeUpdate:sqlDelete])
        {
            // 删除成功
            block(nil);
        }
        else
        {
            NSLog(@"delete from bdreport table %@ single failed %@", tableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
}

// 每个事件都有唯一的seq作为标志
- (void)insertReportIntoTable:(NSString *)tableName
               reportInfoDict:(NSDictionary *)reportInfoDict // 一个事件信息
           reportInfoSequence:(NSString *)reportInfoSeq // 一个事件信息对应的seq编码uuid
         bdReportTableInfoKey:(NSString *)tableInfoKey // table中事件信息对应key
      bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                 bdReportType:(NSString *)reportType
                       result:(void (^)(id result))block;// table中事件seq对应key
{
#pragma mark 超过200*20条，则新的数据挤掉旧的数据
    NSInteger cacheNum = [self numberOfBdReportsOfTable:tableName bdReportTableInfoKey:tableInfoKey result:nil];
    DLog(@"table count %ld",cacheNum);
    
    // 字典转data
    NSError *dataError = nil;
    NSData *reportInfoData = [NSJSONSerialization dataWithJSONObject:reportInfoDict options:NSJSONWritingPrettyPrinted error:&dataError];
    
    if([_dataBase open])
    {
        // 以后增加字段
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' VARCHAR(255), '%@' VARCHAR(255))", tableName, BdReportPrimaryKey, tableInfoSeqKey, tableInfoKey, BdReportReportType];
        if([_dataBase executeUpdate:sqlCreateTable])
        {
            // 创建表成功
            NSString *jsonString = [[NSString alloc] initWithData:reportInfoData encoding:NSUTF8StringEncoding];
            NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')", tableName, tableInfoSeqKey, tableInfoKey, BdReportReportType, reportInfoSeq, jsonString, reportType];
            
//#pragma mark 超过200*20条，则新的数据挤掉旧的数据
//            NSInteger cacheNum = [self numberOfBdReportsOfTable:tableName bdReportTableInfoKey:tableInfoKey result:nil];
//            NSLog(@"上报数量：%d", cacheNum);
//            if(cacheNum > 20 *200)
//            {
//                // 先删掉最顶端的400条再插入
//                [self deleteLastPieceOfReportOfNumber:(cacheNum - 4000 + 400) resultBlock:^(id result) {
//                    if(result != nil)
//                    {
//                        NSLog(@"超过200*20条删除失败: %@", result);
//                    }
//                }];
//            }
            
            if(reportInfoSeq != nil && jsonString != nil && reportType != nil)
            {
                if([_dataBase executeUpdate:sqlInsert])
                {
                    // 插入表格成功
                    block(nil);
                }
                else
                {
                    NSLog(@"insert into bdreport table %@ failed %@", tableName, [_dataBase lastError]);
                    block([_dataBase lastError]);
                }
            }
            else
            {
                block([NSError errorWithDomain:@"nil error" code:-1 userInfo:@{@"userInfo":@"bdreport try to insert nil"}]);
            }
        }
        else
        {
            NSLog(@"创建 %@ failed %@", tableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
    
}

- (void)deleteReportsFromTable:(NSString *)tableName
           reportInfoDictArray:(NSArray *)reportInfoDicts
       reportInfoSequenceArray:(NSArray *)reportInfoSeqs
          bdReportTableInfoKey:(NSString *)tableInfoKey
       bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                        result:(void (^)(id result))block
{
    if([_dataBase open])
    {
        for(int i=0; i<reportInfoSeqs.count; i++)
        {
            NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", tableName, tableInfoSeqKey, reportInfoSeqs[i]];
            if([_dataBase executeUpdate:sqlDelete])
            {
                // 删除成功
                block(nil);
                NSLog(@"上报完的数据，删除成功%@  %@", tableInfoSeqKey, reportInfoSeqs[i]);
            }
            else
            {
                NSLog(@"delete from bdreport table %@ array failed %@", tableName, [_dataBase lastError]);
                block([_dataBase lastError]);
            }
        }
        
        [_dataBase close];
    }
}

- (void)deleteReportFromTable:(NSString *)tableName
               reportInfoDict:(NSDictionary *)reportInfoDict
           reportInfoSequence:(NSString *)reportInfoSeq
         bdReportTableInfoKey:(NSString *)tableInfoKey // 插入table的信息对应的key值
      bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                       result:(void (^)(id result))block// 插入table的seq对应key值
{
    if([_dataBase open])
    {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", tableName, tableInfoSeqKey, reportInfoSeq];
        if([_dataBase executeUpdate:sqlDelete])
        {
            // 删除成功
            block(nil);
        }
        else
        {
            NSLog(@"delete from bdreport table %@ single failed %@", tableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
}



// 取出table前200的信息
- (void)queryReportsFromTable:(NSString *)tableName
                settedReportNumber:(NSInteger )reportedNumber
              bdReportTableInfoKey:(NSString *)tableInfoKey
           bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                            result:(void (^)(NSArray* seqsArray, NSArray* infoArray, NSArray *reportTypeArray, id result))block
{
    // 必须将sid数组和对应的dictionary数组一期返回
    if([_dataBase open])
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %ld", tableName, (long)reportedNumber];
        NSMutableArray *seqsArray = [NSMutableArray array];
        NSMutableArray *reportsInfoArray = [NSMutableArray array];
        NSMutableArray *reportTypeArray = [NSMutableArray array];
        FMResultSet *resultSets = [_dataBase executeQuery:sqlQuery];
        
        NSInteger cachedReportNumber = 0;
        while ([resultSets next])
        {
            cachedReportNumber++;
            
            NSString *seqString = [resultSets stringForColumn:tableInfoSeqKey];
            NSString *reportInfoDataString = [resultSets stringForColumn:tableInfoKey];
            NSString *reportTypeString = [resultSets stringForColumn:BdReportReportType];
            
            // data转成字典
            NSError *dataDictError;
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:[reportInfoDataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&dataDictError];
//            NSLog(@"query**:%@ \n query**: %@",dataDict, dataDictError);
            
            if(seqString != nil &&dataDict != nil && reportTypeString != nil)
            {
                [seqsArray addObject:seqString];
                [reportsInfoArray addObject:dataDict];
                [reportTypeArray addObject:reportTypeString];
            }
        }
        
        NSLog(@"query bdrepport %ld  %ld", (unsigned long)seqsArray.count, (unsigned long)reportsInfoArray.count);
        
        // 上报200的个数限制
        if(cachedReportNumber <= reportedNumber )
        {
            block(seqsArray, reportsInfoArray, reportTypeArray, nil);
        }
        else
        {
            NSMutableArray *subSeqsArray = [NSMutableArray arrayWithArray:[seqsArray subarrayWithRange:NSMakeRange(0, 199)]];
            NSMutableArray *subReportInfoArray = [NSMutableArray arrayWithArray: [reportsInfoArray subarrayWithRange:NSMakeRange(0, 199)]];
            NSMutableArray *subReportTypeArray = [NSMutableArray arrayWithArray:[reportTypeArray subarrayWithRange:NSMakeRange(0, 199)]];
            
            block(subSeqsArray, subReportInfoArray, subReportTypeArray, nil);
        }
        
        [_dataBase close];
    }
}

- (NSInteger)numberOfBdReportsOfTable:(NSString *)tableName
                 bdReportTableInfoKey:(NSString *)tableInfoKey
                               result:(void (^)(id result))block
{
    NSUInteger totalNumber = 0;
    if([_dataBase open])
    {
        NSString *sqlQueryTotalNumber = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
        FMResultSet *resultSet = [_dataBase executeQuery:sqlQueryTotalNumber];
        
        while ([resultSet next])
        {
            NSData *infoData = [resultSet dataForColumn:tableInfoKey];
            if(infoData)
            {
                totalNumber++;
            }
        }
    
        [_dataBase close];
    }
    
    return totalNumber;
}

// 删除最顶端的旧数据
- (void)deleteLastPieceOfReportOfNumber:(NSInteger )number resultBlock:(void (^)(id result))block
{
    if([_dataBase open])
    {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE id IN (SELECT id FROM '%@' ORDER BY '%@' ASC LIMIT '%ld')", BdReportTableNameStartUp, BdReportTableNameStartUp, BdReportPrimaryKey, (long)number];
        if([_dataBase executeUpdate:sqlDelete])
        {
            block(nil);
            NSLog(@"***超过容量限制，删除上报数据成功");
        }
        else
        {
            NSLog(@"上报  删除最顶端的旧数据 失败：%@", [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
    
}

// 检测table是否存在
- (BOOL)isTableOK:(FMDatabase *)db tableName:(NSString *) tableName
{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)insertNotificaitonIntoTableForConstent:(NSString *)constent
                                           key:(NSString *)key
                                        result:(void (^)(id))block
{
    if([_dataBase open])
    {
          NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT)", BdNotificationTableName, BdReportPrimaryKey,BdNotificationKeyName, BdNotificationConstentName];
        if([_dataBase executeUpdate:sqlCreateTable])
        {
            // 创建表成功
            
            NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@') VALUES ('%@','%@')", BdNotificationTableName,BdNotificationKeyName, BdNotificationConstentName ,key,constent];
            
            
            if(constent != nil)
            {
                if([_dataBase executeUpdate:sqlInsert])
                {
                    // 插入表格成功
                    block(nil);
                }
                else
                {
                    NSLog(@"insert into bdreport table %@ failed %@", BdNotificationTableName, [_dataBase lastError]);
                    block([_dataBase lastError]);
                }
            }
            else
            {
                block([NSError errorWithDomain:@"nil error" code:-1 userInfo:@{@"userInfo":@"bdreport try to insert nil"}]);
            }
        }
        else
        {
            NSLog(@"创建 %@ failed %@", BdNotificationTableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
    
}

- (void)queryNotificaitonConstentCallBackResult:(void (^)(NSArray* seqsArray,id result))block
{
    if([_dataBase open])
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %@", BdNotificationTableName, @(5000)];
        NSMutableArray *seqsArray = [NSMutableArray array];
        
        FMResultSet *resultSets = [_dataBase executeQuery:sqlQuery];
        
        NSInteger cachedReportNumber = 0;
        while ([resultSets next])
        {
            cachedReportNumber++;
            
            NSString *seqString = [resultSets stringForColumn:BdNotificationConstentName];
           NSString *key = [resultSets stringForColumn:BdNotificationKeyName];
            
            NSString *idNumber = [resultSets stringForColumn:BdReportPrimaryKey];
            NSString *seqStringF8 = [NSString stringWithString:[seqString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
           NSString *keyF8 = [NSString stringWithString:[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
                [dict setObject:idNumber forKey:BdReportPrimaryKey];
                [dict setObject:seqStringF8 forKey:BdNotificationConstentName];
                [dict setObject:keyF8 forKey:BdNotificationKeyName];
                [seqsArray addObject:dict];
            }
        }
        
        NSLog(@"query bdrepport %ld", (unsigned long)seqsArray.count);
        
        
        block(seqsArray, nil);
        
        
        
        [_dataBase close];
    }
    
}

- (void)deleteNotificaitonIntoFromTableKey:(NSString *)key value:(NSString *)value result:(void (^)(id))block
{
    
    if([_dataBase open])
    {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", BdNotificationTableName, key, value];
        if([_dataBase executeUpdate:sqlDelete])
        {
            // 删除成功
            block(nil);
        }
        else
        {
            NSLog(@"delete from bdreport table %@ single failed %@", BdNotificationTableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
}

- (void)insertHistoryNotificaitonIntoTableForConstent:(NSString *)constent
                                                  key:(NSString *)key
                                        result:(void (^)(id))block
{
    if([_dataBase open])
    {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT)", BdNotificationHistoryTableName, BdReportPrimaryKey, BdNotificationHistoryKeyName,BdNotificationHistoryConstentName];
        if([_dataBase executeUpdate:sqlCreateTable])
        {
            // 创建表成功
            
            NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@') VALUES ('%@','%@')", BdNotificationHistoryTableName, BdNotificationHistoryKeyName,BdNotificationHistoryConstentName,key, constent];
            
            
            if(constent != nil)
            {
                if([_dataBase executeUpdate:sqlInsert])
                {
                    // 插入表格成功
                    block(nil);
                }
                else
                {
                    NSLog(@"insert into bdreport table %@ failed %@", BdNotificationTableName, [_dataBase lastError]);
                    block([_dataBase lastError]);
                }
            }
            else
            {
                block([NSError errorWithDomain:@"nil error" code:-1 userInfo:@{@"userInfo":@"bdreport try to insert nil"}]);
            }
        }
        else
        {
            NSLog(@"创建 %@ failed %@", BdNotificationTableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
    
}

- (void)queryHistoryNotificaitonConstentCallBackResult:(void (^)(NSArray* seqsArray,id result))block
{
    if([_dataBase open])
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %@", BdNotificationHistoryTableName, @(5000)];
        NSMutableArray *seqsArray = [NSMutableArray array];
        
        FMResultSet *resultSets = [_dataBase executeQuery:sqlQuery];
        
        NSInteger cachedReportNumber = 0;
        while ([resultSets next])
        {
            cachedReportNumber++;
            
            NSString *seqStringKey = [resultSets stringForColumn:BdNotificationHistoryKeyName];
            NSString *seqString = [resultSets stringForColumn:BdNotificationHistoryConstentName];

            
            NSString *idNumber = [resultSets stringForColumn:BdReportPrimaryKey];
            
            NSString *seqStringF8 = [NSString stringWithString:[seqString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *seqStringF8key = [NSString stringWithString:[seqStringKey stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
                [dict setObject:idNumber forKey:BdReportPrimaryKey];
                [dict setObject:seqStringF8 forKey:BdNotificationHistoryConstentName];
                [dict setObject:seqStringF8key forKey:BdNotificationHistoryKeyName];
                [seqsArray addObject:dict];
            }
        }
        
        NSLog(@"query bdrepport %ld", (unsigned long)seqsArray.count);
        
        
        block(seqsArray, nil);
        
        
        
        [_dataBase close];
    }
    
}

- (void)deleteHistoryNotificaitonIntoFromTableKey:(NSString *)key value:(NSString *)value result:(void (^)(id))block
{
    
    if([_dataBase open])
    {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", BdNotificationHistoryTableName, key, value];
        if([_dataBase executeUpdate:sqlDelete])
        {
            // 删除成功
            block(nil);
        }
        else
        {
            NSLog(@"delete from bdreport table %@ single failed %@", BdNotificationHistoryTableName, [_dataBase lastError]);
            block([_dataBase lastError]);
        }
        
        [_dataBase close];
    }
}

@end
