> # 注意：  
> 该文档虽然是Markdown格式，但是因为这篇文档主要用来在终端下通过`see`命令来快速查阅的，  
> 故编写时为了终端环境下更好看，以markdown格式渲染出来的画面就有些不可描述了:joy:  
> 因为代码中有很多`<>`、`_`、`*`都会被当作标签
> 所以这篇文档得看源码哦

# 标准库异常
* 异常体系结构
```
exception                 `<exception>`  
├─── bad_cast             `<typeinfo>`      ：多态引用的转换失败  
├─── bad_typeid           `<typeinfo>`      ：在typeid()中解引用多态类型的空指针
├─── bad_weak_ptr         `<memory>`        ：构造weak_ptr失败  
├─── bad_function_call    `<functional>`    ：调用无目标的function类  
├─── bad_alloc            `<new>`           ：内存申请失败  
├─── bad_array_new_length `<new>`           ：传给new的size不在有效范围  
│  
├─── logic_error          `<stdexcept>`  
│   │  
│   ├─── domain_error                       ：数学库, 传入值域错误  
│   ├─── invalid_argument                   ：bitset构造参数无效  
│   ├─── length_error                       ：容器size超出限制  
│   ├─── out_of_range                       ：容器的无效索引  
│   └─── future_error     `<future>`        ：异步系统调用  
│  
└─── runtime_error        `<stdexcept>`  
    │  
    ├─── range_error                        ：wide string与byte string转换出错  
    ├─── overflow_error                     ：bitset转换为整型时溢出  
    ├─── underflow_error                    ：算术下溢  
    └─── system_error     `<system_error>`  ：系统调用出错  
        │  
        └─── ios::failure `<ios>`           ：stream出错  
```
<!-- -->

* 异常成员
    * .what() ：返回`const char*`用于打印
        > 根部基类**exception**的虚函数
        > 异常类销毁后该C-string也不复存在  
    * .code() ：返回error_code类对象
        > error_code 与 error_condition 区别：可移植性  
        > 前者由编译器定义(OS相关), 后者为默认标准
        * error_code成员：
            * .message()
            * .value()
            * .category().name()
            * .default_error_condition()
            * .default_error_condition().message()
            * .default_error_condition().value()
            * .default_error_condition().category().name()
        * 比较：
            > 重载了与**领域枚举值**的比较运算符
            * errc        ：`<cerrno>`
            * io_errc     ：`<ios>`
            * future_errc ：`<future>`
<!-- -->

* 异常挂起
    * current_exception()       ：返回exception_ptr对象
    * rethrow_exception(exceptr)：重新抛出exception_ptr对象
<!-- -->

* 异常构造
    > 异常类的构造参数
    * logic_error与runtime_error
        * (const string&)
        * (const char*)
    * system_error
        > 提供`make_error_code(errc)`构造error_code
        * (error_code)
        * (error_code, const string&)
        * (error_code, const char*)
<!-- -->

# C库
* 调试：`<cassert>`
    * assert(expr)                  ：运行时断言, false则执行
        > #define NDEGUG  
        > 可以取消宏函数assert()
    * static_assert(expr, message)  ：编译期断言, 可以自定义打印消息
        > #define NDEBUG  
        > 并不会取消**关键字static_assert()**
    * 编译器预处理宏：
        * `__func__`
        * `__LINE__`
        * `__FILE__`
        * `__TIME__`
        * `__DATE__`
<!-- -->

* `<cstdlib>`
    * EXIT_SUCCESS
    * EXIT_FAILURE
    * exit(status)
    * atexit(void (*func)())
    * quick_exit(status)
    * at_quick_exit(void (*func)())
<!-- -->

* `<cctype>`
    * isalnum(c)     ：字母+数字
    * isalpha(c)     ：字母
    * islower(c)     ：小写字母
    * isupper(c)     ：大写字母
    * isdigit(c)     ：数字
    * isxdigit(c)    ：数字+`xabcdefXABCDEF`
    * ispunct(c)     ：符号
    * isblank(c)     ：` `+`\t`
    * isspace(c)     ：` `+`\t`+`\n`+`\r`+`\v`+`\f`
    * iscntrl(c)     ：0x00-0x1F + 0x7F
    * isgraph(c)     ：字母+数字+符号
    * isprint(c)     ：字母+数字+符号+空格
    * toupper(c)
    * tolower(c)
<!--  -->

* 数学库：`<cmath>`
    > 几乎所有函数的参数都对`float` `double` `long double` 和整数 有重载，故一般省略形参类型  
    > 若只能为浮点数会指明`double`
    * 三角函数
        * cos(T)
        * sin(T)
        * tan(T)
        * acos(T)
        * asin(T)
        * atan(T)

    * 对数与幂
        * log(N)                    ：log_e(N)
        * log1p(N)                  ：更加精准的log_e(N + 1)
        * log2(N)                   ：log_2(N)
        * log10(N)                  ：log_10(N)

        * exp(x)                    ：e ^ x
        * expm1(x)                  ：exp(x) - 1（计算更精准）
        * exp2(x)                   ：2 ^ x
        * exp10(x)                  ：10 ^ x

        * pow(x, y)                 ：x ^ y
        * sqrt(double x)            ：x的平方根
        * cbrt(double x)            ：x的立方根
        * hypot(x, y, z=0)          ：sqrt(pow(x, 2), pow(y, 2), pow(z, 2))

    * 浮点数取整
        * ceil(double x)            ：向上取整
        * floor(double d)           ：向下取整
        * trunc(double x)           ：丢弃小数
        * round(double x)           ：四舍五入

    * 其它
        * frexp(double x, int* exp) ：x = n * (2 ^ exp)，返回n值域为[0.5, 1.0)，并返回exp到指针所指的int
        * ldexp(double x, int exp)  ：n = x * (2 ^ exp)，返回n，x的值域为[0.5, 1.0)
        * fmod(double x, double y)  ：浮点数的x % y
        * modf(double x, int* n)    ：将x分解为整数与小数部分，整数存于n，返回小数

        * abs(x)                    ：x的绝对值
        * fdim(x, y)                ：如果x > y则返回x - y，否则返回0
        * fma(x, y, z)              ：返回x * y + z
        * div(x, y)                 ：x除以y的商(div_t.quot)和余数(div_t.rem)   `<cstdlib>`

        * gcd(x, y)                 ：`<numeric>`
        * lcm(x, y)                 ：`<numeric>`
