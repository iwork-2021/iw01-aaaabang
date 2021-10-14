# IOS-hw1 Calculator

> 姓名：林芳麒
>
> 学号：191220057



### 设计目标

仿照Apple官方iOS中的计算器编写一个自己的计算器App，要求（利用Autolayout技术）支持竖屏（portrait）和横屏（landscape）两种使用模型。



### 目前进度

所有功能键都已实现，并实现了多步计算，整体还原了ios官方计算器。



### 设计结构

**（一）界面布局**

输入框使用label控件，操作符和数字按钮使用button控件。二者分别用Stack View封装，再整合到APP的全布局Stack View（fill proportionally)中。

布局总分为上下两部分，输入框和用户键盘。用户键盘又分为左右布局两部分，左边是横屏状态下才显示的特殊操作符区，右边是横竖屏都显示的通用键盘。竖屏时特殊操作符区的Stack View采用Hidden模式。



**（二）数据结构**

采用MVC框架，

**Controller**中设置触发各种按钮的接口，分为数字、操作符、Rad、2nd四个接口，按下数字、Rad、2nd接口更新**View**界面，按下操作符进入**Model**执行计算后结果返回给**Controller**再更新**View**。

**Model**中类`Calculator`实现计算器功能。

​	1.枚举操作符类型Constant、UnaryOp、EqualOp、BinaryOp

​	2.操作符及其对应函数使用字典`operations`存储

​	3.核心函数`performOnOperation`执行计算并返回结果给**Controller**



### 功能实现

**一）数字和操作符的触发函数与控件进行连接。**

按下触发对应操作，一旦选中操作一定会执行（包括双目操作符），简单

——————————version 1.0 @date10.11————————————————



**二）用字典存储操作符及操作符对应的功能函数，按下操作符button后触发其函数，进入Calculator计算模式。**

1.简单计算“+”“-”“x”"/"等，实现单步计算

2.实现AC和C功能

> 当选中双目操作符，之后按下“C”，只是取消了按下“C”前的digitOnDisplay数，再按一次“AC“，才彻底清除当前操作符栈。

3.实现mc、m+、m-、mr存储器功能

——————————version 1.0 @date10.11————————————————

4.实现多步计算，“1+1”后再按下“+”，结果展示“2”

5.Rad/Deg模式切换

6.实现“(”“)”多层嵌套处理

> 设计一个waitingPendingOp栈（swift中无栈集合，用数组Array模拟实现），每遇到一个“(”将当前pendingOp压栈，若遇到“)”则将栈中最后一个pendingOp弹出，并显示该对括号中表达式的值。

7.实现2nd切换模式

——————————version 1.1@date10.13————————————————



**三）结果输出打印**

输出框Label 连接`UILabel`变量`displayLabel`

`String`变量`digitOnDisplay`

——————————version 1.0 @date10.11————————————————

改进：功能键EE的输出特殊处理

> EE双目操作符按下后屏幕显示* e 0 ，“0”是下一步即将键入操作数，最后按下“=”或其他操作符才显示结果。如果直接按下其他操作符，右操作数将默认是0。

——————————version 1.1@date10.13————————————————





#### 问题：

1.在Calculator类定义一个var变量memory作为存储器，但无法在类中的其他变量中使用memory

解决办法：将memory在类外声明，定义成全局变量。

2.设置"mr": Operation.Constant(memory),在performOnOperation()调用`case .Constant(let value):`，value如何都读不出memory的值，value值一直是0。

原因尚未得知，解决办法：将mr操作定义为UnaryOp（memory），将memory的值作为result返回。

3.精度问题，e.g.调用库函数sin()得到的值与实际在计算器显示的值有微小偏差，如0.499999999和0.5。

解决办法：使用`FloatingPoint` [`rounded()`](https://developer.apple.com/documentation/swift/floatingpoint/2295900-rounded)方法

4.常遇到报错'NSUnknownKeyException',  this class is not key value coding-compliant for the key buttonChanged.'

原因：一般是在代码中移除了outlet属性后，但是却没有在nib中移除关于这个outlet的connection。



### 结果展示





### 总结

计算器需要处理的问题远比我想象的繁杂，要考虑用户各种形式的输入。我总是想到一种特殊输入才考虑到一个细节，感觉这样的效率比较低。我在IOS提供的原计算器上测试使用时，也会觉得有些小细节处理不到位。一个小需求的增加可能需要改变大量代码，除了深刻体会到MVC模式外，也体会到了软件工程的重要性。

计算器作为一个单场景的应用，比较简单，但是一个很好体验MVC框架的例子。写完之后反思了一下，自己搭建的MVC不是很完美，e.g.计算器Rad/Deg模式切换相关的处理放在Model中更合适。我放在了Controller中，这样操作会在更新View的时候方便些，但是我需要在Controller中特殊处理一些操作符（sin、cos、tan等）的操作数或结果，这不符合Controller职能，属于加班了。下次一定写更好。这次主要在脑海中没有这个框架意识，是边做边意识到的，下次写APP应该要先做好规划和设计。

