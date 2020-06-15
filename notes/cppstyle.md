# 目录
<!-- vim-markdown-toc GFM -->

- [C++ Style](#c-style)
  - [名字](#名字)
  - [注释](#注释)
  - [括号](#括号)
  - [空白符](#空白符)
- [设计经验](#设计经验)
  - [一般性设计准则](#一般性设计准则)
  - [面向对象](#面向对象)
  - [异常安全](#异常安全)
  - [函数参数](#函数参数)
  - [初始化](#初始化)
  - [内存引用](#内存引用)
  - [易错点](#易错点)
  - [解题经验](#解题经验)

<!-- vim-markdown-toc -->
# C++ Style
部分风格参考自[HosseinYousefi/CompetitiveCPPManifesto](https://github.com/HosseinYousefi/CompetitiveCPPManifesto)

## 名字
* 类名、静态变量&emsp;&emsp;&emsp;&emsp;&emsp;：大驼峰拼写法`ExampleName`
* 基本类型别名、动态变量&emsp;：小驼峰拼写法`exampleName`
* 类的数据成员&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;：小驼峰并带`_m`后缀`exampleName_m`
* 模板参数、宏、常量&emsp;&emsp;&emsp;：全部大写和下划线间隔`EXAMPLE_NAME`
* 命名空间、函数名称&emsp;&emsp;&emsp;：全部小写和下划线间隔`example_name`
>
可用于命名标识符的一些通用前后缀：
* 位置：`prev`，`next`，`lhs`，`rhs`，`head`，`tail`，`mid`
* 循环：`pos`，`idx`，`this`，`cur`，`beg`，`end`
* 时间：`new`，`old`，`early`，`late`，`last`，`now`，`orig`
* 计数：`size`，`len`，`num`，`cnt`，`nr`，`dep`，`wid`，`hei`
* 序数：`fst`，`snd`，`last`
* bool：`is`，`not`，`and`，`or`，`any`，`all`，`none`
* 介词：`in`，`on`，`at`，`of`，`2`，`4`
* 类型：`int`，`char`，`str`，`strm`，`ptr`
* 用途：`ret`，`ans`，`val`，`need`，`tmp`，`deal`，`have`

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
* 内置类型初始化时使用列表初始化`{num}`
* 调用非copy非move构造函数函数时也使用列表初始化`{args}`

## 空白符
* template与<>间隔空格，如`template <typename T>`

* 嵌套模板参数的右括号`>`间隔空格，如`vector<vector<int> >`
* 模板参数包`...`与右边隔空格，如`<typename... T>`与`(T&&... args)`
* 函数有关键字inline、constexpr、template、static应该分行写
    ```cpp
        template <typename T>
        inline int
        test_func(T& t);
    ```
* 函数名与参数列表不间隔空格

* operator与重载符号间一般不留空格，合在一起当作函数名并遵守上述规则
    ```cpp
        int operator()(int i);
        int operator""_s(unsigned long long i);
    ```
* 用4个`<space>`代替`<tab>`

* 指针与引用声明中，`*`与`&`应该与类型放在一起，故引用和指针应该单独声明，如`int& r; double* p;`
* 控制流语句的括号需内部空格，控制流语句关键字与括号隔空格，如`if ( get_bool() )`
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
* 一行内容过长要有节奏的断行
* 函数体、类作用域、命名空间的头尾不留空行
* 各作用域和功能模块之间一般需要隔空行
* 文件末尾加一空行

# 设计经验
## 一般性设计准则
* 头文件保护宏

* 利用预处理指令做错误处理与条件编译
* 不对外链接的符号应该都写在无名命名空间中
* 函数不抛出异常则一定限定为`noexcept`
* 类中无virtual函数，应该声明为`final`

## 面向对象
* 将多态基类的析构函数声明为virtual，注意声明virtual析构函数的同时会拒绝编译器合成默认析构函数，
    故需手动定义或者使用`=default`；
    若不是多态基类则不要声明任何虚函数而引入虚指针与虚表

* 不要在构造函数与析构函数中调用虚函数
* 不要让异常逃离析构函数，并提供一个接口函数执行析构任务以让用户有处理的机会
    > 当异常发生时会析构当前作用域的对象，若析构这些对象又发生了异常，会导致直接终止程序
* non-member non-friend函数比member函数封装性更好，
    并尽量使用public成员函数作底层接口供non-member封装函数调用以取消后者的friend属性
* 注意返回的private句柄(handle)应该const，以维护封装性，当然最好避免返回handle
    > private句柄包括封装好的private的函数、指针、引用
* 数据成员封装为private，为了更好的封装数据成员以降低编译依赖甚至可以使用**handle类**或**interface类**
    > 主要是重构数据成员时，所有调用该类的文件都要重新编译，因为数据成员包含在类的定义中被一起放在类头文件，
    > 用以编译器判断类对象所需栈内存大小。解决办法：
    * Handle类：Handle类作为**接口类**给用户使用，其内存储指针指向**实现类**（其中包含数据成员），如此一来实现类便只需声明式，
        再将**实现类的定义**与**接口类的接口函数的定义**放在*实现源文件*中，如此实现分离而降低编译依赖
        <details>
            <summary><b>例子</b></summary>
        
        ```cpp
        // 接口头文件
        #include <string>

        class Person
        {
        public:
            Person(const std::string& name, size_t id);
            ~Person();
            const std::string& name() const;
            size_t id() const;
        private:
            struct PersonImpl;
            PersonImpl* ptr2ps_m;
        };
        
        // 实现源文件
        #include "person.hpp"
        #include <string>

        struct Person::PersonImpl
        {
            std::string name_m;
            size_t id_m;
        };

        Person::Person(const std::string& name, size_t id):
            ptr2ps_m{new Person::PersonImpl{name, id}} {  }

        Person::~Person()
        {
            delete ptr2ps_m;
        }

        const std::string& Person::name() const
        {
            return ptr2ps_m->name_m;
        }

        size_t Person::id() const
        {
            return ptr2ps_m->id_m;
        }
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

## 异常安全
* 异常安全性
    * 不泄漏任何资源
    * 不允许数据败坏
* 异常安全等级
    > 由等级最低者决定
    * 基本承诺  ：若异常发生，保证资源不泄漏，保证数据有效
    * 强烈保证  ：若异常发生，保证返回状态与调用前状态相同
    * 不抛出异常：顾名思义，但若还是抛出异常则终止程序
* 技巧：
    * 留心可能发生异常的代码，限制从不受信任的源接收数据的数量和格式，减少当异常发生时做的无用功
        > 大部分标准库异常见[这儿](https://github.com/mrbeardad/DotFiles/blob/master/cheat/cppman.md#%E6%A0%87%E5%87%86%E5%BA%93%E5%BC%82%E5%B8%B8)
    * 使用unique_ptr管理资源
    * 使用copy-and-sawp技巧

## 函数参数
主要是注意对函数传引用参数的const修饰，还有不要忘了对成员函数this的const修饰与引用限定  
原因有两点：
* 利用const可以让编译期帮助我们查找违反本意（即修改了不该修改的数据）的代码
* <b>const T&</b>相比<b>T&</b>，前者可以接收更多类型，见下表

| 类型          | 特性                                 |
|---------------|--------------------------------------|
| T             | 拷贝                                 |
| T&            | 引用、左值(非常量)                   |
| T&&           | 引用、右值                           |
| const T&      | 引用、左值、右值、隐式类型转换、只读 |
| temp T&       | 引用、左值、泛型                     |
| temp const T& | 引用、左值、右值、泛型、只读         |
| temp T&&      | 引用、左值、右值、泛型、转发         |

<img align="center" height=600 src="../images/cpp_args.png"></img>

注意：
* 何时使用传引用参数
    * 需要修改实参对象
    * 实参对象为类而非基础类型（避免拷贝构造）
    * 需要动态绑定，避免切割
* <b>重载T&</b>时，应该利用non-const版本调用const版本以避免代码重复，  
不应该反过来让const调用non-const，因为non-const版本并未保证const语义
> 参考自**C++ Primer**与**Effective C++**
```cpp
const T& func(const T& t);

T& func(T& t)
{
    return const_cast<T&>(func(static_cast<const T&>(t)));
}
```

## 初始化
* 内置类型初始化与调用非copy非move构造函数时使用列表初始化，如`int i{1}`，  
    * 优点是防止窄化数据，  

    * 缺点是会优先调用`initializer_list<>`形参的构造函数，
        比如`vector v{4, 0}`会构造一个2元素的`vector<int>`{4, 0}，而非构造一个4元素的{0, 0, 0, 0}。
        此时就应该用圆括号初始化`vector v(4, 0)`

* 默认初始化与值初始化
    * 对于内置类型与聚合类，`int a[5];`叫默认初始化，`int a[5]{}`叫值初始化，  
        前者初始化静态变量为全零，初始化动态变量为未定义；后者将初始化对象为全零(0)
        > 在全局作用域中，默认初始化又会升级为值初始化
    * 对于其它类型（类），`string s;`与`string s{};`都叫默认初始化，行为都一样，即调用其默认构造函数

* 构造函数的初始化列表
    * 在进入函数体前会初始化所有non-static数据成员，对未出现在初始化列表中的成员执行默认初始化（见上）

    * 注意成员的构造顺序与声明顺序一致，且基类本身先构造；对于多重继承的基类构造顺序，则是从左到右、从上到下 <a href=## title="从左到右即是在派生说明中的顺序，从上到下即是从更深的基类到派生类">[注]</a>

* 尽可能延后对象的初始化直到使用的前一刻，并确认使用对象时，其值是有效的（见默认初始化与值初始化）

* 循环中使用的对象，一般在循环体中定义而非在循环外，因为
    * **效率一般更好**。前者执行1次构造+1次析构+n次赋值，后者执行n次构造+n次赋值，
        除非1次赋值比1次构造+1次析构更高效。
        > 一般来讲，长string、容器与流都是后者，即应该定义在循环外
    * 减小其作用域范围，防止名称污染

* 注意多个翻译单元(TU)中，non-local static对象的初始化顺序是未定义的。  
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

读取某个内存引用，若在作用域内不可能被某些操作写入，重复引用时可以被编译器优化，
而避免手动将其载入寄存器的麻烦，以下操作便会妨碍优化：
* 传引用参数：函数有多个传引用形参，试图读取其中一个实参，又要写入另一个参数（调用任何有非底层const传引用参数的函数都视为写入）
    > 因为传入的多个引用可能指向同一个对象，所以对于所有处理多引用的函数应该能够处理该情况
* 类成员：试图读取一个类的数据成员，但又要调用同一个类对象的non-const成员函数
* 全局变量：试图读取全局对象，但又要调用任何函数
    > 任何函数都可能修改全局变量，包括lambda

## 易错点
* 注意对I/O格式化的要求：
    * istream会忽略前导空格，并注意`cin.ignore()`的使用
    * 大量的非格式化I/O应该使用流缓冲区迭代器，如`istreambuf_iterator<charT>`
    * 浮点数输出：
        * fixed
        * setprecision(n)
        * setw(n)
        * 四舍五入
        * 丢弃小数
* 使用节点式容器时删除元素前别忘记后移迭代器`*p++`
* 循环中，注意stream是否失效
* 类的单参构造函数若非有意，一定要explicit

## 解题经验
* online，offline：边输入边处理，输入完全后处理
* 抓住题干：
    * 无需保存所有数据，只存储题目需要的
    * 转换题意并找出核心计算问题
    * 逆向思维，由起点到终点，变为求终点的起点

