DECLARE a INT DEFAULT 10;

SELECT a;

SHOW GLOBAL VARIABLES LIKE 'max_connections';


SHOW TABLES;


DESC book;

CREATE UNIQUE INDEX idx_book_name_price ON book (`name`, price);

SHOW INDEX FROM book;

DROP INDEX idx_book_name_price ON book;

DROP INDEX idx_book_name_price ON book;


ALTER TABLE book ADD PRIMARY KEY (id);

ALTER TABLE book ADD UNIQUE INDEX idx_book_name (`name`);

ALTER TABLE book ADD INDEX idx_book_price (`name`, price);

ALTER TABLE book ADD FULLTEXT idx_book_content (content);



-- 创建区政图
CREATE DATABASE testdb;

USE testdb;

CREATE TABLE area_map (
    id INT PRIMARY KEY AUTO_INCREMENT,
    stat VARCHAR(32) NOT NULL,  -- 州/镇
    city VARCHAR(32),  -- 市
    province VARCHAR(20),  -- 省
    postcode INT  -- 邮编
);

DESC area_map;


INSERT INTO area_map (stat, city, province, postcode) VALUES
('aa镇', 'anqing市', 'anhui省', 246000),
('bb镇', 'anqing市', 'anhui省', 246100),
('cc镇', 'anqing市', 'anhui省', 246200),
('aa镇', 'bengbu市', 'anhui省', 233000),
('bb镇', 'bengbu市', 'anhui省', 233100),
('cc镇', 'bengbu市', 'anhui省', 233200),
('aa镇', 'chizhou市', 'anhui省', 247100),
('bb镇', 'chizhou市', 'anhui省', 247200),
('cc镇', 'chizhou市', 'anhui省', 247300),
('aa镇', 'changle市', 'fujian省', 350200),
('bb镇', 'changle市', 'fujian省', 350300),
('cc镇', 'changle市', 'fujian省', 350400),
('aa镇', 'fuzhou市', 'fujian省', 350000),
('bb镇', 'fuzhou市', 'fujian省', 350100),
('cc镇', 'fuzhou市', 'fujian省', 350200),
('aa镇', 'zhangzhou市', 'fujian省', 363000),
('bb镇', 'zhangzhou市', 'fujian省', 363000),
('cc镇', 'zhangzhou市', 'fujian省', 363000),
('aa镇', 'baiyin市', 'gansu省', 730100),
('bb镇', 'baiyin市', 'gansu省', 730200),
('cc镇', 'baiyin市', 'gansu省', 730300),
('aa镇', 'duhuang市', 'gansu省', 736200),
('bb镇', 'duhuang市', 'gansu省', 736300),
('cc镇', 'duhuang市', 'gansu省', 736400),
('aa镇', 'gannan州', 'gansu省', 747000),
('bb镇', 'gannan州', 'gansu省', 747100),
('cc镇', 'gannan州', 'gansu省', 747200);



SELECT province, city, stat, postcode
FROM area_map
ORDER BY province, city, stat;


-- explain分析sql语句
EXPLAIN
SELECT province, city, stat, postcode
FROM area_map
ORDER BY province, city, stat;


-- explain示例
CREATE TABLE t1 (
    id INT PRIMARY KEY,
    `name` VARCHAR(32),
    score INT
);

CREATE TABLE t2 (
    id INT PRIMARY KEY,
    `name` VARCHAR(32),
    height INT
);

CREATE TABLE t3 (
    id INT PRIMARY KEY,
    `name` VARCHAR(32),
    income DOUBLE
);


INSERT INTO t1 VALUES
(1, '张衡', 96),
(2, '蔡伦', 80),
(3, '严复', 98),
(4, '沈括', NULL);

INSERT INTO t2 VALUES
(1, '张衡', 170),
(2, '蔡伦', 163),
(3, '严复', 177);

INSERT INTO t3 VALUES
(1, '张衡', 2300),
(2, '蔡伦', 5300),
(3, '严复', 4800);


