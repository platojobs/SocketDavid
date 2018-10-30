//
//  DBSoket_DavManager.m
//  DBSoketDavid
//
//  Created by 崔曦 on 2018/10/26.
//  Copyright © 2018 崔曦. All rights reserved.
//

#import "DBSoket_DavManager.h"
#import "SRWebSocket.h"

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

static  NSString * Khost = @"127.0.0.1";
static const uint16_t Kport = 8080;

@interface DBSoket_DavManager()<SRWebSocketDelegate>

{
    SRWebSocket * webSocket;
    NSTimeInterval reConnecTime;
}

@property(nonatomic,strong)NSTimer*heartBeat;

@end

@implementation DBSoket_DavManager
+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static DBSoket_DavManager * instance=nil;
    dispatch_once(&onceToken,^{
        instance=[[self alloc]init];
        [instance initSocket];
    });
    return instance;
}
-(void)initSocket
{
    if (webSocket) {
        return;
    }
   // webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%d", Khost, Kport]]];//原来的
    webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:@"http://192.168.1.93/ico-funding-web/priceSocket"]];
    webSocket.delegate=self;
    //  设置代理线程queue
    NSOperationQueue * queue=[[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount=1;
    [webSocket setDelegateOperationQueue:queue];
    
    //  连接
    [webSocket open];
}
//   初始化心跳
-(void)initHearBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        
        __weak typeof (self) weakSelf=self;
        //心跳设置为3分钟，NAT超时一般为5分钟
       self.heartBeat=[NSTimer scheduledTimerWithTimeInterval:3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"heart");
            //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
            [weakSelf sendMsg:@"heart"];
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
    })
}
//   取消心跳
-(void)destoryHeartBeat
{
    __weak typeof (self) weakSelf=self;
    dispatch_main_async_safe(^{
        if (weakSelf.heartBeat) {
            [weakSelf.heartBeat invalidate];
           weakSelf.heartBeat=nil;
        }
    })
}
//   建立连接
-(void)connect
{
    [self initSocket];
}
//   断开连接
-(void)disConnect
{
    if (webSocket) {
        [webSocket close];
        webSocket=nil;
    }
}
//   发送消息
-(void)sendMsg:(NSString *)msg
{
    [webSocket send:msg];
}
//  重连机制
-(void)reConnect
{
    [self disConnect];
    
    //  超过一分钟就不再重连   之后重连5次  2^5=64
    if (reConnecTime>64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnecTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webSocket=nil;
        [self initSocket];
    });
    
    //   重连时间2的指数级增长
    if (reConnecTime == 0) {
        reConnecTime =2;
    }else{
        reConnecTime *=2;
    }
}
// pingpong
-(void)ping{
    [webSocket sendPing:nil];
}
#pragma mark - SRWebScokerDelegate
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    self.data=message;
    if (self.dataFromSeverReponse) {
        self.dataFromSeverReponse(message);
    }
   // NSLog(@"服务器返回的信息:%@",message);
}
-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"连接成功");
    //   连接成功 开始发送心跳
    [self initHearBeat];
}
//  open失败时调用
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败。。。。。%@",error);
    //  失败了去重连
    [self reConnect];
}
//  网络连接中断被调用
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
    NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    
    //如果是被用户自己中断的那么直接断开连接，否则开始重连
    if (code == disConnectByUser) {
        [self disConnect];
    }else{
        
        [self reConnect];
    }
    //断开连接时销毁心跳
    [self destoryHeartBeat];
}
//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"收到pong回调");
    
}

-(NSData*)data{
    if (!_data) {
        _data=[[NSData alloc]init];
    }
    return _data;
}


@end
