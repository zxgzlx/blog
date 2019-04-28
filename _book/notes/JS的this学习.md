### this和对象原型

被自定义所有函数的作用域中

```js
function identify() { // 隐式“传递”一个对象的引用，this
    return this.name.toUpperCase();
}
var me = {
    name: "haha"
}

me.identify.call(me); // HAHA

// 显示传递一个上下文对象context
function identify(context) {
    return context.name.toUpperCase();
}
var me = {
    name: "haha"
}
identify(me);
```

**this到底是什么**

this是在运行时进行绑定的，并不是在编写时绑定，它的上下文取决于函数调用时的各种条件。this的绑定和函数声明的位置没有任何关系，只取决于函数的调用方式。

当一个函数被调用时，会创建一个活动记录（有时候也称为执行上下文）。这个记录会包含函数在哪里被调用（调用栈）、函数的调用方法、传入的参数等信息。this就是记录其中一个属性，会在函数执行的过程中用到。

this实际上时在函数被调用时发生的绑定，它指向什么完全取决于函数在哪里被调用。

**调用位置**

调用位置就是函数在代码中被调用的位置（而不是声明的位置）。

最重要的是要分析调用栈（就是为了到达当前执行位置所调用的所有函数）。我们关心的调用位置就在当前正在执行的函数的前一个调用中。

**案例分析**

```js
function baz() {
    // 当前调用栈是：baz
    // 因此，当前调用位置是全局作用域
    console.log("baz");
    bar(); // <-- bar的调用位置
}
function bar() {
    // 当前调用栈是baz --> bar
    // 因此，当前调用位置在baz中
    console.log("bar");
    foo(); // <-- foo 的调用位置
}

function foo(){
    // 当前调用栈是baz --> bar --> foo
    // 因此，当前调用位置在bar中
    console.log("foo");
}

baz(); // <-- baz的调用位置
```

#### 绑定规则

**默认绑定**

```js
function foo() {
    console.log(this.a);
}
var a = 2;
foo(); // 2 在严格模式下会报错
// 这里面的this默认绑定的全局window对象
```

**隐式绑定**

```js
function foo() {
    console.log(this.a);
}
var obj = {
    a: 2,
    foo: foo
};
obj.foo(); // 2

// 调用位置会使用obj上下文来引用函数，因此可以说函数被调用时obj对象“拥有”或者“包含”它。当foo()被调用时，它的落脚点确实指向obj对象。当函数引用上下文对象时，隐式绑定规则会把函数调用的this绑定到这个上下文对象。因此调用foo()时this被绑定到obj，this.a和obj.a是一样的。

// 对象属性引用链中只有最顶层或者说最后一层会影响调用位置
function foo() {
    console.log(this.a);
}
var obj2 = {
    a: 42,
    foo: foo
};
var obj1 = {
    a: 2,
    obj2: obj2
}
obj1.obj2.foo(); // 42

// 注意隐式丢失
function foo() {
    console.log(this.a);
}
var obj = {
    a: 2,
    foo: foo
};
var bar = obj.foo;
var a = "hello";
bar(); // "hello"
```

**显式绑定**

```js
function foo() {
    console.log(this.a);
}
var obj = {
    a: 2
}
foo.call(obj); // 2 使用call、apply、bind
```

**new 绑定**

```js
function foo(a) {
    this.a = a;
}
var bar = new foo(2);
console.log(bar.a); // 2
```

**案例**

```js
function foo() {
    return (a) => {
        console.log(this.a);
    };
}
var obj1 = {
    a: 2
};
var obj2 = {
    a: 3
};
var bar = foo.call(obj1);
bar.call(obj2); // 2, 不是3
// 箭头函数的绑定无法再次被修改（new也不行）
```

**判断this优先级顺序**

1. 由new调用，绑定到新创建的对象
2. 由call、apply、bind显式调用，绑定到指定对象
3. 由上下文对象隐式调用，绑定到指定的对象
4. 默认绑定，在严格模式下绑定到undefined，否则绑定到全局对象

