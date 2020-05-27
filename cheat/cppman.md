> # 注意：  
> 该文档虽然是Markdown格式，但是因为这篇文档主要用来在终端下通过`see`命令来快速查阅的，  
> 故编写时为了终端环境下更好看，以markdown格式渲染出来的画面就有些不可描述了:joy:  
> 因为代码中有很多`<>`、`_`、`*`都会被当作标签
> 所以这篇文档得看源码哦

# 标准库异常
* 异常体系结构
```
exception <exception>`  
├─── bad_cast             `<typeinfo>`      ：多态引用的转换失败  
├─── bad_typeid           `<typeinfo>`      ：目标为含有虚函数的类型的空指针  
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
│   ├─── out_of_range                       ：数组类型的无效索引  
│   └─── future_error     `<future>`        ：异步  
│  
└─── runtime_error        `<stdexcept>`  
    │  
    ├─── range_error                        ：wide string与byte string转换出错  
    ├─── overflow_error                     ：bitset转换为整型溢出  
    ├─── underflow_error                    ：算术下溢  
    └─── system_error     `<system_error>`  ：并发  
        │  
        └─── ios::failure `<ios>`           ：stream出错  
```
<!-- -->

* 异常成员
    * .what() ：返回`const char*`用于打印
        > 异常类销毁后该C-string也不复存在  
        > 根部基类**exception**的虚函数
    * .code() ：返回error_code类对象
        > error_code 与 error_condition 区别：可移植性  
        > 前者由编译器定义(OS相关), 后者为默认标准
        * error_code成员：
            * .value()
            * .message()
            * .category().name()
            * .default_error_condition()
            * .default_error_condition().value()
            * .default_error_condition().message()
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

# 运算符优先级
* 运算符优先级
![cpp](../images/cppman.png)

# C库
* 调试：`<cassert>`
    * assert(expr)                  ：运行时断言, false则执行
        > #define NDEGUG  
        > 可以取消宏函数assert()
    * static_assert(expr, message)  ：编译期断言, 可以自定义打印消息
        > #define NDEBUG  
        > 并不会取消关键字static_assert()
    * 编译器预处理宏：
        * `__func__`
        * `__FILE__`
        * `__LINE__`
        * `__TIME__`
        * `__DATE__`
<!-- -->

* 选项处理：`<unistd.h>短版, <getopt.h>`长版
    * int getopt(argc, argv, optstring)
        * 参数argc与argv：
            > `int main(int argc, char* argv[])`
        * 参数optstring：
            > C-Style字符串
            * `t`       ：代表没有参数  
            * `t:`      ：代表必有参数, **紧跟**或**间隔**都被视为参数  
            * `t::`     ：代表可选参数, 只识别**紧跟**为参数
        * 返回int：
            > 表示当前选项字符
            * `?`       ：表示无对应选项
            * `-1`      ：表示结束
        * 全局变量：
            * optarg    ：指向当前选项的参数
            * optind    ：指向当前处理的argv数组的索引
    * int getopt_long(argc, argv, optstring, long_opt, long_optind)
        > 在上述基础上增加对长选项的支持  
        > 注：规则同上, 不过"紧跟"用`=`区别与选项, 而且长选项可不用完整输入
        * 参数long_opt：
            > struct option的数组, 最后一个option必须全0以作为数组结束标志
            ```c
            struct option {
                const char* name;    // 参数名称
                int has_arg;         // no|required|optional_argrument
                int* flag;           // 不设为NULL则匹配时*flag=val且函数返回0
                int val;             // 指定匹配到该选项时返回的int值
            };
            ```
        * 参数long_optind：
            > 传入一个int*用于存放当前处理option数组的下标
    * getopt_long_only(argc, argv, optstring, option*, int*)
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

# 通用工具
* pair：`<utility>`
    * 构造
        * 类聚合式构造      ：支持移动语义
        * 逐块式构造      ：
            * (std::piecewise_constructor, make_tuple(args1), make_tuple(args2))
                > 第一个参数作用是避免与构造pair<tuple1, tuple2>冲突
        * 模板拷贝控制    ：支持不同模板实例隐式类型转换
    * 读取与写入
        * .first
        * .second
    * 比较：
        > 字典比较
<!-- -->

* tuple：`<tuple>`
    * 构造
        * 类聚合式构造    ：支持移动语义
        * 模板拷贝控制    ：支持不同模板实例隐式类型转换
        * 支持由pair赋值
    * 读取
        * get<T>(t) 与 get<N>(t)
            > 返回引用
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
        * 就地构造      ：
            * (std::in_place_type<Type>, args...)
    * 读取：
        * .has_value()
        * .type().name()
            > 利用关键字type_id()比较
        * any_cast<T&>(any)
    * 修改：
        * .operator=()
        * .emplace<T>()
        * .reset()
<!-- -->

* variant：`<variant>`
    * 构造：
        * 默认构造      ：构造第一个类型
            > std::monostate类作占位符避免无默认构造函数
        * 类聚合式构造  ：支持移动语义
            > 匹配最佳的类型  
            > 注意：char*匹配数值类型比匹配string更佳
        * 就地构造：
            * (std::in_place_type<Type>, args...)
            * (std::in_place_index<Type>, args...)
    * 读取：
        * .index()
        * get<T>(vrt)         与 get<N>(vrt)
        * get_if<T>(&variant) 与 get_if<N>(&variant)
        > 注：get<>错误匹配类型会抛出异常  
        > 注：get_if<>错误匹配类型返回空指针
    * 修改：
        * .operator=()
            > 注意：若类型不匹配则会抛出异常
        * .emplace<T>()
        * .emplace<N>()
    * 访问：
        * visit(func, vrt)
            > func为能接受所有vrt模板参数类型的重载可调用类型
<!-- -->

* optional：`<optional>`
    * 构造：
        * 默认构造      ：构造为std::nullopt
        * 类聚合式构造  ：支持移动构造
        * 就地构造      ：
            * (std::in_place, args...)
    * 读取与修改：
        * .operator bool()
        * .operator*()
        * .operator->()
        * .value()            ：nullopt则抛出异常
        * .value_or(type_val) ：nullopt则返回type_val
<!-- -->

* shared_ptr：`<memory>`
    * 构造：
        * 拷贝/移动构造         ：更新引用计数
        * shared_ptr<T>(new_ptr, deleter)
        * make_shared<T>()
            > 对象内存与引用计数器一次分配
    * 读取：
        * operator*()
        * operator->()
        * .use_count()
    * 修改：
        * .reset()
        * .reset(ptr)
        * .reset(ptr, del)
    * 类型转换：
        * static_pointer_cast<>()
        * dynamic_pointer_cast<>()
        * const_pointer_cast<>()
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
    * 读取：
        * .operator*()
        * .operator->()
        * .expired()
            > 返回是否为空
<!-- -->

* unique_ptr：`<memory>`
    * 构造：
        * unique_ptr<T, Del>(ptr, del)
            > del默认为delete表达式
        * 支持移动构造, 拒绝拷贝构造
    * 读取：
        * .get()
    * 修改：
        * .reset()
        * .reset(ptr)
<!-- -->

* numeric_limits：`<limits>`
    * ::lowest()
        > 负数
    * ::min()
        > 正数
    * ::max()
    * ::infinity()
    * ::quiet_NaN()
<!-- -->

* TypeTrait：`<type_traits>`
    * 类型判断式
    * 类型关系检验
    * 类型修饰符
    * 常用：decay_t`<T>`
    * 使用：
        * ::value   ：返回std::true_type或std::false_type
        * ::type    ：返回修饰后的类型
        * `typetrait_t<T>` 代替 `typename typetrait<T>::type`
        * 通过包装函数处理/过滤类型后调用工具函数
            * 利用::value调用重载工具
            * 利用::type转换类型传递给模板或修改参数类型
<!-- -->

* reference_wrapper：`<functional>`
    * 构造：
        * ref()
        * cref()
    * 转换：提供到目标引用的转换from&to
    * 读取：
        * .get()    ：返回目标引用才能调用成员函数
<!-- -->

* function：`<functional>`
    * 运行时能够统一可调用类型的三种形式
        * 函数指针
        * 成员函数指针
        * 函数对象(包括lambda表达式)
<!-- -->

* ratio：`<ratio>`
    * 构造：预定义ratio类型
    * 读取：模板非类型参数作分子与分母
        * ::num    ：分子
        * ::den    ：分母
    * 运算：编译期运算、比较、化简、报错
        * ratio_OP<ratio1, ratio2>::type
        * ratio_OP<ratio1, ratio2>::value
<!-- -->

* 时间库：`<chrono>`
    * duration
        * 构造：
            * time_point相减
            * 预定义字面值
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
        * 构造：
            * 默认构造为epoch
            * Clock::now()获取
            * time_point与duration运算
                > 注：由Clock提供Epoch, duration可相对为负值
        * 算术运算
        * 关系运算
        * 类型转换：
            * time_point_cast<Clock, Duration>(tp)
    * `<ctime>`：
        * time(time_t*)                         ：获取当前时间
        * localtime(time_t*); gmtime(time_t*)   ：返回`tm*`
    * `<iomanip>`：
        * get_time(tm*, fmt)
        * put_time(tm*, fmt)
<!-- -->

> * STL组件
>     * 容器：序列、关联、无序
>         * 异常发生：容器reallocate, 元素的copy与move
>         * 异常处理：容器保证reallocate安全；对于元素产生的异常, 随机访问容器无法恢复, 节点式容器保证安全
>     * 迭代器：输出、输入、单向、双向、随机
>     * 泛型算法：搜索比较、更替复制、涂写删除
> * 以下：
>     * a : array
>     * s : string
>     * v : vector
>     * d : deque
>     * l : list
>     * fl: forward-list
>     * A : Assoicated
>     * U : Unordered
>     * M : all-kinds-of-Map
<!-- -->

* 容器构造：
    * 默认               ：all-a
    * (initializer-list) ：all-a
    * (beg, end)         ：all-a
    * 拷贝               ：all
    * 移动               ：all
    * (num)              ：v, d, l, fl
    * (num, value)       ：s, v, d, l, fl
    > 注：array只有拷贝构造、移动构造与聚合初始化  
    > 注：前三条对于A与U都可加额外参数(..., cmpPred)与(..., bnum, hasher, eqPred)
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

* 容器插入：
    * .insert(pos, value)            ：all
    * .insert(pos, num, val)         ：s, v, d, l
    * .insert(pos, initializer-list) ：s, v, d, l
    * .insert(pos, beg, end)         ：s, v, d, l
    * .insert(value)                 ：A, U(非multi返回`pair<iter, bool>`)
    * .insert(initializer-list)      ：A, U
    * .insert(beg, end)              ：A, U
    * .emplace(args...)              ：A, U(非multi返回`pair<iter, bool>`)
    * .emplace(pos, args...)         ：v, d, l
    * .emplace_hint(pos, args...)    ：A, U
    * .emplace_back(v)               ：v, d, l
    * .emplace_front(v)              ：d, l, fl
    * .push_back(v)                  ：s, v, d, l
    * .push_front(v)                 ：d, l, fl
<!-- -->

* 容器删除：
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
    * 相等比较：all
    * 非相等比较：all-U
<!-- -->

* A与U特有：
    * .count(v)      ：A, U
    * .find(v)       ：A, U
    * .lower_bound(v)：A
    * .upper_bound(v)：A
    * .equal_range(v)：A
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
    * .splice(pos, source, sourcePos)
    * .splice(pos, source, sourceBeg, sourceEnd)
    * .merge(source)
    * .merge(source, cmpPred)
    * .reverse()
<!-- -->

* 迭代器辅助函数：`<iterator>`
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

* 插入迭代器
    * 获取：通过泛型函数
        * back_inserter(cont)
        * front_inserter(cont)
        * inserter(cont, pos)
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

> * 泛型算法：`<algorithm>, <numeric>, <execution>`
> * 默认by value传递谓词, 算法并不保证在类内保存状态的谓词能正确运作(拷贝谓词导致重置状态)
> * 获取谓词状态：
>     * 谓词指向外部状态
>     * 显式指定模板实参为reference
>     * 利用for_each()算法的返回值
> * 并行算法：第一参数为std::execution::par

* 其它算法
    * for_each(b, e, op1)                 ：返回op(以改动过的)拷贝
    * count(b, e, v)
    * count_if(b, e, op1)
    * min_element(b, e, op2 = lower_to)   ：返回第一个最小值
    * max_element(b, e, op2 = lower_to)   ：返回第一个最大值
    * minmax_element(b, e, op2 = lower_to)：返回第一个最小值和最后一个最大值
<!-- -->

* 搜索算法：返回第一个位置
    * find(b, e, v)                                         ：相当于string::find(), 利用反向迭代器则相当于string::rfind()
    * find_if(b, e, op1)
    * find_if_not(b, e, op1)
    * search_n(b, e, count, v, op2 = equal_to)              ：op2(elem, v)
    * search(b, e, searchB, searchE, op2 = equal_to)        ：相当于string::find()
    * find_end(b, e, searchB, searchE, op2 = equal_to)      ：相当于string::rfind()
    * find_first_of(b, e, searchB, searchE, op2 = equal_to) ：相当于string::find_first_of(), 利用反向迭代器则相当于string::find_last_of()
    * adjacent_find(b, e, op2 = equal_to)                   ：搜索一对连续相等的元素, 返回第一个位置
<!-- -->

* 更易算法：返回dest更易区间的尾后迭代器
    * move(b, e, destB)
    * move_backward(b, e, destE)         ：调用std::move(element)
    * copy(b, e, destB)                  ：子区间前移
    * copy_backward(b, e, destE)         ：子区间后移
    * copy_if(b, e, destB, op1)
    * copy_n(b, size, destB)
    * transform(b, e, destB, op1)        ：将op1(sourceElem)返回结果写入destB
    * transform(b1, e1, b2, destB, op2)  ：将op2(srcElem1, srcElem2)返回结果写入destB
    * swap_ranges(b, e, destB)
    * replace(b, e, oldV, newV)
    * replace_if(b, e, op1, newV)
    * replace_copy(b, e, destB)
    * replace_copy_if(b, e, destB, op1, newV)
    * remove(b, e, v)
    * remove_if(b, e, op1)
    * remove_copy(b, e, destB, v)
    * remove_copy_if(b, e, destB, op1)
    * unique(b, e, op2=equal_to)         ：需要先排序
    * unique_copy(b, e, destB, op2 = equal_to)
    * fill(b, e, v)
    * fill_n(b, num, v)
    * generate(b, e, op0)
    * generate(b, num, op0)
    * iota(b, e, T)                      ：赋值T, T+1, T+2, ...
<!-- -->

* 变序算法
    * reverse(b, e)
    * reverse_copy(b, e, destB)
    * rotate(b, newB, e)                 ：返回原本的begin现在的位置
    * rotate_copy(b, newB, e, destB)
    * next_permutation(b, e, op = lower_to)
    * prev_permutation(b, e, op = lower_to)
    * shuffle(b, e, randomEngine)
    * partition(b, e, op1)
    * stable_partition(b, e, op1)
    * partition_copy(b, e, destTrueB, destFalseB, op1)
    * sort(b, e, op2 = lower_to)
    * stable_sort(b, e, op2 = lower_to)
    * partition_sort(b, partE, e, op = lower_to)
    * partition_sort_copy(b, partE, e, op2 = lower_to)
    * nth_element(b, nth, e, op2 = lower_to)
    * make_heap(b, e, op2 = lower_to)
    * push_heap(b, e, op2 = lower_to)
    * pop_heap(b, e, op2 = lower_to)
    * sort_heap(b, e, op2 = lower_to)
<!-- -->

* 已排序区间算法
    * binary_search(b, e, v, op2 = lower_to)
    * includes(b1, e1, b2, e2, op2 = equal_to)                          ：2区间是否为1区间的子序列
    * lower_bound(b, e, v, op2 = lower_to)
    * upper_bound(b, e, v, op2 = lower_to)
    * equal_range(b, e, v, op2 = lower_to)
    * merge(b1, e1, b2, e2, destB, op2 = lower_to)
    * set_union(b1, e1, b2, e2, destB, op2 = lower_to)
    * set_intersection(b1, e1, b2, e2, destB, op2 = lower_to)
    * set_difference(b1, e1, b2, e2, destB, op2 = lower_to)
    * set_symmetric_difference(b1, e1, b2, e2, destB, op2 = lower_to)   ：并集去交集
    * inplace_merge(b1, b2, e2 ,op)                                     ：将同一个集合中的两部分合并, 两部分都有序
<!-- -->

* 数值算法：`<numeric>`
    * accumulate(b, e, initV, op2 = add)
    * inner_product(b1, e1, b2, e2, initV, op2 = add, op2 = multiply)
    * partial_sum(b, e, destB, op2 = add)            ：a1, a1+a2, a1+a2+a3,
    * adjacent_difference(b, e, destB, op2 = reduce) ：a1, a2-a1, a3-a2,
<!-- -->

* 区间检验算法：
    * is_sorted(b, e, op2 = lower_to)
    * is_sorted_until(b, e, op2 = lower_to)：返回已排序区间的尾后迭代器
    * is_heap(b, e, op2 = lower_to)
    * is_heap_until(b, e, op2 = lower_to)
    * is_partitioned(b, e, op1)            ：确认使op1为ture的元素都在前面
    * partition_point(b, e, op1)           ：返回第一个使op1为false的元素的位置
    * all_of(b, e, op1)
    * any_of(b, e, op1)
    * none_of(b, e, op1)
<!-- -->

* 区间比较算法：
    * equal(b, e, cmpB, op2 = equal_to)
    * is_permutation(b, e, b2, op2 = equal_to)      ：检测前一个区间的元素是否为后者元素的子集, 顺序无所谓
    * mismatch(b, e, cmpB, op2 = equal_to)          ：查找第一个不相同的元素, 返回pair存储两个区间的不同点的迭代器
    * lexicographical(b1, e1, b2, e2, op = equal_to)：比较两区间字典序
<!-- -->

* bitset：`<bitset>`
    * 方便访问指定位
    * 构造：() (ull) (string) (cstring)
    * 操作：
        * .any()
        * .all()
        * .none()
        * .count()
        * .size()
        * .set()      .set(pos, v=true)
        * .reset()    .reset(pos)
        * .flip()     .flip(pos)
        * b[pos].flip()
    * 转换：
        * .to_ulong()
        * .to_ullong()
        * .to_string(zero, one)
<!-- -->

* string：`<string>`
    * 构造、.assign()、.append()     ：(s)、(s, i)、(s, i, l)、(c)、(c, l)、(char)、(n, char)
    * operator= operator+ operator+= ：(s)、(c)、(char)
    * 关系运算符                     ：(s)、(c)
    * .insert()                      ：pos + 目标（除了single char）
    * .replace()                     ：范围+ 目标
    * .substr()                      ：范围
    * .find()
    * .rfind()
    * .find_first_of()
    * .find_first_not_of()
    * .find_last_of()
    * .find_last_not_of()            ：(s) (s,i) (c) (c,i) (c,i,l) (char) (char,i)
    * .compare()                     ：范围+目标(除了single char、num chars)
    * .copy(buf, length, idx)
    * getline(istrm, string)
    * stoi() stol() stoul() stof() stod() ：(str, idx=nullptr, base=10)
    * to_string(val)
    * 参数：
        * 范围：(i, l)、(b, e)
        * 目标：(s)、(s, i)、(s, i, l)、(c)、(c, l)、(char)、(n, char)
<!-- -->

* string_view：`<string_view>`
    * 原理：只是string或C-string的引用, 没有数据的拥有权, 只含有元数据
    * 目的：高效的提供string接口的拷贝操作, 尤其.substr(), 当需要const string时改用string_view
    * 注意：所有拷贝共享一个底层数据, 所以.substr().data()会导致错误（因为'\0'只在最后才有）
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
        * regex_replace((outputPos,)(str|b, e), regex, repl, flag)
        * regex_contants： 标志用于控制regex、match、replace行为
    * regex                 ：(seq, regex_contants::icase)
    * sregex_iterator       ：(b, e, regex) 默认初始化为end
    * sregex_token_iterator ：(b, e, r, -1) 保存匹配间的子字符串
    * smatch                ：存放ssub_match的容器
        * .size()
        * .empty()
        * .prefix()
        * .suffix()
        * .begin() .cbegin() .end() .cend()
        * .length(n)
        * .position(n)
        * .str(n)
        * .operator[]
        * .format(dest, fmt, flag)
        * .format(fmt, flag)
    * ssub_match： 指向表达式匹配到的子表达式
        .operator basic_string()
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
    * 状态与异常： 注意, 当stream会反复使用时, 注意要恢复其状态
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
        * .get() .get(char)
        * .get(char*, count, delim='\n')     ：读取 count - 1 个字符, 并自动添加'\0'在末尾
        * .getline(char*, count, delim='\n') ：其他同上, 但读取包括delim
        * .read(char*, count)                ：count代表指定读取的字符, 而非极限
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
    * I/O运算符与操作符：后者实质是接受stream的函数对象
    * 预定义I/O运算符：
    ```
        * 整型：  
            [0-9]*, [0-8]*,  
            ((0(x|X))|[0-9a-fA-F])[0-9a-fA-F]*
        * 浮点型：  
            [0-9]+\.?[0-9]*(e[+-]?[0-9]+)?  
            \.[0-9]+(e[+-]?[0-9]+)?
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
    * endl
    * ends
    * flush
    * (no)unitbuf
    * setw(n)
    * setfill(c)
    * left
    * right
    * internal
    * (no)boolalpha
    * (no)showpos：正号
    * (no)uppercase
    * oct dec hex (no)showbase
    * (no)showpoint
    * setprecision(v), .precision() .precision(v)
    * fixed , scientific：使用这两个操作符后, 精度的语义由“所有数字位数”变为“小数位数”
