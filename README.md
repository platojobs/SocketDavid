# SocketDavid


***[WebSocket](https://github.com/facebook/SocketRocket)***

### [WebSocket](https://github.com/facebook/SocketRocket) 是 HTML5 一种新的协议。它实现了浏览器与服务器全双工通信，能更好的节省服务器资源和带宽并达到实时通讯，它建立在 TCP 之上，同 HTTP 一样通过 TCP 来传输数据，但是它和 HTTP 最大不同是：WebSocket 是一种双向通信协议.

由于项目需要创建一个聊天室,需要通过长链接,和后台保持通讯,进行聊天,并且实时进行热点消息的推送.

目前Facebook的SocketRocket应该是目前最好的关于SocketRocket使用的框架了.而且简单易用.

使用

一般一个项目在启动后的某个时机会启动创建一个长链接,如果需要多个就多次创建.如果只要一个就可以封装为一个单例,全局使用.

可以使用podpod管理库, 在podfile中加入
```
pod 'SocketRocket'
```
在使用命令行工具cd到当前工程 安装
```
pod install
```
导入头文件后即可使用.
----------------------
## 本项目是对SocketRocket应用的一个简单封装

>>>socket的应用
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
