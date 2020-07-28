**关系型数据库的典型实现主要被调整用于执行规模小而读写频繁，或者大批量极少写访问的事务。**

* 初始化mysql
    * `mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql`或
    * `mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql`
    * `mysql_secure_installation`
<!--  -->

* 密码验证策略
    * validate_password_check_user_name     ：不得使用当前会话用户名作为密码的一部分
    * validate_password_dictionary_file     ：验证密码强度的字典文件路径
    * validate_password_length              ：密码最小长度
    * validate_password_mixed_case_count    ：密码至少要包含的小写字母个数和大写字母个数
    * validate_password_number_count        ：密码至少要包含的数字个数
    * validate_password_policy              ：密码强度检查等级，0/LOW、1/MEDIUM、2/STRONG
        * 0/LOW     ：只检查长度。
        * 1/MEDIUM  ：检查长度、数字、大小写、特殊字符。
        * 2/STRONG  ：检查长度、数字、大小写、特殊字符字典文件。
    * validate_password_special_char_count  ：密码至少要包含的特殊字符数
<!--  -->

* mysql
    * -h    ：主机名
    * -P    ：端口号
    * -u    ：用户名
    * -p    ：密码
    * -D    ：数据库名
<!--  -->

# SQL
> * `--`开启注释
> * SQL语句以分号`;`结束
> * 关键字可以忽略大小写
> 
> * 库名、表名、字段名等，一般都可以使用`*`匹配

```sql
---------------------------------------------------------------------------------------------------
-- <user_name>          ：用户名，<user_name>后面可选添加 @<host_name>（默认 @'%'）
-- <host_name>          ：主机名
    -- '%'              ：默认任意机器可登录
    -- localhost        ：只能本机登录
    -- <IP>             ：只能从该IP地址登录

-- <db_name>            ：数据库名
-- <tbl_name>           ：表名，<tbl_name>前面可选添加 <db_name>.（默认当前`use`选中的库）

-- <privileges_code>    ：权限码
    -- all privileges
    -- select
    -- delete
    -- update
    -- create
    -- drop

-- <passwd>             ：明文密码

-- <type>               ：类型，后面可选添加 <const>（默认无）
    -- 数值类型
        -- tinyint(size)        +-------------------------------------------------------------------+
        -- smallint(size)       | 每个整数类型之后可选添加`unsigned`指明为无符号型整数              |
        -- mediumint(size)      | 每个类型之后可选指定`(size)`表示显示时的十进制长度，用0填充不足的 |
        -- int(size)            | `(d)`表示浮点数十进制小数部分数字位数                             |
        -- bigint(size)         +-------------------------------------------------------------------+
        -- float(size, d)
        -- double(size, d)
    -- 字符串
        -- blob
        -- char(N)              +--------------------------------------------------+
        -- varchar(N)           | 字符串类型与日期时间类型的值，需要用单引号括起来 |
        -- 等等...              +--------------------------------------------------+
    -- 日期时间
        -- date         ：YYYY-mm-dd
        -- time         ：HH:MM:SS
        -- datetime     ：YYYY-mm-dd HH:MM:SS
        -- timestamp    ：%s
        -- year         ：%Y

-- <const>              ：约束
    -- not null         ：不能有NULL值，primary key必要条件
    -- unique           ：不能有重复值，primary key与foreign key的必要条件，unique key的充分条件
    -- default <value>  ：设置默认值，
    -- auto_increment   ：初始值为1，每次递增1，其后可选添加`=n`设置初始值
---------------------------------------------------------------------------------------------------
```

## 用户管理
* sql用户管理
```sql
-- 创建用户
create user <user_name> [identified by '<passwd>'];

-- 删除用户
drop user <user_name>;

-- 查询用户信息
select user,host,password,... from mysql.user ... ;

-- 授权用户
grant <pribileges_code> on <db_name>.<tbl_name> to <user_name>;
flush privileges;

-- 修改密码
set password for <user_name> = password('<passwd>');
```
<!--  -->

## 数据库、数据表、视图
* 数据库、数据表、视图
```sql
-- 查询、创建、删除数据库
show databases;
create database <db_name>;
drop database <db_name>;

-- 查询、创建、删除、更名数据表
show tables [from <db_name>];
create table <tbl_name> (
        <fd_name> <type>,
        ...,
        primary key (<fd_name>),
        [constraint <const_name> foreign key (<fd_name>) references <tbl_name>(<fd_name>)]
        [constraint <const_name> check (<Clause>)]
    ) ;
drop table <tbl_name>,...;
alter table <tbl_name> rename to <new_tbl_name>;

-- 创建、删除视图
create view <view_name> as select 语句 ;
drop view <view_name>;
```
<!--  -->

