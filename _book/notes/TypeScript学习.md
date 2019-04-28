### TypeScript基础语法

#### 原始数据类型的应用

> JavaScript 中的 Primitive 类型直接用 ：Boolean, Number, String, Null, Undefined, Symbol
>
> TS中这些原始类型boolean, number, string, null, undefined的表示方法如下:

**布尔值 boolean**

```ts
// ts
let isDone: boolean = false;
let createdByNewBoolean: Boolean = new Boolean(0);
let createdByBoolean: boolean = Boolean(1);

// ts编译为js 
// tsc hello.js 终端运行
var isDone = false;
var createdByNewBoolean = new Boolean(0);
var createdByBoolean = Boolean(1);
```

**数值 number**

```ts
// ts
let decLiteral: number = 6;
let hexLiteral: number = 0xf00d;
// ES6 中的二进制表示法
let binaryLiteral: number = 0b1010;
// ES6 中的八进制表示法
let octalLiteral: number = 0o744;
let notANumber: number = NaN;
let infinityNumber: number = Infinity;

// ts编译为js 
var decLiteral = 6;
var hexLiteral = 0xf00d;
// ES6 中的二进制表示法
var binaryLiteral = 10;
// ES6 中的八进制表示法
var octalLiteral = 484;
var notANumber = NaN;
var infinityNumber = Infinity;
// 其中 0b1010 和 0o744 是 ES6 中的二进制和八进制表示法，它们会被编译为十进制数字。
```

**字符串 string**

```ts
// ts
let myName: string = 'Tom';
let myAge: number = 25;

// 模板字符串
// 其中 ` 用来定义 ES6 中的模板字符串，${expr} 用来在模板字符串中嵌入表达式。
let sentence: string = `Hello, my name is ${myName}.
I'll be ${myAge + 1} years old next month.`;


// ts编译为js
var myName = 'Tom';
var myAge = 25;
// 模板字符串
var sentence = "Hello, my name is " + myName + ".\nI'll be " + (myAge + 1) + " years old next month.";

```

**空值 void**

```ts
// ts
function alertName(): void {
    alert('My name is Tom');
}
// 声明一个 void 类型的变量没有什么用，因为你只能将它赋值为 undefined 和 null
let unusable: void = undefined;

// js
function alertName() {
    alert('My name is Tom');
}
var unusable = undefined;
```

**null 和 undefined**

```ts
// ts
// undefined 类型的变量只能被赋值为 undefined，null 类型的变量只能被赋值为 null。
// 与 void 的区别是，undefined 和 null 是所有类型的子类型。也就是说 undefined 类型的变量，可以赋值给 number 类型的变量。但是不能将void赋值给其他变量，会报错。
let u: undefined = undefined;
let n: null = null;
let num: number = undefined;

// js
var u = undefined;
var n = null;
var num = undefined;
```

**任意值类型 any**

```ts
// ts
// 普通类型赋值过程中不允许改变类型
// 如果是 any 类型，则允许被赋值为任意类型
let myFavoriteNumber: any = 'seven';
myFavoriteNumber = 7;

// js
var myFavoriteNumber = 'seven';
myFavoriteNumber = 7;

// 任意值的属性和方法
// 在任意值上访问和调用任何属性都是允许的
// 可以认为，声明一个变量为任意值之后，对它的任何操作，返回的内容的类型都是任意值
let anyThing: any = 'hello';
console.log(anyThing.myName);
console.log(anyThing.myName.firstName);
let anyThing: any = 'Tom';
anyThing.setName('Jerry');
anyThing.setName('Jerry').sayHello();
anyThing.myName.setFirstName('Cat');

// 未声明类型的变量
// 变量如果在声明的时候，未指定其类型，那么它会被识别为任意值类型
let something;
something = 'seven';
something = 7;
something.setName('Tom');
// 等价于
let something: any;
something = 'seven';
something = 7;
something.setName('Tom');
```

**类型推论**

> 如果没有明确的指定类型，那么 TypeScript 会依照类型推论（Type Inference）的规则推断出一个类型。

```ts
// ts
let myFavoriteNumber = 'seven';
// 等价于
let myFavoriteNumber: string = 'seven';