<!-- -->

* `int getopt(int argc, char* const argv[], const char* optstring)`  `<unistd.h>`
    * 参数argc与argv：
        * 来自`int main(int argc, char* argv[])`
    * 参数optstring：
        * `:`       ：第一个字符若为`:`表示开启silent模式，此模式下不自动打印错误消息
        * `o`       ：代表选项`o`没有参数  
        * `o:`      ：代表选项`o`必有参数, 紧跟`-oarg`或间隔`-o arg`中的`arg`都被视为`-o`的参数  
        * `o::`     ：代表选项`o`可选参数, 只识别紧跟`-oarg`
    * 返回int：
        > 表示当前选项字符
        * `?`       ：默认模式表示无效选项，即**不存在此选型**或**该选项必有参数却未提供**，silent模式下只表示前者
        * `:`       ：silent模式表示上述无效选项的后者，通过`argv[optind - 1]`可获取该选项字母
        * `-1`      ：表示结束，剩余的都是non-option-element
    * 全局变量：
        * optarg    ：类型为`char*`，指向当前选项的参数，无则为NULL
        * optind    ：类型为`size_t`，作为下次调用getopt()将要处理的argv数组中元素的索引

> 命令行单个参数中可能有以下几种情况：
> * `-o`单个选项`o`
> * `-opt`多个选项`o` `p` `t`，且除了最后一个选项`t`，其它选项必须**没有参数**
> * `-ofile`单个选项`o`及其参数`file`
> * `file`作为前面**必有参数**的选项的参数，或者作为该命令需要的参数

> 非预期的情况有：
> * **必有参数**的选项作为命令行最后一个参数，即它没有参数
> * `optstring`中不存在当前选项
> * 以`-`开头的**命令行参数**若不被识别为选项参数，则会被视作选项
> * non-option-element，即不被识别为选项，又不作为选项参数的*命令行参数*，它应该作为该命令的参数，
>       这类参数会被getopt()转移到argv数组的最后，即当getopt()返回-1时，此时的optind即指向这类参数中第一个（如果有的话）
<!--  -->

* `int getopt_long(argc, argv, optstring, const struct option longopts[], int* longindex)`   `<getopt.h>`
    > 基本规则同`getopt()`，增加了对长选项的解析  
    > “长选项的紧跟”为`--option=arg`, 而且长选项若无歧义可不用完整输入
    * 参数longopts：
        > struct option的数组, 最后一个option必须全0以作为数组结束标志
        ```c
        struct option {
            const char* name;    // 选项名称
            int has_arg;         // no|required|optional_argrument
            int* flag;           // 等于NULL则函数返回val，否则匹配时*flag=val且函数返回0
            int val;             // 指定匹配到该选项时返回的int值
        };
        ```
    * 参数longindex：
        > 若不等于NULL，存储当前处理的长选项在`longopts`中的索引
* `getopt_long_only(argc, argv, optstring, option*, int*)`
    > 注：规则同上, 但是`-opt`会优先解析为长选项, 不符合再为短
<!-- -->

* SIMD：`<immintrin.h>`
    * 需要利用`alignas(32)`对齐数组
    * 向量寄存器抽象类型：
        * `__m256`
        * `__m256d`
        * `__m256i`
    * 加载到向量寄存器：
        ```c
        _mm256_load_ps( float* )
        _mm256_load_pd( double* )
        _mm256_load_epi256( __m256i* )
        ```
    * SIMD运算：
        ```c
        _mm256_OP_ps( __m256, __m256 )
        _mm256_OP_pd( __m256d, __m256d )
        _mm256_OP_epi32( __m256i, __m256i )
        _mm256_OP_epi64( __m256i, __m256i )
        ```
    * 存储回内存：
        ```c
        _mm256_store_ps( float* , __m256)
        _mm256_store_pd( double* , __m256d )
        _mm256_store_epi256( int* , __m256i )
        ```
<!-- -->

# 解释规范
> * 类聚合式构造    ：即是对每个数据成员进行copy/move构造
> * 逐块式构造      ：利用tuple传递每个数据成员的构造函数的实参
> * 成员模板构造    ：比如pair<int, char*>可以赋值给pair<int, string>，尽管类型不一样，
>   但提供了模板构造函数用于接收不同实例。
> * 所有需要使用`foo<T>::type`与`bar<T>::value`，都提供了模板类型别名`foo_t<T>`与变量模板`bar_v<T>`代替
> * **访问**表示可以读取也可以写入
> * .operator=()与.emplace()省略参数

# 通用工具
* initializer_list：`<initializer_list>`
    > 语言支持库，支持聚合初始化
    > * 使用列表初始化时，会优先调用参数为initializer_list的构造函数
    > * 在range-based-for中，可以直接在冒号右边用列表初始化构造initializer_list作为容器

* integer_sequence：`<utility>`
    * 构造
        * integer_sequence<typename T, T... INTS>
        * index_sequence<size_t... SIZETS>
        > 以下构造1 ~ N-1的T类型的证书序列
        * make_integer_sequence<typename T, T N>
        * make_index_sequence<size_t N>
    * 读取
        * ::size()                          ：获取整数个数
        * (integer_sequece<T, INTS...> t)   ：利用模板参数解包与折叠表达式处理INTS
<!--  -->

* pair：`<utility>`
    * 构造
        * 类聚合式构造    ：支持移动语义
        * 逐块式构造      ：(std::piecewise_constructor, make_tuple(args1), make_tuple(args2))
        * 成员模板构造
    * 访问
        * .first
        * .second
    * 比较：
        > 字典比较
<!-- -->

* tuple：`<tuple>`
    * 构造
        * 类聚合式构造    ：支持移动语义
        * 成员模板构造
        * 支持由pair赋值
    * 访问
        * get<T>(t) 与 get<N>(t)
            > 返回引用
    * 读取
        * tuple_size<TT>::value
        * tuple_element<N, TT>::type
        * tuple_cat(tuple1, tuple2, ...)
    * 比较：
        > 字典比较
