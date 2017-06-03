//
//  RMTBdReportBufferManager.h
//  RemoteControl
//
//  Created by runmit_HLC on 15/10/20.
//  Copyright © 2015年 runmit.com. All rights reserved.
//
/*
 1. 一次生命周期，插入一个启动事件
 2. 上报成功，批量删除启动事件数组
 3. [[NSUUID UUID] UUIDString]; seq 的uuid生成
 */

#import <Foundation/Foundation.h>

// 上报事件类型
#define BDReportTypeStartUps @"StartUps"
#define BDReportTypeOpenDurs @"OpenDurs"


typedef enum{
    RMTBdReportTypeStartUp,
    RMTBdReportTypeOpenDuration
}RMTBdReportType;

// 定义好的table中key值
extern NSString *const BdReportPrimaryKey;

extern NSString *const BdReportInfoKey;
extern NSString *const BdReportInfoSeqKey;

//extern NSString *const BdReportOpenDurationInfoSeqKey;
//extern NSString *const BdReportOpenDurationInfoKey;

// 定义好的table名
extern NSString *const BdReportTableNameStartUp;
//extern NSString *const BdReportTableNameOpenDuration;

extern NSString *const BdTableName;

extern NSString *const BdTableMenuLabelName;
extern NSString *const BdTableMenuName;
extern NSString *const BdTableTypeName;

@interface RMTBdReportBufferManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  插入数据
 */
- (void)insertReportIntoTable:(NSString *)tableName
               reportInfoDict:(NSDictionary *)reportInfoDict // 一个事件信息
           reportInfoSequence:(NSString *)reportInfoSeq // 一个事件信息对应的seq编码uuid
         bdReportTableInfoKey:(NSString *)tableInfoKey // table中事件信息对应key
      bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                 bdReportType:(NSString *)reportType
                       result:(void (^)(id result))block;// table中事件seq对应key

// 批量删
- (void)deleteReportsFromTable:(NSString *)tableName
           reportInfoDictArray:(NSArray *)reportInfoDicts
       reportInfoSequenceArray:(NSArray *)reportInfoSeqs
          bdReportTableInfoKey:(NSString *)tableInfoKey
       bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                        result:(void (^)(id result))block;

// 单个删
- (void)deleteReportFromTable:(NSString *)tableName
               reportInfoDict:(NSDictionary *)reportInfoDict
           reportInfoSequence:(NSString *)reportInfoSeq
         bdReportTableInfoKey:(NSString *)tableInfoKey // 插入table的信息对应的key值
      bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                       result:(void (^)(id result))block; // 插入table的seq对应key值

// 查询前200个
- (void)queryReportsFromTable:(NSString *)tableName
                settedReportNumber:(NSInteger )reportedNumber
              bdReportTableInfoKey:(NSString *)tableInfoKey
           bdReportTableInfoSeqKey:(NSString *)tableInfoSeqKey
                            result:(void (^)(NSArray* seqsArray, NSArray* infoArray, NSArray *reportTypeArray, id result))block;

// 获取存储的记录总数
- (NSInteger)numberOfBdReportsOfTable:(NSString *)tableName
                 bdReportTableInfoKey:(NSString *)tableInfoKey
                               result:(void (^)(id result))block;


- (void)insertMenuIntoTable:(NSString *)tableName
                   menuName:(NSString *)menuName
             menuMutilpeStr:(NSString *)menuLabel
                   menuType:(NSString *)type
                     result:(void (^)(id result))block;

- (void)queryDBMenuFromTable:(NSString *)tableName
                 menuNameKey:(NSString *)menuNameKey
                menuLabelKey:(NSString *)menuLabelKey
                 menuTypeKey:(NSString *)menuTypeKey
                      result:(void (^)(NSArray* seqsArray, NSArray* infoArray, NSArray *reportTypeArray, id result))block;
- (void)deleteMenuFromTable:(NSString *)tableName
                   tableKey:(NSString *)key
                      value:(NSString *)value // 插入table的信息对应的key值
                     result:(void (^)(id result))block;
@end
