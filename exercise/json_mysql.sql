CREATE DATABASE jsontest CHARSET 'utf8mb4';

USE jsontest;
-- 创建json table
CREATE TABLE json_tab (
    jdoc JSON
);

SHOW CREATE TABLE json_tab;

INSERT INTO json_tab VALUES('{"key1": "value1", "key2": "value2"}');

INSERT INTO json_tab VALUES('[1, 2,');
INSERT INTO json_tab VALUES('[1, 2,]');  -- 会有如下的错误提示
/*
错误代码： 3140
Invalid JSON TEXT: "Invalid value." AT POSITION 6 IN VALUE FOR COLUMN 'json_tab.jdoc'.
*/
INSERT INTO json_tab VALUES('[1, 2]');


SELECT * FROM json_tab;

SELECT * FROM json_tab LIMIT 1;

-- 获取json指定key的值。包括引号或任何转义符
SELECT jdoc->"$.key1" FROM json_tab;

-- 不包括 引号或任何转义符
SELECT jdoc->>"$.key1" FROM json_tab

-- json key 值作为条件查询
SELECT * FROM json_tab WHERE jdoc->>"$.key1" = 'value1';


CREATE TABLE department_tbl (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL
);

INSERT INTO department_tbl(`name`) VALUES
('行政部'),
('财务部'),
('销售部'),
('客服部')
;


-- user table
CREATE TABLE employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    rest JSON COMMENT '其它信息(json类型)'
);

-- insert record
INSERT INTO employee(`name`, rest) VALUES
('Mally', '{"age":23, "gender":0, "salary": 56000, "positions": "cfo,ceo", "stock": 6000000, "department_id":1}'),
('Jakob', '{"age":22, "gender":1, "salary": 80000, "positions": "Mathematics consultant,cfa", "stock": 96000000,"department_id":1}'),
('Einstein', '{"age":21, "gender":1, "salary": 80000, "positions": "Security consultant,cfa"}')
;



SELECT * FROM employee;


SELECT 17 MEMBER OF('[23, "abc", 17, "ab", 10]');

SELECT 'ab' MEMBER OF('[23, "abc", 17, "ab", 10]');

INSERT INTO employee(`name`, rest) VALUES
('Kally', '[3,10,5,17,[22,44,66]]'),
('Bakry', '[3,10,5,17,44]')
;


SELECT * FROM employee WHERE rest->"$[0]" = 3;

SELECT rest->"$[4][1]" FROM employee;

-- 以json的某个值作为连接条件
SELECT e.id, e.name, e.rest->>"$.age", e.rest->>"$.salary", d.name department_name FROM department_tbl AS d
INNER JOIN employee AS e 
ON d.id = e.rest->>"$.department_id"
;

SELECT e.id, e.name, e.rest->>"$.age", e.rest->>"$.salary", d.name department_name FROM department_tbl AS d
RIGHT OUTER JOIN employee AS e 
ON d.id = e.rest->>"$.department_id"
;


## Functions That Create JSON Values  --start
-- json数组
SELECT JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME());  -- CURTIME() 当前时间
/*
JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME())  
---------------------------------------------
[1, "abc", null, true, "02:49:16.000000"]    
*/

SELECT JSON_ARRAY('a', 1, NOW());  -- now() 当前日期时间
/*
JSON_ARRAY('a', 1, NOW())               
----------------------------------------
["a", 1, "2021-09-01 02:48:58.000000"]  
*/

--  json对象
SELECT JSON_OBJECT('id', 87, 'name', 'carrot');
/*
JSON_OBJECT('id', 87, 'name', 'carrot')  
-----------------------------------------
{"id": 87, "name": "carrot"}             
*/


-- 双引号包裹字符串
SELECT JSON_QUOTE('null'), JSON_QUOTE('"null"');
/*
JSON_QUOTE('null')  JSON_QUOTE('"null"')  
------------------  ----------------------
"null"              "\"null\""            
*/


SELECT JSON_QUOTE('[1, 2, 3]'), JSON_QUOTE('{"total": 2300}');
/*
JSON_QUOTE('[1, 2, 3]')  JSON_QUOTE('{"total": 2300}')  
-----------------------  -------------------------------
"[1, 2, 3]"              "{\"total\": 2300}"                       
*/

## Functions That Create JSON Values  --end


## Functions That Search JSON Values  --start
### ->
CREATE TABLE jemp (
   g INT,
   c JSON
);

INSERT INTO jemp(g, c) VALUES
(1, '{"id": 1, "name": "Niki"}'),
(2, '{"id": 2, "name": "Wilma"}'),
(3, '{"id": 3, "name": "Barney"}'),
(4, '{"id": 4, "name": "Betty"} ')
;

SELECT c, JSON_EXTRACT(c, "$.id"), g 
FROM jemp
WHERE JSON_EXTRACT(c, "$.id") > 1
ORDER BY JSON_EXTRACT(c, "$.name")
;
/*
c                            JSOn_EXTRACt(c, "$.id")       g  
---------------------------  -----------------------  --------
{"id": 3, "name": "Barney"}  3                               3
{"id": 4, "name": "Betty"}   4                               4
{"id": 2, "name": "Wilma"}   2                               2
*/

-- 等价于 上面的写法
SELECT c, c->"$.id", g
FROM jemp
WHERE c->"$.id" > 1
ORDER BY c->"$.name"
;

/*
c                            c->"$.id"       g  
---------------------------  ---------  --------
{"id": 3, "name": "Barney"}  3                 3
{"id": 4, "name": "Betty"}   4                 4
{"id": 2, "name": "Wilma"}   2                 2
*/


ALTER TABLE jemp ADD COLUMN n INT;
UPDATE jemp SET n=1 WHERE c->"$.id" = 4;

SELECT c, c->"$.id", g, n
FROM jemp
WHERE c->"$.id" > 1
ORDER BY c->"$.name"
;
/*
c                            c->"$.id"       g       n  
---------------------------  ---------  ------  --------
{"id": 3, "name": "Barney"}  3               3    (NULL)
{"id": 4, "name": "Betty"}   4               4         1
{"id": 2, "name": "Wilma"}   2               2    (NULL)
*/

DELETE FROM jemp WHERE c->"$.id" = 4;

SELECT c, c->"$.id", g, n
FROM jemp
WHERE JSON_EXTRACT(c, "$.id") > 1
ORDER BY c->"$.name"
;
/*
c                            c->"$.id"       g       n  
---------------------------  ---------  ------  --------
{"id": 3, "name": "Barney"}  3               3    (NULL)
{"id": 2, "name": "Wilma"}   2               2    (NULL)
*/