<!-- -->

* any：`<any>`
    * 构造：
        * 默认构造      ：构造为nullptr
        * 类聚合式构造  ：支持移动语义
        * 就地构造      ：(std::in_place_type<Type>, args...)
    * 访问
        * any_cast<T&>(any)
    * 读取：
        * .has_value()
        * .type().name()
            > 利用关键字type_id()比较
    * 修改：
        * .operator=()
        * .emplace<T>()
        * .reset()
<!-- -->

* variant：`<variant>`
    * 构造：
        * 默认构造      ：默认构造第一个类型
            > std::monostate类作占位符避免无默认构造函数
        * 类聚合式构造  ：支持移动语义
            > 匹配最佳的类型，但注意char*匹配数值类型比匹配string更佳
        * 就地构造：
            * (std::in_place_type<Type>, args...)
            * (std::in_place_index<Type>, args...)
    * 读取：
        * .index()
    * 修改：
        * .operator=()
        * .emplace<T>()
        * .emplace<N>()
    * 访问：
        * get<T>(vrt)
        * get<N>(vrt)
        * get_if<T>(vrt*)
        * get_if<N>(vrt*)
        > get<>错误匹配类型会抛出异常，get_if<>错误匹配类型返回空指针
        * visit(func, vrt)
            > func为能接受所有vrt模板参数类型的重载可调用类型
    * 比较：
        > 字典序
<!-- -->

* optional：`<optional>`
    * 构造：
        * 默认构造      ：构造为std::nullopt
        * 类聚合式构造  ：支持移动构造
        * 就地构造      ：(std::in_place, args...)
    * 访问
        * .operator*()
        * .operator->()
    * 读取
        * .value()            ：nullopt则抛出异常
        * .value_or(type_val) ：nullopt则返回type_val
        * .operator bool()
<!-- -->

* shared_ptr：`<memory>`
    * 构造：
        * 拷贝/移动构造         ：更新引用计数
        * shared_ptr<T>(new_ptr, deleter)
        * make_shared<T>()
            > 对象内存与引用计数器一次分配  
            > 同时避免new表达式与用shared_ptr管理new获取的指针这两步之间发生异常，而导致内存泄漏（make_unique同）
    * 访问：
        * .operator*()
        * .operator->()
        * .get()
    * 读取：
        * .use_count()
    * 修改：
        * .reset()
        * .reset(ptr)
        * .reset(ptr, del)
    * 类型转换：
        * static_pointer_cast<>(sp)
        * dynamic_pointer_cast<>(sp)
        * const_pointer_cast<>(sp)
        * .operator bool()
    * 比较：
        > 比较存储的指针
    * 错误问题：
        * 循环依赖
        * 多组指向
<!-- -->

* weak_ptr：`<memory>`
    * 构造：
        * weak_ptr<T>(sp)
    * 访问：
        * .operator*()
        * .operator->()
    * 读取
        * .expired()
            > 返回是否为空
<!-- -->

* unique_ptr：`<memory>`
    * 构造：
        * unique_ptr<T, Del>(ptr, del)
            > del默认为delete表达式
        * make_unique<>()
        * 支持move, 拒绝copy
    * 访问：
        * .operator*()
        * .operator->()
        * .get()
    * 修改：
        * .reset()
        * .reset(ptr)
<!-- -->

* numeric_limits：`<limits>`
    * ::lowest()        ：负数最小值
    * ::min()           ：正数最小值
    * ::max()           ：最大值
    * ::digits          ：二进制数字位数
    * ::digits10        ：能准确表示的十进制数字位数
    * ::max_digits10    ：能表示的最大的十进制数字位数
    * ::max_exponent10  ：浮点数最大正指数
    * ::min_exponent10  ：浮点数最小负指数
    * ::infinity()      ：正无穷
    * ::quiet_NaN()     ：NAN
<!-- -->

* `<type_traits>`
    * 类型判断式
    * 类型修饰符
    * 类型关系检验
    * 类型计算
    * 常用：`decay<T>::type`
    * 使用：
        * ::value   ：返回std::true_type或std::false_type
        * ::type    ：返回修饰后的类型
        * wrapper函数利用上述两者封装调用重载的too函数
<!-- -->

* reference_wrapper：`<functional>`
    * 构造：
        * ref(obj)
        * cref(obj)
    * 转换：提供到目标引用的转换`from & to`
    * 访问
        * .get()    ：返回目标引用，如此才能调用其成员函数
<!--  -->

* hash：`<functional>`
    > 预定义：整型、浮点型、指针、智能指针、string、bitset<>、vector<bool>
<!-- -->

* ratio：`<ratio>`
    * 构造：预定义ratio类型
    * 读取：
        > 模板非类型参数作分子与分母
        * ::num    ：分子
        * ::den    ：分母
    * 运算：
        > 编译期运算、比较、化简、报错
        * 算术运算：ratio_OP<ratio1, ratio2>::type
        * 关系运算：ratio_OP<ratio1, ratio2>::value
<!-- -->

* 时间库：`<chrono>`
    * duration
        * 构造：
            * time_point相减
            * 字面值构造
        * 读取：
            * .count()
            * ::rep
            * ::period
        * 算术运算：会隐式转换为更高精度
        * 类型转换：转为粗精度直接截断数值
            * duration_cast<>()
    * Clock
        * 构造：
            * 预定义system_clock、steady_clock等
        * 读取：
            * ::now()
            * ::duration
            * ::time_point
            * system_clock还提供
                * ::from_time_t()
                * ::to_time_t()
    * time_point
        > 由Clock提供Epoch，
        > duration可相对为负值
        * 构造：
            * 默认构造为epoch
            * Clock::now()获取
            * time_point与duration运算
        * 算术运算、关系运算、类型转换
* `<ctime>`：
    * time(time_t*)                         ：获取当前时间并存储到time_t*指向的位置
    * localtime(time_t*); gmtime(time_t*)   ：传入上述的time_t*，返回`tm*`
