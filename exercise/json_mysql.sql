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
SELECT JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]');
/*
JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]')  
-----------------------------------------------
["a", "d"]                                     
*/


## Functions That Modify JSON Values  --end

-- 字符转为JSON对象
SELECT CAST('[11, 22, 33]' AS JSON);
SELECT CAST('{"k1": 11, "k2": 22}' AS JSON);

-- 多个json组合成一个json
SELECT JSON_MERGE_PRESERVE('["a", 1]', '{"key": "value"}');

SELECT JSON_VALID('null'), JSON_VALID('Null'), JSON_VALID('NULL');