#### 多层key
INSERT INTO jemp(c, g) VALUES
('{"kkk": {"kk": {"k": 111}}, "jjj": {"jj": {"j": 222}}}', 5);

SELECT c->"$.kkk.kk" FROM jemp WHERE g=5;
/*
c->"$.kkk.kk"  
---------------
{"k": 111}     
*/
DELETE FROM jemp WHERE c->"$.kkk.kk.k" = 111;

#### 数组
INSERT INTO jemp(c, g) VALUES
("[3,10,5,17,44]", 33),
("[3,10,5,17,[22,44,66]]", 34);

SELECT c->"$[4]" FROM jemp WHERE g >=33 AND g <= 34;
/*
c->"$[4]"     
--------------
44            
[22, 44, 66] 
*/

SELECT * FROM jemp WHERE c->"$[0]" = 3;
/*
     g  c                                  n  
------  ----------------------------  --------
    33  [3, 10, 5, 17, 44]              (NULL)
    34  [3, 10, 5, 17, [22, 44, 66]]    (NULL)
*/

#### 多维数组
SELECT * FROM jemp
WHERE c->"$[4][1]" IS NOT NULL;
/*
     g  c                                  n  
------  ----------------------------  --------
    34  [3, 10, 5, 17, [22, 44, 66]]    (NULL)
*/

#### map与list组合
INSERT INTO jemp(c, g) VALUES
('{"data": [{"hostname": "webserv1", "ip": "172.17.0.2"}, 11, 22, 33], "code": 0}', 35),
('{"data": [{"hostname": "webserv2", "ip": "172.17.0.3"}, 44, 55, 66], "code": 0}', 36);

SELECT c->"$.data[0].hostname" FROM jemp WHERE g = 35;


### ->>
SELECT c->"$.name" AS 'name' FROM jemp WHERE g > 2 AND g < 5;
/*
name      
----------
"Barney"  
"Betty"  
*/

-- 以下两条SQL等价，查询结果也一样
SELECT JSON_UNQUOTE(c->"$.name") AS 'name' FROM jemp WHERE g > 2 AND g < 5;
SELECT c->>"$.name" AS 'name' FROM jemp WHERE g>2 AND g < 5;
/*
name    
--------
Barney  
Betty  
*/


INSERT INTO jemp(c, g) VALUES
('[3, 10, 5, "x", 44]', 37),
('[3, 10, 5, 17, [22, "y" , 66]]', 38)
;

SELECT c->'$[3]', c->'$[4][1]' FROM jemp 
WHERE g = 37 OR g = 38;
/*
c->'$[3]'  c->'$[4][1]'  
---------  --------------
"x"        (NULL)        
17         "y"           
*/

SELECT c->>'$[3]', c->>'$[4][1]' FROM jemp 
WHERE g = 37 OR g = 38;
/*
c->>'$[3]'  c->>'$[4][1]'  
----------  ---------------
x           (NULL)         
17          y              
*/


### JSON_KEYS()
SELECT JSON_KEYS('{"a": 1, "b": {"c": 30}}');
/*
JSON_KEYS('{"a": 1, "b": {"c": 30}}')  
---------------------------------------
["a", "b"]  
*/

SELECT JSON_KEYS('[11, 22, 33, {"k1": 100}]');
-- 结果为 NULL

SELECT c FROM jemp WHERE g = 5;
/*
c                                                       
--------------------------------------------------------
{"jjj": {"jj": {"j": 222}}, "kkk": {"kk": {"k": 111}}}  
*/

SELECT JSON_KEYS(c) FROM jemp WHERE g = 5;
/*
JSON_KEYs(c)    
----------------
["jjj", "kkk"]  
*/

SELECT JSON_KEYS(c, "$.kkk.kk") FROM jemp WHERE g = 5;
/*
JSON_KEYS(c, "$.kkk.kk")  
--------------------------
["k"]                     
*/

### JSON_EXTRACT()
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[1]');
/*
json_extract('[10, 20, [30, 40]]', '$[1]')  
--------------------------------------------
20                                          
*/

-- JSON_EXTRACT() 获取多个path位置的值，返回值组合成一个json数组
SELECT JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[1]', '$[3]');
/*
json_extract('[10, 20, [30, 40], 50]', '$[1]', '$[3]')  
--------------------------------------------------------
[20, 50]                                                
*/

SELECT JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[2][*]');
/*
JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[2][*]')  
---------------------------------------------------
[30, 40]                                           
*/

SELECT JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[*][*]');
/*
JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[*][*]')  
---------------------------------------------------
[30, 40]                                           
*/

SELECT JSON_EXTRACT('[10, 20, [30, 40], 50, [311, 411]]', '$[*][*]');
/*
JSON_EXTRACT('[10, 20, [30, 40], 50, [311, 411]]', '$[*][*]')  
---------------------------------------------------------------
[30, 40, 311, 411]                                             
*/

-- '$.*' 获取所有的值
SELECT JSON_EXTRACT('{"k1":11, "k2": [22, 33]}', '$.*');
/*
json_extract('{"k1":11, "k2": [22, 33]}', '$.*')  
--------------------------------------------------
[11, [22, 33]]                                    
*/

SELECT c FROM jemp WHERE g = 1;
/*
c                           
----------------------------
{"id": 1, "name": "Nicki"}  
*/

-- 类似 JSON_VALUES()，Mysql暂未提供 JSON_VALUES()函数
SELECT c->'$.*' FROM jemp WHERE g = 1;
SELECT c->>'$.*' FROM jemp WHERE g = 1;
/*
c->'$.*'      
--------------
[1, "Nicki"]  
*/

-- 等同上面的SQL效果
SELECT JSON_EXTRACT(c, '$.*') FROM jemp WHERE g = 1;
/*
JSON_extract(c, '$.*')  
------------------------
[1, "Nicki"]            
*/


-- '$.*.*'
SELECT JSON_EXTRACT('{"k1":11, "k2": {"k21":21, "k22":22}}', '$.*.*');
/*
JSON_EXTRACT('{"k1":11, "k2": {"k21":21, "k22":22}}', '$.*.*')  
----------------------------------------------------------------
[21, 22]                                                        
*/

