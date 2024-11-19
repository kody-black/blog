---
title: JS基础笔记
date: 2024-11-19
summary: JavaScript基础内容中一些值得注意的点
categories:
  - 学习总结
tags:
  - JavaScript
draft: false
---

> 一直没有专门学过JavaScript，大部分的了解都是做题的时候知道的，想了想不如花点时间系统总结一下，主要来自：[重新介绍 JavaScript | MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Language_overview)

## 基础类型和运算

- JS里面的数字实际上没有整型的概念，其所有的数字其实都是浮点数。`0.1 + 0.2 = 0.30000000000000004`
- parseInt函数可以把字符串解析为整数，parseFloat用于解析浮点数字字符串，一元运算符+也可以把数字字符串转换为数值
```js
parseInt("123", 10); // 123
parseInt("010", 10); // 10
parseInt("010"); //  8
parseInt("0x10"); // 16
parseInt("11", 2) // 3
parseFloat("12.21abcdefgh") //12.21
+"0x10"; // 16
2+"12"； //212，该情况会将前后都视为字符串，结果也是字符串
// 一个实用的技巧：通过与空字符串相加，可以将某个变量快速转换成字符串类型
```
- JavaScript 按照如下规则将变量转换成布尔类型：
	1. `false`、`0`、空字符串（`""`）、`NaN`、`null` 和 `undefined` 被转换为 `false`
	2. 所有其他值被转换为 `true`

- 声明一个新变量的方法是使用关键字 let, const 和 var
	1. let声明一个块级作用域的本地变量（即其作用域和python中的变量一样，只在所属块里面有效）
	2. const声明一个不可变的常量，和let一样作用于所属块里面。
	3. var没有任何限制，它是传统上在 JavaScript 声明变量的唯一方法。使用 **`var`** 声明的变量在它所声明的整个函数都是可见的。
- JS中，赋值表达式的值等价于赋值完成后的值（所以可以直接用赋值语句作为条件语句），并且支持链式赋值
```js
a = [1,2,3]
console.log(b = a[1]) // 2
console.log(b = a[4]) // undefined
console.log(x = 10); // 5
console.log(y = x = 5); // 5
```
## 控制结构

- 除了和C一样的for、while、do...while循环外，JS还支持for...in和for...of循环
	- for...in用于遍历对象的属性（包括继承的属性），通常用于对象
	- for...of（ES6中引入）用于遍历可迭代对象的值，通常用于数组、字符串、Set、Map等集合类数据结构。
```js
const arr = [10, 20, 30];

for (let index in arr) {
    console.log(index); // 输出: 0, 1, 2
}

for (let index of arr) {
    console.log(index); // 输出: 10, 20, 30
}
```

## 对象

- JavaScript 中的对象`Object`，可以简单理解成“名称 - 值”对（而不是键值对：现在，ES 2015 的映射表（Map），比对象更接近键值对），其类似于python中的字典。在JS中，几乎万物皆对象。
```js
// 普通对象
const obj = { a: 1, b: 2 };

// 函数对象
function myFunction() {
    console.log("I am a function");
}
myFunction.myProperty = "I am a property of the function";

// 数组对象
const arr = [1, 2, 3];
arr.myMethod = function() {
    console.log("I am a method of the array");
};

// 日期对象
const date = new Date();

// 正则表达式对象
const regex = new RegExp("\\d+");

// 内置对象
const math = Math;
const json = JSON;

console.log(typeof obj); // "object"
console.log(typeof myFunction); // "function" (函数也是一种对象)
console.log(typeof arr); // "object"
console.log(typeof date); // "object"
console.log(typeof regex); // "object"
console.log(typeof math); // "object"
console.log(typeof json); // "object"
```
- JS里面的数值是一种特殊的对象，它的工作原理与普通对象类似（以数字为属性名，但只能通过`[]` 来访问），但数组还有一个特殊的属性——`length`（长度）属性。这个属性的值通常比数组最大索引大 1。
```js
var a = ["dog", "cat", "hen"];
a[100] = "fox";
a.length; // 101
console.log(a[12]); //undefined

// 遍历数组建议使用下面两种方法之一，是等效的
for (var i = 0; i < a.length; i++) {
  console.log(a[i]); //dog cat hen
}

for (const currentValue of a) {
  console.log(currentValue); //dog cat hen
}

// 遍历数组的另一种方法是使用for...in循环，然而这并不是遍历数组元素而是数组的索引。注意，如果有人直接向Array.prototype添加了新的属性，使用for...in循环这些属性也同样会被遍历。
Array.prototype.myCustomProp = "alien";
for (var i in a) {
  console.log(a[i]); //dog cat hen alien
}

```

