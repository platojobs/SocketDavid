# SocketDavid
socket的应用
***基于scoketrocket的一个实际应用
DBSoket_DavManager类，处理长链接
```
//回调接收的服务器的内容
@property (nonatomic,copy)void(^dataFromSeverReponse)(id data);

@property(nonatomic,strong)NSData*data;

+ (instancetype)shareManager;

/*连接  */
- (void)connect;
/*断开连接*/
- (void)disConnect;
/*发送消息*/
- (void)sendMsg:(NSString *)msg;
// Send Data (can be nil) in a ping message.

- (void)ping;


```