### JSON_CONTAINS(target, candidate[, path])
SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1', '$.a');
/*
json_contains('{"a":1, "b":2, "c":{"d":4}}', '1', '$.a')  
----------------------------------------------------------
                                                         1
*/

SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1', '$.b');
/*
JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1', '$.b')  
----------------------------------------------------------
                                                         0
*/

SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.b');
/*
json_contains('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.b')  
----------------------------------------------------------------
*/

SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.c');
/*
JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.c')  
----------------------------------------------------------------
                                                               1
*/

SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1');
/*
JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1')  
---------------------------------------------------
                                                  0
*/

SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"a":1}');
/*
JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"a":1}')  
---------------------------------------------------------
                                                        1
*/

SELECT JSON_CONTAINS('[11, 22, 33, 44]', '[44]');
/*
JSON_CONTAINS('[11, 22, 33, 44]', '[44]')  
-------------------------------------------
                                          1
*/

SELECT JSON_CONTAINS('[11, 22, 33, 44]', '44');
/*
JSON_CONTAINS('[11, 22, 33, 44]', '44')  
-----------------------------------------
                                        1
*/

SELECT JSON_CONTAINS('[11, 22, 33, 44]', '[11, 33]');
/*
JSON_CONTAINS('[11, 22, 33, 44]', '[11, 33]')  
-----------------------------------------------
                                              1
*/

SELECT JSON_CONTAINS('[11, 22, 33, 44]', '11', '$[0]');
/*
JSON_CONTAINS('[11, 22, 33, 44]', '11', '$[0]')  
-------------------------------------------------
                                                1
*/

### JSON_CONTAINS_PATH(json_doc, one_or_all, path[, path] ...)
SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a', '$.e');
/*
json_contains_path('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a', '$.e')  
------------------------------------------------------------------------
                                                                       1
*/

SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'all', '$.a', '$.e');
/*
JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'all', '$.a', '$.e')  
------------------------------------------------------------------------
                                                                       0
*/

SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.c.d');
/*
json_contains_path('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.c.d')  
-------------------------------------------------------------------
                                                                  1
*/

SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a.d');
/*
JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a.d')  
-------------------------------------------------------------------
                                                                  0
*/


### JSON_OVERLAPS(json_doc1, json_doc2)
SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '[2, 5, 7]');
/*
JSON_OVERLAPS('[1, 3, 5, 7]', '[2, 5, 7]')  
--------------------------------------------
                                           1
*/

SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 7]');
/*
JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 7]')  
------------------------------------------------
                                               1
*/

SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 300]');
/*
JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 300]')  
--------------------------------------------------
                                                 0
*/

SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '1');
/*
JSON_OVERLAPS('[1, 3, 5, 7]', '1')  
------------------------------------
                                   1
*/

-- 部分匹配视为不匹配
SELECT JSON_OVERLAPS('[[1,2], [3,4], 5]', '[1, [2,3]]');
/*
JSON_OVERLAPS('[[1,2], [3,4], 5]', '[1, [2,3]]')  
--------------------------------------------------
                                                 0
*/

-- When comparing objects, the result is true if they have at least one key-value pair in common.
SELECT JSON_OVERLAPS('{"a":1, "b":10, "d":10}', '{"c":1, "e":10, "f":1, "d":10}');
/*
JSON_OVERLAPS('{"a":1,"b":10,"d":10}', '{"c":1,"e":10,"f":1,"d":10}')  
-----------------------------------------------------------------------
                                                                     1
*/

SELECT JSON_OVERLAPS('{"a":1, "b":10, "d":10}', '{"a":5, "e":10, "f":1, "d":20}');
/*
JSON_OVERLAPS('{"a":1, "b":10, "d":10}', '{"a":5, "e":10, "f":1, "d":20}')  
----------------------------------------------------------------------------
                                                                           0
*/

SELECT JSON_OVERLAPS('5', '5');
/*
JSON_OVERLAPS('5', '5')  
-------------------------
                        1
*/

SELECT JSON_OVERLAPS('5', '6');
/*
JSON_OVERLAPS('5', '6')  
-------------------------
                        0
*/

SELECT JSON_OVERLAPS('[4, 5, 6, 7]', '6');
/*
JSON_OVERLAPS('[4,5,6,7]', '6')  
---------------------------------
                                1
*/

SELECT JSON_OVERLAPS('[4, 5, "6", 7]', '6');
/*
JSON_OVERLAPS('[4,5,"6",7]', '6')  
-----------------------------------
                                  0
*/

SELECT JSON_OVERLAPS('[4, 5, 6, 7]', '"6"');
/*
JSON_OVERLAPS('[4, 5, 6, 7]', '"6"')  
--------------------------------------
                                     0
*/


### JSON_SEARCH(json_doc, one_or_all, search_str[, escape_char[, path] ...])
SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'one',  'abc');
/*
JSON_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'one',  'abc')  
---------------------------------------------------------------------------------------
"$[0]"                                                                                 
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'abc');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'abc')  
---------------------------------------------------------------------------------------
["$[0]", "$[2].x"]                                                                     
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'haha');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'haha')  
---------------------------------------------------------------------------------------
NULL
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 10);
/*
json_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 10)  
-----------------------------------------------------------------------------------
"$[1][0].k"                                                                        
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$')  
------------------------------------------------------------------------------------------------
"$[1][0].k"                                                                                     
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*]');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*]')  
---------------------------------------------------------------------------------------------------
"$[1][0].k"                                                                                        
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$**.k');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$**.k')  
----------------------------------------------------------------------------------------------------
"$[1][0].k"                                                                                         
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*][0].k');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*][0].k')  
--------------------------------------------------------------------------------------------------------
"$[1][0].k"                                                                                             
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1]');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1]')  
---------------------------------------------------------------------------------------------------
"$[1][0].k"                                                                                        
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1][0]');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1][0]')  
------------------------------------------------------------------------------------------------------
"$[1][0].k"                                                                                           
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'abc', NULL, '$[2]');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'abc', NULL, '$[2]')  
----------------------------------------------------------------------------------------------------
"$[2].x"                                                                                            
*/

-- 通配符查找（模糊查找）
SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%d%');
/*
json_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%d%')  
--------------------------------------------------------------------------------------
["$[1][1]", "$[3].y"]                                                                 
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%');
/*
json_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%')  
--------------------------------------------------------------------------------------
["$[0]", "$[2].x", "$[3].y"]                                                          
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%', '', '$[3]');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%', '', '$[3]')  
--------------------------------------------------------------------------------------------------
"$[3].y"                                                                                          
*/

SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'd_f');
/*
JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'd_f')  
--------------------------------------------------------------------------------------
"$[1][1]"                                                                             
*/

-- 转义特殊字符
SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a%bc');
/*
JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a%bc')  
-------------------------------------------------------------------------------------------------
["$[0]", "$[1]", "$[3].x"]                                                                       
*/

SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\%bc');
/*
JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\%bc')  
--------------------------------------------------------------------------------------------------
"$[3].x"                                                                                          
*/

-- 显示指定%转义为字面意思
SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a$%bc', '$');
/*
JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a$%bc', '$')  
-------------------------------------------------------------------------------------------------------
"$[3].x"                                                                                               
*/

SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a_bc');
/*
JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a_bc')  
-------------------------------------------------------------------------------------------------
["$[0]", "$[1]", "$[3].x"]                                                                       
*/

-- _转义为字面意思
SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\_bc');
/*
JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\_bc')  
--------------------------------------------------------------------------------------------------
"$[0]"                                                                                            
*/

SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a`_bc', '`');
/*
JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a`_bc', '`')  
-------------------------------------------------------------------------------------------------------
"$[0]"                                                                                                 
*/

### JSON_VALUE(json_doc, path [RETURNING type] [on_empty] [on_error])
SELECT JSON_VALUE('{"fname":"Joe", "lname":"Palmer"}', '$.fname');
/*
json_value('{"fname":"Joe", "lname":"Palmer"}', '$.fname')  
------------------------------------------------------------
Joe                                                         
*/

SELECT JSON_VALUE('{"item":"shoes", "price":"49.9502"}', '$.price' RETURNING DECIMAL(4,2)) AS 'price';
/*
 price  
--------
   49.95
*/

-- JSON_VALUE() 简化在JSON列上创建索引过程
-- t1、t2表 两表创建的索引效果相当.
CREATE TABLE t1(
    j JSON,
    INDEX i1 ( (JSON_VALUE(j, '$.id' RETURNING UNSIGNED)) )
);

EXPLAIN SELECT * FROM t1 WHERE JSON_VALUE(j, '$.id' RETURNING UNSIGNED) = 123;
/*
    id  select_type  table   partitions  type    possible_keys  key     key_len  ref       rows  filtered  Extra   
------  -----------  ------  ----------  ------  -------------  ------  -------  ------  ------  --------  --------
     1  SIMPLE       t1      (NULL)      ref     i1             i1      9        const        1    100.00  (NULL)  
                                                                                                                   
*/

CREATE TABLE t2 (
    j JSON,
    g INT GENERATED ALWAYS AS (j->"$.id"),
    INDEX i1 (g)
);

EXPLAIN SELECT * FROM t2 WHERE g  = 123;
/*
    id  select_type  table   partitions  type    possible_keys  key     key_len  ref       rows  filtered  Extra   
------  -----------  ------  ----------  ------  -------------  ------  -------  ------  ------  --------  --------
     1  SIMPLE       t2      (NULL)      ref     i1             i1      5        const        1    100.00  (NULL)  
*/


### value MEMBER OF(json_array)
SELECT 17 MEMBER OF('[23, "abc", 17, "ab", 10]');
/*
17 member of('[23, "abc", 17, "ab", 10]')  
-------------------------------------------
                                          1
*/

SELECT 'ab' MEMBER OF('[23, "abc", 17, "ab", 10]');
/*
'ab' member of('[23, "abc", 17, "ab", 10]')  
---------------------------------------------
                                            1
*/

-- 部分匹配不算匹配
SELECT 7 MEMBER OF('[23, "abc", 17, "ab", 10]');
/*
7 member of('[23, "abc", 17, "ab", 10]')  
------------------------------------------
                                         0
*/

SELECT 'a' MEMBER OF('[23, "abc", 17, "ab", 10]');
/*
'a' MEMBER OF('[23, "abc", 17, "ab", 10]')  
--------------------------------------------
                                           0
*/

-- 不执行字符串自动转数字
SELECT 17 MEMBER OF('[23, "abc", "17", "ab", 10]'), 
"17" MEMBER OF('[23, "abc", 17, "ab", 10]');
/*
17 MEMBER OF('[23, "abc", "17", "ab", 10]')  "17" MEMBER OF('[23, "abc", 17, "ab", 10]')  
-------------------------------------------  ---------------------------------------------
                                          0                                              0
*/

SELECT CAST('[4, 5]' AS JSON) MEMBER OF('[[3, 4], [4, 5]]');
/*
cast('[4, 5]' as json) member of('[[3, 4], [4, 5]]')  
------------------------------------------------------
                                                     1
*/

SELECT JSON_ARRAY(4, 5) MEMBER OF('[[3, 4], [4, 5]]');
/*
Json_ARRAY(4, 5) member of('[[3, 4], [4, 5]]')  
------------------------------------------------
                                               1
*/



## Functions That Search JSON Values  --end


## Functions That Modify JSON Values  --start
### JSON_ARRAY_APPEND()
SELECT c FROM jemp WHERE g = 38;
/*
c                              
-------------------------------
[3, 10, 5, 17, [22, "y", 66]]  
*/


SELECT JSON_ARRAY_APPEND(c, "$[4]", 99) FROM jemp
WHERE g = 38;
/*
JSON_ARRAY_APPEND(c, "$[4]", 99)   
-----------------------------------
[3, 10, 5, 17, [22, "y", 66, 99]]  
*/

-- 更新JSON数组值
UPDATE jemp SET c = JSON_ARRAY_APPEND(c, "$[4]", 99) WHERE g = 38;

SELECT JSON_ARRAY_APPEND(c, "$[0]", 518) FROM jemp
WHERE g = 38;
/*
JSON_ARRAY_APPEND(c, "$[0]", 518)     
--------------------------------------
[[3, 518], 10, 5, 17, [22, "y", 66]]  
*/

SELECT JSON_ARRAY_APPEND(c->"$[4]", "$[1]", 88) FROM jemp WHERE g = 38;
SELECT JSON_ARRAY_APPEND(c->>"$[4]", "$[1]", 88) FROM jemp WHERE g = 38;
-- 上面两个SQL，查询结果都相同
/*
JSON_ARRAY_APPEND(c->"$[4]", "$[1]", 88)  
------------------------------------------
[22, ["y", 88], 66, 99]                   
*/

SELECT JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1]", 1);
/*
JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1]", 1)  
--------------------------------------------------------
["a", ["b", "c", 1], "d"]    
*/