## 函数

- JS的函数也是一种特殊的对象，其中，函数形参只是一个指示而没有其他作用，调用函数时并不会检查参数个数，缺少的参数会被undefined替代。如果函数没有return语句或者是没有值的return语句，则会返回undefined。
```js
// 可以直接用剩余参数的方法传递所有未被捕获的参数
function avg(...args) {
  var sum = 0;
  for (let value of args) {
    sum += value;
  }
  return sum / args.length;
}

// 该函数等效如下：
function avg() {
  var sum = 0;
  // 函数的内部对象arguments包含了所有被传入的参数
  for (var i = 0, j = arguments.length; i < j; i++) {
    sum += arguments[i];
  }
  return sum / arguments.length;
}

avg(2, 3, 4, 5); // 3.5
```
- JS支持词法作用域（lexical scoping），这意味着和大部分的语言不同，函数可以直接访问和修改其定义时所在作用域中的变量。
```js
var a = 1;
var b = 2;
// JS支持匿名函数，下面是一个立即执行的函数表达式（IIFE）
(function () {
  var b = 3; //IIFE 内部定义了一个新的局部变量b
  a += b; // a 是全局的 a，而 b 是 IIFE 内部的局部变量 b
})();

a; // 4
b; // 2
```

## 自定义对象

- JS里面没有class，而是把函数作为类。
	- 当使用在函数中时，this 指代当前的对象，也就是调用了函数的对象。如果在一个对象上使用点或者方括号来访问属性或方法，这个对象就成了 this。
	- new关键字的作用是创建一个崭新的空对象，然后使用指向那个对象的 `this` 调用特定的函数。注意，含有 `this` 的特定函数不会返回任何值，只会修改 `this` 对象本身。`new` 关键字将生成的 `this` 对象返回给调用方，而被 `new` 调用的函数称为构造函数。习惯的做法是将这些函数的首字母大写，这样用 `new` 调用他们的时候就容易识别了。
```js
function Person(first, last) {
  this.first = first;
  this.last = last;
  this.fullName = function () {
    return this.first + " " + this.last;
  };
}
var s = new Person("Simon", "Willison");
s.fullName(); // "Simon Willison"

// 如果并没有使用“点”运算符调用某个对象，那么 this 将指向全局对象（global object）这是一个经常出错的地方。例如：
var fullName = s.fullName;
fullName(); // undefined undefined
// 当我们调用 fullName() 时，this 实际上是指向全局对象的，并没有名为 first 或 last 的全局变量，所以它们两个的返回值都会是 undefined。
```
- JavaScript 中，构造函数的 `prototype` 属性指向一个对象，该对象上的所有属性和方法都会被通过该构造函数创建的实例共享。这个特性功能十分强大，JavaScript 允许你在程序中的任何时候修改原型（prototype）中的一些东西，也就是说你可以在运行时 (runtime) 给已存在的对象添加额外的方法
```js
Person.prototype.fullNameReversed = function(){
    return this.last + " " + this.first;
}
s.fullNameReversed(); // Willison, Simon
```
- 甚至可以给内置函数的原型添加内容，而不同层次的原型组成原型链，根节点是`Object.prototype`，我们可以直接修改一些原始的方法，例如`toString()`是将对象转换成字符串时调用的方法，可以对Person的该方法做出如下修改：
```js
var s = new Person("Simon", "Willison");
console.log(s.toString()) // [object Object]
Person.prototype.toString = function () {
  return "<Person: " + this.fullName() + ">";
};
console.log(s.toString()); // <Person: Simon Willison>
```
- [**`apply()`**](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/apply) 用于调用一个函数，并显式地指定 `this` 上下文和传递参数。它的语法如下：
	- `function.apply(thisArg, [argsArray])` 
	- `thisArg`：在函数调用时用作 `this` 的值。
	- `argsArray`：一个数组或类数组对象，其中的元素作为单独的参数传递给函数。