EXPLAIN
SELECT d1.name, (SELECT id FROM t3) d2
FROM (SELECT id, `name` FROM t1 WHERE score = 98) AS d1
UNION
(SELECT `name`, id FROM t2);



-- 单表分析
-- 
CREATE TABLE IF NOT EXISTS article (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    views INT NOT NULL,
    comments INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL
);


INSERT INTO article VALUES
(NULL, 1, 1, 10, 10, '三体', '用前沿科学对《三体》世界进行支撑，用烧脑理论让《三体》的意义进一步延伸。'),
(NULL, 2, 2, 20, 20, '登月使命', '这本书用文字、图片结合AR技术复现了人类登上月球的伟大旅程。'),
(NULL, 3, 3, 30, 30, '人类的未来', '大宇宙时代的到来，是我们人类必然会走的一个康庄大道，也是科技发展的一个重要的领域。');

SELECT * FROM article;

# 查询category_id为1，且comments >1的情况下，views最多的article_id, author_id
EXPLAIN
SELECT id, author_id
FROM article
WHERE category_id = 1
    AND comments > 1
ORDER BY views DESC
LIMIT 0, 1;

# 结论
/*
type为ALL，最坏情况。
Extra中出现了Using filesort，也最坏的情况
*/

-- 优化
-- 新建索引
CREATE INDEX  idx_article_category_id_comments_views ON article (category_id, comments, views);

SHOW INDEX FROM article;

-- 2
EXPLAIN
SELECT id, author_id
FROM article
WHERE category_id = 1
    AND comments > 1
ORDER BY views DESC
LIMIT 0, 1;

# 结论：
/*
type变成了range,这时可以忍受的。
但是Extra为Using filesort，这个情况任然很坏

## 为什么建了索引没什么用呢
1. 这是因为先按category_id排序，
2. 在步骤1基础上，category_id相同的再按comments排序
3. 在步骤2基础上，comments相同的再按views排序

但comments字段在符合索引里处于中间位置是，因为comments > 1 条件是一个范围(即range)
所以mysql无法利用索引再对后面的views进行检索，即range类型对应的查询字段后面的索引失效

*/

-- 3
EXPLAIN
SELECT id, author_id
FROM article
WHERE category_id = 1
    AND comments = 1
ORDER BY views DESC
LIMIT 0, 1;


-- 继续优化，删除前面的索引，新建新的复合索引
DROP INDEX idx_article_category_id_comments_views ON article;
ALTER TABLE article ADD INDEX (category_id, views);

SHOW INDEX FROM article;

EXPLAIN
SELECT id, author_id
FROM article
WHERE category_id = 1
    AND comments > 1
ORDER BY views DESC
LIMIT 0, 1;

# 结论
/*
type为ref
Extra为Using where; Backward index scan，已经没有Using filesort情况了

这是一种非常理想的情况
*/



-- 两表分析
-- 
DROP TABLE IF EXISTS class;
CREATE TABLE class (
    id INT PRIMARY KEY AUTO_INCREMENT,
    card INT NOT NULL
);

DROP TABLE IF EXISTS book;
CREATE TABLE book (
    bookid INT PRIMARY KEY AUTO_INCREMENT,
    card INT NOT NULL
);

INSERT INTO class (card) VALUES
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20));

INSERT INTO book (card) VALUES
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20));


-- 分析1：无索引情况
EXPLAIN
SELECT *
FROM book
LEFT OUTER JOIN class
ON class.card = book.card;

# 结论：type均为ALL，不好

-- 分析2：book表添加索引优化
ALTER TABLE book ADD INDEX idx_book_card(card);
SHOW INDEX FROM book;

-- 2_1
EXPLAIN
SELECT *
FROM book
LEFT OUTER JOIN class
ON class.card = book.card;
# 结论
/*
book表的类型为index，Extra为Using index，rows为12行
class表的为ALL，Extra为Using where; Using join buffer (Block Nested Loop)
*/

-- 2_2
EXPLAIN
SELECT *
FROM book
RIGHT OUTER JOIN class
ON class.card = book.card;

--
EXPLAIN
SELECT *
FROM class
INNER JOIN book
ON class.card = book.card;