* `<iomanip>`：
    > `fmt`格式见linux中date命令的格式
    * get_time(tm*, fmt)
    * put_time(tm*, fmt)
<!-- -->

# STL
> * STL组件
>     * 容器：序列、关联、无序
>         * 异常发生：容器reallocate, 元素的copy与move等
>         * 异常处理：容器保证reallocate异常安全；对于元素增删时产生的异常, 随机访问容器无法恢复, 节点式容器保证安全
>     * 迭代器：输出、输入、单向、双向、随机
>     * 泛型算法：搜索比较、更替复制、涂写删除
> * 解释：
>     * a : array
>     * s : string
>     * v : vector
>     * d : deque
>     * l : list
>     * fl: forward-list
>     * A : Assoicated
>     * U : Unordered
>     * M : all-kinds-of-Map
> * STL算法
>     * 为了简化，将重载函数的形参当作同一函数的默认实参来处理
>     * op1表示接收一个实参的操作数，op2接收两个
>     * b表示begin，e表示end
>     * partB表示是和b是同一个容器的且非end的迭代器
>     * destB表示是作为算法的输出区间
<!-- -->

* 容器构造：
    * 默认               ：all-a
    * (initializer-list) ：all-a
    * (beg, end)         ：all-a
    * 聚合初始化         ：a
    * 拷贝               ：all
    * 移动               ：all
    * (num)              ：v, d, l, fl
    * (num, value)       ：s, v, d, l, fl
    > array为聚合类  
    > 前三条对于A与U都可加额外参数(..., cmpPred)与(..., bnum, hasher, eqPred)
<!-- -->

* 容器赋值：
    * .operator=()                ：all
    * .fill(v)                    ：a
    * .assign(initializer-list)   ：all-a-A-U
    * .assign(beg, end)           ：all-a-A-U
    * .assign(num, value)         ：all-a-A-U
<!-- -->

* 容器访问：
    * .at(idx)                                ：a, s, v, d
    * .at(key)                                ：Map
    * .operator[](idx)                        ：a, s, v, d
    * .operator[](key)                        ：Map(自动创建key)
    * .front()                                ：a, v, d, l, fl
    * .back()                                 ：a, v, d, l
    * .data()                                 ：a, s, v
    * .begin(), .cbegin(), .end(), cend()     ：all
    * .rbegin(), .crbegin(), .rend(), crend() ：all-U-fl
<!-- -->

* 元素插入：
    * .insert(pos, value)            ：all
    * .insert(pos, num, val)         ：s, v, d, l
    * .insert(pos, initializer-list) ：s, v, d, l
    * .insert(pos, beg, end)         ：s, v, d, l
    * .insert(value)                 ：A, U(非multi返回pair<iter, bool>)
    * .insert(initializer-list)      ：A, U
    * .insert(beg, end)              ：A, U
    * .emplace(pos, args...)         ：v, d, l
    * .emplace(args...)              ：A, U(非multi返回pair<iter, bool>)
    * .emplace_hint(pos, args...)    ：A, U
    * .emplace_back(v)               ：v, d, l
    * .emplace_front(v)              ：d, l, fl
    * .push_back(v)                  ：s, v, d, l
    * .push_front(v)                 ：d, l, fl
<!-- -->

* 元素删除：
    * .erase(v)          ：A, U(返回删除个数)
    * .erase(pos)        ：all-fl
    * .erase(beg, end)   ：all-fl
    * .pop_back()        ：s, v, d, l
    * .pop_front()       ：d, l, fl
    * .clear()           ：all
<!-- -->

* 容器大小：
    * .empty()                   ：all
    * .size()                    ：all-fl
    * .max_size()                ：all
    * .resize(num)               ：s, v, d, l, fl
    * .resize(num, v)            ：s, v, d, l, fl
    * .capacity()                ：s, v
    * .reserve(num)              ：s, v, U(v不能缩小)
    * .shrink_to_fit()           ：s, v, d
<!-- -->

* 容器比较：
    * 相等比较：U
    * 非相等比较：all-U
<!-- -->

* U与A特有：
    * .count(v)         ：A, U
    * .find(v)          ：A, U
    * .lower_bound(v)   ：A
    * .upper_bound(v)   ：A
    * .equal_range(v)   ：A
    * .merge(C )        ：A, U
    * .extract(iter)    ：A, U
    * .extract(key)     ：A, U
        > .extract()的作用是利用move语义获取元素handle
<!-- -->

* U特有：bucket接口
    * .bucket_count()
    * .max_bucket_count()
    * .load_factor()
    * .max_load_factor()
    * .max_load_factor(float)
    * .rehash(bnum)
    * .bucket(val)
    * .bucket_size(bucktidx)
    * .begin(bidx)
    * .cbegin(bidx)
    * .end(bidx)
    * .cend(bidx)
<!-- -->

* l与fl特有
    * .remove(v)
    * .remove_if(op)
    * .sort()
    * .sort(op)
    * .unique()
    * .unique(op)
    * .splice(pos, sourceList, sourcePos)
    * .splice(pos, sourceList, sourceBeg, sourceEnd)
    * .merge(source)
    * .merge(source, cmpPred)
    * .reverse()
<!-- -->

* 迭代器辅助函数： `<iterator>`
    * next(iter, n=1)
    * prev(iter, n=1)
    * distance(iter1, iter2)
    * iter_swap(iter1, iter2)
<!-- -->

* 反向迭代器
    * 获取：容器的成员函数
        * .rbegin()
        * .rend()
        * .crbegin()
        * .crend()
    * .base()：反向迭代器的成员，转换为正常迭代器(+1)
<!-- -->

* 流迭代器
    * 获取：类模板构造
        * istream_iterator<T>(istream)              ：默认构造为end
        * ostream_iterator<T>(ostream, delim="")    ：`delim`为C-Style-String
    > 注： 只是通过I/O操作符实现, 而非底层I/O, 迭代器保存上次读取的值
<!-- -->

* 流缓冲区迭代器
    * 获取：类模板构造
        * istreambuf_iteratot<char>
            * ()    ：默认构造为end
            * (istrm)
            * (ibuf_ptr)
        * ostreambuf_iteratot<char>
            * (ostrm)
            * (obuf_ptr)
