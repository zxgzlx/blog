### REST学习和理解

> REST -- REpresentational State Transfer 表现层状态转移。

其实就是：URL定位资源，用HTTP动词（GET,POST,DELETE,DETC）描述操作。

资源在网络中以某种表现形式进行状态转移。分解开来：
Resource：资源，即数据（前面说过网络的核心）。比如 newsfeed，friends等；Representational：某种表现形式，比如用JSON，XML，JPEG等；
State Transfer：状态变化。通过HTTP动词实现。

更通俗易懂的就是：
* 看Url就知道要什么
* 看http method就知道干什么
* 看http status code就知道结果如何

1. REST描述的是在网络中client和server的一种交互形式；REST本身不实用，实用的是如何设计 RESTful API（REST风格的网络接口）；

2. Server提供的RESTful API中，URL中只使用名词来指定资源，原则上不使用动词。“资源”是REST架构或者说整个网络处理的核心。比如：http://api.qc.com/v1/newsfeed: 获取某人的新鲜; http://api.qc.com/v1/friends: 获取某人的好友列表;http://api.qc.com/v1/profile: 获取某人的详细信息;

3. 用HTTP协议里的动词来实现资源的添加，修改，删除等操作。

   即通过HTTP动词来实现资源的状态扭转：

   GET    用来获取资源，

   POST  用来新建资源（也可以用于更新资源），

   PUT    用来更新资源，DELETE  用来删除资源。

   比如：DELETE http://api.qc.com/v1/friends: 删除某人的好友 （在http parameter指定好友id）

   POST http://api.qc.com/v1/friends: 添加好友

   UPDATE http://api.qc.com/v1/profile: 更新个人资料

4. Server和Client之间传递某资源的一个表现形式，比如用JSON，XML传输文本，或者用JPG，WebP传输图片等。当然还可以压缩HTTP传输时的数据（on-wire data compression）。

5. 用 HTTP Status Code传递Server的状态信息。比如最常用的 200 表示成功，500 表示Server内部错误等。

#### REST协议和SOAP区别
1. rest协议是面向资源的假如要管理一些用户，那么将用户看作是一种资源：
get /users/{userId}  获取userId对应的user信息
post /users 创建一个新的userput /users/{userId} 更改userId对应的user信息
delete /users/{userId} 删除
userId对应的user。
2. soap是面向服务的还是管理用户，将对用户的操作看成服务：
post /users/getUser
post /users/creatUser
post /users/updateUser
post /users/deleteUser
这两个例子就是，REST使用了HTTP中提供的methods且资源名是名词，而SOAP基本乱用post且api使用了动词
#### HATEOAS
> Hypermedia As The Engine Of Application State
> 超媒体即是应用状态引擎
> 其原则就是客户端与服务器的交互完全由超媒体动态提供，客户端无需事先了解如何与数据或者服务器交互。
> 看不懂，哈哈哈，反正是RESTful的约束条件之一
例如：RESTful api资源 
> www.xiaodai.com/people/niudai
假如说, 这个URL对应的资源是我账号的基本信息, 比如头像图片url, 关注者人数, 等,"/people"可以理解为在"/people"文件夹下, 而"/niudai"是我的用户名, 表示这个文件夹里有和我相关的资源.
/niudai下面还有一些api：
> www.xiaodai.com/people/niudai/followers (关注我的人的信息)
> www.xiaodai.com/people/niudai/activities (我的近期动态)
> www.xiaodai.com/people/niudai/anwsers (我的所有回答)
看起来很正常的 url, 的确是用 url 去 "定位" 资源, 但是这样的后端 API, 无法进行向我们刚才在命令行的文件系统中实现的那种 "导航", 就是如果我手里没有后端 API 文档, 我无法从 "http://www.xiaodai.com/people/niudai" 中得知在这个资源下还有那些相关资源, 这就给前端对后端 API 的调用带来了麻烦.

于是, 我们规定所有后端 API 返回的数据, json 也好, xml 也好, 不仅要包含当前资源数据, 还要包含和这个资源相关的其他资源的 url, 比如, 假设

> “www.xiaodai.com/people/niudai"
原先返回这样的数据:
```json
{
    "id": "b50644ff6e611664f9518847da1d2e05",
    "url_token": "niu-dai-68-44",
    "name": "牛岱",
    "use_default_avatar": false,
    "url": "牛岱",
    "user_type": "people",
    "headline": "我只是一株稻草。",
    "gender": 1,
    "is_advertiser": false,
}
```

好, 标准的 json 数据, 包含了我的用户名, token, 个性签名, 性别等信息.
那么在此基础之上, 我们给它加上 HATEOAS 标准, 返回的数据就应该是这样:
```json
{
    "id": "b50644ff6e611664f9518847da1d2e05",
    "url_token": "niu-dai-68-44",
    "name": "牛岱",
    "use_default_avatar": false,
    "url": "牛岱",
    "user_type": "people",
    "headline": "我只是一株稻草。",
    "gender": 1,
    "is_advertiser": false,
    "follwers": "www.xiaodai.com/people/niudai/followers",
    "activities": "www.xiaodai.com/people/niudai/activities",
    "anwsers": "www.xiaodai.com/people/niudai/anwsers"
}
```
这样的话, 即便我只知道最开始的那个 url, 我也能根据 url 返回给我的数据进行后端 API 的导航.
满足了我上面说的这些, 就是完整的现代化 RestfulAPI, 下面就我的工程经验解释一下 Restful 的优势:

我认为 RestfulAPI 最大的优势在于极大程度简化前端对后端的 API 调用, 并且在 HATEOAS 的建议基础上进一步降低了前端对后端 API 具体 url 的依赖性.

举个例子, 假如满足 restful, 那么就最开始的例子, 无论是执行 post 操作, 还是 delete 操作, 对于统一个资源, url 不变, 所以前端就更容易写和后端的交互层, 比如:

ResourceUrl = 'myurl';
http.post<any>(ResourceUrl, { options: 'delete' });
http.delete<any>(ResourceUrl, { options: 'post' });
http.get<any>(ResourceUrl, { options: 'post' });
简化了前端代码, 再次基础上, HATEOAS 又让前端可以从 API Gateway 进行导航得到想要的具体资源 url, 而不是直接那样 hardcoded, 就是把 url 硬写出来, 比如:

还是刚才的例子, 我们要访问我的 followers, 没有 HATEOAS, 结果就是我必须在前端代码里明确写出来这个 url:
> http.post<any>('www.xiaodai.com/people/niudai/followers', { options: 'delete' });
但是有了 HATEOAS, 我可以先对 "www.xiaodai.com/people/niudai" 进行请求, 把结果存在一个 object 里, 比如名字是 response, 然后直接这样:

> http.post<any>(response.followers, { options: 'delete' });
因为 response 的 followers 属性本来就是 "www.xiaodai.com/people/niudai/followers", 所以结果是一样的, 但是减少了 hardcoded 部分, 当后端的一些 API 的具体 url 路径更改时, 前端可以避免代码的更改!
这就降低了前端对后端 API 的依赖性, 降低了前端和后端的耦合度, 让前端和后端协作更加容易, 方便后端对前端进行一个 API 兼容.

那么事实上 RESTFul API 也有缺点, 基本上就一个：

基于网络的数据传输量变得更大.

### 总结：

1. 了解HTTP api相关设计逻辑和思想，尽量在业务框架上面和标准保持一致。
2. 了解HTTP method的使用方法，之前只用到get、post，之前做细胞危机的时候用到过put，没仔细了解过。
3. 更好的增强前端和服务器直接的api的调用和协作，更好的解耦对服务器api变动的依赖。