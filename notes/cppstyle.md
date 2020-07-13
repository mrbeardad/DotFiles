# 目录
<!-- vim-markdown-toc GFM -->

- [C++ Style](#c-style)
  - [名字](#名字)
  - [注释](#注释)
  - [括号](#括号)
  - [空白符](#空白符)
- [设计经验](#设计经验)
  - [一般性设计准则](#一般性设计准则)
  - [函数设计](#函数设计)
  - [面向对象](#面向对象)
    - [类的设计](#类的设计)
    - [类间关系](#类间关系)
  - [泛型编程](#泛型编程)
  - [异常安全](#异常安全)
  - [并发](#并发)
  - [初始化](#初始化)
  - [内存引用](#内存引用)
  - [效率优化](#效率优化)
  - [易错点](#易错点)
  - [解题经验](#解题经验)
- [附](#附)
  - [函数参数](#函数参数)
  - [类的封装](#类的封装)
  - [reference-return](#reference-return)
  - [异常安全](#异常安全-1)
  - [初始化](#初始化-1)
    - [auto初始化](#auto初始化)
    - [列表初始化](#列表初始化)
    - [默认初始化](#默认初始化)
  - [内存引用](#内存引用-1)

<!-- vim-markdown-toc -->

# C++ Style
部分风格参考自[HosseinYousefi/CompetitiveCPPManifesto](https://github.com/HosseinYousefi/CompetitiveCPPManifesto)

## 名字
* 模板类型参数、类名、类型别名、静态变量：大驼峰拼写法`ExampleName`
* 动态变量&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;：小驼峰拼写法`exampleName`
* 类的数据成员&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;：依据以上两写法并带`_m`后缀`exampleName_m`
* 模板非类型参数、宏、常量&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;：全部大写和下划线间隔`EXAMPLE_NAME`
* 命名空间、函数名称&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;：全部小写和下划线间隔`example_name`
>
可用于命名标识符的一些通用前后缀：
* 位置：`prev`，`next`，`lhs`，`rhs`，`head`，`tail`，`mid`
* 循环：`pos`，`idx`，`this`，`cur`，`beg`，`end`
* 时间：`new`，`old`，`early`，`late`，`last`，`now`，`orig`
* 计数：`size`，`len`，`num`，`cnt`，`nr`，`dep`，`wid`，`hei`
* 序数：`1st`，`2nd`，`3th`，`last`
* bool：`is`，`not`，`and`，`or`，`any`，`all`，`none`，`has`
* 介词：`in`，`on`，`at`，`of`，`2`，`4`
* 类型：`int`，`char`，`str`，`strm`，`ptr`，`iter`
* 用途：`ret`，`ans`，`val`，`need`，`tmp`，`deal`，`src`，`tag`

## 注释
* 块注释`/* comment */`：
    * 注释大片代码
    * 源文件标题
* 单行注释`// comment ` ：代码步骤解释
    * 尾后注释：解释<u>*该行*</u>或<u>*该语句块*</u>或<u>*该作用域*</u>的功能
    * 行前注释：解释接下来一段的代码的功能
>
一般使用单行注释，这样可以用块注释来注释大片代码，因为`/* */`内是可以嵌套`//`的，
但是不能嵌套`/* */`

## 括号
* 命名空间、类、函数的花括号下一行开端
* 控制流语句块、多行lambda的花括号同一行开端
* 所有控制流语句都应该用花括号，即使现在只有一行
* 复合表达式中，注意括号的使用以突出显示优先级

## 空白符
* template与<>间隔空格，如`template <typename T>`

* 嵌套模板参数的右括号`>`间隔空格，如`vector<vector<int> >`
* 模板参数包`...`与右边隔空格，如`<typename... T>`与`(T&&... args)`
* 函数有关键字template、static、inline、constexpr应该分行写
    ```cpp
        template <typename T>
        inline int
        test_func(T& t);
    ```
* 函数名与参数列表不间隔空格
* operator与重载符号间不留空格，合在一起当作函数名并遵守上述规则
    ```cpp
        int operator()(int i);
        int operator""_s(unsigned long long i);
        // 非重载符号的例外
        operator bool();
        operator new();
    ```
* 用4个`<space>`代替`<tab>`
* 指针与引用声明中，`*`与`&`应该与类型放在一起，从而引用和指针应该单独声明，如`int& r; double* p;`
* 控制流语句关键字与括号隔空格，控制流语句的括号需内部空格，如`if ( get_bool() )`
* else(catch)跟在if(try)语句块末端花括号后面
    ```cpp
        if ( get_bool() ) {
            //statement
        } else {
            //statement
        }
    ```
* 二元运算符两边空格，一元只隔一边，三元全隔
* 逗号与分号只与右边隔空格
* 除了条件运算符，其它地方的冒号只与右边隔空格
* lambda函数体超过2行时应该分行
* 若本该在一行的内容过长，要有节奏的断行
* 函数体、类作用域、命名空间的头尾不留空行
* 各作用域和功能模块之间一般需要隔空行
* 文件末尾加一空行

# 设计经验
## 一般性设计准则
* 头文件保护宏

* 利用预处理指令做条件编译
* 不对外链接的符号应该都写在无名命名空间中

## 函数设计
* 形参修饰
> 泛型相比隐式类型转换的优点在于，后者需要调用转换函数来构造一个新对象做形参

| 类型          | 特性                                 |
|---------------|--------------------------------------|
| T             | 拷贝                                 |
| T&            | 引用、左值（非常量）                 |
| T&&           | 引用、右值                           |
| const T&      | 引用、左值、右值、隐式类型转换、只读 |
| temp T&       | 引用、左值、泛型                     |
| temp const T& | 引用、左值、右值、泛型、只读         |
| temp T&&      | 引用、左值、右值、泛型、转发         |
<img align="center" height=600 src="../images/cpp_args.png"></img>

* 何时使用传引用参数：
    * 需要修改实参对象
    * 避免拷贝构造的开销
    * 需要动态绑定而避免切割

* 转发与移动：
    * 针对右值引用使用move，对万能引用使用forward；并注意应该最后使用对象时进行move或forward
    * 以传值形式返回右值引用或万能引用形参的“副本”时，return语句使用中move或forward

* 其它：
    * 不要忘记限定成员函数的`this`，包括const限定和引用限定
    * 利用`=delete`来在调用函数时，***拒绝类型转换***与***拒绝模板某个实例****
    * 只要函数不抛出异常，就应该限定为`noexcept`
    * 重载T&时，non-const版本调用const版本以避免代码重复  
        ```cpp
        const T& func(const T& t);

        T& func(T& t)
        {
            return const_cast<T&>(func(static_cast<const T&>(t)));
        }
        ```

## 面向对象
### 类的设计
* 友元
    * 注意声明与定义的顺序
    * 思考是否可提供接口成员函数以取消友元函数的friend属性

* 类型成员
    * 类型成员需要在前面声明

* 数据成员
    * 构造顺序与对齐问题
    * 若有const与引用成员，则无法合成default构造与operator=
    * private封装
    * handle与interface封装

* 构造函数
    * 思考default构造是否有意义
    * 单参构造最好`explicit`
    * 构造函数抛出异常时不会调用析构函数，若有其它数据成员的构造函数可能抛出异常，则用`unique_ptr`代替裸指针成员避免资源泄漏
    * 构造函数与析构函数不要调用虚函数

* 析构函数
    * 不要让异常逃离析构函数，同时提供`destroy`接口给用户来处理异常的机会
    * 多态基类的析构函数应该声明为`virtual`并提供定义（即使是`pure virtual`）
    * `delete`析构函数可以强制该类对象只能由new表达式获取

* copy语义
    * copy构造函数一般不为`virtual`，可以提供`virtual unique_ptr<T> clone() const`接口来进行copy而不会发生切割（截断）

* move语义
    * 利用成员函数的引用修饰，可以判断该类对象是否为右值，从而可以进行move优化

* 三路比较

* 类型转换
    * 除`bool`外，最多只定义一个与内置类型有关的类型转换
    * 所有转换最好`explicit`

* 重载operator
    * 模仿内置类型的operator
    * 一般单目运算符都设计为成员
    * 不要重载`&&`、`||`、`,`
    * 若定义了算术运算符，也应定义相应的复合赋值
    * 后置自增减运算符调用前置版本

* 接口成员函数
    * [见函数设计](#函数设计)

### 类间关系
* 类之间的关系及其设计
    * D ***is-a*** B：B的所有特性与操作D都支持。例如，"student is a person"
        > 设计：
        > * D <u>public继承</u> B
    * D ***has-a*** B：B是D的一个组分或一种性质。例如，"person has a name and ID"
        > 设计：
        > * D <u>复合</u> B，即B作为D的数据成员
    * D ***is-implement-in-terms-of*** B：B为D提供一些用户不可见的实现细节
        > 设计：
        > * D <u>复合</u> B
        > * D <u>priveta继承</u> B，满足以下情况才选择此设计：
        >   * D需要访问B的protect成员
        >   * D需要修改B的virtual函数
        >   * 利用EBO优化基类尺寸

* 对于public继承实现***is-a***关系
    * 若B的某些特性，D并不支持，则需要从B中抽出更基础的基类特性，再进行继承
    * 实现一种可供多种类使用的特性，若需要使用static数据成员，则该基类应该设计为类模板，
        并让派生类将自己的类型作为模板参数来继承该基类，因为基类的static成员堆所有继承体系唯一

* 继承基类时的接口含义
    * pure virtual：只声明接口，强制派生类覆写定义
    * non-pure virtual：声明接口，并提供默认定义
    * non-virtual：声明接口，并提供不应该被修改的定义

* 继承体系中，non-leaf类应该设计为抽象基类

## 泛型编程
* 减少代码膨胀
    * 将与模板参数无关的代码从类模板与函数模板中抽离
    * 与非类型数值模板参数有关的代码应该使用一份共享的相同的实现代码
    * 二进制表述相同的类型（指针）也应该使用一份共享的相同的实现代码

## 异常安全
* 异常的易错点
    * 抛出异常时必定会进行一次拷贝构造

    * catch语句按顺序进行捕获，所以派生类放前面，基类放后面
    * 最好以引用捕获，而非值捕获或指针捕获
    * catch允许的类型转换：
        * 精准匹配、数组与函数蜕化、顶层const转non-const
        * 继承体系的转换
    * 重新抛出应该使用`throw;`而非`throw excep;`，因为后者会调用excep静态类型的拷贝构造函数，可能出现截断

* 异常安全技巧：
    * 留心可能发生异常的代码
        > 大部分标准库异常见[这儿](https://github.com/mrbeardad/DotFiles/blob/master/cheat/cppman.md#%E6%A0%87%E5%87%86%E5%BA%93%E5%BC%82%E5%B8%B8)
    * 限制从不受信任来源接收的数据的数量和格式
    * 代码前移以减少当异常发生时做的无用功
    * 使用unique_ptr管理资源
    * 使用copy-and-sawp技巧

## 并发
* 同步单个变量用`std::atomic`，同步多个变量用`std::mutex`

* 保证const成员函数的线程安全性，因为const成员函数一般视为只读，如此在多线程环境是无需用户手动同步的；
    但是若它更改了mutable数据成员，为了维护上述线程安全性，需要在const成员函数中进行同步

## 初始化
* 初始化的形式
    * 具有***非代理类的初始化器***时，使用`auto x = proxy`
    * 具有***代理类的初始化器***时，使用`T x = proxy`
    * 调用容器的非`initializer_list`的构造函数时，使用`vector<int> v(10, 1)`
    * 调用容器的`initializer_list`的构造函数时，使用`vector<int> v{10, 1}`
    * 其它情况（该类无形参为initializer_list的构造函数）调用构造函数时，使用`string s{"string"}`

* 尽可能延后对象的初始化直到使用的前一刻，并确认使用对象时其值是有效的

* 循环中使用的对象，一般在循环体中定义而非在循环外，因为
    * **效率一般更好**。前者执行1次构造+1次析构，后者执行n次赋值，
        除非1次赋值比1次构造+1次析构更高效。
        > 一般来讲，长string、容器与流都是后者，即应该定义在循环外
    * 减小其作用域范围，防止名称污染

* 注意多个翻译单元(TU)中，non-local static对象的初始化顺序是未定义的，此时需要使用[reference-return技术](#reference-return)
    该技术优点如下：
    * 解决多TU中static对象的初始化顺序问题
    * 在调用`get_a()`之前，不会有构造`a`的开销

## 内存引用
* 何时使用指针而非引用：
    * 当需要NULL语义时
    * 当需要更改它的指向时
* 容器增删元素时，为防止一些引用对象失效，检查：
    * 是否在**range-based-for**中
    * 是否之前获取了与改容器相关的**指针**、**引用**、**迭代器**

## 效率优化
* 延迟评估：
    * 写时复制
        * Handle类持有Implement类的指针
        * Implement类public继承RCSupport类，并管理数据
        * RCSipport类维护引用计数
        * Handle类对象执行写入操作时，才通过new表达式构造新的Implement对象，否则与拷贝目标共享
    * 区分读写
        * 利用proxy类作operator[]返回值  
        * proxy类持有Handle类的指针以及所代理对象的下标
        * 若对proxy对象执行赋值、取地址、自增减等操作时，则视为写入
        * 其它情况可以利用转换函数解决
    * 延迟获取
        > 类的数据成员设为`mutable optional<T>`，需要时再获取值
    * 延迟计算
        > 计算结果在需要时才进行计算获取，且只计算需要的部分结果

* 超前预算：
    * Caching
        > 缓存之前获取的结果
    * Prefetching
        > 预先进行一次大动作，代替多次小动作  
        > 如：磁盘I/O，堆内存申请，等各种系统调用

## 易错点
* 注意对I/O格式化的要求：
    * istream会忽略前导空格
    * 注意`cin.ignore()`的使用
    * 大量的非格式化I/O应该使用流缓冲区迭代器，如`istreambuf_iterator<charT>`
* 使用节点式容器时删除元素前别忘记后移迭代器`*p++`
* 循环中注意stream是否失效

## 解题经验
* online，offline：边输入边处理，输入完全后处理
* 抓住题干：
    * 无需保存所有数据，只存储题目需要的
    * 转换题意并找出核心计算问题
    * 逆向思维，由起点到终点，变为求终点的起点

# 附
## 函数参数
* 底层const优点：
    * 可以让编译器帮助我们查找违反本意（即修改了不该修改的数据）的代码
    * <b>const T&</b>相比<b>T&</b>，前者可以接收更多类型，见下表
* 对于局部变量：RVO。即返回的**局部变量**与返回类型相同，则直接在返回值的内存构造该局部对象；
    若返回的**局部变量**与返回类型不同，则调用其move构造

## 类的封装
* 数据成员应该封装为private，  
    为了更好的封装数据成员以降低编译依赖甚至可以使用**handle类**或**interface类**
    > 主要是重构数据成员时，所有调用该类的文件都要重新编译，因为数据成员包含在类的定义中被一起放在类头文件，
    > 用以编译器判断类对象所需栈内存大小。解决办法：
    * Handle类：Handle类作为**接口类**给用户使用，其内存储指针指向**实现类**（其中包含数据成员），如此一来实现类便只需声明式，
        再将**实现类的定义**与**接口类的接口函数的定义**放在*实现源文件*中，如此实现分离而降低编译依赖
        <details>
            <summary><b>例子</b></summary>

        ```cpp
        // 接口头文件
        #pragma once
        #include <memory>

        class Handle
        {
        public:
            /* ... */
            ~Person();
        private:
            struct Impl;
            unique_ptr<Impl> pImp_m;
        };

        // 实现源文件
        #include <string>
        #include "myheader.hpp"

        struct Handle::Impl
        {
            std::string str_m;
            mine::MyType t_m;
        };

        /* ... */

        Handle::~Handle() = default // unique_ptr<T>的析构需要获取T的完整定义，并且注意三五原则
        ```
        </details>

    * Interface类：Interface类作为**接口**给用户使用，其本质是一个**抽象基类**，其中定义了用户接口（没有数据成员），
        并提供static成员函数来构造**实现类**（即派生类）并获取其指针或引用（具体来说是unique_ptr）。最后将该**static函数**与**实现类**（派生类）
        定义在*实现源文件*中
        > 使用`unique_ptr`的目的是防止static函数返回的**指针**忘记被delete，而抽象基类是无法定义具体对象的，
        > 包括其**引用**
        <details>
            <summary><b>例子</b></summary>
        
        ```cpp
        // 接口头文件
        #include <string>
        #include <memory>

        struct Human
        {
            virtual ~Human() {  };
            virtual const std::string& name() const =0;
            virtual std::size_t id() const =0;
            static std::unique_ptr<Human> make(const std::string& name = "", std::size_t id = 0);
        };

        // 实现源文件
        #include "human.hpp"
        #include <memory>
        #include <string>

        class HumanInte : public Human
        {
        public:
            HumanInte(const std::string& name, std::size_t id):
                name_m{name}, id_m{id} {  }

            const std::string& name() const override
            {
                return name_m;
            }

            std::size_t id() const override
            {
                return id_m;
            }

        private:
            std::string name_m;
            std::size_t id_m;
        };

        std::unique_ptr<Human> Human::make(const std::string& name, std::size_t id)
        {
            return std::make_unique<HumanInte>(name, id);
        }
                        ```
        </details>

* non-member non-friend函数比member具有更好的函数封装性，且可以前者可以分离编译

## reference-return
&emsp;当在`A`文件中定义`a`，在`B`文件中定义`b`，`b`依赖于`a`，
但是`a`不一定就在`b`之前构造
<a href=## title="即使a会存储在数据段中，看似构造了，但其实它可能还需要在运行期调用构造函数，比如std::vector即使定义在全局，仍然需要在运行期在main调用之前调用其构造函数来获取堆内存；另一个例子就是定义在<iostream>里的cin与cout">[注]</a>，
这就可能导致致命错误。  
&emsp;解决办法是将non-local static转换为local-static，即在函数内定义static对象，然后返回该对象的引用
<details>
    <summary><b>例子</b></summary>

```cpp
/*
 * 参考自 Effective C++ 3e
 */

// A文件的全局作用域
ObjA& get_a()       // reference-returning函数
{
    static Obj a{}; // 在首次调用该函数期间，或首次遇到该对象定义式时构造该对象
    return a;
}

// B文件的全局作用域
ObjB b{get_a()};    // 这样在构造b之前，a必定是已构造的
```
</details>

## 异常安全
* 异常安全性
    * 不泄漏任何资源
    * 不允许数据败坏

* 异常安全等级
    > 由等级最低者决定
    * 基本承诺  ：若异常发生，保证资源不泄漏，保证数据有效
    * 强烈保证  ：若异常发生，保证返回状态与调用前状态相同
    * 不抛出异常：顾名思义，但若还是抛出异常则终止程序

## 初始化
### auto初始化
* 优点
    * 书写更加简洁
    * 防止人工判断类型出错
    * 推断出编译器才知晓的类型，如lambda
* 缺点
    * 初始化器为代理类时，可能会出错

### 列表初始化
* 优点
    * 用`initializer_list`实现类聚合式初始化
    * 调用构造函数
    * 防止窄化
* 缺点
    * 上述优点1，同时也是缺点。因为编译器会优先调用initializer_list形参的构造函数，
        即使需要类型转换；同时因为防止窄化，从而导致这种情况`vector<bool> v{10, true};`，
        这段代码会报错，因为它调用了构造函数`vector(initializer_list<bool>)`，同时10转为bool被视作窄化。
        而其实我们本意是构造***含10个元素，且均为true的`vector<bool>`***

### 默认初始化
* 默认初始化与值初始化
    * 对于内置类型与聚合类，`int a[5];`叫默认初始化，`int a[5]{}`叫值初始化，  
        * 默认初始化静态变量为全零，初始化动态变量为未定义；  
        * 而值初始化会将对象初始化为全零

    * 对于其它类类型，`string s;`与`string s{};`都叫默认初始化，行为都一样，即调用其默认构造函数，
        类类型的默认初始化应该显式的使用后者

* 构造函数的初始化列表
    * 在进入函数体前会初始化所有non-static数据成员
    * 对未出现在初始化列表中的成员执行默认初始化；若成员为内置类型且该类非聚合类，则值初始化该成员

    * 注意成员的构造顺序与声明顺序一致，且基类本身先构造；对于多重继承的基类构造顺序，则是从左到右、从上到下 <a href=## title="从左到右即是在派生说明中的顺序，从上到下即是从更深的基类到派生类">[注]</a>

## 内存引用
读取某个内存引用，若在作用域内不可能被某些操作写入，重复引用时可以被编译器优化，
而避免手动将其载入寄存器的麻烦，以下操作便会妨碍优化：
* 传引用参数：函数有多个传引用形参，试图读取其中一个实参，又要写入另一个参数（调用任何有非底层const传引用参数的函数都视为写入）
    > 因为传入的多个引用可能指向同一个对象，所以对于所有处理多引用的函数应该能够处理该情况
* 类成员：试图读取一个类的数据成员，但又要调用同一个类对象的non-const成员函数
* 全局变量：试图读取全局对象，但又要调用任何函数
    > 任何函数都可能修改全局变量，包括lambda