<!-- -->

* fstream：`<fstream>`
    * 构造：(filename, flag=)
    * 成员：.open(filename, flag=) .close() .is_open()
    * flags：
        * in
        * out
        * app
        * in|out        ：文件必须存在
        * in|out|trunc  ：自动创建
        * in|app
        * in|out|app
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

* 字符处理：
    * `<cctype>`    ：字符分类
    * `<codecvt>`   ：字符编码转换器
    * `<locale>`    ：转换宽字符需要此头文件
    例：
    * wbuffer_convert<codecvt_utf8<wchar_t>> wbuf_utf8(stream.rdbuf())
    * wistream utf8(&wbuf_utf8)
    * wstring_convert`<codecvt_utf8<wchar_t>>` convertor
    * .to_bytes() .from_bytes() 参数：(char) (char*) (string) (beg, end)
<!-- -->

* 随机数生成器：`<random>`
* 引擎：默认初始化的种子都一样
    .seed() .seed(result_type)
* 分布：产生指定分布类型与范围的随机数
* 例：
```
    * default_random_engine e ;
    * uniform_int_distribution di(min=0, max=INTMAX) ;
    * uniform_real_distribution dr(min=0, max=1.0) ;
    * bernoulli_distribution db(p=0.5) ;返回bool
    * binomial_distribution dbi(n=1, p=0.5) ;二项分布
    * normal_distribution dn(u=0, o=1) ;正态分布
    * cout << distribution(engine) << endl ;
```
<!-- -->

