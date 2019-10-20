## kotlin 设计模式学习

[TOC]

### 行为型模式

> 在[软件工程](https://zh.wikipedia.org/wiki/軟體工程)中， **行为型模式**为[设计模式](https://zh.wikipedia.org/wiki/设计模式_(计算机))的一种类型，用来识别对象之间的常用交流模式并加以实现。如此，可在进行这些交流活动时增强弹性。

- [责任链模式](https://zh.wikipedia.org/wiki/責任鏈模式)：处理命令物件或将之传到下一个可以处理的物件。

- [命令模式](https://zh.wikipedia.org/wiki/命令模式)：命令物件将动作及参数封装起来。

- "具现化堆叠"：使用堆叠将递回函式转成重复执行。[[1\]](https://zh.wikipedia.org/wiki/行為型模式#cite_note-1)

- [解释器模式](https://zh.wikipedia.org/w/index.php?title=解釋器模式&action=edit&redlink=1)：实作特制化的编程语言以解决一系列特殊的问题。

- [迭代器模式](https://zh.wikipedia.org/wiki/迭代器模式)：迭代器用于存取包含器中元素而不用透露底层实作的方式。

- [调停者模式](https://zh.wikipedia.org/w/index.php?title=調停者模式&action=edit&redlink=1)：对子系统中的界面集面提供一个统一的界面。

- [备忘录模式](https://zh.wikipedia.org/w/index.php?title=備忘錄模式&action=edit&redlink=1)：使一个物件还原到前一个状态的能力（rollback）。

- [空物件模式](https://zh.wikipedia.org/w/index.php?title=空物件模式&action=edit&redlink=1)：扮演预设物件的角色。

- 观察者模式

  ：亦即发行／订阅或事件聆听者。物件注册去聆听由另一个物作所引发的事件。

  - 弱参照模式：将观察者与可观察间的藕合程度。[[2\]](https://zh.wikipedia.org/wiki/行為型模式#cite_note-2)

- [协议栈](https://zh.wikipedia.org/wiki/协议栈)：通讯是由许多封装成阶层式的层所处理。[[3\]](https://zh.wikipedia.org/wiki/行為型模式#cite_note-3)

- [状态模式](https://zh.wikipedia.org/w/index.php?title=狀態模式&action=edit&redlink=1)：在执行可以部分改变物件的一种方法。

- [策略模式](https://zh.wikipedia.org/wiki/策略模式)：在执行时依需求而选择算法。

- [规格模式](https://zh.wikipedia.org/w/index.php?title=規格模式&action=edit&redlink=1)：以布林值的方式来重组事务逻辑。

- [模板方法模式](https://zh.wikipedia.org/wiki/模板方法模式)：描述一个程式的[骨架](https://zh.wikipedia.org/wiki/虛設代碼)。

- [访问者模式](https://zh.wikipedia.org/wiki/訪問者模式): 一种从物件中取出算法的方式。

- 单服务访问者模式：最佳化访问者。使用一次后即行删除。

- 阶层式访问者模式：提供一种方式可以拜访阶层式[数据结构](https://zh.wikipedia.org/wiki/資料結構)如树中的每一个节点。

- 排程任务模式：在特定区时或时间点执行排程任务(用于[即时计算](https://zh.wikipedia.org/w/index.php?title=即時計算&action=edit&redlink=1))。

#### 观察者模式

> **观察者模式**是[软件设计模式](https://zh.wikipedia.org/wiki/軟件設計模式)的一种。在此种模式中，一个目标对象管理所有相依于它的观察者对象，并且在它本身的状态改变时主动发出通知。这通常透过呼叫各观察者所提供的方法来实现。此种模式通常被用来实时事件处理系统。

```kotlin
// 观察者模式Observer
 
// 功能:文本框内容变化时通知其他监听器发生变化
 
// 实例
import kotlin.properties.Delegates
 
interface TextChangedListener {
    fun onTextChanged(newText: String)
}
 
class PrintingTextChangedListener : TextChangedListener {
    override fun onTextChanged(newText: String) = println("Text is changed to: $newText")
}
 
class TextView {
 
    var listener: TextChangedListener? = null
 
    var text: String by Delegates.observable("") { prop, old, new ->
        listener?.onTextChanged(new)
    }
}
 
// 使用
fun main(args: Array<String>) {
    val textView = TextView()
    textView.listener = PrintingTextChangedListener()
    textView.text = "Lorem ipsum"
    textView.text = "dolor sit amet"
}

// 输出
Text is changed <empty> -> Lorem ipsum
Text is changed Lorem ipsum -> dolor sit amet
```

#### 策略模式

> 策略模式作为一种[软件设计模式](https://zh.wikipedia.org/wiki/軟件設計模式)，指对象有某个行为，但是在不同的场景中，该行为有不同的实现算法。比如每个人都要“交个人所得税”，但是“在美国交个人所得税”和“在中国交个人所得税”就有不同的算税方法。
>
> 策略模式：
>
> - 定义了一族算法（业务规则）；
> - 封装了每个算法；
> - 这族的算法可互换代替（interchangeable）。

```kotlin
// 举例
class Printer(private val stringFormatterStrategy: (String) -> String) {

    fun printString(string: String) {
        println(stringFormatterStrategy(string))
    }
}

val lowerCaseFormatter: (String) -> String = { it.toLowerCase() }
val upperCaseFormatter = { it: String -> it.toUpperCase() }

// 使用
fun main(args: Array<String>) {
    val inputString = "LOREM ipsum DOLOR sit amet"

	val lowerCasePrinter = Printer(lowerCaseFormatter)
	lowerCasePrinter.printString(inputString)

	val upperCasePrinter = Printer(upperCaseFormatter)
	upperCasePrinter.printString(inputString)

	val prefixPrinter = Printer { "Prefix: $it" }
	prefixPrinter.printString(inputString)
}

// 输出
lorem ipsum dolor sit amet
LOREM IPSUM DOLOR SIT AMET
Prefix: LOREM ipsum DOLOR sit amet
```



#### 命令模式

> 在[面向对象编程](https://zh.wikipedia.org/wiki/物件導向程式設計)的范畴中，**命令模式**（英语：**Command pattern**）是一种设计模式，它尝试以对象来代表实际行动。命令对象可以把行动(action) 及其参数封装起来，于是这些行动可以被：
>
> - 重复多次
> - 取消（如果该对象有[实现](https://zh.wikipedia.org/w/index.php?title=實作&action=edit&redlink=1)的话）
> - 取消后又再重做
>
> 这些都是现代大型应用程序所必须的功能，即“撤销”及“重复”。除此之外，可以用命令模式来实现的功能例子还有：
>
> - 交易行为
> - 进度列
> - 向导
> - 用户界面按钮及功能表项目
> - 线程 pool
> - 宏收录

```kotlin
// 举例
import java.util.*

interface OrderCommand {
    fun execute()
}

class OrderAddCommand(val id: Long) : OrderCommand {
    override fun execute() = println("Adding order with id: $id")
}

class OrderPayCommand(val id: Long) : OrderCommand {
    override fun execute() = println("Paying for order with id: $id")
}

class CommandProcessor {

    private val queue = ArrayList<OrderCommand>()

    fun addToQueue(orderCommand: OrderCommand): CommandProcessor =
        apply {
            queue.add(orderCommand)
        }

    fun processCommands(): CommandProcessor =
        apply {
            queue.forEach { it.execute() }
            queue.clear()
        }
}

// 使用
fun main(args: Array<String>) {
    CommandProcessor()
    .addToQueue(OrderAddCommand(1L))
    .addToQueue(OrderAddCommand(2L))
    .addToQueue(OrderPayCommand(2L))
    .addToQueue(OrderPayCommand(1L))
    .processCommands()
}

// 输出
Adding order with id: 1
Adding order with id: 2
Paying for order with id: 2
Paying for order with id: 1
```



#### 状态模式

> 当一个对象的内在状态改变时允许改变其行为，这个对象看起来像是改变了其类。
>
> 状态模式主要解决的是当控制一个对象状态的条件表达式过于复杂时的情况。把状态的判断逻辑转移到表示不同状态的一系列类中，可以把复杂的判断逻辑简化

```kotlin
// 举例
sealed class AuthorizationState

object Unauthorized : AuthorizationState()

class Authorized(val userName: String) : AuthorizationState()

class AuthorizationPresenter {

    private var state: AuthorizationState = Unauthorized

    fun loginUser(userLogin: String) {
        state = Authorized(userLogin)
    }

    fun logoutUser() {
        state = Unauthorized
    }

    val isAuthorized: Boolean
        get() = when (state) {
            is Authorized -> true
            is Unauthorized -> false
        }

    val userLogin: String
        get() {
            val state = this.state //val enables smart casting of state
            return when (state) {
                is Authorized -> state.userName
                is Unauthorized -> "Unknown"
            }
        }

    override fun toString() = "User '$userLogin' is logged in: $isAuthorized"
}

// 使用
fun main(args: Array<String>) {
    val authorizationPresenter = AuthorizationPresenter()

	authorizationPresenter.loginUser("admin")
	println(authorizationPresenter)

	authorizationPresenter.logoutUser()
	println(authorizationPresenter)
}

// 输出
User 'admin' is logged in: true
User 'Unknown' is logged in: false
```



#### 责任链模式

> **责任链模式**在[面向对象程式设计](https://zh.wikipedia.org/wiki/物件導向程式設計)里是一种[软件设计模式](https://zh.wikipedia.org/wiki/软件设计模式)，它包含了一些命令对象和一系列的处理对象。每一个处理对象决定它能处理哪些命令对象，它也知道如何将它不能处理的命令对象传递给该链中的下一个处理对象。该模式还描述了往该处理链的末尾添加新的处理对象的方法。

```kotlin
// 举例
interface HeadersChain {
    fun addHeader(inputHeader: String): String
}

class AuthenticationHeader(val token: String?, var next: HeadersChain? = null) : HeadersChain {

    override fun addHeader(inputHeader: String): String {
        token ?: throw IllegalStateException("Token should be not null")
        return inputHeader + "Authorization: Bearer $token\n"
            .let { next?.addHeader(it) ?: it }
    }
}

class ContentTypeHeader(val contentType: String, var next: HeadersChain? = null) : HeadersChain {

    override fun addHeader(inputHeader: String): String =
        inputHeader + "ContentType: $contentType\n"
            .let { next?.addHeader(it) ?: it }
}

class BodyPayload(val body: String, var next: HeadersChain? = null) : HeadersChain {

    override fun addHeader(inputHeader: String): String =
        inputHeader + "$body"
            .let { next?.addHeader(it) ?: it }
}

// 使用
fun main(args: Array<String>) {
    //create chain elements
	val authenticationHeader = AuthenticationHeader("123456")
	val contentTypeHeader = ContentTypeHeader("json")
	val messageBody = BodyPayload("Body:\n{\n\"username\"=\"dbacinski\"\n}")

	//construct chain
	authenticationHeader.next = contentTypeHeader
	contentTypeHeader.next = messageBody

	//execute chain
	val messageWithAuthentication =
    	authenticationHeader.addHeader("Headers with Authentication:\n")
	println(messageWithAuthentication)

	val messageWithoutAuth =
    	contentTypeHeader.addHeader("Headers:\n")
	println(messageWithoutAuth)
}

// 输出
Headers with Authentication:
Authorization: Bearer 123456
ContentType: json
Body:
{
"username"="dbacinski"
}

Headers:
ContentType: json
Body:
{
"username"="dbacinski"
}
```



#### 访问者模式

> 访问者模式是一种将算法与对象结构分离的[软件设计模式](https://zh.wikipedia.org/wiki/软件设计模式)。
>
> 这个模式的基本想法如下：首先我们拥有一个由许多[对象](https://zh.wikipedia.org/wiki/对象_(计算机))构成的对象结构，这些对象的[类](https://zh.wikipedia.org/w/index.php?title=类_(计算机)&action=edit&redlink=1)都拥有一个accept[方法](https://zh.wikipedia.org/wiki/方法_(计算机))用来接受访问者对象；访问者是一个接口，它拥有一个visit方法，这个方法对访问到的对象结构中不同类型的元素作出不同的反应；在对象结构的一次访问过程中，我们遍历整个对象结构，对每一个元素都实施accept方法，在每一个元素的accept方法中[回调](https://zh.wikipedia.org/wiki/回调)访问者的visit方法，从而使访问者得以处理对象结构的每一个元素。我们可以针对对象结构设计不同的实在的访问者类来完成不同的操作。

```kotlin
// 举例
interface ReportVisitable {
    fun accept(visitor: ReportVisitor)
}

class FixedPriceContract(val costPerYear: Long) : ReportVisitable {
    override fun accept(visitor: ReportVisitor) = visitor.visit(this)
}

class TimeAndMaterialsContract(val costPerHour: Long, val hours: Long) : ReportVisitable {
    override fun accept(visitor: ReportVisitor) = visitor.visit(this)
}

class SupportContract(val costPerMonth: Long) : ReportVisitable {
    override fun accept(visitor: ReportVisitor) = visitor.visit(this)
}

interface ReportVisitor {
    fun visit(contract: FixedPriceContract)
    fun visit(contract: TimeAndMaterialsContract)
    fun visit(contract: SupportContract)
}

class MonthlyCostReportVisitor(var monthlyCost: Long = 0) : ReportVisitor {
    override fun visit(contract: FixedPriceContract) {
        monthlyCost += contract.costPerYear / 12
    }

    override fun visit(contract: TimeAndMaterialsContract) {
        monthlyCost += contract.costPerHour * contract.hours
    }

    override fun visit(contract: SupportContract) {
        monthlyCost += contract.costPerMonth
    }
}

class YearlyReportVisitor(var yearlyCost: Long = 0) : ReportVisitor {
    override fun visit(contract: FixedPriceContract) {
        yearlyCost += contract.costPerYear
    }

    override fun visit(contract: TimeAndMaterialsContract) {
        yearlyCost += contract.costPerHour * contract.hours
    }

    override fun visit(contract: SupportContract) {
        yearlyCost += contract.costPerMonth * 12
    }
}

// 使用
fun main(args: Array<String>) {
    val projectAlpha = FixedPriceContract(costPerYear = 10000)
	val projectBeta = SupportContract(costPerMonth = 500)
	val projectGamma = TimeAndMaterialsContract(hours = 150, costPerHour = 10)
	val projectKappa = TimeAndMaterialsContract(hours = 50, costPerHour = 50)

	val projects = arrayOf(projectAlpha, projectBeta, projectGamma, projectKappa)

	val monthlyCostReportVisitor = MonthlyCostReportVisitor()
	projects.forEach { it.accept(monthlyCostReportVisitor) }
	println("Monthly cost: ${monthlyCostReportVisitor.monthlyCost}")

	val yearlyReportVisitor = YearlyReportVisitor()
	projects.forEach { it.accept(yearlyReportVisitor) }
	println("Yearly cost: ${yearlyReportVisitor.yearlyCost}")
}

// 打印
Monthly cost: 5333
Yearly cost: 20000
```



#### 中介者模式

> 中介者模式是软件设计模式的一种，用于模块间解耦，通过避免对象互相显式的指向对方从而降低耦合。

```kotlin
// 举例
class ChatUser(private val mediator: ChatMediator, val name: String) {
    fun send(msg: String) {
        println("$name: Sending Message= $msg")
        mediator.sendMessage(msg, this)
    }

    fun receive(msg: String) {
        println("$name: Message received: $msg")
    }
}

class ChatMediator {

    private val users: MutableList<ChatUser> = ArrayList()

    fun sendMessage(msg: String, user: ChatUser) {
        users
            .filter { it != user }
            .forEach {
                it.receive(msg)
            }
    }

    fun addUser(user: ChatUser): ChatMediator =
        apply { users.add(user) }

}

// 使用
fun main(args: Array<String>) {
    val mediator = ChatMediator()
	val john = ChatUser(mediator, "John")

	mediator
    	.addUser(ChatUser(mediator, "Alice"))
    	.addUser(ChatUser(mediator, "Bob"))
    	.addUser(john)
	john.send("Hi everyone!")
}

// 输出
John: Sending Message= Hi everyone!
Alice: Message received: Hi everyone!
Bob: Message received: Hi everyone!
```



#### 备忘录模式

> 备忘录模式是一种软件[设计模式](https://baike.baidu.com/item/设计模式)：在不破坏封闭的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样以后就可将该对象恢复到原先保存的状态。

```kotlin
// 举例
data class Memento(val state: String)

class Originator(var state: String) {

    fun createMemento(): Memento {
        return Memento(state)
    }

    fun restore(memento: Memento) {
        state = memento.state
    }
}

class CareTaker {
    private val mementoList = ArrayList<Memento>()

    fun saveState(state: Memento) {
        mementoList.add(state)
    }

    fun restore(index: Int): Memento {
        return mementoList[index]
    }
}

// 使用
fun main(args: Array<String>) {
    val originator = Originator("initial state")
	val careTaker = CareTaker()
	careTaker.saveState(originator.createMemento())

	originator.state = "State #1"
	originator.state = "State #2"
	careTaker.saveState(originator.createMemento())

	originator.state = "State #3"
	println("Current State: " + originator.state)
	assertThat(originator.state).isEqualTo("State #3")

	originator.restore(careTaker.restore(1))
	println("Second saved state: " + originator.state)
	assertThat(originator.state).isEqualTo("State #2")

	originator.restore(careTaker.restore(0))
	println("First saved state: " + originator.state)
}

// 输出
Current State: State #3
Second saved state: State #2
First saved state: initial state
```



### 创建型模式

> **创建型模式**是处理[对象](https://zh.wikipedia.org/wiki/对象_(计算机科学))创建的[设计模式](https://zh.wikipedia.org/wiki/设计模式_(计算机))，试图根据实际情况使用合适的方式创建对象。基本的对象创建方式可能会导致设计上的问题，或增加设计的复杂度。创建型模式通过以某种方式控制对象的创建来解决问题。
>
> 创建型模式由两个主导思想构成。一是将系统使用的具体类封装起来，二是隐藏这些具体类的实例创建和结合的方式。[[1\]](https://zh.wikipedia.org/wiki/創建型模式#cite_note-1)
>
> 创建型模式又分为对象创建型模式和类创建型模式。对象创建型模式处理对象的创建，类创建型模式处理类的创建。详细地说，对象创建型模式把对象创建的一部分推迟到另一个对象中，而类创建型模式将它对象的创建推迟到子类中。[[2\]](https://zh.wikipedia.org/wiki/創建型模式#cite_note-2)

- [抽象工厂模式](https://zh.wikipedia.org/wiki/抽象工厂模式)，提供一个创建相关或依赖对象的接口，而不指定对象的具体类。
- [工厂方法模式](https://zh.wikipedia.org/wiki/工厂方法模式)，允许一个类的实例化推迟到子类中进行。
- [生成器模式](https://zh.wikipedia.org/wiki/生成器模式)，将一个复杂对象的创建与它的表示分离，使同样的创建过程可以创建不同的表示。
- [延迟初始化模式](https://zh.wikipedia.org/wiki/延迟初始化模式)，将对象的创建，某个值的计算，或者其他代价较高的过程推迟到它第一次需要时进行。
- [对象池模式](https://zh.wikipedia.org/wiki/对象池模式)，通过回收不再使用的对象，避免创建和销毁对象时代价高昂的获取和释放资源的过程。
- [原型模式](https://zh.wikipedia.org/wiki/原型模式)，使用原型实例指定要创建的对象类型，通过复制原型创建新的对象。
- [单例模式](https://zh.wikipedia.org/wiki/单例模式)，保证一个类只有一个实例，并且提供对这个实例的全局访问方式。

#### 建造者模式

> 它可以将复杂对象的建造过程抽象出来（抽象类别），使这个抽象过程的不同实现方法可以构造出不同表现（属性）的对象。
>
> - 当创建复杂对象的算法应该独立于该对象的组成部分以及它们的装配方式时；
> - 当构造过程必须允许被构造的对象有不同的表示时。

```kotlin
// 举例
// Let's assume that Dialog class is provided by external library.
// We have only access to Dialog public interface which cannot be changed.

class Dialog() {

    fun showTitle() = println("showing title")

    fun setTitle(text: String) = println("setting title text $text")

    fun setTitleColor(color: String) = println("setting title color $color")

    fun showMessage() = println("showing message")

    fun setMessage(text: String) = println("setting message $text")

    fun setMessageColor(color: String) = println("setting message color $color")

    fun showImage(bitmapBytes: ByteArray) = println("showing image with size ${bitmapBytes.size}")

    fun show() = println("showing dialog $this")
}

//Builder:
class DialogBuilder() {
    constructor(init: DialogBuilder.() -> Unit) : this() {
        init()
    }

    private var titleHolder: TextView? = null
    private var messageHolder: TextView? = null
    private var imageHolder: File? = null

    fun title(init: TextView.() -> Unit) {
        titleHolder = TextView().apply { init() }
    }

    fun message(init: TextView.() -> Unit) {
        messageHolder = TextView().apply { init() }
    }

    fun image(init: () -> File) {
        imageHolder = init()
    }

    fun build(): Dialog {
        val dialog = Dialog()

        titleHolder?.apply {
            dialog.setTitle(text)
            dialog.setTitleColor(color)
            dialog.showTitle()
        }

        messageHolder?.apply {
            dialog.setMessage(text)
            dialog.setMessageColor(color)
            dialog.showMessage()
        }

        imageHolder?.apply {
            dialog.showImage(readBytes())
        }

        return dialog
    }

    class TextView {
        var text: String = ""
        var color: String = "#00000"
    }
}

// 使用
fun main(args: Array<String>) {
    //Function that creates dialog builder and builds Dialog
	fun dialog(init: DialogBuilder.() -> Unit): Dialog {
    	return DialogBuilder(init).build()
	}

	val dialog: Dialog = dialog {
		title {
    		text = "Dialog Title"
    	}
    	message {
        	text = "Dialog Message"
        	color = "#333333"
    	}
    	image {
        	File.createTempFile("image", "jpg")
    	}
	}

	dialog.show()
}

// 输出
setting title text Dialog Title
setting title color #00000
showing title
setting message Dialog Message
setting message color #333333
showing message
showing image with size 0
showing dialog Dialog@5f184fc6
```



#### 工厂方法模式

> 就像其他[创建型模式](https://zh.wikipedia.org/wiki/創建型模式)一样，它也是处理在不指定[对象](https://zh.wikipedia.org/wiki/对象_(计算机科学))具体[类型](https://zh.wikipedia.org/wiki/类_(计算机科学))的情况下创建对象的问题。工厂方法模式的实质是“定义一个创建对象的接口，但让实现这个接口的类来决定实例化哪个类。工厂方法让类的实例化推迟到子类中进行。”[[1\]](https://zh.wikipedia.org/wiki/工厂方法#cite_note-1)
>
> 创建一个对象常常需要复杂的过程，所以不适合包含在一个复合对象中。创建对象可能会导致大量的重复代码，可能会需要复合对象访问不到的信息，也可能提供不了足够级别的抽象，还可能并不是复合对象概念的一部分。工厂方法模式通过定义一个单独的创建对象的方法来解决这些问题。由[子类](https://zh.wikipedia.org/wiki/子类)实现这个方法来创建具体类型的对象。
>
> 对象创建中的有些过程包括决定创建哪个对象、管理对象的生命周期，以及管理特定对象的创建和销毁的概念。

```kotlin
// 举例
interface Currency {
    val code: String
}

class Euro(override val code: String = "EUR") : Currency
class UnitedStatesDollar(override val code: String = "USD") : Currency

enum class Country {
    UnitedStates, Spain, UK, Greece
}

class CurrencyFactory {
    fun currencyForCountry(country: Country): Currency? {
        return when (country) {
            Country.Spain, Country.Greece -> Euro()
            Country.UnitedStates          -> UnitedStatesDollar()
            else                          -> null
                }
    }
}

// 使用
fun main(args: Array<String>) {
    val noCurrencyCode = "No Currency Code Available"

	val greeceCode = CurrencyFactory().currencyForCountry(Country.Greece)?.code ?: 		noCurrencyCode
	println("Greece currency: $greeceCode")

	val usCode = CurrencyFactory().currencyForCountry(Country.UnitedStates)?.code ?: noCurrencyCode
	println("US currency: $usCode")

	val ukCode = CurrencyFactory().currencyForCountry(Country.UK)?.code ?: noCurrencyCode
	println("UK currency: $ukCode")
}

// 输出
Greece currency: EUR
US currency: USD
UK currency: No Currency Code Available
```



#### 单例模式

> 在应用这个模式时，单例对象的[类](https://zh.wikipedia.org/wiki/类_(计算机科学))必须保证只有一个实例存在。许多时候整个系统只需要拥有一个的全局[对象](https://zh.wikipedia.org/wiki/对象)，这样有利于我们协调系统整体的行为。比如在某个[服务器](https://zh.wikipedia.org/wiki/服务器)程序中，该服务器的配置信息存放在一个[文件](https://zh.wikipedia.org/wiki/文件)中，这些配置数据由一个单例对象统一读取，然后服务[进程](https://zh.wikipedia.org/wiki/进程)中的其他对象再通过这个单例对象获取这些配置信息。这种方式简化了在复杂环境下的配置管理。
>
> 实现单例模式的思路是：一个类能返回对象一个引用(永远是同一个)和一个获得该实例的方法（必须是静态方法，通常使用getInstance这个名称）；当我们调用这个方法时，如果类持有的引用不为空就返回这个引用，如果类保持的引用为空就创建该类的实例并将实例的引用赋予该类保持的引用；同时我们还将该类的[构造函数](https://zh.wikipedia.org/wiki/构造函数)定义为私有方法，这样其他处的代码就无法通过调用该类的构造函数来实例化该类的对象，只有通过该类提供的静态方法来得到该类的唯一实例。
>
> 单例模式在[多线程](https://zh.wikipedia.org/wiki/线程)的应用场合下必须小心使用。如果当唯一实例尚未创建时，有两个线程同时调用创建方法，那么它们同时没有检测到唯一实例的存在，从而同时各自创建了一个实例，这样就有两个实例被构造出来，从而违反了单例模式中实例唯一的原则。 解决这个问题的办法是为指示类是否已经实例化的变量提供一个互斥锁(虽然这样会降低效率)。
>
> 通常单例模式在[Java语言](https://zh.wikipedia.org/wiki/Java语言)中，有两种构建方式：
>
> - 懒汉方式。指全局的单例实例在第一次被使用时构建。
> - 饿汉方式。指全局的单例实例在类装载时构建。

```kotlin
// 举例
object PrinterDriver {
    init {
        println("Initializing with object: $this")
    }

    fun print() = println("Printing with object: $this")
}

// 使用
fun main(args: Array<String>) {
    println("Start")
	PrinterDriver.print()
	PrinterDriver.print()
}

// 输出
Start
Initializing with object: PrinterDriver@6ff3c5b5
Printing with object: PrinterDriver@6ff3c5b5
Printing with object: PrinterDriver@6ff3c5b5
```



#### 抽象工厂

> **抽象工厂模式**（英语：**Abstract factory pattern**）是一种软件开发[设计模式](https://zh.wikipedia.org/wiki/设计模式_(计算机))。抽象工厂模式提供了一种方式，可以将一组具有同一主题的单独的[工厂](https://zh.wikipedia.org/wiki/工厂方法)封装起来。在正常使用中，客户端程序需要创建抽象工厂的具体实现，然后使用抽象工厂作为[接口](https://zh.wikipedia.org/w/index.php?title=接口_(资讯科技)&action=edit&redlink=1)来创建这一主题的具体对象。客户端程序不需要知道（或关心）它从这些内部的工厂方法中获得对象的具体类型，因为客户端程序仅使用这些对象的通用接口。抽象工厂模式将一组对象的实现细节与他们的一般使用分离开来。
>
> 举个例子来说，比如一个抽象工厂类叫做`DocumentCreator`（文档创建器），此类提供创建若干种产品的接口，包括`createLetter()`（创建信件）和`createResume()`（创建简历）。其中，`createLetter()`返回一个`Letter`（信件），`createResume()`返回一个`Resume`（简历）。系统中还有一些`DocumentCreator`的具体实现类，包括`FancyDocumentCreator`和`ModernDocumentCreator`。这两个类对`DocumentCreator`的两个方法分别有不同的实现，用来创建不同的“信件”和“简历”（用`FancyDocumentCreator`的实例可以创建`FancyLetter`和`FancyResume`，用`ModernDocumentCreator`的实例可以创建`ModernLetter`和`ModernResume`）。这些具体的“信件”和“简历”类均继承自[抽象类](https://zh.wikipedia.org/w/index.php?title=抽象类&action=edit&redlink=1)，即`Letter`和`Resume`类。客户端需要创建“信件”或“简历”时，先要得到一个合适的`DocumentCreator`实例，然后调用它的方法。一个工厂中创建的每个对象都是同一个主题的（“fancy”或者“modern”）。客户端程序只需要知道得到的对象是“信件”或者“简历”，而不需要知道具体的主题，因此客户端程序从抽象工厂`DocumentCreator`中得到了`Letter`或`Resume`类的引用，而不是具体类的对象引用。
>
> “工厂”是创建产品（对象）的地方，其目的是将产品的创建与产品的使用分离。抽象工厂模式的目的，是将若干抽象产品的接口与不同主题产品的具体实现分离开。这样就能在增加新的具体工厂的时候，不用修改引用抽象工厂的客户端代码。
>
> 使用抽象工厂模式，能够在具体工厂变化的时候，不用修改使用工厂的客户端代码，甚至是在[运行时](https://zh.wikipedia.org/wiki/运行时)。然而，使用这种模式或者相似的设计模式，可能给编写代码带来不必要的复杂性和额外的工作。正确使用设计模式能够抵消这样的“额外工作”。

```kotlin
// 举例
interface Plant

class OrangePlant : Plant

class ApplePlant : Plant

abstract class PlantFactory {
    abstract fun makePlant(): Plant

    companion object {
        inline fun <reified T : Plant> createFactory(): PlantFactory = when (T::class) {
            OrangePlant::class -> OrangeFactory()
            ApplePlant::class  -> AppleFactory()
            else               -> throw IllegalArgumentException()
        }
    }
}

class AppleFactory : PlantFactory() {
    override fun makePlant(): Plant = ApplePlant()
}

class OrangeFactory : PlantFactory() {
    override fun makePlant(): Plant = OrangePlant()
}

// 使用
fun main(args: Array<String>) {
    val plantFactory = PlantFactory.createFactory<OrangePlant>()
	val plant = plantFactory.makePlant()
	println("Created plant: $plant")
}

// 输出
Created plant: OrangePlant@4f023edb
```



### 结构型模式

> 借由一以贯之的方式来了解元件间的关系，以简化设计。

- 适配器模式

  ：将一个物件的界面'转接'成当事人预期的样子。

  - 翻新界面模式[[1\]](https://zh.wikipedia.org/wiki/結構型模式#cite_note-1)[[2\]](https://zh.wikipedia.org/wiki/結構型模式#cite_note-2): 同时使用多个类别的界面的适配器。
  - 适配器导管：因除错目的而使用多个适配器。[[3\]](https://zh.wikipedia.org/wiki/結構型模式#cite_note-3)

- [聚集模式](https://zh.wikipedia.org/w/index.php?title=聚集模式&action=edit&redlink=1)：一种[组合模式](https://zh.wikipedia.org/w/index.php?title=組合模式&action=edit&redlink=1)的版本，包含用于聚集子成员的成员函式。

- 桥接模式

  ：将一个抽象与实现解耦，以便两者可以独立的变化。

  - 墓碑模式：一种中介的查询物件，包含物件的实际位址。[[4\]](https://zh.wikipedia.org/wiki/結構型模式#cite_note-4)

- [组合模式](https://zh.wikipedia.org/w/index.php?title=組合模式&action=edit&redlink=1)：树状结构的物件，每个物件有相同的界面

- [修饰模式](https://zh.wikipedia.org/wiki/修饰模式)：对一个执行的类别，若使用继承方式加上新功能可能会新类别的数量呈指数型地增加，可使用此模式来解决。

- 扩充模式：亦即框架，将复杂的程式码隐藏在简单的界面后

- [外观模式](https://zh.wikipedia.org/wiki/外觀模式)：对于已有的界面建立一个简化的界面以简化使用共通任务。

- [享元模式](https://zh.wikipedia.org/wiki/享元模式)：通过共享以便有效的支持大量小颗粒对象。

- [代理模式](https://zh.wikipedia.org/wiki/代理模式)：为其他对象提供一个代理以控制对这个对象的访问。

- 导线及过滤器模式：一串的处理者，其中每个处理者的输出是下一个的输入

- 私有类别资料模式：限制存取者／修改者的存取。

#### 适配器模式

> **适配器模式**（英语：adapter pattern）有时候也称包装样式或者包装(wrapper)。将一个[类](https://zh.wikipedia.org/wiki/类_(计算机科学))的接口转接成用户所期待的。一个适配使得因接口不兼容而不能在一起工作的类能在一起工作，做法是将类自己的接口包裹在一个已存在的类中。

```kotlin
// 举例
interface Temperature {
    var temperature: Double
}

class CelsiusTemperature(override var temperature: Double) : Temperature

class FahrenheitTemperature(var celsiusTemperature: CelsiusTemperature) : Temperature {

    override var temperature: Double
        get() = convertCelsiusToFahrenheit(celsiusTemperature.temperature)
        set(temperatureInF) {
            celsiusTemperature.temperature = convertFahrenheitToCelsius(temperatureInF)
        }

    private fun convertFahrenheitToCelsius(f: Double): Double = (f - 32) * 5 / 9

    private fun convertCelsiusToFahrenheit(c: Double): Double = (c * 9 / 5) + 32
}

// 使用
fun main(args: Array<String>) {
    val celsiusTemperature = CelsiusTemperature(0.0)
	val fahrenheitTemperature = FahrenheitTemperature(celsiusTemperature)

	celsiusTemperature.temperature = 36.6
	println("${celsiusTemperature.temperature} C -> ${fahrenheitTemperature.temperature} F")

	fahrenheitTemperature.temperature = 100.0
	println("${fahrenheitTemperature.temperature} F -> ${celsiusTemperature.temperature} C")
}

// 输出
36.6 C -> 97.88000000000001 F
100.0 F -> 37.77777777777778 C
```



#### 装饰器模式

> 一种动态地往一个类中添加新的行为的[设计模式](https://zh.wikipedia.org/wiki/软件设计模式)。就功能而言，修饰模式相比生成[子类](https://zh.wikipedia.org/wiki/子类)更为灵活，这样可以给某个对象而不是整个类添加一些功能。[[1\]](https://zh.wikipedia.org/wiki/修饰模式#cite_note-1)
>
> 通过使用修饰模式，可以在运行时扩充一个类的功能。原理是：增加一个修饰类包裹原来的类，包裹的方式一般是通过在将原来的对象作为修饰类的构造函数的参数。装饰类实现新的功能，但是，在不需要用到新功能的地方，它可以直接调用原来的类中的方法。修饰类必须和原来的类有相同的接口。
>
> 修饰模式是类继承的另外一种选择。类继承在编译时候增加行为，而装饰模式是在运行时增加行为。
>
> 当有几个相互独立的功能需要扩充时，这个区别就变得很重要。在有些面向对象的编程语言中，类不能在运行时被创建，通常在设计的时候也不能预测到有哪几种功能组合。这就意味着要为每一种组合创建一个新类。相反，修饰模式是面向运行时候的对象实例的,这样就可以在运行时根据需要进行组合。一个修饰模式的示例是JAVA里的[Java I/O Streams](https://zh.wikipedia.org/w/index.php?title=Java_Platform,_Standard_Edition&action=edit&redlink=1)的实现。

```kotlin
// 举例
interface CoffeeMachine {
    fun makeSmallCoffee()
    fun makeLargeCoffee()
}

class NormalCoffeeMachine : CoffeeMachine {
    override fun makeSmallCoffee() = println("Normal: Making small coffee")

    override fun makeLargeCoffee() = println("Normal: Making large coffee")
}

//Decorator:
class EnhancedCoffeeMachine(val coffeeMachine: CoffeeMachine) : CoffeeMachine by coffeeMachine {

    // overriding behaviour
    override fun makeLargeCoffee() {
        println("Enhanced: Making large coffee")
        coffeeMachine.makeLargeCoffee()
    }

    // extended behaviour
    fun makeCoffeeWithMilk() {
        println("Enhanced: Making coffee with milk")
        coffeeMachine.makeSmallCoffee()
        println("Enhanced: Adding milk")
    }
}

// 使用
fun main(args: Array<String>) {
    val normalMachine = NormalCoffeeMachine()
    val enhancedMachine = EnhancedCoffeeMachine(normalMachine)

    // non-overridden behaviour
    enhancedMachine.makeSmallCoffee()
    // overriding behaviour
    enhancedMachine.makeLargeCoffee()
    // extended behaviour
    enhancedMachine.makeCoffeeWithMilk()
}

// 输出
Normal: Making small coffee

Enhanced: Making large coffee
Normal: Making large coffee

Enhanced: Making coffee with milk
Normal: Making small coffee
Enhanced: Adding milk
```



#### 外观模式

> 它为子系统中的一组接口提供一个统一的高层接口，使得子系统更容易使用。

```kotlin
// 举例
class ComplexSystemStore(val filePath: String) {

    init {
        println("Reading data from file: $filePath")
    }

    val store = HashMap<String, String>()

    fun store(key: String, payload: String) {
        store.put(key, payload)
    }

    fun read(key: String): String = store[key] ?: ""

    fun commit() = println("Storing cached data: $store to file: $filePath")
}

data class User(val login: String)

//Facade:
class UserRepository {
    val systemPreferences = ComplexSystemStore("/data/default.prefs")

    fun save(user: User) {
        systemPreferences.store("USER_KEY", user.login)
        systemPreferences.commit()
    }

    fun findFirst(): User = User(systemPreferences.read("USER_KEY"))
}

// 使用
fun main(args: Array<String>) {
	val userRepository = UserRepository()
	val user = User("dbacinski")
	userRepository.save(user)
	val resultUser = userRepository.findFirst()
	println("Found stored user: $resultUser")
}

// 输出
Reading data from file: /data/default.prefs
Storing cached data: {USER_KEY=dbacinski} to file: /data/default.prefs
Found stored user: User(login=dbacinski)
```



#### 代理模式

> 是指一个类别可以作为其它东西的接口。代理者可以作任何东西的接口：网络连接、存储器中的大对象、文件或其它昂贵或无法复制的资源。
>
> 著名的代理模式例子为[引用计数](https://zh.wikipedia.org/wiki/參照計數)（英语：reference counting）指针对象。
>
> 当一个复杂对象的多份副本须存在时，代理模式可以结合[享元模式](https://zh.wikipedia.org/wiki/享元模式)以减少存储器用量。典型作法是创建一个复杂对象及多个代理者，每个代理者会引用到原本的复杂对象。而作用在代理者的运算会转送到原本对象。一旦所有的代理者都不存在时，复杂对象会被移除。

```kotlin
// 举例
interface File {
    fun read(name: String)
}

class NormalFile : File {
    override fun read(name: String) = println("Reading file: $name")
}

//Proxy:
class SecuredFile : File {
    val normalFile = NormalFile()
    var password: String = ""

    override fun read(name: String) {
        if (password == "secret") {
            println("Password is correct: $password")
            normalFile.read(name)
        } else {
            println("Incorrect password. Access denied!")
        }
    }
}

// 使用
fun main(args: Array<String>) {
    val securedFile = SecuredFile()
	securedFile.read("readme.md")

	securedFile.password = "secret"
	securedFile.read("readme.md")
}

// 输出
Incorrect password. Access denied!
Password is correct: secret
Reading file: readme.md
```



#### 组合模式

> 组合模式，将对象组合成树形结构以表示“部分-整体”的层次结构，组合模式使得用户对单个对象和组合对象的使用具有一致性。掌握组合模式的重点是要理解清楚 “部分/整体” 还有 ”单个对象“ 与 "组合对象" 的含义。
>
> 组合模式可以让客户端像修改配置文件一样简单的完成本来需要流程控制语句来完成的功能。
>
> 经典案例：系统目录结构，网站导航结构等。 [1] 

```kotlin
// 举例
open class Equipment(private var price: Int, private var name: String) {
    open fun getPrice(): Int = price
}


/*
[composite]
*/

open class Composite(name: String) : Equipment(0, name) {
    val equipments = ArrayList<Equipment>()

    fun add(equipment: Equipment) {
        this.equipments.add(equipment);
    }

    override fun getPrice(): Int {
        return equipments.map { it -> it.getPrice() }.sum()
    }
}


/*
 leafs
*/

class Cabbinet : Composite("cabbinet")
class FloppyDisk : Equipment(70, "Floppy Disk")
class HardDrive : Equipment(250, "Hard Drive")
class Memory : Equipment(280, "Memory")

// 使用
fun main(args: Array<String>) {
    var cabbinet = Cabbinet()
	cabbinet.add(FloppyDisk())
	cabbinet.add(HardDrive())
	cabbinet.add(Memory())
	println(cabbinet.getPrice())
}

// 输出
600
```

