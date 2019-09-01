#### 装饰器Cocos creator TypeScript中@修饰符代码分析

> 自己简单实现一个装饰器UML图

![装饰器简单UML](C:\Users\Administrator\Desktop\装饰器简单UML.png)

> 这里发现装饰器模式和代理模式有点像，从网上找了一张代理模式的UML图，这里就不自己画了

![代理模式](C:\Users\Administrator\Desktop\代理模式.png)

**区别**

>对装饰器模式来说，装饰者（decorator）和被装饰者（decoratee）都实现同一个接口。
>
>对代理模式来说，代理类（proxy class）和真实处理的类（real class）都实现同一个接口



> 直接拿网上分析的这个很好解释了区别：
>
> 装饰器模式偏重对原对象功能的扩展，扩展后的对象仍是是对象本身；然而代理模式偏重因自己无法完成或无需关心，需要他人干涉事件流程，更多的是对对象的控制（代理使客户端不需要知道实现类是什么，怎么做的，而客户端只需知道代理即可，即将客户端与实现类解耦）
>
> 换句话说，用代理模式，代理类（proxy class）可以对它的客户隐藏一个对象的具体信息。因此，当使用代理模式的时候，我们常常在**一个代理类中创建一个对象的实例**。并且，当我们使用装饰器模式的时候，我们通常的做法是**将原始对象作为一个参数传给装饰者的构造器**。
>
> 一句话总结这些差别：使用代理模式，代理和真实对象之间的的关系通常在编译时就已经确定了，而装饰者能够在运行时递归地被构造

**工程里面装饰器模式的已经分析**

> 使用在Cocos中使用TypeScript时，发现官方代码的Component脚步中有cc._decorator和@ccclass，比较好奇其中的实现原理，这里面用到的就是装饰的部分知识，通过@decorator语法糖，可以简化相关代码，是代码更加简洁

```typescript
const {ccclass, property} = cc._decorator;

@ccclass
export default class NewClass extends cc.Component { }
```

> 这里就在Cocos中做一个测试脚步，来自定义自己的类、属性、方法、参数装饰器，通过@decorator语法糖给相关组件添加相关功能，而不改变这些组件本身原有功能和属性，可以很好的实现相关组件的拓展。

```typescript
// Log.ts
// 实现一个Log类,拓展功能的实现
export default class Log {
    //不带参数的装饰器
    static logClass(target: any) {
        var original = target;
        function construct(constructor, args) {
            var c: any = function () {
                return constructor.apply(this.args);
            }
            c.prototype = constructor.prototype;
            return new c();
        }
        var f: any = function (...args) {
            console.log("New:" + original.name);
            return construct(original, args);
        }
        f.prototype = original.prototype;
        return f;
    }
    //类装饰器,带有参数的
    static logClass2(option: string) {
        return function (target: any) {
            console.log("option:" + option);
            var original = target;
            function construct(constructor, args) {
                var c: any = function () {
                    return constructor.apply(this.args);
                }
                c.prototype = constructor.prototype;
                return new c();
            }
            var f: any = function (...args) {
                console.log("New:" + original.name);
                return construct(original, args);
            }
            f.prototype = original.prototype;
            return f;
        }
    }
    //方法装饰器
    static logMethod(target: any, key: string, descriptor: any) {
        var originalMethod = descriptor.value;//保留原方法的引用
        descriptor.value = function (...args: any[]) {
            var a = args.map(a => JSON.stringify(a)).join();//将方法参数转为字符串
            var result = originalMethod.apply(this, args);//执行方法，得到其返回值
            var r = JSON.stringify(result);//将返回值转为字符串
            console.log(`Call:${key}(${a}) => ${r}`, key, target.constructor.name, descriptor);
            return result;
        }
        return descriptor;//返回编辑后的属性描述对象
    }
    //属性装饰器
    static logProperty(target: any, key: string) {
        target[key] = key;
        var _val = target[key];//属性值
        var getter = function () {
            console.log(`Get:${key} => ${_val}`);
            return _val;
        }
        var setter = function (newVal) {
            console.log(`Set:${key} => ${newVal}`);
            _val = newVal;
        }
        //删除属性，在严格模式下，如果对象是不可配置的，将会抛出一个错误。否则返回false
        if (delete target[key]) {
            Object.defineProperty(target, key, {
                get: getter,
                set: setter,
                enumerable: true,
                configurable: true
            })
        }
    }
    //读取通过参数装饰器添加的元数据，在执行时，不在展示所有参数，而是仅打印被装饰的参数
    static readMetadata(target: any, key: string, descriptor: any) {
        var originMethod = descriptor.value;
        descriptor.value = function (...args: any[]) {
            var metadataKey = `_log_${key}_parameters`;
            var indices = target[metadataKey];
            if (Array.isArray(indices)) {
                for (var i = 0; i < args.length; i++) {
                    if (indices.indexOf(i) !== -1) {
                        var arg = args[i];
                        var argStr = JSON.stringify(arg) || arg.toString();
                        console.log(`${key} arg[${i}]:${argStr}`);
                    }
                }
                var result = originMethod.apply(this, args);
                return result;
            }
            return descriptor;
        }
    }
    //参数装饰器
    static addMetadata(target: any, key: string, index: number) {
        var metadataKey = `_log_${key}_parameters`;
        if (Array.isArray(target[metadataKey])) {
            target[metadataKey].push(index);
        } else {
            target[metadataKey] = [index];
        }
    }
}
```

