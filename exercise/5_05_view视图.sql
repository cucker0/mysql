-- view视图


/*
概念：虚拟表，值保存了sql逻辑，不保存结果，使用视图时动态生成表数据。
与普通表一样使用。mysql 5.1开始添加此特性

## 使用场景
* 多个地方用到同样的查询结果
* 该查询结果使用的sql语句比较复杂

## 好处
* 重用sql语句
* 简化复杂的sql语句，不必知道它的查询细节
* 保护数据，提高安全性

## view视图与表对比
类型      关键字         占用空间                    使用
视图      create view    只保存sql逻辑，不保存数据   主要是查，增删改只能是特殊的操作(简单的，也不建议增删改)
表        create table   保存表数据                  增删改查


## view视图的生命周期是永久，一旦创建后，不手动删除是一直存在的
*/


-- 创建视图
/*
## 语法
create view 视图
as
查询语句
;

*/


# 案例：查询姓张的学生名和专业名
USE student;

-- 一般的方法
SELECT s.studentname, m.majorname
FROM student s
INNER JOIN major m
ON s.majorid = m.majorid
WHERE s.studentname LIKE '张%';

-- view 视图
-- ①创建视图
CREATE VIEW myv1
AS
SELECT s.studentname, m.majorname
FROM student s
INNER JOIN major m
ON s.majorid = m.majorid
;

-- ②使用视图
SELECT * FROM myv1
WHERE studentname LIKE '张%';

