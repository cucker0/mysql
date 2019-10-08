-- DDL数据定义语言(库和表的管理)

/*
功能：库和表的管理

## 库的管理
库的创建、修改、删除

## 表的管理
表的创建、修改、删除


创建：create
修改：alter
删除：drop

*/

-- 库的管理 
--

# 库的创建
/*
## 语法

create database [if not exists] 库名;


数据库管理工具到处的sql文件中，含有版本标注的如：
CREATE DATABASE /*!32312 IF NOT EXISTS*/`girls` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;

* /*!32312 IF NOT EXISTS*/ 表示mysql版本 >= 3.23.12的才执行这个命令
iff you ADD a VERSION number AFTER the “!” CHARACTER, the syntax WITHIN the COMMENT IS executed only IF the MySQL VERSION IS greater THAN OR equal TO the specified VERSION number

*/


# 案例：创建库books

CREATE DATABASE IF NOT EXISTS books;


-- 库的修改
# 案例：修改数据库名
RENAME DATABASE books TO 新库名;
-- 已经被淘汰，此语法仅在5.1.7到5.1.23版本可以用的，但是官方不推荐，会有丢失数据的危险

-- mysql改库名方案1
/*
①停止mysql服务
②找到库对应的服务器本地文件，修改文件名为新库名
③启动mysql服务
*/

-- mysql改库名方案2
/*
--
①创建需要改成新名的数据库
②mysqldum 导出要改名的数据库
③在新建的库中还原数据
④删除原来的旧库（确定是否真的需要）
*/

-- 更改库的字符集
ALTER DATABASE books CHARACTER SET gbk;

SHOW CREATE DATABASE books;

-- 库的删除
/*
## 语法
drop database [if exists] books;
*/
DROP DATABASE IF EXISTS books;



-- 表的管理
-- 

-- 表的创建
/*
## 语法
create table 表名 (
    列名1 列类型 [(长度) 约束],
    列名2 列类型 [(长度) 约束],
    ...
    列名n 列类型 [(长度) 约束]
);

*/

# 案例：创建book表
USE books;

CREATE TABLE book (
    id INT, -- 编号
    `name` VARCHAR (32), -- 书名
    price DOUBLE, -- 价格
    authorId INT, -- 作者ID
    publishDate DATETIME -- 发布让日期
);

DESC book;


# 案例：创建author表
CREATE TABLE IF NOT EXISTS author (
    id INT,
    `name` VARCHAR (32),
    nation VARCHAR (20)
);


-- 向author、books表中插入数据

INSERT INTO author (id, `name`, nation)
VALUES (1, 'jean-henri casimir fabre', '法国'),
(2, '李淼', '中国'),
(3, '霍金', '英国')
;


INSERT INTO book VALUES
(1, '昆虫记', 37.10, 1, '2019-04-01'),
(2, '给孩子讲宇宙', 26.90, 2, '2017-08-01'),
(3, '时间简史', 32.40, 3, '2012-01-01')
;


-- 表的修改
/*
## 语法
alter table 表名 add|drop|modify|change column 列名 [列类型 约束];

*/

# change重命名列名
ALTER TABLE book CHANGE COLUMN publishDate pubdate DATETIME;

DESC book;


# 修改列的类型或约束
ALTER TABLE book MODIFY COLUMN pubdate TIMESTAMP;

# 把name字段的长度修改为64
ALTER TABLE book MODIFY COLUMN `name` VARCHAR (64);

# 添加新列
ALTER TABLE book ADD COLUMN quantity INT; -- 数量

# 删除列
ALTER TABLE book DROP COLUMN quantity;

# 修改表名
/*
## 语法
alter table 表名 rename [to] 新表名;
*/
ALTER TABLE book RENAME TO ebook;

DESC ebook;
SELECT * FROM ebook;


-- 表的删除
/*
## 语法
drop table [if exists] 表名;

* [if exists] 表示如果表存在就删除，如果不加这个判断，在表不存在的情况下执行删除表语句会报错，加了这个判断则只会报警告
*/

DROP TABLE IF EXISTS ebook;


-- 表的复制


# 只复制表的结构
/*
## 语法
create table 表名 like 源表;

*/
CREATE TABLE tab_copy LIKE author;

DESC tab_copy;

SELECT * FROM tab_copy;


# 复制表的结构 + 全部数据
CREATE TABLE tab_copy2
SELECT * FROM author;

SELECT * FROM tab_copy2;

# 复制表的部分结构 + 部分数据
CREATE TABLE tab_copy3
SELECT id, `name`
FROM author
WHERE nation = '中国';

SELECT * FROM tab_copy3;


# 只复制表的部分结构(部分字段)
-- 就是让查询结果集为0条记录
CREATE TABLE tab_copy4
SELECT id, `name`
FROM author
WHERE 0;

-- 或
CREATE TABLE tab_copy4
SELECT id, `name`
FROM author
LIMIT 0;

SELECT * FROM tab_copy4;