> 在cocos creator脚步中通过@decorator语法糖调用这些装饰器来拓展组件函数，达到打印log目的，而不破坏原有函数或组件的结构

```typescript
// NewClass.ts
// @decorator语法糖拓展组件
import Log from "./Log";

const {ccclass, property} = cc._decorator;

@Log.logClass
@Log.logClass2("带参数的类装饰器")
@ccclass
export default class NewClass extends cc.Component {
    public name: string = "名字"

    @Log.logProperty
    public testName: string = "测试属性标记";

    @property(cc.Label)
    label: cc.Label = null;

    @property
    text: string = 'hello';
    // LIFE-CYCLE CALLBACKS:
    onLoad () {
        this.say("你好");
    }

    @Log.logMethod
    @Log.readMetadata
    say(@Log.addMetadata hello) {
        this.testName = "修改属性标记";
        console.log("hello world" + hello + name + this.testName);
    }
    // update (dt) {}
}
```

> 调试结果:

![img](C:\Users\Administrator\Documents\youdu\14177240-100118-章翔\image\temp\{8f790ef7-5589-4d47-aace-b62588fc98f5}.png)

> 发现通过@decorator简洁的拓展了相关组件，代码复用更加有效简洁

**总结：**

* 了解Typescript中的@语法糖的优点
* 了解cocos官方@ccclass的相关原理
* 了解了装饰器的相关知识

**拓展**

* 我们游戏中日志系统通过装饰器完善。
* 我们消息是否能够通过装饰器重构，语法调用更加简洁。


#### Typescript装饰器和注解

> https://blog.csdn.net/liwusen/article/details/86482476

**类的装饰器**

当装饰函数直接修饰类的时候，装饰函数接受唯一的参数，这个参数就是该被修饰类本身。

```typescript
let temple 
function foo(target){ 
  console.log(target); 
  temple = target;
} 
@foo 
class P{ 
  constructor(){ } 
} 
const p = new P(); 
temple === P //true
```



此外，在修饰类的时候，如果装饰函数有返回值，该返回值会重新定义这个类，也就是说当装饰函数有返回值时，其实是生成了一个新类，该新类通过返回值来定义。

举例来说：


```typescript
function foo(target){
  	return class extends target{
  		name = 'Jony';
  		sayHello(){
     		console.log("Hello "+ this.name)
  		}
    }
}
@foo
class P{
   constructor(){}
}
const p = new P();
p.sayHello(); // 会输出Hello Jony
// 当装饰函数foo有返回值时，实际上P类已经被返回值所代表的新类所代替，因此P的实例p拥有sayHello方法。
```

**类方法的装饰器**

在类的实例函数的装饰器函数第一个参数为类的原型，第二个参数为函数名本身，第三个参数为该函数的描述属性。

```typescript
let temple; 
function log(target, key, descriptor) { 
  console.log(`${key} was called!`); 
  temple = target; 
} 
class P { 
  @log 
  foo() { 
    console.log('Do something'); 
  } 
} 
const p = new P() 
p.foo() 
console.log(P.prototype === temple) //true
// P.prototype === temple(target)可以判断，在类的实例函数的装饰器函数第一个参数为类的原型，第二个参数为函数名本身，第三个参数为该函数的描述属性。
```



