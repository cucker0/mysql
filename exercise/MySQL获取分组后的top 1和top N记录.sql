-- MySQL获取分组后的top 1和top N记录


-- 表结构
USE test;

DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(32), -- 姓名
    course VARCHAR(32), -- 课程
    score INT -- 成绩
);

-- 插入数据
INSERT INTO stuinfo (`name`, course, score) VALUES
('张三', '语文', 80),
('李四', '语文', 90),
('王五', '语文', 93),
('刘六', '语文', 66),
('赵七', '语文', 74),
('张三', '数学', 77),
('李四', '数学', 68),
('王五', '数学', 99),
('刘六', '数学', 83),
('赵七', '数学', 94),
('张三', '英语', 90),
('李四', '英语', 50),
('王五', '英语', 89),
('刘六', '英语', 95),
('赵七', '英语', 81);


SELECT * FROM stuinfo;


-- top 1的记录
# 案例：查询每门课程分数最高的学生信息以及成绩
    -- 方式1:自身内连接
-- ①查询出每门课程的最高成绩
SELECT MAX(score)
FROM stuinfo
GROUP BY course
;

-- ②stuinfo表与①结果集(当成表t2)内连接，满足stuinfo表.成绩 = t2.成绩
    
SELECT t1.id, t1.`name`, t1.`score` 
FROM stuinfo t1
INNER JOIN (
    SELECT MAX(score) AS max_score
    FROM stuinfo
    GROUP BY course
) AS t2
ON t1.score = t2.max_score;

/*
查询结果:
    id  name     score  
------  ------  --------
     3  王五            93
     8  王五            99
    14  刘六            95
*/


    -- 先关子查询
SELECT t1.id, t1.name, t1.score 
FROM stuinfo t1
WHERE score = (
    SELECT MAX(score)
    FROM stuinfo t2
    WHERE t2.course = t1.course -- 相当于分别查询每门课程的最高成绩
);

    -- 或(比较难理解)
    -- 思路：该课程中没有比它高的成绩
SELECT `name`,course,score 
FROM stuinfo t1
WHERE NOT EXISTS( -- 查询格门课程成绩中不满足：t2.score > t1.score，即找出各课程中没有比它高的成绩
    SELECT 1 FROM stuinfo AS t2
    WHERE t2.course = t1.course -- 相同的课程
    AND t2.score > t1.score
);


-- top n的记录(N>=1)
-- 

# 案例：查询每门课程前3名的学生信息以及成绩
-- 使用union all联合各门课程top n记录子查询结果集
/*
如果结果集比较小，可以用程序查询单个分组结果后拼凑，
也可以使用union all
*/


(
    SELECT *
    FROM stuinfo
    WHERE course = '语文'
    ORDER BY score DESC
    LIMIT 1, 3
)

UNION ALL

(
    SELECT *
    FROM stuinfo
    WHERE course = '数学'
    ORDER BY score DESC
    LIMIT 3
)

UNION ALL

(
    SELECT *
    FROM stuinfo
    WHERE course = '英语'
    ORDER BY score DESC
    LIMIT 1, 3
)
;


-- 自身左外连接
/*
思路：找出该课程中，比它高的成绩的个数。
最高成绩，0个成绩比它高;
第二稿成绩，1个成绩比它高;
第三稿成绩，2个成绩比它高;
*/
SELECT t1.name, t1.course, t1.score
FROM stuinfo t1 
LEFT JOIN stuinfo t2
ON t1.course = t2.course 
AND t1.score < t2.score -- 把同课程中成绩比它高的联起来
GROUP BY t1.course, t1.name, t1.score
HAVING COUNT(t2.id) <= 2
ORDER BY t1.course, t1.score DESC;


-- 相关子查询
SELECT t1.*
FROM stuinfo t1
WHERE (
    SELECT COUNT(*)
    FROM stuinfo t2
    WHERE t2.course = t1.course
    AND t1.score > t2.score -- 筛选出t1中比t2中同课程成绩高的记录
) >= 2
ORDER BY t1.course, t1.score DESC;


-- 使用用户变量
/*
思路：先把每门课程的成绩排序，再给成绩编排列序号
*/
SET @num = 0, @course = '';

SELECT `name`, course, score
FROM (
    SELECT 
        `name`, 
        course, 
        score,
        @num := IF(@course = course, @num + 1, 1) AS `row_number`,
        @course := course AS dummy
    FROM stuinfo
    ORDER BY course, score DESC
) AS t
WHERE t.row_number <= 3
;

-- 分析
/*
SET @num = 0, @course = '';

SELECT 
    `name`, 
    course, 
    score,
    @num := IF(@course = course, @num + 1, 1) AS `row_number`,
    @course := course AS dummy
FROM stuinfo
ORDER BY course, score DESC
;

查询结果集(注意row_number值)：

name    course   score  row_number  dummy   
------  ------  ------  ----------  --------
王五    数学    99      1           数学  
赵七    数学    94      2           数学  
刘六    数学    83      3           数学  
张三    数学    77      4           数学  
李四    数学    68      5           数学  
刘六    英语    95      1           英语  
张三    英语    90      2           英语  
王五    英语    89      3           英语  
赵七    英语    81      4           英语  
李四    英语    50      5           英语  
王五    语文    93      1           语文  
李四    语文    90      2           语文  
张三    语文    80      3           语文  
赵七    语文    74      4           语文  
刘六    语文    66      5           语文 

*/