SELECT JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[0]", 2);
/*
JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[0]", 2)  
--------------------------------------------------------
[["a", 2], ["b", "c"], "d"]   
*/

SELECT JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1][0]", 3);
/*
JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1][0]", 3)  
-----------------------------------------------------------
["a", [["b", 3], "c"], "d"]                                
*/

SELECT JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.b", 'x');
/*
JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.b", 'x')  
----------------------------------------------------------------
{"a": 1, "b": [2, 3, "x"], "c": 4}                              
*/

SELECT JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.c", 'yy');
/*
JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.c", 'yy')  
-----------------------------------------------------------------
{"a": 1, "b": [2, 3], "c": [4, "yy"]}                            
*/

SELECT JSON_ARRAY_APPEND('{"a": 1}', '$', 'z');
/*
JSON_ARRAY_APPEND('{"a": 1}', '$', 'z')  
-----------------------------------------
[{"a": 1}, "z"]                          
*/

-- 多个path-value对 JSON_ARRAY_APPEND操作
SELECT JSON_ARRAY_APPEND('[11, 22, 33, 44]', '$[0]', 66, '$[2]', 77);
/*
JSON_ARRAY_APPEND('[11, 22, 33, 44]', '$[0]', 66, '$[2]', 77)  
---------------------------------------------------------------
[[11, 66], 22, [33, 77], 44]                                   
*/

### JSON_ARRAY_INSERT()

SELECT c FROM jemp WHERE g = 36;
/*
c                                                                                
---------------------------------------------------------------------------------
{"code": 0, "data": [{"ip": "172.17.0.3", "hostname": "webserv2"}, 44, 55, 66]}  
*/

-- 在c["data"]数组的第三个位子插入777
SELECT JSON_ARRAY_INSERT(c, "$.data[2]", 777) FROM jemp WHERE g = 36;
/*
JSON_ARRAY_INSERT(c, "$.data[2]", 777)                                                
--------------------------------------------------------------------------------------
{"code": 0, "data": [{"ip": "172.17.0.3", "hostname": "webserv2"}, 44, 777, 55, 66]}  
*/

UPDATE jemp SET c = JSON_ARRAY_INSERT(c, "$.data[2]", 777)
WHERE g = 36;

SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1]', 'x');
/*
JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1]', 'x')  
----------------------------------------------------------------
["a", "x", {"b": [1, 2]}, [3, 4]]                               
*/

-- 下标越界，直接插到数组的最后
SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[100]', 'x');
/*
JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[100]', 'x')  
------------------------------------------------------------------
["a", {"b": [1, 2]}, [3, 4], "x"]                                 
*/

SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1].b[0]', 'x');
/*
JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1].b[0]', 'x')  
---------------------------------------------------------------------
["a", {"b": ["x", 1, 2]}, [3, 4]]                                    
*/

-- 插入多个path-value对时，其执行过程从左到右，一对一对path-value来插入的，前一对path-value求值返回的结果作为后一对path-value求值的json_doc
SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[0]', 'x', '$[2][1]', 'y');
/*
JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[0]', 'x', '$[2][1]', 'y')  
--------------------------------------------------------------------------------
["x", "a", {"b": [1, 2]}, [3, 4]]                                               
*/

SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[2][1]', 'y', '$[0]', 'x');
-- 上面的写法与下面的等价
SELECT JSON_ARRAY_INSERT(
        (SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[2][1]', 'y')), 
        '$[0]', 
        'x'
    );
/*
JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[2][1]', 'y', '$[0]', 'x')  
--------------------------------------------------------------------------------
["x", "a", {"b": [1, 2]}, [3, "y", 4]]                                          
*/


### JSON_INSERT()
SELECT c FROM jemp WHERE g = 36;
/*
{"code": 0, "data": [{"ip": "172.17.0.3", "hostname": "webserv2"}, 44, 777, 55, 66]}  
*/

-- c["data[0]"] 添加网关key-value对，key: gateway, value: "172.17.0.1"
UPDATE jemp SET c = JSON_INSERT(c, '$.data[0].gateway', '172.17.0.1')
WHERE g = 36;


SELECT JSON_INSERT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', '[true, false]');
/*
JSON_INSERT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', '[true, false]')  
--------------------------------------------------------------------------
{"a": 1, "b": [2, 3], "c": "[true, false]"}                               

-- 因为 '$.a' path已经存在，所以JSON_INSERT操作忽略。
-- '$.c' path不存在，所以JSON_INSERT操作执行成功
*/

SELECT JSON_INSERT( '{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', CAST('[true, false]' AS JSON) );
/*
JSON_INSERT( '{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', CAST('[true, false]' as JSON) )  
------------------------------------------------------------------------------------------
{"a": 1, "b": [2, 3], "c": [true, false]}                                                 
*/

-- JSON数组的插入
SELECT JSON_INSERT('[11, 22, 33]', '$[100]', 99);
/*
JSON_INSERT('[11, 22, 33]', '$[100]', 99)  
-------------------------------------------
[11, 22, 33, 99]                           
*/

### JSON_REPLACE()
SELECT c FROM jemp WHERE g = 1;
/*
c                          
---------------------------
{"id": 1, "name": "Niki"}  
*/

-- 更新name Niki为Nicki
UPDATE jemp SET c = JSON_REPLACE(c, '$.name', 'Nicki');

SELECT JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
/*
JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
--------------------------------------------------------------
{"a": 10, "b": [2, 3]}                                        
*/

### JSON_SET()
SELECT JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
/*
JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
----------------------------------------------------------
{"a": 10, "b": [2, 3], "c": 66}                           
*/


### JSON_INSERT(), JSON_REPLACE(), JSON_SET()的对比
SELECT JSON_INSERT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
/*
JSON_INSErT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
-------------------------------------------------------------
{"a": 1, "b": [2, 3], "c": 66}                               
*/

SELECT JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
/*
JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
--------------------------------------------------------------
{"a": 10, "b": [2, 3]}                                        
*/

-- JSON_SET() 相当于是JSON_INSERT()和JSON_REPLACE() 的合并版
SELECT JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
/*
JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
----------------------------------------------------------
{"a": 10, "b": [2, 3], "c": 66}                           
*/


### JSON_UNQUOTE()
SELECT JSON_UNQUOTE('"abc"');
/*
JSON_UNQUOTE('"abc"')  
-----------------------
abc                    
*/

SELECT JSON_UNQUOTE('[1, 2, 3]');
/*
JSON_UNQUOTE('[1, 2, 3]')  
---------------------------
[1, 2, 3]                  
*/

### JSON_REMOVE()
-- 删除 g=35的 code key-value
SELECT c FROM jemp WHERE g = 35;
/*
c                                                                                
---------------------------------------------------------------------------------
{"code": 0, "data": [{"ip": "172.17.0.2", "hostname": "webserv1"}, 11, 22, 33]}  
*/

UPDATE jemp SET c = JSON_REMOVE(c, '$.code');


SELECT JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]');
/*
JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]')  
-----------------------------------------------
["a", "d"]                                     
*/
SELECT JSON_REMOVE('["a", ["b", "c"], "d"]', '$[0]', '$[1][0]');
/*
JSON_REMOVE('["a", ["b", "c"], "d"]', '$[0]', '$[1][0]')  
----------------------------------------------------------
[["b", "c"]]                                              
*/


