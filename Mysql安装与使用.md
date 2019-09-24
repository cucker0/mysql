Mysql安装与使用
==

# Mysql发展简史
```text
MySQL最早来源于瑞典的MySQL AB公司前身的ISAM与mSQL项目（主要用于数据仓库场景），
于1996年前后发布第一个版本MYSQL 1.0，当时只支持SQL特性，没有事务支持。

2008年1月，MySQL AB公司被Sun公司以10亿美金收购，MySQL数据库进入Sun时代。在Sun时代，Sun公司对其进行了大量的推广、优化、Bug修复等工作。

2009年4月，Oracle公司以74亿美元收购Sun公司，自此MySQL数据库进入Oracle时代，而其第三方的存储引擎InnoDB早在2005年就被Oracle公司收购。
```

# Mysql版本
* Community社区版(免费)
>https://dev.mysql.com/downloads/
* Enterprise企业版(收费)
>https://www.mysql.com/trials/

# 启停mysql服务
* 方式1：windows的服务管理器(services.msc)
* 方式2：windows cmd命令
    ```text
    启动: net start mysql服务名
    停止: net stop mysql服务名
    ```
* 方式3：linux shell命令
    ```text
     启动: systemctl start mysql服务名
     停止: systemctl start mysql服务名
    ```
# mysql服务端的登录连接与退出
* 登录连接
    ```text
    mysql -h 主机名 -P 端口 -u 用户名 -p密码
    或
    mysql -h主机名 -P 端口 -u 用户名 -p
    注意：-p密码，-p后不能有空格，其他参数与参数指示关键字之间的空格可有可无均可
    ```
* 退出
    ```text
    exit
    \q
    ```

# Mysql数据库的使用
* 不区分大小写
* 语句以;或 \g结尾
* 各子句一般分行写
* 关键字不能缩写
* 用缩进提高语句的可读性，建议4个空格
* 根据标准，关键字建议都大写

## 基本语句
* 列出所有数据库
>show databases;

* 切换到指定的数据库
>use 数据库名

* 新建数据库
>create database 数据库名;

* 列出当前数据库中所有的表
>show tables;

* 建表
```text
create tables 表名(
id varchar(32),
age int,
name varchar(30),
birthday date
);

```

* 查看表结构
```text
desc 表名;

# desc为descript的缩写
``` 

* 删除表
>drop table 表名;

* 查看所有的记录(所有列)
>select * from 表名;

* 向表中插入记录
```text
insert into 表名(列名1,列表2, ...) values(列1值,列2, ...);

# 注意：插入varch或date类型的数据时要用单引号（''）引起来
```

* 修改记录
>update 表名 set 列1 = 列1的值, 列2 = 列2的值 where 筛选条件;

* 删除记录
>delete from 表名 where 筛选条件表达式;

* 查询特定的列
>select 列名1,列名2,... from 表名;

* 对查询的数据进行过滤,使用where子句
```text
select id, name, age from customer where age > 21;
```