EXPLAIN
SELECT *
FROM book
INNER JOIN class
ON class.card = book.card;


# 结论
/*
book表的类型为ref，比上面的查询更好一些，Extra为Using index，rows为1行
class表的为ALL，Extra为NULL
*/




-- 分析3：class表添加索引优化
DROP INDEX idx_book_card ON book;

ALTER TABLE class ADD INDEX idx_class_card (card);
SHOW INDEX FROM book;
SHOW INDEX FROM class;

-- 3_1
EXPLAIN
SELECT *
FROM book
LEFT OUTER JOIN class
ON class.card = book.card;
# 结论
/*
book表的类型为ref，比上面的查询更好一些，Extra为Using index，rows为1行
class表的为ALL，Extra为NULL
*/

-- 3_2
EXPLAIN
SELECT *
FROM book
RIGHT OUTER JOIN class
ON class.card = book.card;

--
EXPLAIN
SELECT *
FROM class
INNER JOIN book
ON class.card = book.card;

EXPLAIN
SELECT *
FROM book
INNER JOIN class
ON class.card = book.card;

# 结论
/*
book表的类型为index，Extra为Using index，rows为12行
class表的为ALL，Extra为Using where; Using join buffer (Block Nested Loop)
*/


# 两表连接查询总结
/*
对于左外连接、有外连接查询，在连接条件的字段建索引，把索引建在从表上性能更好。
因为从表值查询相同部分的行，主表查询所有行。
用行数少的表驱动大表，即在行数少的表上建索引效果更好

对于内连接无此差别
*/



-- 3表分析
-- 
-- 两表分析的表结构下，再加一张表
CREATE TABLE phone (
    phoneid INT PRIMARY KEY AUTO_INCREMENT,
    card INT NOT NULL
);

INSERT INTO phone (card) VALUES
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20)),
(CEIL(RAND() * 20));


-- 
-- 把 class、book表的索引都删除
DROP INDEX idx_class_card ON class;
DROP INDEX idx_book_card ON book;

-- 无索引情况
EXPLAIN
SELECT *
FROM class c
LEFT OUTER JOIN book b
ON c.card = b.card
LEFT OUTER JOIN phone p
ON c.card = p.card;


EXPLAIN
SELECT *
FROM class c
INNER JOIN book b
ON c.card = b.card
INNER JOIN phone p
ON c.card = p.card;

-- 优化1：在从表book、phone中建的索引在关联字段上
ALTER TABLE book ADD INDEX idx_book_card (card);

ALTER TABLE phone ADD INDEX idx_phone_card (card);


EXPLAIN
SELECT *
FROM class c
LEFT OUTER JOIN book b
ON c.card = b.card
LEFT OUTER JOIN phone p
ON c.card = p.card;

# 结论
/*
表book、phone的type都为ref,rows都为1, Extra都为Using index
优化良好，效果不错。

索引要建在经常查询的字段中


*/


# 三表join语句的优化总结
/*
* 尽可能减少join语句中的嵌套循环总次数
* 永远用小结果集驱动大结果集，即在小结果集表的字段中建索引
* 优先优化嵌套循环的内层循环
* 保证join语句中被驱动表上join条件字段已经被索引
* 当无法保证被驱动表的join条件字段被索引且内存资源充足的情况下，把join_buffer_size设置大点


*/


-- 员工表
CREATE TABLE staffs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(24) NOT NULL DEFAULT '' COMMENT '姓名',
    age INT NOT NULL DEFAULT 1 COMMENT '年龄',
    pos VARCHAR(20) NOT NULL DEFAULT '' COMMENT '职位',
    add_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入职时间'
) CHARSET utf8 COMMENT '员工表';


INSERT INTO staffs (`name`, age, pos, add_time) VALUES
('z3', 22, 'manager', NOW()),
('July', 23,'dev', NOW()),
('2000', 23,'dev', NOW());

SELECT * FROM staffs;


ALTER TABLE staffs ADD INDEX idx_staffs_name_age_pos (NAME, age ,pos);