* 数学库：`<cmath>`
    * pow(double x, double y)   ：x**y
    * sqrt(double)
    * exp(double x)             ：e**x
    * expm1(double x)           ：更加精准的exp(x) - 1
    * exp2(double x)            ：2**x
    * exp10(double x)           ：10**x
    * log(double N)             ：log_e(N)
    * log1p(double N)           ：更加精准的log_e(N + 1)
    * log2(double N)            ：log_2(N)
    * log10(double N)           ：log_10(N)
    * cos()
    * sin()
    * tan()
    * acos()
    * asin()
    * atan()
    * ceil(double d)            ：大于d的最小整数
    * floor(double d)           ：小于d的最大整数
    * fmod(x, y)                ：浮点数的x%y
    * modf(x, *iptr)            ：将x分解为整数与小数部分, 整数存于*iptr, 返回小数
    * abs(x)                    ：x的绝对值, 重载了整形和浮点型
    * div(x, y)                 ：x除以y的商(div_t.quot)和余数(div_t.rem)
    * gcd(m, n)                 ：欧几里得算法求最大公因数`<numeric>`
<!-- -->

* `<cstdlib>`
    * EXIT_SUCCESS
    * EXIT_FAILURE
    * exit(status)
    * atexit(void (*func)())
    * quick_exit(status)
    * at_quick_exit(void (*func)())
