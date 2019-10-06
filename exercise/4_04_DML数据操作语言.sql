-- DML数据操作语言


/*
查询(DQL)：select ...      -- 前面有一章介绍DQL
插入：insert
修改：update
删除：delete


*/


-- 插入语句
--

-- values多行插入
--
/*
## 语法
insert into 表名(列名,...) values
(值1,...),
...
(值n,...);

注意：
值要与列位置对应

*/


USE girls;

SELECT * FROM beauty;

# 插入的值的类型要与列的类型一致或兼容
INSERT INTO beauty (id, `name`, sex, borndate, phone, photo, boyfriend_id) 
VALUES (13, '苏路', '女', '1988-01-03', '13544456666', NULL, 2);

-- 不可以为null的列必须指定值。

-- 可以为null的列若想插入的值为null，有一下两种方式

-- 方式1：指定值为null，如上示例
-- 方式2：插入列名列表中不指定该列
INSERT INTO beauty (id, `name`, sex, phone) 
VALUES (15, '云朵', '女', '13826966677');


# 指定的列顺序可以不与表的顺序一样，只要值与列对应即可
INSERT INTO beauty (`name`, sex, phone) 
VALUES ('花姐', '女', '15899888888');


# 列数与值的个数必须相同

# 省略列名，默认为所有的列，且列的顺序与表中列的顺序一致

INSERT INTO beauty 
VALUES (17, 'K娃', '女', '2005-5-1' ,'18933335555' ,NULL ,NULL);


-- set单行插入
-- 
/*
## 语法
insert into 表名
set 列名=值, 列2=值2,...
;

*/

INSERT INTO beauty
SET id=19, `name`='刘涛', phone='13533339999';


-- values多行插入、set单行插入对比
## values多行插入支持多行插入，set单行插入不支持
INSERT INTO beauty (`name`, sex, phone)
VALUES
('周笔畅', '女', '110'),
('张靓颖', '女', '120'),
('降央卓玛', '女', '119')
;

## values多行插入支持子查询，set单行插入不支持
INSERT INTO beauty (NAME, sex, phone)
SELECT '韩雪', '女', '15823326677';


INSERT INTO beauty (NAME, sex, phone)
SELECT boyName, '男', '12306'
FROM boys WHERE id < 3;