```js
// 改变 this 上下文
function greeting() {
    console.log(`Hello, ${this.name}!`);
}
const person = { name: "Alice" };
greeting.apply(person);  // 输出: Hello, Alice!

// 传递参数列表
function sum(a, b, c) {
    return a + b + c;
}
const numbers = [1, 2, 3];
console.log(sum.apply(null, numbers));  // 输出: 6

// 处理类数组对象
function extend() {
    console.log(arguments);  // 输出：Arguments(5) ...
    const args = Array.prototype.slice.apply(arguments);
    console.log(args);  // 输出: [1, 2, 3, 4, 5]
}

extend(1, 2, 3, 4, 5);
```
- [**`call()`**](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/call) 函数几乎与`apply()`相同，只是函数的参数以列表的形式逐个传递给 `call()`，而在 `apply()` 中它们被组合在一个对象中，通常是一个数组——例如，`func.call(this, "eat", "bananas")` 与 `func.apply(this, ["eat", "bananas"])`。
- [**`bind()`**](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) 方法创建一个新函数，当调用该新函数时，它会调用原始函数并将其 `this` 关键字设置为给定的值，同时，还可以传入一系列指定的参数，这些参数会插入到调用新函数时传入的参数的前面。
```js
const module = {
  x: 42,
  getX: function () {
    return this.x;
  },
};

const unboundGetX = module.getX;
console.log(unboundGetX()); // 函数调用于全局作用域，返回undefined

const boundGetX = unboundGetX.bind(module);
console.log(boundGetX()); // 返回42
```
- 进一步的，绑定函数可以通过调用 `boundFn.bind(thisArg, /* more args */)` 进一步进行绑定，从而创建另一个绑定函数 `boundFn2`。新绑定的 `thisArg` 值会被忽略，因为 `boundFn2` 的目标函数是 `boundFn`，而 `boundFn` 已经有一个绑定的 `this` 值了。当调用 `boundFn2` 时，它会调用 `boundFn`，而 `boundFn` 又会调用 `fn`。`fn` 最终接收到的参数按顺序为：`boundFn` 绑定的参数、`boundFn2` 绑定的参数，以及 `boundFn2` 接收到的参数。
```js
"use strict"; // 防止 `this` 被封装到到包装对象中

function log(...args) {
  console.log(this, ...args);
}
const boundLog = log.bind("this value", 1, 2);
const boundLog2 = boundLog.bind("new this value", 3, 4);
boundLog2(5, 6); // "this value", 1, 2, 3, 4, 5, 6
```

## 闭包

- 笼统地说，闭包就是拥有状态的函数。在JavaScript中，闭包是指一个函数能够记住并访问它的词法作用域，即使这个函数是在它的词法作用域之外被调用的。闭包不仅能够访问函数内部的变量，还能访问外部函数的变量。
```js
function createCounter() {
    let count = 0; // 外部函数的局部变量
    return function() {
        count++; // 内部函数访问并修改外部函数的局部变量
        return count;
    };
}

const counter = createCounter();
console.log(counter()); // 输出: 1
console.log(counter()); // 输出: 2
console.log(counter()); // 输出: 3
// 上述示例中，createCounter 是外部函数，它定义了一个局部变量 count 并返回一个内部函数。这个内部函数每次被调用时都会增加 count 的值并返回这个新的值。即使 createCounter 已经执行完毕，count 仍然通过闭包被内部函数记住，因此每次调用 counter 都能看到 count 的最新状态。
```