类的函数的装饰器函数，依次接受的参数为：

    target：如果修饰的是类的实例函数，那么target就是类的原型。如果修饰的是类的静态函数，那么target就是类本身。
    key： 该函数的函数名。
    descriptor：该函数的描述属性，比如 configurable、value、enumerable等。

**类的属性的装饰器**

装饰函数修饰类的属性时，在类实例化的时候调用属性的装饰函数:

```typescript
function foo(target,name){ 
  console.log("target is",target); 
  console.log("name is",name) 
} 
class P{ 
  @foo name = 'Jony' 
} 
const p = new P(); //会依次输出 target is f P() name is Jony
// 类的属性的装饰器函数接受两个参数，对于静态属性而言，第一个参数是类本身，对于实例属性而言，第一个参数是类的原型，第二个参数是指属性的名字。
```

**类函数参数的装饰器**

类函数的参数装饰器可以修饰类的构建函数中的参数，以及类中其他普通函数中的参数。该装饰器在类的方法被调用的时候执行:

```typescript
function foo(target,key,index){ 
  console.log("target is",target); 
  console.log("key is",key); 
  console.log("index is",index) 
} 
class P{ 
  test(@foo a){ } 
} 
const p = new P(); 
p.test("Hello Jony") // 依次输出 f P() , test , 0 
// 类函数参数的装饰器函数接受三个参数，依次为类本身，类中该被修饰的函数本身，以及被修饰的参数在参数列表中的索引值。
```

修饰函数参数的装饰器函数中的参数含义：

- target： 类本身
- key：该参数所在的函数的函数名
- index： 该参数在函数参数列表中的索引值

> 装饰器可以起到分离复杂逻辑的功能，且使用上极其简单方便。与继承相比，也更加灵活，可以从装饰类，到装饰类函数的参数

#### 注解

> 什么是注解，所谓注解的定义就是：
>
> 为相应的类附加元数据支持。
>
> 所谓元数据可以简单的解释，就是修饰数据的数据，比如一个人有name，age等数据属性，那么name和age这些字段就是为了修饰数据的数据，可以简单的称为元数据。
>
> 元数据简单来说就是可以修饰某些数据的字段。下面给出装饰器和注解的解释和区别：
>
>     装饰器：定义劫持，可以对类，类的方法，类的属性以及类的方法的入参进行修改。不提供元数据的支持。
>     注解：仅提供元数据的支持。
>
> 两者之间的联系：
>
> 通过注解添加元数据，然后在装饰器中获取这些元数据，完成对类、类的方法等等的修改，可以在装饰器中添加元数据的支持，比如可以可以在装饰器工厂函数以及装饰器函数中添加元数据支持等。

**Typescript中的元数据操作**

通过reflect-metadata包来实现对于元数据的操作。首先我们来看reflect-metadata的使用，首先定义使用元数据的函数：

```typescript
const formatMetadataKey = Symbol("format"); 
function format(formatString: string) { 
  return Reflect.metadata(formatMetadataKey, formatString); 
} 
function getFormat(target: any, propertyKey: string) { 
  return Reflect.getMetadata(formatMetadataKey, target, propertyKey); 
}
// 这里的format可以作为装饰器函数的工厂函数，因为format函数返回的是一个装饰器函数，上述的方法定义了元数据Sysmbol(“format”),用Sysmbol的原因是为了防止元数据中的字段重复，而format定义了取元数据中相应字段的功能。
// 使用相应的元数据:
class Greeter { 
  @format("Hello, %s") 
  name: string; 
  constructor(name: string) { 
    this.name = message; 
  } 
  sayHello() { 
    let formatString = getFormat(this, "name"); 
    return formatString.replace("%s", this.name); 
  } 
} 
const g = new Greeter("Jony"); 
console.log(g.sayHello());
```

> 通过装饰器，可以方便的修饰类，以及类的方法，类的属性等，相比于继承而言更加灵活，此外，通过注解的方法，可以在Typescript中引入元数据，实现元编程等。特别是在angularjs、nestjs中，大量使用了注解，特别是nestjs构建了类似于java springMVC式的web框架。

