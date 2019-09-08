### websocket简单介绍

#### http

>  半双工通信, 客户端/服务器模式中请求-响应所用的协议，在这种模式中，浏览器向服务器提交HTTP请求，服务器响应请求的资源.
>
> HTTP 是个懒惰的协议，server 只有收到请求才会做出回应

半双工通信的特点：

- **同一时刻**数据是**单向流动**的，客户端向服务端请求数据->单向，服务端向客户端返回数据->单向
- 服务器不能主动的推送数据给客户端

短轮询（Polling）

![img](https://pic1.zhimg.com/80/v2-5b71d794906f9db7c27b36cf11ede05c_hd.jpg)

client 每隔一段时间都会向 server 发送 http 请求，服务器收到请求后，将最新的数据发回给 client。一开始必须通过提交表单的形式，这样的后果就是传输很多冗余的数据，浪费了带宽。

在某个时间段 server 没有更新数据，但 client 仍然每隔一段时间发送请求来询问，所以这段时间内的询问都是无效的，这样浪费了网络带宽。将发送请求的间隔时间加大会缓解这种浪费，但如果 server 更新数据很快时，这样又不能满足数据的实时性。

长轮询（Long-polling)

![img](https://pic4.zhimg.com/80/v2-101193ed11bd882d59e9429dd8882cf3_hd.jpg)

client 向 server 发出请求，server 接收到请求后，server 并不一定立即发送回应给 client，而是看数据是否更新，如果数据已经更新了的话，那就立即将数据返回给 client；但如果数据没有更新，那就把这个请求保持住，等待有新的数据到来时，才将数据返回给 client。

如果 server 的数据长时间没有更新，一段时间后，请求便会超时，client 收到超时信息后，再立即发送一个新的请求给 server。

在长轮询机制下，client 向 server 发送了请求后，server会等数据更新完才会将数据返回，而不是像（短）轮询一样不管数据有没有更新然后立即返回。

弊端。当 server 向 client 发送数据后，必须等待下一次请求才能将新的数据发送出去，这样 client 接收到新数据的间隔最短时间便是 2 * RTT（往返时间），这样便无法应对 server 端数据更新频率较快的情况。

流技术（Http Streaming）：

流技术基于 Iframe。Iframe 是 HTML 标记，这个标记的 src 属性会保持对指定 server 的长连接请求，server 就可以不断地向 client 返回数据。

![img](https://pic2.zhimg.com/80/v2-b0bc3974bd8b04c67d460d55d6945145_hd.jpg)

流技术与长轮询的区别是长轮询本质上还是一种轮询方式，只不过连接的时间有所增加，想要向 server 获取新的数据，client 只能一遍遍的发送请求；而流技术是一直保持连接，不需要 client 请求，当数据发生改变时，server 自动的将数据发送给 client。

client 与 server 建立连接之后，便不会断开。当数据发生变化，server 便将数据发送给 client。

缺点：网页会一直显示未加载完成的状态。

#### 双工通信

在H5的websocket出现之前，为了实现这种**推送技术**，大家最常用的实现方式有这三种：**轮询**、**长轮询**和**iframe流**。

#### websocket

> 在客户端和服务端上建立了一个**长久的连接**, 属于**应用层**的协议，它**基于TCP**传输协议，并**复用HTTP**的握手通道
>
> WebSocket 是一种长连接的模式。一旦 WebSocket 连接建立后，除非 client 或者 server 中有一端主动断开连接，否则每次数据传输之前都不需要 HTTP 那样请求数据。client 第一次需要与 server 建立连接，当 server 确认连接之后，两者便一直处于连接状态。直到一方断开连接，WebSocket 连接才断开。

![img](https://pic4.zhimg.com/80/v2-361334a3f98fb379672d837d894c19fb_hd.png)

websocket优点：

1. 支持双向通信，实时性更强(你可以来做个QQ，微信了，老铁)
2. 更好的二进制支持
3. 较少的控制开销(连接创建后，ws客户端、服务端进行数据交换时，协议控制的数据包头部较少)

```js
// 前端

// 创建一个index.html文件
// 下面直接写WebSocket

// 只需要new一下就可以创建一个websocket的实例
// 我们要去连接ws协议
// 这里对应的端口就是服务端设置的端口号9999
let ws = new WebSocket('ws://localhost:9999');

// onopen是客户端与服务端建立连接后触发
ws.onopen = function() {
    ws.send('哎呦，不错哦');
};

// onmessage是当服务端给客户端发来消息的时候触发
ws.onmessage = function(res) {
    console.log(res);   // 打印的是MessageEvent对象
    // 真正的消息数据是 res.data
    console.log(res.data);
};

// 后台
const express = require('express');
const app = express();
// 设置静态文件夹
app.use(express.static(__dirname));
// 监听3000端口
app.listen(3000);
// =============================================
// 开始创建一个websocket服务
const Server = require('ws').Server;
// 这里是设置服务器的端口号，和上面的3000端口不用一致
const ws = new Server({ port: 9999 });

// 监听服务端和客户端的连接情况
ws.on('connection', function(socket) {
    // 监听客户端发来的消息
    socket.on('message', function(msg) {
        console.log(msg);   // 这个就是客户端发来的消息
        // 来而不往非礼也，服务端也可以发消息给客户端
        socket.send(`这里是服务端对你说的话： ${msg}`);
    });
});
```

websocket缺点：有些老版本不兼容

*报文层面谈一下 WebSocket 与 HTTP 的差异*

![img](https://pic4.zhimg.com/80/v2-9063570c22d3e12a821ab8c07834f18f_hd.png)

首先，client 发起 WebSocket 连接，报文类似于 HTTP，但主要有几点不一样的地方：

- "Upgrade: websocket"： 表明这是一个 WebSocket 类型请求，意在告诉 server 需要将通信协议切换到 WebSocket
- "Sec-WebSocket-Key: ***": 是 client 发送的一个 base64 编码的密文，要求 server 必须返回一个对应加密的 "Sec-WebSocket-Accept" 应答，否则 client 会抛出 "Error during WebSocket handshake" 错误，并关闭连接

server 收到报文后，如果支持 WebSocket 协议，那么就会将自己的通信协议切换到 WebSocket，返回以下信息：

- "HTTP/1.1 101 WebSocket Protocol Handshake"：返回的状态码为 101，表示同意 client 的协议转换请求
- "Upgrade: websocket"
- "Connection: Upgrade"
- "Sec-WebSocket-Accept: ***"
- ...

以上都是利用 HTTP 协议完成的。这样，经过“请求-相应”的过程， server 与 client 的 WebSocket 连接握手成功，后续便可以进行 TCP 通讯了，也就没有 HTTP 什么事了。

这里可以看出websocket先进行Http请求模式，连接成功后就是TCP通讯模式。在这里测试中发现游戏登录时候用fiddler进行抓包时，在使用fiddler代理http弱网情况下，发现登录是符合预期的，但是在游戏中使用fiddler代理http弱网情况下，游戏是正常进行的，这就说明了游戏中和http就没什么关系了，而登录就和http有关系，所以游戏中使用的TCP在fiddler弱网下没什么影响，而登录就受此影响。

#### socket.io

> 全双工通信
>
> [Socket.IO](https://link.zhihu.com/?target=http%3A//socket.io/) 是一个封装了 Websocket、基于 Node 的 JavaScript 框架，包含 client 的 JavaScript 和 server 的 Node。其屏蔽了所有底层细节，让顶层调用非常简单。
>
> 另外，[Socket.IO](https://link.zhihu.com/?target=http%3A//socket.io/) 还有一个非常重要的好处。其不仅支持 WebSocket，还支持许多种轮询机制以及其他实时通信方式，并封装了通用的接口。这些方式包含 Adobe Flash Socket、Ajax 长轮询、Ajax multipart streaming 、持久 Iframe、JSONP 轮询等。换句话说，当 [Socket.IO](https://link.zhihu.com/?target=http%3A//socket.io/) 检测到当前环境不支持 WebSocket 时，能够自动地选择最佳的方式来实现网络的实时通信。

- 易用性：封装了服务端和客户端，使用简单方便
- 跨平台：支持跨平台，可以选择在服务端或是客户端开发实时应用
- 自适应：会根据浏览器来自己决定是使用WebSocket、Ajax长轮询还是Iframe流等方式去选择最优方式，甚至支持IE5.5

```js
// 前端
// index.html文件
...省略
// 引用socket.io的js文件
<script src="/socket.io/socket.io.js"></script>
<script>
    const socket = io('/');
    // 监听与服务器连接成功的事件
    socket.on('connect', () => {
        console.log('连接成功');
        socket.send('周杰伦');
    });
    // 监听服务端发来的消息
    socket.on('message', msg => {
        // 这个msg就是传过来的真消息了，不用再msg.data取值了
        console.log(`客户端接收到的消息： ${msg}`);  
    });
    // 监听与服务器连接断开事件
    socket.on('disconnect', () => {
        console.log('连接断开成功');
    });
</script>


// 后台
// server.js文件
const express = require('express');
const app = express();
// 设置静态文件夹
app.use(express.static(__dirname));
// 通过node的http模块来创建一个server服务
const server = require('http').createServer(app);
// WebSocket是依赖HTTP协议进行握手的
const io = require('socket.io')(server);
// 监听客户端与服务端的连接
io.on('connection', function(socket) {
    // send方法来给客户端发消息
    socket.send('青花瓷');
    // 监听客户端的消息是否接收成功
    socket.on('message', function(msg) {
        console.log(msg);  // 客户端发来的消息
        socket.send('天青色等烟雨，而我在等你' );
    });
});
// 监听3000端口
server.listen(3000);

```

Tips：io创建socket的时候可以接收一个**url**参数

- url可以是socket服务完整的http地址，如：**io('http://localhost:3000')**
- 也可以是相对路径，如：**io('/')**
- 不填的话就表示默认连接当前路径，如：**io()**

#### 总结：

1、了解了http、websocket、socket.io三者的不同，已经优缺点

2、在工作用经常和服务器通信要使用到的技术

3、在弱网等情况下经常需要对它进行处理。

4、很好的解释了测试用fiddler抓包遇到的问题，所以测试弱网时，既要测http下的，也要测tcp下的。