<!-- -->

* 移动迭代器
    * 获取：泛型函数获取
        * make_move_iterator(iter)
    * 作算法源区间, 需要保证元素只能处理一次
<!-- -->

* 插入迭代器
    * 获取：通过泛型函数
        * back_inserter(cont)
        * front_inserter(cont)
        * inserter(cont, pos)
<!-- -->

> * 泛型算法：`<algorithm>, <numeric>, <execution>`
> * 默认by value传递pred, 算法并不保证在类内保存状态的pred能正确运作(重新构造pred可能导致重置状态)
> * 获取谓词状态：
>     * 谓词指向外部状态
>     * 显式指定模板实参为reference
>     * 利用for_each()算法的返回值
> * 执行策略：做第一个参数
>     * std::seq        ：顺序执行（默认）
>     * std::par        ：多线程并行
>     * std::unseq      ：使用SIMD
>     * std::par_unseq  ：并行或SIMD
> * 规范：
>     * b, e代表源区间的begin与end
>     * op1, op2代表单参函数与双参函数
<!--  -->

* 非更易算法
    * for_each(b, e, op1)                   ：返回op1(已改动过的)拷贝
    * for_each_n(b, n, op1)
    * count(b, e, v)
    * count_if(b, e, op1)

* 最值比较
    * max(x, y)
    * max(initializer_list)
    * min(x, y)
    * min(initializer_list)
    * minmax(x, y)                          ：返回pair<min, max>
    * minmax(initializer_list)              ：返回pair<min, max>
    * clamp(x, min, max)                    ：返回三者中的第二大者
    * min_element(b, e, op2=lower_to)       ：返回第一个最小值
    * max_element(b, e, op2=lower_to)       ：返回第一个最大值
    * minmax_element(b, e, op2=lower_to)    ：返回第一个最小值和最后一个最大值
<!-- -->

* 搜索算法：返回搜索结果的第一个位置
    > 搜索单个元素
    * find(b, e, v)
    * find_if(b, e, op1)
    * find_if_not(b, e, op1)
    > 以下四个为二分搜索，需要先排序
    * binary_search(b, e, v, op2=lower_to)
    * lower_bound(b, e, v, op2=lower_to)
    * upper_bound(b, e, v, op2=lower_to)
    * equal_range(b, e, v, op2=lower_to)

    > 搜索子区间
    * search(b, e, searchB, searchE, op2=equal_to)          ：op2(elem, v)
    * search_n(b, e, n, v, op2=equal_to)                    ：op2(elem, v)
    * find_end(b, e, searchB, searchE, op2=equal_to)
    * adjacent_find(b, e, op2=equal_to)                     ：搜索一对连续相等的元素, 返回第一个位置

    > 搜索目标范围中的元素
    * find_first_of(b, e, searchB, searchE, op2=equal_to)   ：搜索
<!-- -->

* 更易算法：
    > 存在destB的算法返回dest区间的尾后迭代器
    * move(b, e, destB)                         ：支持子区间左移
    * move_backward(b, e, destE)                ：支持子区间右移
    * copy(b, e, destB)                         ：支持子区间左移
    * copy_backward(b, e, destE)                ：支持子区间右移
    * copy_if(b, e, destB, op1)
    * copy_n(b, n, destB)

    > 删除算法只是将需要删除的元素移到容器后面，若无destB则返回删除后新区间的尾后迭代器
    * remove(b, e, v)
    * remove_if(b, e, op1)
    * remove_copy(b, e, destB, v)
    * remove_copy_if(b, e, destB, op1)
    > unique算法删除相邻重复元素，应该先排序
    * unique(b, e, op2=equal_to)
    * unique_copy(b, e, destB, op2=equal_to)

    * replace(b, e, oldV, newV)                 ：返回void
    * replace_if(b, e, op1, newV)               ：返回void
    * replace_copy(b, e, destB, oldV, newV)
    * replace_copy_if(b, e, destB, op1, newV)
    * transform(b, e, destB, op1)               ：用`[b, e)`区间的元素调用op1()，并将返回结果写入destB
    * transform(b1, e1, b2, destB, op2)         ：用`[b1, e1)`与`[b2, e2)`的元素调用将op2()，并将返回结果写入destB
    * fill(b, e, v)                             ：返回void
    * fill_n(b, n, v)                           ：返回void
    * generate(b, e, op0)                       ：返回void
    * generate_n(b, n, op0)                     ：返回void
    * swap(x, y)                                ：返回void
    * swap_ranges(b, e, destB)
<!-- -->

* 变序算法
    > 存在destB的算法返回dest区间的尾后迭代器，
    > 存在partB或partE的算法返回part
    * sort(b, e, op2=lower_to)                      ：返回void
    * stable_sort(b, e, op2=lower_to)               ：返回void
    * partition_sort(b, partE, e, op=lower_to)      ：返回void
    * partition_sort_copy(b, partE, e, op2=lower_to)
    * nth_element(b, nth, e, op2=lower_to)          ：返回void
    * make_heap(b, e, op2=lower_to)                 ：返回void
    * push_heap(b, e, op2=lower_to)                 ：返回void
    * pop_heap(b, e, op2=lower_to)                  ：返回void
    * sort_heap(b, e, op2=lower_to)                 ：返回void
    * next_permutation(b, e, op=lower_to)           ：当元素为完全升序时返回false
    * prev_permutation(b, e, op=lower_to)           ：当元素为完全降序时返回false
    * reverse(b, e)                                 ：返回void
    * reverse_copy(b, e, destB)
    * rotate(b, partB, e)                           ：返回原本的begin现在的位置
    * rotate_copy(b, partB, e, destB)
    * shuffle(b, e, randomEngine)                   ：返回void
    * sample(b, e, destB, cnt, randomEngine)        ：随机取cnt个值到destB
    * shift_left(b, e, cnt)                         ：返回左移后区间的尾后迭代器
    * shift_right(b, e, cnt)                        ：返回右移后区间的尾后迭代器
    * partition(b, e, op1)                          ：返回划分的前半部分的尾后迭代器
    * stable_partition(b, e, op1)                   ：返回划分的前半部分的尾后迭代器
    * partition_copy(b, e, destTrueB, destFalseB, op1)
