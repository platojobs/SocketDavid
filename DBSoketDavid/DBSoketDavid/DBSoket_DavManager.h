//
//  DBSoket_DavManager.h
//  DBSoketDavid
//
//  Created by 崔曦 on 2018/10/26.
//  Copyright © 2018 崔曦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    disConnectByUser ,
    disConnectByServer,
} DDisConnectType;

@interface DBSoket_DavManager : NSObject

@property (nonatomic,copy)void(^dataFromSeverReponse)(id data);

@property(nonatomic,strong)NSData*data;

+ (instancetype)shareManager;

- (void)connect;
- (void)disConnect;

- (void)sendMsg:(NSString *)msg;

- (void)ping;


@end


