-- DQL数据查询语言作业练习
/*
库表sql脚本：./sql/student.sql

*/


# 一、查询每个专业的学生人数
USE student;

SELECT majorid, COUNT(*)
FROM student
GROUP BY majorid;


# 二、查询参加考试的学生中，每个学生的平均分、最高分
SELECT AVG(score) 平均分, MAX(score) 最高分
FROM result
WHERE score IS NOT NULL;

SELECT AVG(score) 平均分, MAX(score) 最高分
FROM result;


# 三、查询姓张的每个学生，其各专业成绩中最低分大于60的学号、姓名
SELECT MIN(score), s.studentno, s.studentname

FROM student s
INNER JOIN result r
ON r.studentno = s.studentno
WHERE s.studentname LIKE '张%'
GROUP BY s.studentno
HAVING MIN(score) > 60
;


# 四、查询每个专业中，学生生日在"1988-1-1"后的学生姓名、专业名称
-- sql-92
SELECT s.studentname, m.majorname
FROM student s, major m
WHERE s.majorid = m.majorid
AND DATEDIFF(s.borndate, '1988-1-1') > 0;

-- sql:1999
SELECT s.studentname, m.majorname
FROM student s
INNER JOIN major m
ON s.majorid = m.majorid
WHERE DATEDIFF(s.borndate, '1988-1-1') > 0;


# 五、查询每个专业的男生人数和女生人数分别是多少
/*
显示格式：
+--------+-------+-------+--------+
|专业名  |专业ID |男生   |女生    |
+--------+-------+-------+--------+
|xx      |xx     |xx     |xx      |
+--------+-------+-------+--------+

*/
-- ①查询出专业、男生数量
SELECT s.majorid, COUNT(*)
FROM student s
RIGHT OUTER JOIN major m
ON m.majorid = s.majorid
GROUP BY s.majorid, s.sex
HAVING s.sex = '男'
;

-- ②查询出专业、女生数量
SELECT s.majorid, COUNT(*)
FROM student s
RIGHT OUTER JOIN major m
ON m.majorid = s.majorid
GROUP BY s.majorid, s.sex
HAVING s.sex = '女'
;


-- ③把①结果集与②结果集当成两表连接起来，最后再与major表连接起来(因为前一步只有查到majorid，连接major可以查询到majorname)
SELECT m.majorname 专业名, t1.majorid 专业ID, t1.男生, t2.女生
FROM (
    SELECT s.majorid, COUNT(*) AS 男生
    FROM student s
    RIGHT OUTER JOIN major m
    ON m.majorid = s.majorid
    GROUP BY s.majorid, s.sex
    HAVING s.sex = '男'
) t1
INNER JOIN (
    SELECT s.majorid, COUNT(*) AS 女生
    FROM student s
    RIGHT OUTER JOIN major m
    ON m.majorid = s.majorid
    GROUP BY s.majorid, s.sex
    HAVING s.sex = '女'
) t2
ON t1.majorid = t2.majorid
INNER JOIN major m
ON t1.majorid = m.majorid;




SELECT s.majorid, COUNT(*)
FROM student s
RIGHT OUTER JOIN major m
ON m.majorid = s.majorid
GROUP BY s.majorid, s.sex
HAVING s.sex = '女'
;


# 六、查询专业和张翠山一样的学生的最低分
-- ①查询张翠山的专业ID
SELECT majorid
FROM student
WHERE studentname = '张翠山'
;

-- ②查询最低分，满足 majorid = ①
SELECT MIN(r.score)
FROM result r
INNER JOIN student s
ON r.studentno = s.studentno
WHERE s.majorid = (
    SELECT majorid
    FROM student
    WHERE studentname = '张翠山'
);

# 七、查询大于60分的学生的姓名、密码、专业名
SELECT s.studentname, s.loginpwd, s.majorid, r.score
FROM result r
INNER JOIN student s
ON r.studentno = s.studentno
INNER JOIN major m
ON m.majorid = s.majorid
WHERE r.score > 60;

# 八、按邮箱位数分组，查询每组的学生个数
SELECT COUNT(*), LENGTH(email) 邮箱长度
FROM student
GROUP BY LENGTH(email);

# 九、查询学生名、专业名、分数
-- 有可能出现学生未参加考试或其他原因没有成绩的情况，也有可能学生没有报专业
SELECT s.studentname, m.majorname, r.score
FROM student s
LEFT OUTER JOIN result r
ON s.studentno = r.studentno
LEFT OUTER JOIN major m
ON s.majorid = m.majorid;


# 十、查询哪个专业没有学生，分别用左外连接和右外连接实现
-- 这里要以major为主表

-- 左外连接
SELECT m.majorname
FROM major m
LEFT OUTER JOIN student s
ON m.majorid = s.majorid
WHERE s.studentno IS NULL;

-- 右外连接
SELECT  m.majorname
FROM student s
RIGHT OUTER JOIN major m
ON s.majorid = m.majorid
WHERE s.studentno IS NULL;


# 十一、查询没有成绩的学生人数
SELECT COUNT(*)
FROM student s
LEFT OUTER JOIN result r
ON s.studentno = r.studentno
WHERE r.score IS NULL;