### JSON_MERGE()
SELECT JSON_MERGE('[1, 2]', '[true, false]');
/*
JSON_MERGE('[1, 2]', '[true, false]')  
---------------------------------------
[1, 2, true, false]                    
*/

SELECT JSON_MERGE('{"k1":11, "k2":22}', '{"k1":33, "k2":44}');
/*
JSON_MERGE('{"k1":11, "k2":22}', '{"k1":33, "k2":44}')  
--------------------------------------------------------
{"k1": [11, 33], "k2": [22, 44]}                        
*/

### JSON_MERGE_PATH()
SELECT JSON_MERGE_PATCH('[1, 2]', '[true, false]');
/*
JSON_MERGE_PATCH('[1, 2]', '[true, false]')  
---------------------------------------------
[true, false]                                
*/

SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}');
/*
JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}')  
-------------------------------------------------
{"id": 47, "name": "x"}                          
*/

SELECT JSON_MERGE_PATCH('1', 'true');
/*
JSON_MERGE_PATCH('1', 'true')  
-------------------------------
true                         
*/

-- JSON对象、JSON数组 进行JSON_MERGE_PATCH()操作，第二参数直接覆盖第一个参数
SELECT JSON_MERGE_PATCH('[1, 2]', '{"id": 47}');
/*
JSON_MERGE_PATCH('[1, 2]', '{"id": 47}')  
------------------------------------------
{"id": 47}                                
*/

SELECT JSON_MERGE_PATCH('{"id": 47}', '[1, 2]');
/*
JSON_MERGE_PATCH('{"id": 47}', '[1, 2]')  
------------------------------------------
[1, 2]                                    
*/

SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "c":4}');
/*
JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "c":4}')  
------------------------------------------------------
{"a": 3, "b": 2, "c": 4}                              
*/

-- 多个json_doc合并
SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "b":4}', '{"a":5, "d":6}');
/*
JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "b":4}', '{"a":5, "d":6}')  
------------------------------------------------------------------------
{"a": 5, "b": 4, "d": 6}                                                
*/

SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"b":null}');
/*
json_merge_patch('{"a":1, "b":2}', '{"b":null}')  
--------------------------------------------------
{"a": 1}                                          
*/

SELECT JSON_MERGE_PATCH('{"a":{"x":1}}', '{"a":{"y":2}}');
/*
json_merge_patch('{"a":{"x":1}}', '{"a":{"y":2}}')  
----------------------------------------------------
{"a": {"x": 1, "y": 2}}                             
*/


### JSON_MERGE_PRESERVE()
SELECT JSON_MERGE_PRESERVE('[1, 2]', '[true, false]');
/*
JSON_MERGE_PREserve('[1, 2]', '[true, false]')  
------------------------------------------------
[1, 2, true, false]                             
*/

SELECT JSON_MERGE_PRESERVE('{"name":"x"}', '{"id":47}');
/*
json_merge_preserve('{"name":"x"}', '{"id":47}')  
--------------------------------------------------
{"id": 47, "name": "x"}                           
*/

-- 标量值 JSON_MERGE_PRESERVE()操作，会合并为 json数组
SELECT JSON_MERGE_PRESERVE("1", "true");
/*
json_merge_preserve("1", "true")  
----------------------------------
[1, true]                         
*/

SELECT JSON_MERGE_PRESERVE('[1, 2]', '{"id":47}');
/*
json_merge_preserve('[1, 2]', '{"id":47}')  
--------------------------------------------
[1, 2, {"id": 47}]                          
*/

SELECT JSON_MERGE_PRESERVE('{"id":47}', '[1, 2]');
/*
json_merge_preserve('{"id":47}', '[1, 2]')  
--------------------------------------------
[{"id": 47}, 1, 2]                          
*/

SELECT JSON_MERGE_PRESERVE('{"a":1, "b":2}', '{"a":3, "c":4}');
/*
json_merge_preserve('{"a":1, "b":2}', '{"a":3, "c":4}')  
---------------------------------------------------------
{"a": [1, 3], "b": 2, "c": 4}                            
*/

SELECT JSON_MERGE_PRESERVE('[1, 2]', '[true, false]', '[33, 44]');
/*
JSON_MERGE_PRESERVE('[1, 2]', '[true, false]', '[33, 44]')  
------------------------------------------------------------
[1, 2, true, false, 33, 44]                                 
*/

### JSON_MERGE_PATCH() 对比 JSON_MERGER_PRESERVE()
SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "c":4}', '{"a":5, "b":6}') AS 'Patch',
JSON_MERGE_PRESERVE('{"a":1, "b":2}', '{"a":3, "c":4}', '{"a":5, "b":6}') AS 'Preserve';
/*
Patch                     Preserve                               
------------------------  ---------------------------------------
{"a": 5, "b": 6, "c": 4}  {"a": [1, 3, 5], "b": [2, 6], "c": 4}  
*/



## Functions That Modify JSON Values  --end



## Functions That Return JSON Value Attributes  --start
### JSON_DEPTH(json_doc)
SELECT JSON_DEPTH('[]'), JSON_DEPTH('{}'), JSON_DEPTH('11');
/*
json_depth('[]')  json_depth('{}')  json_depth('11')  
----------------  ----------------  ------------------
               1                 1                   1
*/

SELECT JSON_DEPTH('hello world');
/*
错误代码： 3141
Invalid JSON text in argument 1 to function json_depth: "Invalid value." at position 0.
*/