<!-- -->

* 区间检验与比较：一般返回boolean
    * equal(b, e, cmpB, op2 = equal_to)
    * mismatch(b, e, cmpB, op2 = equal_to)                  ：查找第一个不相同的元素, 返回pair存储两个区间的不同点的迭代器
    * lexicographical_compare(b1, e1, b2, e2, op = lower_to)：比较两区间字典序
    * is_sorted(b, e, op2 = lower_to)
    * is_sorted_until(b, e, op2 = lower_to)                 ：返回已排序区间的尾后迭代器
    * is_heap(b, e, op2 = lower_to)
    * is_heap_until(b, e, op2 = lower_to)                   ：返回已堆排序区间的尾后迭代器
    * is_partitioned(b, e, op1)
    * partition_point(b, e, op1)                            ：返回满足op1()为true的区间的尾后迭代器
    * includes(b1, e1, b2, e2, op2 = equal_to)              ：区间`[b2, e2)`是否为区间`[b1, e1)`的**子序列**
    * is_permutation(b1, e1, b2, op2 = equal_to)            ：检测两个区间的所有元素是否为同一个集合，即不考虑顺序
    * all_of(b, e, op1)
    * any_of(b, e, op1)
    * none_of(b, e, op1)
<!-- -->

* 集合算法
    > 需要先排序
    * merge(b1, e1, b2, e2, destB, op2=lower_to)
    * inplace_merge(b1, partB, e2 ,op=lower_to)                         ：将同一个集合中的两部分合并, 两部分都有序
    * set_union(b1, e1, b2, e2, destB, op2=lower_to)                    ：并集
    * set_intersection(b1, e1, b2, e2, destB, op2=lower_to)             ：交集
    * set_difference(b1, e1, b2, e2, destB, op2=lower_to)               ：前一个集合去交集
    * set_symmetric_difference(b1, e1, b2, e2, destB, op2=lower_to)     ：并集去交集
<!-- -->

* 数值算法：`<numeric>`
    * iota(b, e, v)                                                     ：依序赋值 V, V+1, V+2, ...
    * accumulate(b, e, initV, op2=plus)                                 ：求和
    * reduce(b, e, initV=0, op2=plus)                                   ：允许使用执行策略的求和
    * inner_product(b1, e1, b2, e2, initV, op2=plus, op2 = multiply)    ：内积
    * partial_sum(b, e, destB, op2=plus)                                ：a1, a1+a2, a1+a2+a3,
    * adjacent_difference(b, e, destB, op2=reduce)                      ：a1, a2-a1, a3-a2,
<!-- -->

# 字符串与流

* bitset：`<bitset>`
    * 方便访问指定位
    * 构造：() (ulong) (string) (cstring)
    * 操作：
        * .any()
        * .all()
        * .none()
        * .count()
        * .size()
        * .set()
        * .set(pos, v=true)
        * .reset()
        * .reset(pos)
        * .flip()
        * .flip(pos)
        * .operator[](idx).flip()
    * 转换：
        * .to_ulong()
        * .to_ullong()
        * .to_string(zero, one)
<!-- -->

* string：`<string>`
    > 范围：(i, l)、(b, e)  
    > 目标：(s)、(s, i)、(s, i, l)、(c)、(c, l)、(char)、(n, char)
    * 修改
        * string() .assign() .append()      ：目标
        * operator= operator+ operator+=    ：(s)、(c)、(char)
        * .insert()                         ：pos + 目标（除了(char)）
        * .replace()                        ：范围+ 目标
    * 搜索
        > 参数：(s) (s,i) (c) (c,i) (c,i,l) (char) (char,i)
        * .find()
        * .rfind()
        * .find_first_of()
        * .find_first_not_of()
        * .find_last_of()
        * .find_last_not_of()
    * 比较
        * .compare()                        ：范围+目标（除了(char)、(n, char)）
        * .operator<=>()                    ：(s)、(c)
    * 转换
        * stoi() stol() stoul() stof() stod()：(str, idx=nullptr, base=10)
        * to_string(val)
    * 其它
        * .substr()                         ：范围
        * .copy(c, length, idx)             ：不包含`\0`
        * getline(istrm, string)
<!-- -->

* string_view：`<string_view>`
    > 原理：只是string或C-string的引用, 没有数据的拥有权, 只含有元数据  
    > 目的：高效的提供string接口的拷贝操作, 尤其.substr(), 当需要const string时改用string_view  
    > 注意：所有拷贝共享一个底层数据, 所以.substr().data()会导致错误（因为'\0'只在最后才有）
    * 构造：(string) (string_view) (cstring) (cstring, len)
    * 额外提供：.remove_prefix和.remove_suffix缩减视图范围
<!-- -->

