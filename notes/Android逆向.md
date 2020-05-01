### Android逆向

相关教程可以看吾爱破解网Android破解的教程，里面详细介绍Android破解的入门知识

#### 反编译工具

主要工具：Apktool, dex2jar, JD-GUI

额外工具：IDA Pro, HexEdit

#### Apktool

> 功能：将Apk反编译得到资源文件及`smali`代码，将Jar反编译得到`smali`代码，以及回编译。其中将`dex`文件反编译成`smali`的工具为`baksmali.jar`，回编译`smali`成`dex`的为`smali.jar`

- github: https://github.com/iBotPeaches/Apktool
- website: https://ibotpeaches.github.io/Apktool
- usage: https://ibotpeaches.github.io/Apktool/documentation/
- smali syntax: http://www.netmite.com/android/mydroid/dalvik/docs/dalvik-bytecode.html
- smali/baksmali github : https://github.com/JesusFreke/smali.git

去网站下载appt.exe、apktool.jar最新包、apktool.bat的脚本内容从官网install中复制即可，主要apktool环境变量的配置哦

```
# 反编译
apktool d xxx.apk

# 回编译, 打包文件没有签名的apk，无法安装，需要再打包的文件dist中复制apk出了重新签名
# 下面介绍了java生成签名文件及apk重签名的方法
apktool b xxx 

# 参数
# -r,--no-res             忽略资源文件
# -s,--no-src             忽略代码文件
```

#### JAVA生成签名文件

* 生成keystore文件

```
// abc.keystore 主要改名
keytool -genkey -alias abc.keystore -keyalg RSA -validity 20000 -keystore abc.keystore
```

输入后安装提示输入相关内容即可, 主要提示新的标准签名

* 对apk进行重新签名

```
// abc.keystore xxx_signed.apk xxx.apk 注意这些的替换
jarsigner -verbose -keystore abc.keystore -signedjar xxx_signed.apk xxx.apk abc.keystore
```

#### dex2jar

> 将dex文件反编译成`*.class`集合的jar文件，之后可以使用`JD-GUI`工具查看

- github: https://github.com/pxb1988/dex2jar

常用命令: 

sh d2j-dex2jar.sh classes.dex

d2j-dex2jar.bat classes.dex

#### JD-GUI

> 用于查看`*.class`集合的jar文件，如第三方sdk的jar包，或者dex2jar转换得到的jar文件

#### Smali简介

> 摘自http://blog.csdn.net/wdaming1986/article/details/8299996
> Davlik字节码中，寄存器都是32位的，能够支持任何类型，64位类型（Long/Double）用2个寄存器表示；
> Dalvik字节码有两种类型：原始类型；引用类型（包括对象和数组）

原始类型

| 标记 | 类型                |
| ---- | ------------------- |
| V    | void， 只用于返回值 |
| Z    | boolean             |
| B    | byte                |
| S    | short               |
| C    | char                |
| I    | int                 |
| J    | long(64bits)        |
| F    | float               |
| D    | double(64bits)      |

对象类型

> Lpackage/className;

- L：表示这是一个对象类型
- package：该对象所在的包名
- className： 类的simpleName

数组的表示形式：
[I :表示一个整形的一维数组，相当于java的int[];
对于多维数组，只要增加[ 就行了，[[I = int[][];注：每一维最多255个；

对象数组的表示形式：
[Ljava/lang/String 表示一个String的对象数组；

方法的表示形式：
Lpackage/className;—>methodName(III)Z 详解如下：
Lpackage/className 表示类型
methodName 表示方法名
III 表示参数（这里表示为3个整型参数）
说明：方法的参数是一个接一个的，中间没有隔开；

字段的表示形式：
Lpackage/className;—>fieldName:Ljava/lang/String;
即表示： 包名，字段名和各字段类型

有两种方式指定一个方法中有多少寄存器是可用的：
.registers 指令指定了方法中寄存器的总数
.locals 指令表明了方法中非参寄存器的总数，出现在方法中的第一行

举例：

java源码

```
package com.decompile;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        log("使用私有对象方法，p0是MainActivity.this这个对象实例，p1是第一个参数");

        sLog("使用公有静态方法，p0是第一个参数");
    }

    private void log(Object o) {
        Log.e("private object method", String.valueOf(o));
    }

    public static void sLog(Object o) {
        Log.e("public static method", String.valueOf(o));
    }
    
}
```



smali代码

```
.method private log(Ljava/lang/Object;)V
    .locals 2
    .param p1, "o"    # Ljava/lang/Object;

    .prologue
    const-string v0, "private object method"

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static sLog(Ljava/lang/Object;)V
    .locals 2
    .param p0, "o"    # Ljava/lang/Object;

    .prologue
    const-string v0, "public static method"

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    invoke-super {p0, p1}, Landroid/support/v7/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    const v0, 0x7f04001b

    invoke-virtual {p0, v0}, Lcom/decompile/MainActivity;->setContentView(I)V

    const-string v0, "\u4f7f\u7528\u79c1\u6709\u5bf9\u8c61\u65b9\u6cd5\uff0cp0\u662fMainActivity.this\u8fd9\u4e2a\u5bf9\u8c61\u5b9e\u4f8b\uff0cp1\u662f\u7b2c\u4e00\u4e2a\u53c2\u6570"

    invoke-direct {p0, v0}, Lcom/decompile/MainActivity;->log(Ljava/lang/Object;)V

    const-string v0, "\u4f7f\u7528\u516c\u6709\u9759\u6001\u65b9\u6cd5\uff0cp0\u662f\u7b2c\u4e00\u4e2a\u53c2\u6570"

    invoke-static {v0}, Lcom/decompile/MainActivity;->sLog(Ljava/lang/Object;)V

    return-void
.end method
```



对象方法调用：

```
(invoke-direct|invoke-virtual) {xx, ...params}, Lpackage/className;->methodName(...paramTypes)returnType
```



invoke-direct除了用于对象私有方法，还可以用于对象的初始化
invoke-virtual用于对象公有方法

xx：Lpackage/className的实例
params：为参数列表
paramType：参数列表对应类型
returnType：返回值类型

静态方法调用：

```
invoke-static {...params}, Lpackage/className;->methodName(...paramTypes)returnType
```



invok-static用于调用静态方法
静态方法与对象方法，区别是参数列表第一个参数不是Lpackage/className的实例对象