Character Sets, Collations, Unicode
==

参考[Character Sets, Collations, Unicode](https://dev.mysql.com/doc/refman/8.0/en/charset.html)

## Table Of Contents
* [基本概念](#基本概念)
* [Collation Naming Conventions](#Collation-Naming-Conventions)
* [Server Character Set and Collation](#Server-Character-Set-and-Collation)
* [Database Character Set and Collation](#Database-Character-Set-and-Collation)
* [Table Character Set and Collation](#Table-Character-Set-and-Collation)
* [Column Character Set and Collation](#Column-Character-Set-and-Collation)
* [Character String Literal Character Set and Collation](#Character-String-Literal-Character-Set-and-Collation)
* [Connection Character Sets and Collations](#Connection-Character-Sets-and-Collations)
* [综合配置示例](#综合配置示例)

## 基本概念
* Character Set
    ```text
    字符集
    
    A character set is a set of symbols and encodings.
    字符集是一组符号和编码.

    **例子**  
    假设有一个字母表，它有4个字母：A, B, a, b. 我们给每个字母一个编号：A=0, B=1, a=2, b=3.  
    A是字符，数字0是A的encoding编码. 这4个字母以及它们的编码的组合，就是一个`字符集`。
    ```
    * 查看mysql支持的CHARSET
            ```mysql
            SHOW CHARSET;
            ```
* Collation
    ```text
    排序规则
    
    A collation is a set of rules for comparing characters in a character set.
    用于比较字符集中字符的一组规则

    **例子**
    假设我们想比较'A'和'B'两个字符串的值。
    有个简单的方法是看字符的编码：0是A的编码，1是B的编码。因为 0 < 1, 我们称A < B。
    上面做的就是：给字符集 应用 排序规则。
    
    The collation is a set of rules (only one rule in this case): “compare the encodings.” 
    We call this simplest of all possible collations a binary collation.
    当一个collation(只有一个规则)：值比较字符编码，我们称之为binary collation，它是所有collation中最简单的。
    ```
    * 查看mysql支持的COLLATION
        ```mysql
        SHOW COLLATION;
        ```
    
* Unicode
    >Unified coding, 统一编码
    

mysql 8, The default MySQL server character set and collation are `utf8mb4` and `utf8mb4_0900_ai_ci`, 

but you can specify character sets at the `server`, `database`, `table`, `column`, and `string literal` levels.

Character set issues affect not only data storage, but also communication between client programs and the MySQL server. 

**utf8mb4_0900_ai_ci**
```text
属于 utf8mb4_unicode_ci 中的一种，具体含义如下：

uft8mb4  字符集uft8mb4，每个字符最多占4个字节。
0900  指的是 Unicode 校对算法版本。（Unicode归类算法是用于比较符合Unicode标准要求的两个Unicode字符串的方法）。
ai  指的是口音不敏感。也就是说，排序时e，è，é，ê和ë之间没有区别。
ci  表示不区分大小写。也就是说，排序时p和P之间没有区别。
```

## Collation Naming Conventions
Collation命名约定

* 以与其关联的character set名开头，后面通常跟一个或多个表示其他排序规则特征的后缀。
    >例如：utf8mb4_0900_ai_ci and latin1_swedish_ci。  
     binary字符集没有后缀。
     
* 特定collation包含区域代码或语言名称
    ```text
    For example, `utf8mb4_tr_0900_ai_ci` and `utf8mb4_hu_0900_ai_ci` sort characters 
    for the utf8mb4 character set using the rules of `Turkish` and `Hungarian`, respectively.
    ```
* collation后缀
    >区分大小写、区分重音、区分假名（或其组合）还是二进制

    * Collation Suffix Meanings
        
        Suffix|	Meaning
        :--- |:---
        _ai|	Accent-insensitive  不区分重音
        _as|	Accent-sensitive  区分重音
        _ci|	Case-insensitive  不区分大小写
        _cs|	Case-sensitive  区分大小写
        _ks|	Kana-sensitive  假名敏感
        _bin|	Binary  二进制，只比较字符对应的编码

## Server Character Set and Collation
MySQL Server has a `server character set` and a `server collation`.   
By default, these are `utf8mb4` and `utf8mb4_0900_ai_ci`

* 修改Server Character Set and Collation方法
    * mysqld启动时指定Server Character Set and Collation
        ```bash
        mysqld
        
        mysqld --character-set-server=utf8mb4
        
        mysqld --character-set-server=utf8mb4 \
               --collation-server=utf8mb4_0900_ai_ci
        ```
    * 在配置文件中指定
        ```text
        vi /etc/my.cnf

        [mysqld]
        character-set-server=latin1
        collation-server=latin1_swedish_ci
        ```
    * 重新编译mysql
        ```bash
        cmake . -DDEFAULT_CHARSET=latin1
        
        cmake . -DDEFAULT_CHARSET=latin1 \
                -DDEFAULT_COLLATION=latin1_german1_ci
        ```

## Database Character Set and Collation
Every database has a database character set and a database collation. 

* 创建数据库时指定Database Character Set and Collation
    ```mysql
    CREATE DATABASE db_name
        [[DEFAULT] CHARACTER SET charset_name]
        [[DEFAULT] COLLATE collation_name]
    ```
    示例
    ```mysql
    CREATE DATABASE db_name CHARACTER SET latin1 COLLATE latin1_swedish_ci;
    ```

* 修改数据的Database Character Set and Collation
    ```mysql
    ALTER DATABASE db_name
        [[DEFAULT] CHARACTER SET charset_name]
        [[DEFAULT] COLLATE collation_name]
    ```

* 查看数据库的Character Set and Collation
    ```mysql
    -- 方式1
    USE db_name;
    SELECT @@character_set_database, @@collation_database;
  
    -- 方式2  
    SELECT DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
    FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'db_name';
    ```

## Table Character Set and Collation
Every table has a table character set and a table collation. 
The CREATE TABLE and ALTER TABLE statements have optional clauses for specifying the table character set and collation:
```mysql
CREATE TABLE tbl_name (column_list)
    [[DEFAULT] CHARACTER SET charset_name]
    [COLLATE collation_name]];

ALTER TABLE tbl_name
    [[DEFAULT] CHARACTER SET charset_name]
    [COLLATE collation_name];
```
示例
```mysql
CREATE TABLE t1 (
    ...
)
CHARACTER SET latin1 COLLATE latin1_danish_ci;
```

* 查看character set默认的collation
    ```mysql
    SHOW CHARACTER SET;
    ```
* 查看表的
    ```mysql
    SHOW TABLE STATUS;
    ```

## Column Character Set and Collation
Every “character” column (that is, a column of type `CHAR`, `VARCHAR`, a `TEXT` type, or any `synonym`) has a column character set and a column collation. 

Column definition syntax for `CREATE TABLE` and `ALTER TABLE` has optional clauses for specifying the column character set and collation:
```mysql
col_name {CHAR | VARCHAR | TEXT} (col_length)
    [CHARACTER SET charset_name]
    [COLLATE collation_name];
```

示例
```mysql
CREATE TABLE t1
(
    col1 VARCHAR(5)
      CHARACTER SET latin1
      COLLATE latin1_german1_ci
);

ALTER TABLE t1 MODIFY
    col1 VARCHAR(5)
      CHARACTER SET latin1
      COLLATE latin1_swedish_ci;
```

## Character String Literal Character Set and Collation
字符串文字的Character Set和Collation

Every character string literal has a character set and a collation.

* 语法
    >[_charset_name]'string' [COLLATE collation_name]
    
* 示例
    ```mysql
    SELECT 'abc';
    SELECT _latin1'abc';
    SELECT _binary'abc';
    SELECT _utf8mb4'abc' COLLATE utf8mb4_danish_ci;
    ```
    
## Connection Character Sets and Collations
查看当前session的Character Set and Collation
```mysql
SELECT * FROM performance_schema.session_variables
WHERE VARIABLE_NAME IN (
'character_set_client', 'character_set_connection',
'character_set_results', 'collation_connection'
) ORDER BY VARIABLE_NAME;


SHOW SESSION VARIABLES LIKE 'character\_set\_%';
SHOW SESSION VARIABLES LIKE 'collation\_%';
```

* 指定mysql client session的Character Sets and Collations
    ```text
    vi /etc/my.cnf 
  
    [mysql]
    default-character-set=koi8r
    ```
    或的mysql client CLI
    ```bash
    mysql> charset koi8r
    Charset changed
    ```
* SQL Statements for Connection Character Set Configuration
```bash
SET NAMES 'charset_name' COLLATE 'collation_name'


// 等价于下面这三个命令
SET character_set_client = charset_name;
SET character_set_results = charset_name;
SET character_set_connection = charset_name;


SET CHARACTER SET charset_name
// 等价于
SET character_set_client = charset_name;
SET character_set_results = charset_name;
SET collation_connection = @@collation_database;
```

## 综合配置示例
/etc/my.cnf
```text
...
[client] 
default-character-set=utf8mb4

[mysql] 
default-character-set=utf8mb4

[mysqld] 
character-set-client-handshake=FALSE
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'
init_connect='SET collation_connection = utf8mb4_unicode_ci'
...
```

重启并确认
可以看到，系统编码、连接编码、服务器和客户端编码都设置为 UTF-8了：
```bash
mysql> show variables like "%char%";
+--------------------------------------+--------------------------------+
| Variable_name                        | Value                          |
+--------------------------------------+--------------------------------+
| character_set_client                 | utf8mb4                        |
| character_set_connection             | utf8mb4                        |
| character_set_database               | utf8mb4                        |
| character_set_filesystem             | binary                         |
| character_set_results                | utf8mb4                        |
| character_set_server                 | utf8mb4                        |
| character_set_system                 | utf8                           |
| character_sets_dir                   | /usr/share/mysql-8.0/charsets/ |
| validate_password.special_char_count | 1                              |
+--------------------------------------+--------------------------------+
9 rows in set (0.00 sec)
```
MySQL 中字符集相关变量
```text
character_set_client： 客户端请求数据的字符集
character_set_connection： 从客户端接收到数据，然后传输的字符集
character_set_database： 默认数据库的字符集，无论默认数据库如何改变，都是这个字符集；
                            如果没有默认数据库，那就使用 character_set_server指定的字符集，这个变量建议由系统自己管理，不要人为定义。
character_set_filesystem： 把操作系统上的文件名转化成此字符集，
                            即把 character_set_client转换character_set_filesystem， 默认binary是不做任何转换的
character_set_results： 结果集的字符集
character_set_server： 数据库服务器的默认字符集
character_set_system： 存储系统元数据的字符集，总是 utf8，不需要设置
```
