数据库和SQL概述
==


# 数据库
## 数据库的好处
* 实现数据的持久化
* 使用完整的管理系统统一管理，易于查询


## 数据库概念
* DB数据库
```text
database:

存储数据的“仓库”或“容器”。
它保存了一系列有组织的数据
```

* DBMS数据库管理系统
```text
Database Management System:

数据库是通过DBMS创建和操作的容器。

DBMS分两类：
* 基于共享文件系统的DBMS（Access）
* 基于客户端/服务端的DBMS（Mysql， Oracle、SqlServer）
```

* SQL结构化查询语言
```text
Structure Query Language

专门用来与数据库通信的语言

1986年10月，美国ANSI采用SQL作为关系数据库管理系统的标准语言（ANSI X3. 135-1986），
后为国际标准化组织（ISO）采纳为国际标准。
```

## 常见的数据库
>MySQL, Oracle, DB2, SqlServer, PostgreSQL, MogodDB, TiDB等


# SQL语言概述
## 优点
* SQL是通用的，几乎所有的DBMS都支持SQL
* 简单、灵活、功能强大

## SQL分类
* DML数据操作语句
```text
Data Manipulation Language

用于添加、删除、修改、查询数据库记录，并检查数据的完整性
SELECT: 从表或视图中检索数据行
INSERT: 插入数据到表
UPDATE: 更新表数据
DELETE: 删除表数据
```

* DDL数据定义语句
```text
Data Definition Language

数据定义语言DDL用来创建、修改、删除数据库中的各种对象：表、视图、索引、同义词、聚簇等
CREATE: 创建数据库或表
ALTER: 	修改库、表、存储过程等属性
DROP: 删除库、表、存储过程、view视图、行数等
RENAME: 更改数据库对象的名称
TRUNCATE: 清空表数据
```

* DCL数据控制语句
```text
Data Control Language

用于定义用户的访问权限和安全级别，并控制数据库操纵事务发生的时间及效果，对数据库实行监视等
CRANT: 授予用户访问库、表等的访问权限
REVOKE: 回收用户访问库、表等的访问权限
COMMIT: 提交当前事务，将当前事务所做的更改永久化（写入数据库）
ROLLBACK: 取消上次提交以来的所有操作
```
