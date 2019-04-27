#### 单例模式

它是指在一个类只能有一个实例，即使多次实例化该类，也只返回第一次实例化后的实例对象。单例模式不仅能减少不必要的内存开销, 并且在减少全局的函数和变量冲突也具有重要的意义。

#### 对象字面量创建单例

```js
let foo = {
    name: "哈哈",
    bar: function (name) {this.name = name}
}

foo.bar(); // 全局就一个foo,出发对象被覆盖，可以通过const不允许此对象字面量不被覆盖
```

#### 惰性单例

```js
// 懒汉式，调用的时候才实例唯一一个实例
let foo = (function() {
    let _instance = null;
    function instance() {
        this.name = "haha"
    }
    return function() {
        if (!_instance) {
            _instance = new instance();
        }
        return _instance;
    }
})();

let foo1 = foo();
let foo2 = foo();
console.log(foo1 === foo2); //true
```

通过ES6，可以更清晰和简洁，而且更容易理解和使用单例，下面学习ES6中的使用。

### ES6中的单例模式

#### 不构建单例

```js
class Foo {
    constructor(name) {
        this.name = name;
    }
}

let foo1 = new Foo("foo1");
let foo2 = new Foo("foo2");
// 多次new会生成多个对象
```
#### 构建单例

```js
// 构造函数中实现单例，饿汉式
class Foo {
    constructor(name) {
    	this.name = name;
        if (!Foo.instance) {
        	// 把this赋值到instance中去
            Foo.instance = this;
        }
        return Foo.instance;
    }
}
let foo1 = new Foo("foo1");
let foo2 = new Foo("foo2");
console.log(foo1 === foo2);  //true

// 优化上述代码，使用静态方法获取实例，懒汉式
class Foo {
    constructor(name) {
    	this.name = name;
    }
    // 静态方法
    static getInstance(name) {
        if (!this.instance) {
            this.instance = new Foo(name);
        }
        return this.instance;
    }
}
let foo1 = new Foo("foo1");
let foo2 = new Foo("foo2");
console.log(foo1 === foo2);  //true
```

**总结**

使用地方，比如登陆的时候，只能生成一个实例。还有其它等地方全局只使用一个实例，比如通过单例模式进行命名空间来解决全局变量的冲突，使用管理模块让结构更加清晰，减少内存开销等。