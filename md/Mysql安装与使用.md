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

## yum 安装 MySQL--Linux
参考 [Installing MySQL on Linux Using the MySQL Yum Repository](https://dev.mysql.com/doc/refman/8.4/en/linux-installation-yum-repo.html)

1. Adding the MySQL Yum Repository 

a. Download it from the MySQL Yum Repository page (https://dev.mysql.com/downloads/repo/yum/) in the MySQL Developer Zone.
b. Install the downloaded release package. The package file format is:
```bash
mysql84-community-release-{platform}-{version-number}.noarch.rpm
```
c. Install the RPM you downloaded for your system, for example:
```bash
$>  sudo yum localinstall mysql84-community-release-{platform}-{version-number}.noarch.rpm
```

```bash
$> yum repolist enabled | grep mysql.*-community
mysql-8.4-lts-community               MySQL 8.4 LTS Community Server
mysql-tools-8.4-lts-community            MySQL Tools 8.4 LTS Community
```
2. Selecting a Release Series

```bash
$> yum repolist all | grep mysql
mysql-connectors-community                 MySQL Connectors Community   enabled
mysql-tools-8.4-lts-community               MySQL Tools 8.4 LTS Community        enabled
mysql-tools-community                      MySQL Tools Community        disabled
mysql-tools-innovation-community           MySQL Tools Innovation Commu disabled
mysql-innovation-community                 MySQL Innovation Release Com disabled
mysql-8.4-lts-community                          MySQL 8.4 Community LTS Server   enabled
mysql-8.4-lts-community-debuginfo                MySQL 8.4 Community LTS Server - disabled
mysql-8.4-lts-community-source                   MySQL 8.4 Community LTS Server - disabled
mysql80-community                        MySQL 8.0 Community Server - disabled
mysql80-community-debuginfo              MySQL 8.0 Community Server - disabled
mysql80-community-source                 MySQL 8.0 Community Server - disabled
```

Example:
```bash
$> sudo yum-config-manager --enable mysql-8.4-lts-community
$> sudo yum-config-manager --disable   mysql80-community
```
/etc/yum.repos.d/mysql-community.repo 示例
```bash
[mysql-8.4-lts-community]
name=MySQL 8.4 LTS Community Server
baseurl=http://repo.mysql.com/yum/mysql-8.4-community/el/8/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql-2023
```
3. Disabling the Default MySQL Module
```bash
$> sudo yum module disable mysql
```
4. Installing MySQL
```bash
$> sudo yum install mysql-community-server
```
4. Enable and start MySQL Server
```bash
$> systemctl enable mysqld
$> systemctl start mysqld
```

## Install MySQL on Windows
1. 下载 Windows 版本的 Windows (x86, 64-bit), ZIP Archive
>https://dev.mysql.com/downloads/mysql/
2. 解压安装包，如 mysql-8.4.1-winx64.zip 解压到 `D:\Server\mysql-8.4.1-winx64`
3. 在 D:\Server\mysql-8.4.1-winx64 目录下创建 my.ini
```bash
[mysqld]
port=3306
basedir = "D:\Server\mysql-8.4.1-winx64"
datadir = "D:\Server\mysql-8.4.1-winx64\data"
server_id = 10
default-storage-engine = INNODB
max_connections = 500
character-set-server = utf8mb4
default-time-zone = timezone
default-time-zone = '+8:00'

[client]
port=3306

[mysqld_safe]

[mysql]
port = 3306
default-character-set = utf8mb4
```
4. 安装 MySQL

以管理员身份 运行 CMD 命令提示符
```bash
C:\Windows\system32>d:

D:\>cd D:\Server\mysql-8.4.1-winx64\bin

D:\Server\mysql-8.4.1-winx64\bin> mysqld --install mysql
```

也可以把 `D:\Server\mysql-8.4.1-winx64\bin` 追加到 系统环境变量 PATH 中，这样可以直接使用 mysql 的相关命令

5. 初始化 MySQL

会自动生成 ./data 目录，不需要手动创建 ./data 目录，否则可能导致初始化失败。
```bash
// 'root'@'localhost' 用户无密码
mysqld --initialize-insecure 

// 或
// 'root'@'localhost' 用户有初始密码，注意此处保存密码，如果没打印出来密码 就 是空
mysqld --initialize --console
```
6. 启动 MySQL
```bash
net start mysql
```
7. 修改 'root'@'localhost' 密码
```bash
C:\> mysql -uroot -p
Enter password: ********  // 输入密码

-- caching_sha2_password，默认使用该密码插件
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'password_str!';
-- 或
mysql> ALTER USER user() IDENTIFIED BY 'password_str!';

-- mysql_native_password，旧版的密码插件
mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password_str!';

mysql>  FLUSH PRIVILEGES;
```
8.卸载 MySQL
```bash
mysqld --remove mysql
```

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

# Mysql语法规范
* 不区分大小写，建议关键字大写，表名、列名小写
* 语句以;或 \g结尾，建议用;
* 注释
    * 单行注释
        ```text
        -- 注释内容（mysql要求-- 后有一个空格）
        
        或
        # 注释内容（mysql特有）
        ```
    * 多行注释
        ```text
        /*
        注释内容
        ...
        */

        不可嵌套
        ```
        
* 用缩进、换行提高语句的可读性，建议缩进4个空格
* 各子句一般分行写
* 关键字不能缩写
* 字符与字符串都值用单引号包裹起来

## 常见命令
* 列出所有数据库
>show databases;

* 切换到指定的数据库
>use 数据库名

* 新建数据库
>create database 数据库名;

* 列出当前数据库中所有的表
>show tables;

* 列出其他库的所有表
>SHOW TABLES FROM 库名;

* 建表
```text
CREATE TABLES 表名 (
    id VARCHAR (32),
    age INT,
    name VARCHAR (30),
    birthday DATE,
    列名 列类型,
    列名 列类型,
    ...
);

```

* 查看表结构
```text
desc[ribe] 表名;

# desc为describe的缩写
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

* 查看mysql版本
```text
-- 方式1，登入到mysql服务端
SELECT VERSION();

-- 方式2，未登入服务端
mysql --version
或
mysql -V

```

# mysql图形化客户端
* [SQLyog](SQLYog.md)
* [Navicat Premium](NavicatPremium.md)

  