-- json数组
SELECT JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME());  -- CURTIME() 当前时间
SELECT JSON_ARRAY('a', 1, NOW());  -- now() 当前日期时间

--  json对象
SELECT JSON_OBJECT('id', 87, 'name', 'carrot');

-- 双引号包裹字符串
SELECT JSON_QUOTE('null'), JSON_QUOTE('"null"');

SELECT JSON_QUOTE('[1, 2, 3]');

-- 字符转为JSON对象
SELECT CAST('[11, 22, 33]' AS JSON);
SELECT CAST('{"k1": 11, "k2": 22}' AS JSON);

-- 多个json组合成一个json
SELECT JSON_MERGE_PRESERVE('["a", 1]', '{"key": "value"}');

SELECT JSON_VALID('null'), JSON_VALID('Null'), JSON_VALID('NULL');







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


-- user table
CREATE TABLE employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    rest JSON COMMENT 'json类型的其它信息'
);

-- insert record
INSERT INTO employee(`name`, rest) VALUES
('Mally', '{"age":23, "gender":0, "salary": 56000, "positions": "cfo,ceo", "stock": 6000000}'),
('Jakob', '{"age":22, "gender":1, "salary": 80000, "positions": "Mathematics consultant,cfa", "stock": 96000000}'),
('Einstein', '{"age":21, "gender":1, "salary": 80000, "positions": "Security consultant,cfa"}')
;

SELECT * FROM employee;


SELECT 17 MEMBER OF('[23, "abc", 17, "ab", 10]');
