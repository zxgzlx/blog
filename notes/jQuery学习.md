### jQuery

> jQuery是一个JavaScript函数库。
>
> jQuery是一个轻量级的"写的少，做的多"的JavaScript库。
>
> jQuery库包含以下功能：
>
> - HTML 元素选取
> - HTML 元素操作
> - CSS 操作
> - HTML 事件函数
> - JavaScript 特效和动画
> - HTML DOM 遍历和修改
> - AJAX
> - Utilities
>
> **提示：** 除此之外，Jquery还提供了大量的插件。

tips:

  **使用 Staticfile CDN、百度、又拍云、新浪、谷歌或微软的 jQuery，有一个很大的优势：**

许多用户在访问其他站点时，已经从百度、又拍云、新浪、谷歌或微软加载过 jQuery。所以结果是，当他们访问您的站点时，会从缓存中加载 jQuery，这样可以减少加载时间。同时，大多数 CDN 都可以确保当用户向其请求文件时，会从离用户最近的服务器上返回响应，这样也可以提高加载速度。 

#### 语法

> 通过 jQuery，您可以选取（查询，query） HTML 元素，并对它们执行"操作"（actions）。 
>
> jQuery 使用的语法是 XPath 与 CSS 选择器语法的组合。

jQuery 语法是通过选取 HTML 元素，并对选取的元素执行某些操作。

基础语法： **$(selector).action()**

- 美元符号定义 jQuery
- 选择符（selector）"查询"和"查找" HTML 元素
- jQuery 的 action() 执行对元素的操作

实例:

- $(this).hide() - 隐藏当前元素
- $("p").hide() - 隐藏所有 <p> 元素
- $("p.test").hide() - 隐藏所有 class="test" 的 <p> 元素
- $("#test").hide() - 隐藏所有 id="test" 的元素

jQuery入口函数：

```js
$(document).ready(function(){
    // 执行代码
});
// 或者简写
$(function(){
    // 执行代码
});
```

JavaScript入口函数：

```js
window.onload = function () {
    // 执行代码
}
```

-  jQuery 的入口函数是在 html 所有标签(DOM)都加载之后，就会去执行。可以多次执行，第N次都不会被上一次覆盖。
-  JavaScript 的 window.onload 事件是等到所有内容，包括外部图片之类的文件加载完后，才会执行。只能执行一次，如果第二次，那么第一次的执行会被覆盖。

#### 选择器

> jQuery 选择器允许您对 HTML 元素组或单个元素进行操作。
>
> jQuery 选择器允许您对 HTML 元素组或单个元素进行操作。
>
> jQuery 选择器基于元素的 id、类、类型、属性、属性值等"查找"（或选择）HTML 元素。 它基于已经存在的 [CSS 选择器](https://www.runoob.com/cssref/css-selectors.html)，除此之外，它还有一些自定义的选择器。
>
> jQuery 中所有选择器都以美元符号开头：$()。

```js
$("p") // 元素选择器
$("#test") // id选择器
$(".test") // class选择器
```

#### 事件

jQuery中大多数DOM事件都有一个等效的jQuery方法

```js
$("p").click(function(){
    // 动作触发后执行的代码!!
});
```

| 鼠标事件                                                     | 键盘事件                                                     | 表单事件                                                  | 文档/窗口事件                                             |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :-------------------------------------------------------- | :-------------------------------------------------------- |
| [click](https://www.runoob.com/jquery/event-click.html)      | [keypress](https://www.runoob.com/jquery/event-keypress.html) | [submit](https://www.runoob.com/jquery/event-submit.html) | [load](https://www.runoob.com/jquery/event-load.html)     |
| [dblclick](https://www.runoob.com/jquery/event-dblclick.html) | [keydown](https://www.runoob.com/jquery/event-keydown.html)  | [change](https://www.runoob.com/jquery/event-change.html) | [resize](https://www.runoob.com/jquery/event-resize.html) |
| [mouseenter](https://www.runoob.com/jquery/event-mouseenter.html) | [keyup](https://www.runoob.com/jquery/event-keyup.html)      | [focus](https://www.runoob.com/jquery/event-focus.html)   | [scroll](https://www.runoob.com/jquery/event-scroll.html) |
| [mouseleave](https://www.runoob.com/jquery/event-mouseleave.html) |                                                              | [blur](https://www.runoob.com/jquery/event-blur.html)     | [unload](https://www.runoob.com/jquery/event-unload.html) |
| [hover](https://www.runoob.com/jquery/event-hover.html)      |                                                              |                                                           |                                                           |