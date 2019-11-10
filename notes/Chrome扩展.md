（装载自掘金：https://juejin.im/post/5c135a275188257284143418）

# Chrome 扩展开发

> 为什么转载这个，因为想要在游戏加入一些浏览器插件，比如GM命令，想通过这种插件方式加入，所以学习扩展方面的一些知识

# 前言

关于chrome extension的开发经验总结或说明文档等资料很多，很多人在写，然而，我也是一员。但是，也许这篇文章，可能给你一些不一样的感受。
 **这里介绍的是80%你要开发扩展会碰到的问题**

**前面部分**大多数是一些基础介绍，和别人的资料大同小异，但是用的是通俗的语言或者我自己理解来描述的，不是拷贝官方的描述，不然的话，你干脆看官方文档就好啦，干嘛还来我这里折腾对吧，也许这些通俗的描述，更方便你理解（当然不排除也会有官方的话语）
 **后面部分**多为一些我在项目中总结的方法，这部分就是在别人的资料可能看不到的地方了，当然，这些方法也许不通用，因为毕竟是基于我项目里的，但是尽量总结一套方法出来。

废话不多说，咱们开始吧...

------

# 目录

- [WHAT](#what)
- 最基本组成
  - [manifest.json](#manifest)
  - [background script](#background)
  - [content script](#content)
  - [popup](#popup)
- 基础的通信机制
  - [content script与background的通信](#communication01)
  - [popup与background的通信](#communication02)
  - [popup与content script的通信](#communication03)
  - [插件iframe网站与插入网页的通信](#communication04)
- [插件内容发送ajax请求，我的一套“土办法”](#request)
- [检测扩展是否已经安装](#check)
- [注意项](#last)

# WHAT

谷歌扩展（chrome extension），在认识之前，首先要明确一个观念，这种扩展程序，实际上不是一个exe、app之类的程序，下载了本地打开运行安装，本质上，它就是一个网页，写的用的都是前端的语言，高档点说是一个程序，通俗来讲， 就是运行在浏览器上的一个网站，网页。

我这种说法也许不对，不准确，不专业。但是起码，能把小白开发扩展的心态，调整好点，实际上是一个不难的东西，就是在写页面而已。要知道，心态不好，后面就坚持不下去了。

# 最基本组成

这里讲的是开发一个扩展（插件）最常用最基本的所需的东西，并不像官方说的那种分类。

- manifest.json
- background script
- content script
- popup

严格上来讲主要是background script 、 content script 和 popup，毕竟他们都是贯穿在manifest里的，把manifest写出来，只是为了凸显一下它的重要性

## （一）manifest.json

一个插件，必须都含有这个一个文件——manifest.json，位于根目录。顾名思义，这是一个扩展的组成清单，在这个清单里能大约看到该插件的一个“规则”。

罗列和简单介绍一下一些常用的配置项，说之前，先看一个大致的文件，首先感官感受一下先

```
{
	// 必须
	"manifest_version": 2,
	"name": "插件名称a",
	"version": "1.1.2",

	// 推荐
	"default_locale": "en",
	"description": "插件的描述",
	"icons": {
		"16": "img/icon.png",	// 扩展程序页面上的图标
		"32": "img/icon.png",	// Windows计算机通常需要此大小。提供此选项可防止尺寸失真缩小48x48选项。
		"48": "img/icon.png",	// 显示在扩展程序管理页面上
		"128": "img/icon.png"	// 在安装和Chrome Webstore中显示
	},

	// 可选
	"background": {
		"page": "background/background.html",
		"scripts": ["background.js"],
		// 推荐
		"persistent": false
	},
	"browser_action": {
		"default_icon": "img/icon.png",	
		// 特定于工具栏的图标，至少建议使用16x16和32x32尺寸，应为方形，
		// 不然会变形
		"default_title": "悬浮在工具栏插件图标上时的tooltip内容",
		"default_popup": "hello.html"	// 不允许内联JavaScript。
	},
	"content_scripts": [ {
		"js": [ "inject.js" ],
		"matches": [ "http://*/*", "https://*/*" ],
		"run_at": "document_start"
	 } ],
	"permissions": [
		"contextMenus",
		"tabs",
		"http://*/*",
		"https://*/*"
	],
	"web_accessible_resources": [ "dist/*", "dist/**/*" ]
}
复制代码
```

上面有我写的一些注释，用于帮助大家更好的去理解。
 那接下来开始说一下其中的配置项

### icons

extension程序的图标，可以有一个或多个。
 48x48的图标用在extensions的管理界面(chrome://extensions)；
 128x128 的图标用在安装extension程序的时候；
 16x16 的图标当作 extension 的页面图标，也可以显示在信息栏上。
 图标一般为PNG格式, 因为最好的透明度的支持，不过WebKit支持任何格式，包括BMP，GIF，ICO等
 注意: 以上写的图标不是固定的。随浏览器的环境的改变而变。如：安装时弹出的对话框变小。

### browser_action与page_action

这两个配置项都是用来处理扩展在浏览器工具栏上的表现行为。 前者扩展可以适用于任何页面。后者扩展只能作用于某一页面，当打开该页面时触发该Google Chrome扩展，关闭页面则Google Chrome扩展也随之消失。

通俗的举个例子，一些扩展任何页面可用，就都会显示在工具栏上为可用状态，一些扩展只适用于某些页面，如大家很熟悉的vue tools调试器，在检测到页面用的是vue时，就会在工具栏显示出来并可用（非灰色）

##### default_popup

在用户点击扩展程序图标时，都可以设置弹出一个popup页面。而这个页面中自然是可以有运行的js脚本的（比如就叫popup.js）。它会在每次点击插件图标——popup页面弹出时，重新载入。

这个小小的设置，也就是上面我把它分为在基本组成里的**popup**了

### permissions

在background里使用一些chrome api，需要授权才能使用，例如要使用chrome.tabs.xxx的api，就要在permissions引入“tabs”

### web_accessible_resources

允许扩展外的页面访问的扩展内指定的资源。通俗来讲就是，扩展是一个文件夹A的，别人的网站是一个文件夹B，B要看A的东西，需要获得权限，而写在这个属性下的文件，就是授予了别人访问的权限。

## （二）background script

background可以理解为插件运行在浏览器中的一个后台网站/脚本，注意它是与当前浏览页面无关的。
 实际上这部分内容的配置情况也会写在manifest里，对应的是`background`配置项。单独拿出来讲，是彰显它的分量很重，也是一个插件常用的配置。从其中几个配置项项去了解一下什么是background script

### page

可以理解为这个后台网站的主页，在这个主页中，有引用的脚本，其中一般都会有一个专门来管理插件各种交互以及监听浏览器行为的脚本，一般都起名为background.js。这个主页，不一定要求有。

### scripts

这里的脚本其实跟写在page里html引入的脚本目的一样，个人的理解是，page的html在没有的情况下，那么脚本就需要通过这个属性引入了；
 如果在存在page的情况下，一般在这里引入的脚本是专门为插件服务的脚本，而那些第三方脚本如jquery还是在page里引用比较好，或许这是一个众人的“潜规则”吧

### persistent

所谓的后台脚本，在chrome扩展中又分为两类，分别运行于后台页面（background page）和事件页面（event page）中。两者区别在于，

**前者**（后台页面）持续运行，生存周期和浏览器相同，即从打开浏览器到关闭浏览器期间，后台脚本一直在运行，一直占据着内存等系统资源，persistent设为true；

而**后者**（事件页面）只在需要活动时活动，在完全不活动的状态持续几秒后，chrome将会终止其运行，从而释放其占据的系统资源，而在再次有事件需要后台脚本来处理时，重新载入它，persistent设为false。

保持后台脚本持久活动的唯一场合是扩展使用chrome.webRequest API来阻止或修改网络请求。webRequest API与非持久性后台页面不兼容。

## (三) content script

这部分脚本，简单来说是插入到网页中的脚本。它具有独立而富有包容性。

所谓**独立**，指它的工作空间，命名空间，域等是独立的，不会说跟插入到的页面的某些函数和变量发生冲突；

所谓**包容性**，指插件把自己的一些脚本（content script）插入到符合条件的页面里，作为页面的脚本，因此与插入的页面共享dom的，即用dom操作是针对插入的网页的，在这些脚本里使用的window对象跟插入页面的window是一样的。主要用在消息传递上（使用postMessage和onmessage）

实际上这部分内容的配置情况也会写在manifest里，对应的是`content_scripts`配置项。单独拿出来讲，是彰显它的分量很重，也是一个插件常用的配置。从其中几个配置项项去了解一下什么是content script

### js

要插入到页面里的脚本。例子很常见，例如在一个别人的网页上，你要打开你做的扩展，对别人的网页做一些处理或者获取一些数据等，那怎么跟别人的页面建立起联系呢？就是通过把js里的这些脚本嵌入都别人的网页里。

### matches

必需。匹配规则组成的数组，用来匹配页面url的，符合条件的页面将会插入js的脚本。当然，有可以匹配的自然会有不匹配的——exclude_matches。匹配规则：

[developer.chrome.com/extensions/…](https://developer.chrome.com/extensions/match_patterns)

上面的官方描述已经很清晰啦，我就不多说了。

### run_at

js配置项里的脚本何时插入到页面里呢，这个配置项来控制插入时机。有三个选择项：

- document_start
- document_end
- document_idle（默认）

##### document_start

style样式加载好，dom渲染完成和脚本执行前

##### document_end

dom渲染完成后，即DOMContentLoaded后马上执行

##### document_idle

在DOMContentLoaded 和 window load之间，具体是什么时刻，要视页面的复杂程度和加载时间，并针对页面加载速度进行了优化。

## popup

其实这部分，早就讲过了，就是在manifest里的`browser_action`与`page_action`配置项里设置的

------

# 基础的通信机制

上面讲述了基本的组成部分，那么这几部分，他们要进行交流合作，把他们组织起来，才能成就一个漂亮的扩展。那么这种交流，分为以下几种说明：

- content script与background的通信
- popup与background的通信
- popup与content script的通信
- 插件iframe网站与插入网页的通信

最后一点，是额外说的，但是却是很重要的。毕竟很多扩展，也是以iframe的形式呈现的。

## （一）content script与background的通信

### content-script向background发送消息

#### 在content-script端

使用

```
chrome.runtime.sendMessege(
    message,
    function(response) {…}
)
复制代码
```

就能向background发送消息了，第一个参数message为发送的消息（基础数据类型），回调函数里的第一个参数为background接收消息后返回的消息（如有）

#### 在background端

使用

```
chrome.runtime.onMessege.addListener(
    function(request, sender, sendResponse) {…}
)
复制代码
```

进行监听发来的消息，`request`表示发来的消息，`sendResponse`是一个函数，用于对发来的消息进行回应，如 `sendResponse('我已收到你的消息：'+JSON.stringify(request));`

这里需要注意的是，默认情况下`sendResponse`函数的执行是同步的，如果在这个监听消息的处理函数的同步执行流程里没有发现`sendResponse`，则默认返回`undefined`，假设我们是要经过一个异步处理之后才调用`sendResponse`，已经为时已晚了。因此，我们可能需要异步执行`sendResponse`，这时我们在这个监听函数里的添加`return true`就能实现了。

还有，由于background监听所有页面上的content script上发来的消息，如果多个页面同时发送同种消息，background的onMessage只会处理最先收到的那个，其他的不了了之了。

### background向content-script发送消息

我们发现，一个插件里只有一个background环境，而content-script有多个（一个页面一个），那么background怎么向特定的content-script发送消息？

#### 在background端

首先我们需要知道要向哪个content scripts发送消息，一般一个页面一份content scripts，而一个页面对应一个浏览器tab，每个tab都有自己的tabId，因此首先要获取要发送消息的tab对应的tabId。

```
/**
 * 获取当前选项卡id
 * @param callback - 获取到id后要执行的回调函数
 */
function getCurrentTabId(callback) {
    chrome.tabs.query({active: true, currentWindow: true}, function (tabs) {
        if (callback) {
            callback(tabs.length ? tabs[0].id: null);
        }
    });
}
复制代码
```

当知道了tabId后，就使用该api进行发送消息

```
chrome.tabs.sendMessage(tabId, message, function(response) {...});
复制代码
```

其中message为发送的消息，回调函数的response为content scripts接收到消息后的回传消息

#### 在content scripts端

同样是使用

```
chrome.runtime.onMessege.addListener(function(request, sender, sendResponse) {…})
复制代码
```

进行来自background发来消息的监听并回传

## （二）popup与background的通信

一般地，popup与background的交流，常见于popup要获取background里的某些“东西”，当然我们可以使用上述的`chrome.runtime.sendMessage`和`chrome.runtime.onMessage`的方式进行popup向background的交流，但是其实有更方便快捷的方式：

```
var bg = chrome.extension.getBackgroundPage();
bg.someMethod();    //someMethod()是background中的一个方法
复制代码
```

## （三）popup与content script的通信

这里的通信，实际上跟background与content script的方式是一样的

## （四）插件iframe网站与插入网页的通信

其实这两个的通信，算不上是chrome extension开发里的知识，它就是一个基础的js知识——ifame与父窗体的通信。

同域的情况下，可以通过DOM操作达到通信的目的，如获取dom元素，获取值赋值之类的。
 在父窗体里，用`window.contentWindow`获取到iframe的window对象
 在iframe里，用`window.parent`获取到父窗体的window对象

而在跨域下，上述的方法是行不通的，网上也有各种方法解决，但是在插件这块里，最方便的就是使用js的`message机制`了。
 我这里说的`message机制`，就是使用window对象的`postMessage()`和`onmessage`。

一般插件展现都是在别人的网站上，因此没办法直接在别人的网站上添加`postMessage`和`onmessage`的代码。这时候，重任就落在了插件的content script身上了（之前说了他们共用DOM）。由于content script是自己编写的，所以可以“为所欲为”了

### iframe向父窗体发送消息

#### 在iframe端

假设iframe类名为extension-iframe，这里设置类名而不是id名的初衷是，我们不能保证设置的名称原本的网站会不会已经存在，设置类名能共存。发送消息使用
 `window.parent.postMessage(message, '*');`
 其中`message`为发送的消息

#### 在父窗体端

由于一个页面，可能有来自页面本身的postMessage来的消息，也有可能来自该页面其他chrome extension发送来的消息，因此用onmessage来监听，要做好区分来源，这里使用以下方法

```
window.addEventListener('message', function (event, a, b) {
    // 如果没消息就退出
    if (!event.data) {
        return;
    }
    var iframes = document.getElementsByClassName('extension-iframe');
    var extensionIframe = null; // 存插件iframe节点对象
    var correctSource = false;  // 是否来源正确
    // 找出真正的插件生成的iframe
    for (var i = 0; i < iframes.length; i++) {
        if (iframes[i].contentWindow && (event.source === iframes[i].contentWindow)) {
            correctSource = true;
            extensionIframe = iframes[i];
            break;
        }
    }
    // 如果来源不是来自插件的，就退出
    if (!correctSource) {
        return;
    }
}, false);
复制代码
```

这里也不能百分百区分好是不是来自自己extension的消息，或许真的那么倒霉刚好有一个跟自己extension同类名的iframe也发了一个消息过来。因此还可以加多一层保障，在iframe发送消息的内容上做手脚，例如加个from，然后在这边判断一下等。当然，这样也不能百分百确定，只能说保障更上一层楼了。
 如果大家有好的点子，请务必告诉鄙人！受教受教！

### 父窗体向iframe发送消息

#### 在父窗体端

使用  `extensionIframe.contentWindow.postMessage(message, '*');`
 其中`extensionIframe`为插件的iframe节点对象，`message`为发送的消息，例如

```
{from: 'content-script', other: xxx}
复制代码
```

#### 在iframe端

使用

```
window.addEventListener('message', function (event, a, b) {
    let result = event.data;
    if (result && (result.from === 'content-script') && (event.source === window.parent)) {...}
});
复制代码
```

在这里，在发送消息里增加了个from属性，进而进一步判断是不是来自父窗体自己插件的content script

# 插件内容发送ajax请求，我的一套“土办法”

我们知道，在进行ajax请求，是有可能遇到跨域的。例如我的项目就是在任何一个页面插入iframe网站，然后有些操作就需要发请求了，这样必然存在跨域问题。
 然而，如果开发插件还要开发者想办法解决跨域问题，那chrome extension就太逊了，而且，跨不跨域，还不是浏览器自己的主意，是浏览器本身的安全策略。

所以，chrome extension为了保证自己的优越性，允许在自己的程序里面，实现跨域请求，那完全的chrome extension程序，无非就是在background里了。

**因此，插件要实现一些ajax请求，都得通通搬到background里实现**。这个事情，本身不是什么重大发现。接下来要说的是，我利用这个特性，按照某个规则，实现一套方便的请求流程。

这里以一个ifame网站嵌入到别人页面的这类形式的chrome extension为例子。

### 在插件生成的iframe网站里

首先在这个插件网站中，有一些按钮操作本身是要触发某些ajax请求的，但是由于上述原因，不能直接在插件网站里发请求，而是先向父窗口发送消息，利用`postMessage`。例如

```
window.parent.postMessage({
    from: 'extension-iframe',
    type: 'loadTable',
    data: {
        pageIndex: 1,
        pageSize: 10,
        sortProp: '',
        sortOrder: 0
    }
}, '*');
复制代码
```

by the way，这里用`window.parent.postMessage`是为了解决iframe跨域通信问题，当然如果是确保同域的情况下，其实可以直接用DOM操作告诉父窗口一些消息。

言归正传，在postMessage第一个参数对象里

| 属性名 |                        描述                         |
| :----: | :-------------------------------------------------: |
|  from  |                标记这条消息来自哪里                 |
|  type  | 操作的名称，如发送该message的操作目的是为了加载表格 |
|  data  |                   发送请求的data                    |

### 在插件的content script里

监听发来的消息，这里①标注的代码为前面说过的区分来源，这里重点放在②部分的代码

```
window.addEventListener('message', function (event, a, b) {
    var responseData = event.data;
    if (!event.data) {
        return;
    }
    // 来自插件内嵌网站的消息
    if (responseData.from === 'extension-iframe') {
        // ① 判断是否自己插件的iframe
        var iframes = document.getElementsByClassName('extension-iframe');
        var extensionIframe = null;
        var correctSource = false;
        for (var i = 0; i < iframes.length; i++) {
            if (iframes[i].contentWindow && (event.source === iframes[i].contentWindow)) {
                correctSource = true;
                extensionIframe = iframes[i];
                break;
            }
        }
        if (!correctSource) {
            return;
        }
        // ② 加载表格、提交信息等请求操作
        // 该数组为iframe传来各个操作的名称，对应发来的消息的type属性
        var operators = ['loadTable', 'submit', 'getNonMarkedCount', 'getUrl'];
        // 如果跟操作匹配上了，就转发给background
        if (operators.indexOf(responseData.type) !== -1) {
            chrome.runtime.sendMessage({
                type: responseData.type,
                data: responseData.data
            },function (response) {
                // 返回请求后的数据给iframe网站
                extensionIframe.contentWindow.postMessage({
                    from: 'extension-content-script',
                    type:  responseData.type,
                    response: response
                }, '*');
            });
        }
    }
}, false);
复制代码
```

### 在插件的background script里

监听刚转发过来的消息

```
// 这是所有请求组成对象
var httpService = {
    loadTable: function (config) {
        return eodHttp.get('/brandimageservice/perspective/mark', config);
    },
    submit: function (config) {
        return eodHttp.post('/brandimageservice/perspective/mark', config);
    },
    ...
};

// 监听刚转发过来的消息
chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    // 该数组为iframe传来各个操作的名称，对应发来的消息的type属性
    var operators = ['loadTable', 'submit', 'getNonMarkedCount', 'getUrl'];
    if (operators.indexOf(request.type) !== -1) {
        // 这里的type刚好与请求的属性名一致
        httpService[request.type](request.data).then(res => {
            // 把请求的结果回传给content script
            sendResponse(res);
        }).catch(e => {
            // 这里做了请求拦截，如果不是canceled的请求报错，则把报错信息也回传给content script
            (e.status !== -1) && (sendResponse(e.data));
        });
    }
    // 此处return true是为了把sendResponse作为异步处理。
    return true;
});
复制代码
```

### 再返回到插件生成的iframe网站里

这次绕回到这个ifame里，最终的请求的数据还是会流回这里。

```
 window.addEventListener('message', function (event, a, b) {
    let result = event.data;
    if (result && (result.from === 'extension-content-script') && (event.source === window.parent)) {
        // 以下为请求返回内容
        let res = result.response;
        // 加载表格数据
        if (result.type === 'loadTable') {...}
    }
});
复制代码
```

这样，最终在iframe里获取到的请求数据还是跟之前我们平常开发调接口的情况是一样的。

### 总结

整个流程是 **iframe -> content script -> background -> content script -> iframe**
 以background为中分线，前半截为发送请求，后半截为获取请求数据。这里巧妙的用法就是“type”这个字段由始至终都一直存在，都代表一样的意思。这样的写法的好处是，所有请求操作都可以共用这么一个流程，改一下type区分一下操作即可。

# 检测chrome extension是否已经安装

有一些chrome extension，可能不单单是通过点击浏览器工具栏上的插件图标来激活插件，也有一些需求是通过点击网站上某个按钮来激活插件（如自家的系统），那么这时候第一步需要的是，检测浏览器是否安装了要求的chrome extension，如果没有，进行提示等等。

在国内资料中进行搜索，往往会看到很多条教用`navigator`对象来查找安装的插件，可能是我太弱鸡了，我发现并不能用来检测到自己添加的chrome extension。于是我只能另寻他法了，如果有大神知道如何用`navigator`对象来判断，麻烦指导一下。

### 思路

如果安装了某个插件，那么该插件的content script就会插入到页面上（没有content script的除外，但是一般没有content script的插件往往也没有以上这样的需求），因此判断是否安装了该插件，就变为判断content script是否插入到页面上。

#### 方法一

在content script里写这么一个逻辑：往插入页面生成一个html元素标记，如`<div class="extension-flag"><div>`。然后在插入页面获取这个元素，如果获取到了，就证明content script存在了（不存在也就没有这个元素了），就证明已经安装了。

**缺点**： 创建的这个元素，一定要够“特别”，越能确保其独一无二越能证明是来自插件的。什么意思？假设刚好页面也有一个类名跟创建的一样的，那就要做进一步区分这到底是不是来自该插件的了。

#### 方法二

通过message机制，在合适的时机里，页面用`postMessage`发送消息给window，content script监听window消息，判断如果是要求检查是否安装的消息，则再用`postMessage`告知，只要收到这个消息，就证明已经安装了。

**缺点**：由于发送消息和接受消息再到发送消息，这个过程是异步的。所以要处理好何时发送检测的时机问题。

### 安装的一些注意事项

安装手段一般是有两种的，一种在谷歌商店上进行在线安装，一种是下载安装包离线安装。在线安装没什么好说的，那么说一下离线安装。

离线安装的关键是，你提供的下载包是什么？

开发者在开发扩展的时候，往往是直接安装在本地上的扩展所在文件夹。在chrome://extensions上开启开发者模式，点击“加载已解压的扩展程序”。这时候会发现第一次打开浏览器的时候会老是提示你这个扩展不安全之类的。当然我们提供给用户下载的安装包肯定不能是这个了。

一开始我傻不拉几的直接压缩自己的开发的扩展所在文件夹，然后发到服务器上给用户下载，结果呢，用户下载了，然后把压缩包拖动到chrome://extension里，发现chrome不允许安装，说什么基于安全什么的。也就是我这个扩展可能不安全不给我装。

后来才知道，不应该提供这种压缩包，而是在自己发布扩展的开发者信息中心里，把已发布的扩展下载下来提供给用户用才可以。



![img](https://user-gold-cdn.xitu.io/2018/12/14/167ac21e1cd609cf?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



也许...只有我那么傻吧

# 最后

最后的最后，我说一下小细节的注意项吧，稍微不留神，可能就这样傻傻地写下了bug了...

### 扩展之间很容易相互影响

怎么理解？在通信部分我讲过，在传递消息的时候，在消息里，我有用type字段来标明传递的内容类型。在开发完扩展的时候，发现有些同事的电脑可以正常使用有些却不行，后来调试代码发现，在postMessage函数里的type参数给别的扩展改造过了，受到了影响。

为什么会这样呢？原因是扩展都是通过嵌入自己的脚本到别人的网页里，因此在一个网页里的代码，特别是传递消息机制里，更容易受到牵连。

这个问题说明了什么？

- 要安装权威可信的扩展
- 开发一个值得让人信赖的扩展，开发一个尽量考虑全面的扩展，不要给用户添麻烦

### 代码调试

对于content script的调试，平常我们打开F12选择到source选项的时候，一般都会显示在"page"下，其实可以看到，还有个content script的选择，里边的就是各个扩展的内容脚本了。



![img](https://user-gold-cdn.xitu.io/2018/12/17/167ba449c87b9757?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



对于backgroud script的调试，就在去到chrome://extensions页下，找到对应的扩展，然后点击背景视图，就可以看到backgroud script进行调试了，而且，还能在控制台调用chrome api呢。以及，请求也可以在这里看到。



![img](https://user-gold-cdn.xitu.io/2018/12/18/167c01356d69a4e2?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



### 信息传递的异步性

在扩展中，会用到很多消息传递，如上述的postMessage和chrome.runtime.sendMessage等之类的，大家一定要有一个观念，他们的交流并不是同步，不是说我发了一个消息过去，就马上收到然后做接下来的处理。

所以我们写逻辑的时候一定要注意，这种异步性，会对你的逻辑处理产生什么效果。特别是也要考虑到content script的插入时机是否对这些通信产生一定影响，如content script都没有准备好，就发了一些消息，然后就没有声响了。


作者：pekonchan链接：https://juejin.im/post/5c135a275188257284143418来源：掘金著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。