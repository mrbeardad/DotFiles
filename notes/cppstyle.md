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
* 位置：`prev`，`next`，`left`，`right`，`head`，`tail`，`mid`
* 循环：`pos`，`idx`，`this`，`cur`，`beg`，`end`
* 时间：`new`，`old`，`early`，`late`，`last`，`now`
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

## 空格
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
* 访问控制、case标签、构造函数的冒号只右边隔空格
* lambda函数体超过2行时应该分行
* 函数体、类作用域、命名空间的头尾不留空行
* 各作用域和功能模块之间一般需要隔空行
* 文件末尾加一空行

## 设计经验
* 头文件保护宏
* 利用预处理指令做错误处理与条件编译
* 不对外链接的符号应该都写在无名命名空间中
* 函数nothrow一定`noexcept`
* 注意对函数参数与成员函数this的修饰以增强鲁棒性
* 函数模板的形参，若为引用则需要decay
* 类的单参构造函数若非有意，一定要explicit
* 何时使用指针而非引用：
    * 当需要NULL语义时
    * 当需要更改它的指向时

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
* 容器增删元素时，为防止一些对象失效，检查：
    * 是否在**range-based-for**中
    * 是否之前获取了与改容器相关的**指针**、**引用**、**迭代器**
* 使用节点式容器时删除元素前别忘记后移迭代器`*p++`
* 循环中，注意stream是否失效

## 解题经验
* online，offline：边输入边处理，输入完全后处理
* 抓住题干：
    * 无需保存所有数据，只存储题目需要的
    * 转换题意并找出核心计算问题
    * 逆向思维，由起点到终点，变为求终点的起点

## 选择标准库容器
* vector
    * 无其他需求一般选择vector
* array
    * 固定大小
    * 容量需求大且时间效率优于空间效率
* 内置数组
    * 相对array需要多维线性数组
* deque
    * 需要头部增删元素
    * 容量需求大且空间效率优于时间效率
    * 容量需求过大
* list
    * 需要大量地随处插删
* Pqueue
    * 只需快速找出最值而无需完全排序
* Associated
    * 快速搜索且需要自动排序
    * 注：以下以下两点则考虑用线性数组(快速搜索且需要排序)
        > 使用线性数组 + 排序算法
        * 元素的比较为整数的比较，且该整数的值域可接受作为下标索引
        * 且元素总量固定，且允许off-line算法
* Unordered
    * 快速搜索且无需排序
    * 注：以下情况考虑用线性数组
        * 元素的比较为整数的比较，若该整数的值域可接受作为下标索引
* Map
    * 在set的基础上提供更方便的下标操作
    * 只比较key而进行映射集合的分类

