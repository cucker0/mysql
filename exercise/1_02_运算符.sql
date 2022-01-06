# 2_02_运算符

## 算术运算符

-- 将有数值 与 字符运算，将字符串 当作0
SELECT 100 + 'a';  -- 100
SELECT 100 + 'ab';  -- 100

-- 将字符串形式的数字自动解析为数值，这时mysql的隐式转换
SELECT 100 + '8';  -- 108

-- 数值与NULL做运算，结果为NULL
SELECT 10 + NULL;  -- 结果为NULL

-- 被除数为0时，结果为NULL
SELECT 1 / 0;  -- NULL

## 比较运算符
SELECT 1 <=> 1, NULL <=> NULL, 1 <=> NULL;
/*
1 <=> 1  NULL <=> NULL  1 <=> NULL  
-------  -------------  ------------
      1              1             0
*/

SELECT 1 = 1, NULL = NULL, 1 = NULL;
/*
 1 = 1  NULL = NULL  1 = NULL  
------  -----------  ----------
     1       (NULL)      (NULL)
*/

SELECT (a, b) <=> (X, Y);
-- 等价于
SELECT (a <=> X) AND (b <=> Y);


## 逻辑运算符
-- AND, &&
SELECT 1 AND NULL;  -- NULL
SELECT 0 && NULL;  -- 0
SELECT NULL AND 0;  -- 0
SELECT 1 AND 1;  -- 1
SELECT 0 AND 1;  -- 0

-- OR, ||
SELECT 1 OR 1;  -- 1
SELECT 1 OR 0;  -- 1
SELECT 0 OR 0;  -- 0
SELECT 0 OR NULL;  -- NULL
SELECT 1 || NULL;  -- 1
SELECT NULL || 0;  -- NULL
SELECT NULL || 1;  -- 1

-- NOT, !
SELECT NOT NULL;  -- NULL

SELECT NOT TRUE;  -- 0
SELECT NOT FALSE;  -- 1
SELECT NOT 1;  -- 0

SELECT ! (1+1);  -- 0

SELECT ! 1+1; -- 1
-- 等价于
SELECT (!1) + 1;

-- XOR
SELECT 1 XOR 1;  -- 0
SELECT 0 XOR 1;  -- 1
SELECT NULL XOR 1;  -- NULL
SELECT 1 XOR NULL;  -- NULL
SELECT NULL XOR 0;  -- NULL

## 位运算符
SELECT 4 | 2;  -- 6

SELECT b'1010' & b'10';  -- 2
SELECT b'1010' | b'10';  -- 10

## 赋值运算符
-- :=
SELECT @var1 := 1, @var2;
SELECT @var1:=COUNT(*) FROM t1;  -- 4
SELECT @var1;  -- 4

-- =