SELECT JSON_DEPTH('[10, 20]'), JSON_DEPTH('[[], {}]');
/*
json_depth('[10, 20]')  json_depth('[[], {}]')  
----------------------  ------------------------
                     2                         2
*/

SELECT JSON_DEPTH('[10, {"a":20}]');
/*
json_depth('[10, {"a":20}]')  
------------------------------
                             3
*/

### JSON_LENGTH(json_doc[, path])
SELECT JSON_LENGTH('[1, 2, {"a":3}]');
/*
json_length('[1, 2, {"a":3}]')  
--------------------------------
                               3
*/

SELECT JSON_LENGTH('{"a":1, "b":{"c":30}}');
/*
json_length('{"a":1, "b":{"c":30}}')  
--------------------------------------
                                     2
*/

-- 获取json_doc指定path处的值的长度
SELECT JSON_LENGTH('{"a":1, "b":{"c":30}}', '$.b');
/*
JSON_LENGTH('{"a":1, "b":{"c":30}}', '$.b')  
---------------------------------------------
                                            1
*/

### JSON_TYPE(json_val)
SELECT JSON_TYPE('{"a":[10, true]}');
/*
json_type('{"a":[10, true]}')  
-------------------------------
OBJECT                         
*/

SELECT JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a'));
/*
json_type(json_extract('{"a":[10, true]}', '$.a'))  
----------------------------------------------------
ARRAY                                               
*/

SELECT JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[0]'));
/*
JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[0]'))  
-------------------------------------------------------
INTEGER                                                
*/

SELECT JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[1]'));
/*
JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[1]'))  
-------------------------------------------------------
BOOLEAN                                                
*/

SELECT JSON_TYPE(NULL);
/*
json_type(NULL)  
---------------
NULL
*/

SELECT JSON_TYPE(10);
/*
错误代码： 3146
Invalid data type for JSON data in argument 1 to function json_type; a JSON string or JSON type is required.
*/

### JSON_VALID(val)
SELECT JSON_VALID('{"a":1}');
/*
json_valid('{"a":1}')  
-----------------------
                      1
*/

SELECT JSON_VALID('hello'), JSON_VALID('"hello"');
/*
json_valid('hello')  json_valid('"hello"')  
-------------------  -----------------------
                  0                        1
*/

## Functions That Return JSON Value Attributes  --end

## JSON Table Functions  --start
### JSON_TABLE()
SELECT * FROM 
JSON_TABLE(
    '[{"c1": null}]',
    '$[*]' COLUMNS (c1 INT PATH '$.c1' ERROR ON ERROR)
) AS jt;
/*
    c1  
--------
  (NULL)
*/

SELECT * FROM 
JSON_TABLE(
    '[{"a":3}, {"a":2}, {"b":1}, {"a":0}, {"a":[1, 2]}]',
    '$[*]' COLUMNS(
        rowid FOR ORDINALITY,
        ac VARCHAR(100) PATH '$.a' 
            DEFAULT '111' ON EMPTY 
            DEFAULT '999' ON ERROR,
        aj JSON PATH '$.a'
            DEFAULT '{"x":333}' ON EMPTY,
        bx INT EXISTS PATH '$.b'
    )
) AS tt;
/*
 rowid  ac      aj              bx  
------  ------  ----------  --------
     1  3       3                  0
     2  2       2                  0
     3  111     {"x": 333}         1
     4  0       0                  0
     5  999     [1, 2]             0
*/

SELECT * FROM 
JSON_TABLE(
    '[{"x":2, "y":"8"}, {"x":"3", "y":"7"}, {"x":"4", "y":6}]',
    '$[*]' COLUMNS(
        xval VARCHAR(100) PATH "$.x",
        yval VARCHAR(100) PATH "$.y"
    )
) AS jt1;
/*
xval    yval    
------  --------
2       8       
3       7       
4       6       
*/

SELECT * FROM 
JSON_TABLE(
    '[{"x":2, "y":"8"}, {"x":"3", "y":"7"}, {"x":"4", "y":6}]',
    '$[1]' COLUMNS(
        xval VARCHAR(100) PATH "$.x",
        yval VARCHAR(100) PATH "$.y"
    )
) AS jt1;
/*
xval    yval    
------  --------
3       7       
*/

-- NESTED嵌套
SELECT * FROM 
JSON_TABLE(
    '[{"a":1, "b":[11, 111]}, {"a":2, "b":[22, 222]}, {"a":3}]',
    '$[*]' COLUMNS(
        a INT PATH '$.a',
        NESTED PATH '$.b[*]' COLUMNS(
            b INT PATH '$'
        )
    )
) AS jt
WHERE b IS NOT NULL
;
/*
     a       b  
------  --------
     1        11
     1       111
     2        22
     2       222
*/

SELECT * FROM 
JSON_TABLE(
    '[{"a":1, "b":[11, 111]}, {"a":2, "b":[22, 222]}]',
    '$[*]' COLUMNS(
        a INT PATH '$.a',
        NESTED PATH '$.b[*]' COLUMNS(
            b1 INT PATH '$'
        ),
        NESTED PATH '$.b[*]' COLUMNS(
            b2 INT PATH '$'
        )
    )
) AS jt;
/*
     a      b1      b2  
------  ------  --------
     1      11    (NULL)
     1     111    (NULL)
     1  (NULL)        11
     1  (NULL)       111
     2      22    (NULL)
     2     222    (NULL)
     2  (NULL)        22
     2  (NULL)       222
*/

SELECT * FROM 
JSON_TABLE(
    '[
        {
            "a":"a_val", 
            "b":[{"c":"c_val", "d":[1,2]}]
        },
        {
            "a":"a_val", 
            "b":[
                {"c":"c_val", "d":[11]}, 
                {"c":"c_val", "d":[22]}
            ]
        }
    ]',
    '$[*]' COLUMNS(
        top_ord FOR ORDINALITY,
        apath VARCHAR(10) PATH '$.a',
        NESTED PATH '$.b[*]' COLUMNS(
            bpath VARCHAR(10) PATH '$.c',
            `ord` FOR ORDINALITY,
            NESTED PATH '$.d[*]' COLUMNS(
                lpath VARCHAR(10) PATH '$'
            )
        )
    )
) AS jt;
/*
top_ord  apath   bpath      ord  lpath   
-------  ------  ------  ------  --------
      1  a_val   c_val        1  1       
      1  a_val   c_val        1  2       
      2  a_val   c_val        1  11      
      2  a_val   c_val        2  22      
*/


## JSON Table Functions  --end

