### JavaScript闭包

> 闭包是基于词法作用域书写代码时所产生的自然结果

#### 作用域

作用域查找，从当前作用域向全局作用域一层层查找。找到即终止查找。

LHS：试图找到变量的容器本身，从而可以对它赋值。（赋值操作的左侧）

RHS：取到它的源值（赋值操作的右侧）

非严格模式下：

LHS没查找到，未声明，编译器会在全局声明它。

RHS未声明，编译器会报ReferenceError错误。

严格模式下：

LHS和RHS都会报ReferenceError错，并不会创建全局声明。

RHS查询到变量，但是尝试对变量的值进行不合理的操作,会抛出TypeError。

ReferenceError同作用域判别失败相关，而TypeError则代表作用域判别成功了，但是对结果的操作是非法或不合理的。

**注意: **

判断函数声明和表达式最简单的方法是看function关键字出现在声明中位置（不仅仅是一行代码，而是整个声明中的位置）。如果function是声明中的第一个词，那么就是一个函数声明，否则就是一个函数表达式。函数表达式可以匿名，而函数声明不可以匿名。

```js
function (){}

(function(){}) // （）将函数变成了表达式
```

### 闭包

**实例1**

```js
function foo() {
    var a = 2;
    function bar() {
        console.log(a);
    }
    return bar;
}

var baz = foo();
baz(); // 2
```

实际上只是通过不同的标识符引用调用了内部的函数bar()。bar()显然可以被正常执行，在自己定义的词法作用域以外的地方执行。

**闭包作用：1.**可以使用同级的作用域

**闭包作用：2.**读取其他元素的内部变量

**闭包作用：3.**延长作用域

**闭包缺点：1.**作用域没有那么直观

**闭包缺点：2.**变量不会被垃圾回收占用一定的内存占用问题

**实例2**

```js
function foo() {
    var a = 2;
    function bar() {
        console.log(a);
    }
    baz(bar);
}
funtion baz(fn) {
    fn(); // 闭包
}
```

**实例3**

```js
// 间接传递
var fn;
function foo() {
    var a = 2;
    function bar() {
        console.log(a);
    }
    fn = bar;
}

function baz() {
    fn(); //闭包
}

foo();
baz(); // 2
```

**无论通过何种手段将内部函数传递到所在的词法作用域以外，它都会持有对原始定义作用域的引用，无论在何处执行这个函数都会使用闭包。**

**实例4**

```js
function wait(message) {
    setTimeout(function timer() {
        console.log(message);
    }, 1000);
}
 wait("Hello, closure");
```

将内部函数timer传递给setTimeout()。timer具有涵盖wait()作用域的闭包，因此还保有对变量message的引用。wait()执行1000毫秒后，它的内部作用域并不会消失，timer函数依然保有wait()作用域的闭包。究其内部代码，setTimeout()参数内部存在像实例2中的baz(fn)参数，来保证整个闭包过程的完整性。

**本质：**无论何时何地，如果将函数(访问它们各自的词法作用域)当作第一级的值类型并到处传递，就会看到闭包在这些函数中的应用。定时器、事件监听器或者任何其他的异步(或者同步)，只要使用了回调函数，实际上就是使用闭包！

**实例5**

```js
var a = 2;
(function foo() {
    console.log(a);
})();
// 严格说并非闭包，因为foo()函数中a全局作用域也持有a，可以通过普通的词法作用域就可以找到它，并非闭包中发现a的。
```

### 循环和闭包

**实例1**

```js
for (var i=1; i<=5; i++){
    setTimeout(function timer(){
        console.log(i);
    }, i*1000);
}
// 输出的五次结果都是6
// 因为var i这里的i是全局作用域中，延迟函数的回调会在循环结束后才执行。所以i=6.
```

**实例2**

```js
// 错误示范
for (var i=1; i<=5; i++){
    (function() {
         setTimeout(function timer(){
        	console.log(i);
    }, i*1000);   
    })(); // 作用域封闭不够，参数为空
}
```

**实例3**

```js
for (var i=1; i<=5; i++){
    (function(j) {
         setTimeout(function timer(){
        	console.log(j);
    }, j*1000);   
    })(i); // 作用域封闭，参数被储存
}
```

**实例4**

```js
// let块级作用域解决问题
for (let i=1; i<=5; i++){
    setTimeout(function timer(){
        console.log(i);
    }, i*1000);
}
```

### 闭包与模块

**实例1**

```js
// 模块
function Foo() {
    var something = "cool";
    var another = {1, 2, 3};
    function doSomething() {
        console.log(something);
    }
    function doAnother() {
        console.log(another.join("!"));
    }
    
    return { 
        doSomething: doSometing,
        doAnother: doAnother
    };
}

var foo = Foo();
foo.doSomething(); // cool 访问闭包作用域中的变量
foo.doAnother(); // 1!2!3

// 模块暴露两个必要条件
// 1. 必须有外部的封闭函数，该函数必须至少被调用一次（每次调用都会创建新的一个模块实例）
// 2. 封闭函数必须返回至少一个内部函数，这样内部函数才能在私有作用域中形成闭包，并且可以访问或者修改私有的状态。

// 修改成单例模式
var foo = (function Foo() {
    var something = "cool";
    var another = {1, 2, 3};
    function doSomething() {
        console.log(something);
    }
    function doAnother() {
        console.log(another.join("!"));
    }
    
    return { 
        doSomething: doSometing,
        doAnother: doAnother
    };
})();

foo.doSomething();
foo.doAnother();

// 模块也是普通的函数，也可以接受参数：
function Foo(id) {
    function bar() {
        console.log(id);
    }
    return {
        identify: identify
    };
}
var foo1 = Foo("foo1");
var foo2 = Foo("foo2");
```

闭包原理大致就是以上，平时使用回调或者模块中会不知不觉用到，可能以前并不注意，也无法解释清楚，通过上述的实例介绍和学习，了解和它的原理，更好的理解代码和使用它，从而避免平时不必要的错误。

**ES6的class的使用**

```js
class A { // class不存在变量提升,因此先声明后才能使用
    construtor(a, b){ // 构造函数
        this.a = a;
        this.b = b;
    }
    sum(){
        return this.a + this.b;
    }
}

var foo1 = new A(1, 2); // new个对象
var foo2 = new B(2, 3);

// const 定义常量，定义后不能再改变
```