// 注意
// 如果定义的时候没有赋值，不管之后有没有赋值，都会被推断成 any 类型而完全不被类型检查
let myFavoriteNumber;
myFavoriteNumber = 'seven';
// 等价于
let something: any;
something = 'seven';
```

**联合类型 Union Types**

> 联合类型（Union Types）表示取值可以为多种类型中的一种。

```ts
// ts
let myFavoriteNumber: string | number;
myFavoriteNumber = 'seven';
myFavoriteNumber = 7;
// 如果传入其他类型就会报错
// 联合类型使用 | 分隔每个类型
// let myFavoriteNumber: string | number 的含义是，允许 myFavoriteNumber 的类型是 string 或者 number，但是不能是其他类型。

// 访问联合类型的属性或方法
// 当 TypeScript 不确定一个联合类型的变量到底是哪个类型的时候，我们只能访问此联合类型的所有类型里共有的属性或方法：
function getString(something: string | number): string {
    return something.toString(); // 不会报错
    // return something.length;
    // length 不是 string 和 number 的共有属性，所以会报错
}

// 联合类型的变量在被赋值的时候，会根据类型推论的规则推断出一个类型：
let myFavoriteNumber: string | number;
myFavoriteNumber = 'seven';
console.log(myFavoriteNumber.length); // 5
myFavoriteNumber = 7;
console.log(myFavoriteNumber.length); // 编译时报错
// 上面 myFavoriteNumber 被推断成了 string，访问它的 length 属性不会报错。myFavoriteNumber 被推断成了 number，访问它的 length 属性时就报错了。

// js
var myFavoriteNumber;
myFavoriteNumber = 'seven';
myFavoriteNumber = 7;
```

#### 对象的类型——接口

> 在 TypeScript 中，我们使用接口（Interfaces）来定义对象的类型。

```ts
// 实例1
// ts
interface Person {
    name: string;
    age: number;
}
let tom: Person = {
    name: 'Tom',
    age: 25
};

// js
var tom = {
    name: 'Tom',
    age: 25,
};

// 注意：
// 定义的变量比接口少了一些属性是不允许的，会报错
interface Person {
    name: string;
    age: number;
}
let tom: Person = {
    name: 'Tom'
};
// 多一些属性也是不允许的
interface Person {
    name: string;
    age: number;
}
let tom: Person = {
    name: 'Tom',
    age: 25,
    gender: 'male'
};
// 赋值的时候，变量的形状必须和接口的形状保持一致。
```

**可选属性**

```ts
// 有时我们希望不要完全匹配一个形状，那么可以用可选属性：
interface Person {
    name: string;
    age?: number; // ?: 为空就不创建，不为空就创建
}
let tom: Person = {
    name: 'Tom'
};
// ===
interface Person {
    name: string;
    age?: number;
}

let tom: Person = {
    name: 'Tom',
    age: 25
};

// 这时仍然不允许添加未定义的属性：所以下面会报错
interface Person {
    name: string;
    age?: number; 
}
let tom: Person = {
    name: 'Tom',
    age: 25,
    gender: 'male' // 没有这个属性, 报错
};
```

**任意属性**

```ts
// 有时候我们希望一个接口允许有任意的属性，可以使用如下方式：
interface Person {
    name: string;
    age?: number;
    [propName: string]: any;
}
let tom: Person = {
    name: 'Tom',
    gender: 'male'
};
// 使用 [propName: string] 定义了任意属性取 string 类型的值。
// 需要注意的是，一旦定义了任意属性，那么确定属性和可选属性的类型都必须是它的类型的子集：所以下面的实例报错
interface Person {
    name: string;
    age?: number;
    [propName: string]: string;
}
let tom: Person = {
    name: 'Tom',
    age: 25,
    gender: 'male' // 因为name和age要是任意属性gender类型的子集才不会报错，而nage的值25不是string，所以报错
};
```

**只读属性**

> 有时候我们希望对象中的一些字段只能在创建的时候被赋值，那么可以用 `readonly` 定义只读属性：

```ts
// ts
interface Person {
    readonly id: number;
    name: string;
    age?: number;
    [propName: string]: any;
}
let tom: Person = {
    id: 89757, 
    name: 'Tom',
    gender: 'male'
};

// js
var tom = {
    id: 89757,
    name: 'Tom',
    gender: 'male'
};

// 下面报错，因为使用 readonly 定义的属性 id 初始化后，又被赋值了，所以报错了。
interface Person {
    readonly id: number;
    name: string;
    age?: number;
    [propName: string]: any;
}
let tom: Person = {
    id: 89757, // 只读的约束存在于第一次给对象赋值的时候，而不是第一次给只读属性赋值的时候
    name: 'Tom',
    gender: 'male'
};
tom.id = 9527; // 第二次赋值造成报错
```



