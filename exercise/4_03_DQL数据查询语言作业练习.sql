-- DQL数据查询语言作业练习


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


# 七、查询大于60分的学生的姓名、密码、专业名


# 八、按邮箱位数分组，查询每组的学生个数


# 九、查询学生名、专业名、分数




# 十、查询哪个专业没有学生，分别用左连接和右连接实现

# 十一、查询没有成绩的学生人数










