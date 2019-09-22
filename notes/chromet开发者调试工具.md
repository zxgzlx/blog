### chrome开发者调试工具

> Chrome DevTools开发者工具调试指南
>
> 视频地址：https://www.imooc.com/learn/1164

#### 快捷键

1. 打开最近关闭的状态：cmd+opt+i(mac), ctrl+shift+i(windows)
2. 快速查看DOM或样式：cmd+opt+c(cmd), ctrl+shift+c(windows)
3. 快速进入console查看log运行JavaScript：cmd+opt+j(cmd), ctrl+shift+j(windows)
4. windows下f12

#### Elements调试DOM和CSS

1. 可以通过html、css语法直接在chrome dev-tools中修改调试
2. 可以通过DOM的断点进行调试

#### console和sources调试

1. console.table()可以将复杂json数据表格化
2. console.time()和console.timeEnd()，可以统计一段代码的运行时间
3. 在ide修改后再打印log调试
4. 在ide中加入debugger后，然后在sources中调试
5. 直接在sources中进行断点调试、修改代码调试
6. 用sources中的snippets来辅助调试，可通过添加代码片段导入第三方库调试，也可以通过自定义脚步来辅助调试，例如改变源代码中的一些参数的值。
7. 使用sources中filesystem来直接导入源码调试，只不过要授权chrome读取工程文件，授权后chrome直接就成了编辑器，可进行代码的编写和调试。

#### network调试

1. ctrl+shift+p调取命令行，可以显示各种需要的功能，例如网络功能
2. 在network菜单上ctrl+f，可以直接搜服务器和客户端传递的信息数据
3. network分析文件耗时的时间文件，可合并请求文件
4. network网络模拟调试

#### 客户端存储application面板

1. cookie在chrome中增删查改
2. localstorage和session在chrome中增删查改

#### 移动端、H5页面调试

1. 移动端的手机尺寸调试、以及相关传感器调用（ctrl+shift+p调用命令），有定位、横竖屏、各种角度、重力传感器等
2. 远程调试使用方法

#### 总结

1. 了解了更多 chrome 的知识
2. 可以提高开发甚至测试效率
3. 针对性对游戏性能的优化