## 操作元数据
* 操作元数据
```sql
-- 查询、添加、删除、修改字段
show cloumns from <tbl_name>;
alter table <tbl_name> add <fd_name> <type>;
alter table <tbl_name> drop <fd_name>;
alter table <tbl_name> change <fd_name> <new_fd_name> <type>; -- 可以修改字段名、类型与约束

-- index
show index from <tbl_name>;
alter table <tbl_name> add index <idx_name>(<fd_name>);
alter table <tbl_name> drop index <idx_name>;

-- primary key
alter table <tbl_name> add primary key (<fd_name>);
alter table <tbl_name> primary key;

-- foreign key
alter table <tbl_name> add constraint <const_name> foreign key (<fd_name>) references <tbl_name>(<fd_name>);
alter table <tbl_name> drop foreign key <const_name>;

-- check
alter table <tbl_name> add constraint <const_name> check (<Clause>);
alter table <tbl_name> drop check <const_name>;
```
<!--  -->

## 操作行数据
* 操作行数据
```sql
-- 插入
insert into <tbl_name> (<fd_name>, ...)
values (<value>, ...), ... ; -- 若类型为字符串或日期时间，则`value`必须使用单引号

-- 删除
delete from <tbl_name>
[where <Clause>] ; -- 默认删除所有数据

-- 修改
update <tbl_name> set <fd_name> = <value>, ...
[where <Clause>] ; -- 默认修改所有行

-- 复制
insert into <tbl_name> (<fd_name>, ...)
select 语句 ; -- 两语句中的<fd_name>部分两两对应

-- 事务
begin;                      -- 开启事务
...
savepoint <point>           -- 设置保存点
...
release savepoint <point>   --删除保存点
...
rollback to <point>         -- 撤销至保存点
...
commit 或 rollback          -- 提交事务 或 撤销此次事务
```
<!--  -->

## select语句
### 查询
* sql查询
```sql
-- 查询，select基础语句
select <fd_name>或function(...) [as <fd_alias>],... from <tbl_name> [<tbl_alias>],...
[where <Clause>] -- 多个<tbl_name>时，需要在<fd_name>前添加<tbl_name>或<tbl_alias>
[limit N]
[offset M] ;
```
<!--  -->

### 分组
* sql分组
```sql
select 语句
group by <fd_name> [with rollup];
[having (Clause)]
-- 将各行进行分组，按选中的<fd_name>中相等的行归为一组
-- select 语句中可以使用aggregate函数对组中的行进行操作
-- with roolup 会合计总行数
-- having 语句代替where，从而可以使用aggregate函数
```
<!--  -->

### 连接
* sql连接
```sql
-- inner|left|right分别表示至少两者中一者|只要左边|只要右边 满足`on`条件就打印，否则过滤掉
-- 原始的、未过滤的join表可设`on 1`来查看
-- on与where的区别在于前者在生成临时表时，后者在生成临时表后
select ... from <tbl_name> [<tbl_alias>] [inner|left|right] join <tbl_name> [<tbl_alias>]
on <tbl_alias>.<fd_name> = <tbl_alias>.<fd_name> ;
```
<!--  -->

### 合并
* sql合并
```sql
-- 将两个select语句查询的字段按顺序对应地合并在一列中，字段名由第一个select指出
select 语句
union [all] -- all表示允许重复，默认删掉重复值
select 语句 ;
```
<!--  -->

### 排序
* sql排序
```sql
select 语句
order by <fd_name> [desc], ... ; -- 默认升序，desc指明为降序
```
<!--  -->

## WHERE语句
* where语句
  * `where <fd_name> <OP> <value>`
  * `where <fd_name> regexp 'regex_pattern'`
  * `where <fd_name> [not] between <value> and <value>`
  * `where <fd_name> [not] in (<value>, ...)`
<!--  -->

## 运算符
* sql运算符
  * 算术：`+` `-` `*` `/` `%`
  * 逻辑：`not` `and`、`or`、`xor`      ：可以用`()`来改变优先级
  * 比较：
      * `=` `!=` `<` `<=` `>` `=>`      ：若有一边为NULL则返回NULL
      * `<=>`                           ：当两边相等或均为NULL返回true
      * `is [not] null <value>`         ：是否[不]为空
      * `[not] regexp '<pattern>'`
      * `[not] between <value1> and <value2>`
      * `[not] in (<value>, ...)`
      * `[not] exists (select 语句)`
<!--  -->

## 函数
* SQL Aggregate 函数计算从完整的列中取得的所有值，返回一个单一的值
| 函数    | 描述           |
|---------|----------------|
| sum()   | 返回总和       |
| avg()   | 返回平均值     |
| count() | 返回行数       |
| first() | 返回第一个值   |
| last()  | 返回最后一个值 |
| max()   | 返回最大值     |
| min()   | 返回最小值     |
<!--  -->

* [其它sql函数](https://www.runoob.com/mysql/mysql-functions.html)

