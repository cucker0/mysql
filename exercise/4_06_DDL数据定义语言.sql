-- DDL数据定义语言

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
    `name` VARCHAR(32), -- 书名
    price DOUBLE, -- 价格
    authorId INT, -- 作者ID
    publishDate DATETIME -- 发布让日期
);

DESC book;


# 案例：创建author表
CREATE TABLE IF NOT EXISTS author (
    id INT,
    `name` VARCHAR(32),
    nation VARCHAR(20)
);


-- 表的修改