* 正则表达式：`<regex>`
    * 组件：
        * regex
        * sregex_iterator
        * sregex_token_iterator
        * smatch
        * ssub_match
        * regex_search()
        * regex_match()
        * regex_replace((str|b, e), regex, repl, flag)
        * regex_contants： 标志用于控制regex、match、replace行为
    * regex
        > flag 主要就有 regex_constants::icase
        * (string, flag)
        * (char*, flag)
        * (char*, len, flag)
        * (b, e, flag)
    * sregex_iterator
        > 自增自减移动模式匹配到的子串  
        > 解引用得到smatch
        * 构造：(b, e, regex)，默认初始化为end
    * sregex_token_iterator
        > 保留不匹配间的子字符串
        * (b, e, r, -1)
    * smatch
        > 存放ssub_match的容器  
        > 0索引存放整个模式匹配到的子串
        * .begin() .cbegin() .end() .cend()
        * .size()
        * .empty()
        * .operator[](idx)
        * .prefix()
        * .suffix()
        * .length(n)
        * .position(n)  ：返回difference_type数字
        * .str(n)
        * .format(dest, fmt, flag)
        * .format(fmt, flag)
    * ssub_match： 指向表达式匹配到的子表达式
        * .operator basic_string<charT>()
    * 替换语法：
    ```
        $1, $2, $3, ...
        $&：全部
        $'：后缀
        $`：前缀
        $$：转义$
    ```
<!-- -->

* iostream：`<iostream>`
    * 状态与异常
        * .good()
        * .eof()
        * .faile()
        * .bad()
        * .rdstate()
        * .clear()
        * .clear(state)
        * .setstate(state)
        * .excptions(flags) ：设定触发异常的flag
        * .exceptions()     ：返回触发异常的flag, 无则返回ios::goodbit
    * 底层I/O：
        * .get()
        * .get(char&)
        * .get(char*, count, delim='\n')     ：读取 count - 1 个字符, 并自动添加'\0'在末尾
        * .getline(char*, count, delim='\n') ：其他同上, 但读取包括delim
        * .read(char*, count)                ：count代表指定读取的字符
        * .readsome(char*, count)            ：返回读取字符数, 只从缓冲区中读取, 而不陷入系统调用
        * .gcount()                          ：返回上次读取字符数
        * .ignore(count=1)
        * .ignore(count, delim)
        * .peek()                            ：返回下个字符, 但不移动iterator
        * .unget()                           ：把上次读取的字符放回（回移iterator）
        * .putback(char)                     ：放回指定字符
        * .put(char)
        * .write(char*, count)
        * .flush()
    * 随机访问：
        * .tellg()
        * .tellp()
        * .seekg(pos) .seekp(pos)
        * .seekg(offset, rpos) .seekp(offset, rpos)：rpos可以是ios::beg ios::end ios::cur
    * 预定义I/O运算符：
    ```
        * 整型：  
            [0-7]*  
            [0-9]*
            (0x|0X)?[0-9a-fA-F]*
        * 浮点型：  
            ([0-9]+\.?[0-9]*|\.[0-9]+)(e[+-]?[0-9]+)
        * 其他：bool, char, char*, void*, string, streambuf*, bitset, complex
    ```
    * 关联stream：
        * 以.tie()和.tie(ostream&)关联, 在I/O该stream时冲刷关联的ostream
        * 以.rdbuf()和.rdbuf(streambuf*)关联, 对同一缓冲区建立多个stream对象
        * 以.copyfmt()传递所有格式信息
    * 关于性能
        * ios::sync_with_stdio(false)：关闭C-stream同步与多线程同步机制
        * cin.tie(nullptr)：关闭cin与cout的关联
    * 国际化
        * .imbue(locale)
        * .getloc()
        * .widen(char)
        * .narrow(c, default)
<!-- -->

* 操作符：`<iomanip>`
    > 后面加`!`代表默认
    > IStream
    * ws                            ：立刻丢弃前导空白
    * noskipws | skipws!            ：是否需要输入时忽略前导空白
    > OStream
    * endl                          ：输出`\n`并刷新缓冲区
    * ends                          ：输出`\0`
    * flush                         ：刷新缓冲区
    * nounitbuf | unitbuf           ：是否每次都刷新缓冲区
    * setfill(char)                 ：用char填充setw()制造的空白，默认空格
    * left                          ：使用setw()后输出左对齐
    * right!                        ：使用setw()后输出右对齐
    * internal                      ：正负号靠左，数值靠右（无`no`版本）
    * noboolalpha! | boolalpha      ：是否字符化输出boolean，如`true`和`false`
    * noshowpos! | showpos          ：是否正数输出正号
    * nouppercase! | uppercase      ：是否对数值输出中的字母强制大写或强制小写
    * noshowpoint! | showpoint      ：是否小数部分为零的浮点数也打印小数部分
    * noshowbase! | showbase        ：是否对二/八/十六/进制的数字输出进制前缀
    * setprecision(v)               ：设置输出浮点数的精度
        > 使用以下两个操作符后, 精度的语义由“所有数字位数”变为“小数位数”
        * fixed                     ：强制用定点表示法输出浮点数
        * scientific                ：强制用科学计数法输出浮点数
    > IOStream
    * oct | dec! | hex              ：设置输入或输出数值时的进制
    * setw(n)                       ：设定下次输出的栏宽，或输入的字符限制最多n-1个
<!-- -->

* quoted：`<iomanip>`
    > 将字符串引用转义  
    > 输出(`<<`)时quoted()的参数作为引用转义的输入对象  
    > 输入(`>>`)时quoted()的参数作为引用转义的输出对象
    * 签名：
        `quoted(char* s, delim='"', escape='\\')`  
        `quoted(string& s, delim='"', escape='\\')`  
```cpp
string in{"hello \"world\""}, out;
stringstream ss;
ss << quoted(in);   // 输出时进行引用。ss.str() == "\"hello \\\"world\\\""，即输出"hello \"world\""
ss >> quoted(out);  // 输入是取消引用。将ss中被引用包围后的字符还原，即out输出为hello "world"
```

* fstream：`<fstream>`
    * 构造：(filename, flag=)
    * 成员：
        * .open(filename, flag=)
        * .is_open()
        * .close()
    * flags：`ios_base::`
        > 若未指出**文件必须存在**，则表示**不存在则自动创建**
        * in            ：只读，文件必须存在
        * out           ：只写，覆盖
        * app           ：只写，追加
        * in|out        ：读写，文件必须存在
        * in|out|trunc  ：读写，覆盖
        * in|app        ：读写，追加
        * binary        ：不要将`\r\n`替换为`\n`
<!-- -->

* stringstream：`<sstream>`
    * 构造：(string)
    * 成员：
        * .str()
        * .str(string)
<!-- -->

* streambuf：`<streambuf>`
    * 销毁问题：basic_i/ostream析构时不会销毁, 其他stream析构时只是不销毁.rdbuf()得到的
    * 高效非格式化I/O：
        * streambuf_iterator    ：不通过stream对象直接I/O缓冲区
        * `streambuf*`          ：利用stream.rdbuf()获取后直接调用I/O运算符与另一个流缓冲区对接, 注意输入时需要std::noskipws
<!-- -->

* locale：`<locale>`
    * locale：封装了多个facet用于多方面信息本地化
    * facet：数值、货币、时间、编码
    * locale的构造：
        * 默认："C"
        * 智能：""
        * 自定义：`zh_CN.UTF-8[@modifier]`
    * 提供
        * .name()
        * ::global(locale)
<!-- -->

* Stream库总览：`<iofwd>`
* 组件：
    * streambuf(系统I/O并缓存数据, 提供位置信息)
    * locale(包含facet将I/O进行进行本地格式化)
    * stream(封装上述两者, 提供状态、格式化信息)
    * centry(帮助stream每次I/O预处理与后处理)
    * 操作符(提供调整stream的便捷方法)
    * std::ios(定义了一些标志位)
<!-- -->

* 字符转换与处理：
    > `<codecvt>`   ：字符编码转换器
    > `<locale>`    ：转换宽字符需要此头文件
    例：
    * 转换stream_buffer
    ```cpp
    wbuffer_convert<codecvt_utf8<wchar_t> > utf8_to_wchar_t(cin.rdbuf())
    wistream get_wstring_from_multibytes_stream(&utf8_to_wchar_t)
    get_wstring_from_multibytes_stream >> wstring;

    wbuffer_convert<codecvt_utf8<wchar_t> > wchar_t_to_utf8(cout.rdbuf())
    wostream put_wstring_to_multibytes_stream(&wchar_t_to_utf8)
    put_wstring_to_multibytes_stream << wstring; // 注意结束时必须冲刷该缓冲区，不然会有字符留在里面未输出
    // 注意cout与put_wstring_to_multibytes_stream的缓冲区并不一样，
    ```
    * 转换string
    ```cpp
    wstring_convert<codecvt_utf8<wchar_t>> convertor
    convertor.to_bytes(wstring&)
    convertor.from_bytes(string)
    /* 参数：
     * (char byte);
     * (const char* ptr);
     * (const byte_string& str);
     * (const char* first, const char* last);
     */

    ```
<!-- -->

* 随机数生成器：`<random>`
* 引擎：
    * default_random_engine
    * .seed()
    * .seed(result_type)
* 分布：
    > 使用：先构造分布对象，再用引擎作参数调用其.operator()(re)
    * uniform_int_distribution di(min=0, max=INTMAX)    ：min-max的均匀整数分布
    * uniform_real_distribution dr(min=0, max=1.0)      ：min-max的均匀实数分布
    * bernoulli_distribution db(p=0.5)                  ：0-1分布，返回bool
    * binomial_distribution dbi(n=1, p=0.5)             ：二项分布
    * normal_distribution dn(u=0, o=1)                  ：正态分布
<!-- -->

# 并发
* 线程并行：`<thread>` `<future>`
    * async(launch::async, func, args...)
        > 封装并启动线程函数, 将其返回值存到shared data  
        > 注意，若不将返回值 赋值给future，则不会异步启动  
        > 注意，func函数不能使用默认return
        * 发射策略
            * launch::async         ：异步调用
            * launch::deferred      ：延迟发射
    * future<>和shared_future<>
        > 可获取shared_data, 还包括状态, 句柄, 异常
        * .valid()
        * .get()                    ：获取返回值或异常
        * .wait()                   ：不获取返回值或异常而取消future状态
        * .wait_for(duration)       ：不会启动延迟发射的任务
        * .wait_until(time_point)   ：不会启动延迟发射的任务 
            > 返回等待状态
            >   * future_status::deferred
            >   * future_status::timeout
            >   * future_status::ready
        * .share()
    * this_thread::
        * get_id()
        * sleep_for(dur)
        * sleep_until(tp)
        * yield()
<!-- -->

> * 并发问题
>     * 访问共享数据： 数据竞争、数据销毁
>     * 编译器优化： 访存优化、顺序优化
<!-- -->

* 互斥锁：`<mutex>`
    * mutex及其变种：
        * 用法：在全局中声明

        | 操作                | mutex | recursive_mutex | shared_mutex | timed_mutex | recursive_timed_mutex | shared_timed_mutex |
        |---------------------+-------+-----------------+--------------+-------------+-----------------------+--------------------|
        | .lock()             |                                   捕获mutex，失败则阻塞                                           |
        | .try_lock()         |                               捕获mutex，失败则返回false                                          |
        | .unlock()           |                                   解除锁定的mutex                                                 |
        | .try_lock_for(dur)  |   -   |        -        |      -       |                限制时间内尝试捕获                        |
        | .try_lock_until(tp) |   -   |        -        |      -       |                限制期限前尝试捕获                        |
        | 多个lock            |   -   |        🉑️️       |      -       |      -      |          🉑️️           |         -          |
    * 辅助函数：
        * lock(mutex...)      ：避免死锁
        * try_lock(mutex...)  ：保证加锁次序
        * once_flag类型
        * call_once(once_flag, func, args...)
    * mutex托管：
        > 用法：mutex做模板类型, mutex对象做构造参数(可能还有其他参数), 在块作用域中初始化
        * lock_guard<>额外参数：adopt_lock(已锁)
        * unique_lock<>额外参数：
            * adopt_lock(已锁)
            * defer_lock(不锁)
            * try_lock(试锁)
            * duration
            * time_point
        * shared_lock<>
    * 提供原子性操作原理：
        * 读取mutex - 判断mutex - 上锁或阻塞
        * 解锁-唤醒
<!-- -->

* 条件量：`<condition_variable>`
    > 依赖于unique_lock`<>`提供保护区, 在全局中声明，  
    > 注意由mutex锁住的线程由mutex唤醒，被condition_variable锁住的线程由condition_variable唤醒，
    > 前者可由lock_guard自动触发唤醒机制，而condition_variable需要手动
    * 成员：
        * .wait(u_l, pred)
        * .wait_for(u_l, dur, func)
        * .wait_until(u_l, tp, func)
            > 返回等待状态：
            > * cv_status::time_out
            > * cv_status::no_timeout
        > 解锁后再notify
        * .notify_one()
        * .notify_all()
        * notify_all_at_thread_exit(cv, ul)
    * 提供原子性操作：
        * 解锁-阻塞
        * 唤醒
<!-- -->