<!-- -->

# 并发
* 线程：`<thread> <future>`
    * async(launch::async, func, args...)： 封装并启动线程函数, 将其返回值存到shared data
        > 发射策略：launch:: async | deferred
    * future`<>和shared_future<>`： 可获取shared_data, 还包括状态, 句柄, 异常
        等待状态：future_status:: deferred | timeout | ready
        * .valid()
        * .get() .wait()：此两函数会启动deferred
        * .wait_for(duration) .wait_until(time_point)
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
        | .try_lock_for(dur)  |   -   |        -        |      -       |                限制时间内进行捕获                        |
        | .try_lock_until(tp) |   -   |        -        |      -       |                限制期限前进行捕获                        |
        | 多个lock            |   -   |        🉑️️       |      -       |      -      |          🉑️️           |         -          |
    * 辅助函数：
        * lock(mutex...)      ：避免死锁
        * try_lock(mutex...)  ：保证加锁次序
        * once_flag类型
        * call_once(once_flag, func, args...)
    * mutex托管：
        > 用法：mutex做模板类型, mutex对象做构造参数(可能还有其他参数), 在块作用域中初始化
        * lock_guard<> ：adopt_lock
        * unique_lock<>：adopt_lock(已锁)、defer_lock(不锁)、try_lock(试锁)、duration、time_point
        * shared_lock<>
    * 提供原子性操作原理：
        * 读取mutex - 判断mutex - 上锁或阻塞
        * 解锁-唤醒
<!-- -->

* 条件量：`<condition_variable>`
    * 依赖于unique_lock`<>`提供保护区, 在全局中声明
    * 成员：
        * .wait(ul, pred)
        * .wait_for(ul, dur, func)
        * .wait_until(ul, dur, func)
            > 等待状态：cv_status:: time_out | no_timeout
        * .notify_one() .notify_all()
        * notify_all_at_thread_exit(cv, ul) 应该在保护区外使用notify...()
    * 提供原子性操作：
        * 解锁-阻塞
        * 唤醒
<!-- -->