## JSON Schema Validation Functions  --start
### JSON_SCHEMA_VALID()
SELECT JSON_SCHEMA_VALID(
    '{
        "id": "http://json-schema.org/geo",
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "A geographical coordinate",
        "type": "object",
        "properties": {
            "latitude": {
                "type": "number",
                "minimum": -90,
                "maximum": 90
            },
            "longitude": {
                "type": "number",
                "minimum": -180,
                "maximum": 180
            }
        },
        "required": ["latitude", "longitude"]
    }',
    '{"latitude":63.444697, "longitude":10.445118}'
) AS is_scheme_valid;
/*
is_scheme_valid  
-----------------
                1
*/

SELECT JSON_SCHEMA_VALID(
    '{
        "id": "http://json-schema.org/geo",
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "A geographical coordinate",
        "type": "object",
        "properties": {
            "latitude": {
                "type": "number",
                "minimum": -90,
                "maximum": 90
            },
            "longitude": {
                "type": "number",
                "minimum": -180,
                "maximum": 180
            }
        },
        "required": ["latitude", "longitude"]
    }',
    '{}'
) AS is_scheme_valid;
/*
is_scheme_valid  
-----------------
                0
*/

SELECT JSON_SCHEMA_VALID(
    '{
        "id": "http://json-schema.org/geo",
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "A geographical coordinate",
        "type": "object",
        "properties": {
            "latitude": {
                "type": "number",
                "minimum": -90,
                "maximum": 90
            },
            "longitude": {
                "type": "number",
                "minimum": -180,
                "maximum": 180
            }
        }
    }',
    '{}'
) AS is_scheme_valid;
/*
is_scheme_valid  
-----------------
                1
*/

-- 当值类型为string时，schema支持正常表达式
SELECT JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"abcd"');
/*
JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"abcd"')  
--------------------------------------------------------------------
                                                                   1
*/

SELECT JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"aecd"');
/*
JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"aecd"')  
--------------------------------------------------------------------
                                                                   0
*/

-- JSON_SCHEMA_VALID()用于强制执行check约束
CREATE TABLE geo (
    coordinate JSON,
    CHECK(
        JSON_SCHEMA_VALID(
            '{
                "type": "object",
                "properties": {
                    "latitude":{"type":"number", "minimum":-90, "maximum":90},
                    "longitude":{"type":"number", "minimum":-180, "maximum":180}
                },
                "required": ["latitude", "longitude"]
            }',
            coordinate
        )
    )
);

INSERT INTO geo VALUES('{"latitude":59, "longitude":18}');
INSERT INTO geo VALUES('{"latitude":91, "longitude":0}');
/*
错误代码： 3819
Check constraint 'geo_chk_1' is violated.
*/
INSERT INTO geo VALUES('{"longitude":120}');
/*
错误代码： 3819
Check constraint 'geo_chk_1' is violated.
*/

### JSON_SCHEMA_VALIDATION_REPORT(schema, document)
SELECT JSON_SCHEMA_VALIDATION_REPORT(
    '{
        "id": "http://json-schema.org/geo",
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "A geographical coordinate",
        "type": "object",
        "properties": {
            "latitude": {
                "type": "number",
                "minimum": -90,
                "maximum": 90
            },
            "longitude": {
                "type": "number",
                "minimum": -180,
                "maximum": 180
            }
        },
        "required": ["latitude", "longitude"]
    }',
    '{"latitude":63.444697, "longitude":10.445118}'
) AS 'report';
/*
report           
-----------------
{"valid": true}  
*/

SELECT JSON_PRETTY(JSON_SCHEMA_VALIDATION_REPORT(
    '{
        "id": "http://json-schema.org/geo",
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "A geographical coordinate",
        "type": "object",
        "properties": {
            "latitude": {
                "type": "number",
                "minimum": -90,
                "maximum": 90
            },
            "longitude": {
                "type": "number",
                "minimum": -180,
                "maximum": 180
            }
        },
        "required": ["latitude", "longitude"]
    }',
    '{"latitude":63.444697, "longitude":310}'
) ) AS "report";
/*
report                                                                                                                                                    --------------------------------------------------------------------------------------------------------------------------------------
{
  "valid": false,   
  "reason": "The JSON document location '#/longitude' failed requirement 'maximum' at JSON Schema location  '#/properties/longitude'",
  "schema-location": "#/properties/longitude",
  "document-location": "#/longitude",
  "schema-failed-keyword": "maximum"
*/

## JSON Schema Validation Functions  --end

## JSON Utility Functions  --start
### JSON_PRETTY(json_val)
SELECT JSON_PRETTY('{"k1":11, "k2":22}');
/*
json_pretty('{"k1":11, "k2":22}')  
-----------------------------------
{                                  
  "k1": 11,                        
  "k2": 22                         
}     
*/

### JSON_STORAGE_FREE(json_val)
CREATE TABLE jtable (jcol JSON);
INSERT INTO jtable VALUES
('{"a":10, "b":"wxyz", "c":"[true, false]"}');

SELECT JSON_STORAGE_FREE(jcol) FROM jtable;
/*
JSON_STORAGE_FREE(jcol)  
-------------------------
                        0
*/

UPDATE jtable SET jcol = JSON_SET(jcol, "$.a", 10, "$.b", "wxyz", "$.c", 1);
SELECT JSON_STORAGE_FREE(jcol) FROM jtable;
/*
JSON_STORAGE_FREE(jcol)  
-------------------------
                       14
*/

### JSON_STORAGE_SIZE(json_val)
SELECT JSON_STORAGE_SIZE('{"a":1000, "b":"wxyz", "c":"[1, 3, 5, 7]"}') AS 'size';
/*
  size  
--------
      47
*/

SELECT jcol, JSON_STORAGE_SIZE(jcol) AS Size, JSON_STORAGE_FREE(jcol) AS Free 
FROM jtable;
/*
jcol                              Size    Free  
------------------------------  ------  --------
{"a": 10, "b": "wxyz", "c": 1}      48        14
*/

## JSON Utility Functions  --end


-- 字符转为JSON对象
SELECT CAST('[11, 22, 33]' AS JSON);
SELECT CAST('{"k1": 11, "k2": 22}' AS JSON);

-- 多个json组合成一个json
SELECT JSON_MERGE_PRESERVE('["a", 1]', '{"key": "value"}');

SELECT JSON_VALID('null'), JSON_VALID('Null'), JSON_VALID('NULL');


