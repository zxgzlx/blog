### XMLHttpRequest 和 Fetch 

> 这是两个网络相关的js请求
>
> 使用 XMLHttpRequest（XHR）对象可以与服务器交互。您可以从URL获取数据，而无需让整个的页面刷新。这允许网页在不影响用户的操作的情况下更新页面的局部内容。在 AJAX 编程中，XMLHttpRequest 被大量使用。
>
> XMLHttpRequest 可以用于获取任何类型的数据，而不仅仅是XML，它甚至支持 HTTP 以外的协议（包括 file:// 和 FTP）
>
> Fetch API 提供了一个 JavaScript接口，用于访问和操纵HTTP管道的部分，例如请求和响应。它还提供了一个全局 fetch()方法，该方法提供了一种简单，合理的方式来跨网络异步获取资源。
>
> 这种功能以前是使用  XMLHttpRequest实现的。Fetch提供了一个更好的替代方法，可以很容易地被其他技术使用，例如 Service Workers。Fetch还提供了单个逻辑位置来定义其他HTTP相关概念，例如CORS和HTTP的扩展。

#### XMLHttpRequest

> 在目前的项目中使用的就是此种请求方式

```js
url = 'https://www.baidu.com/';
xhr = new XMLHttpRequest();
xhr.open('GET',  url,  true);
xhr.send();
xhr.onreadystatechange = function(){ // 当 readyState 的值改变的时候，callback 函数会被调用。
  if(xhr.readyState == 4){
    if(xhr.status == 200){
      success(xhr.responseText);
    } else {
      if(failed){
         failed(xhr.status);
      }
    }
  }
}
```

**readyState 值	状态	描述**
0	UNSENT	代理被创建，但尚未调用 open() 方法。
1	OPENED	open() 方法已经被调用。
2	HEADERS_RECEIVED	send() 方法已经被调用，并且头部和状态已经可获得。
3	LOADING	下载中； responseText 属性已经包含部分数据。
4	DONE	下载操作已完成。

**XHR 的事件监听**
progress 处理中
abort 取消，XHR.abort() 函数调用时触发该事件
error 错误
load 完成加载
timeout 事件超时

####  fetch

* 当接收到一个代表错误的 HTTP 状态码(404 或 500)时，从 fetch()返回的 Promise 不会被标记为 reject，相反标记了 resolve（但ok 属性设置为 false）。仅当网络故障时或请求被阻止时，才会标记为 reject。
* 默认情况下，fetch 不会从服务端发送或接收任何 cookies, 若要发送 cookies，必须设置 credentials 属性。

```js
fetch(url, {
  method: 'POST', // or 'PUT'
  body: JSON.stringify(data), // data can be `string` or {object}!
  mode:'cors' // 跨域问题解决，但是要保证后端支持
  headers:{
    'Content-Type': 'application/json'
  }
}).then(res => res.json())
.catch(error => console.error('Error:', error))
```

cors是"Cross-Origin Resource Sharing"的简称，是实现跨域的一种方式，相对于其他跨域方式，比较灵活，而且不限制发请求使用的method

所以前端实现要按照上面的mode参数，有'cors'和'no-cors'两个参数

后端代码配置

```js
// header中配置
"Access-Control-Allow-Origin":"*"
```

跨域问题在web中经常出现，当前项目中遇到了不少跨域问题，比如活动的图片无法获取资源服的图片，就是因为跨域问题，需要资源服解决。

#### Fetch 与 XMLHttpRequest 的区别

> XHR 基于事件机制实现请求成功与失败的回调，不符合关注分离（Separation of Concerns）的原则，配置和调用方式非常混乱。
> Fetch 通过 Promise 来实现回调，调用更加友好。

xmlHttpRequest

```js
var xhr = new XMLHttpRequest();
xhr.open('GET', url);
xhr.responseType = 'json';

xhr.onload = function() {
  console.log(xhr.response);
};

xhr.onerror = function() {
  console.log("Oops, error");
};

xhr.send();
```

Fetch

```js
fetch(url).then(function(response) {
  return response.json();
}).then(function(data) {
  console.log(data);
}).catch(function(err) {
  console.log("Oops, error");
});
```

#### 总结

在web项目中经常遇到跨域问题，这个问题很麻烦，需要服务器的支持和处理。在实际项目中网络问题也经常和这个相关。

学习了基本的网络的api和使用，以及注意事项。

具体api可以参考https://developer.mozilla.org/，里面列举了api和常见的浏览器兼容性问题

