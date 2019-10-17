-- 变量


/*
## 变量分类
* 系统标量
    * 全局变量(@@global.)
    * 会话变量(连接,@@session.)


* 自定义变量
    * 用户变量(@)
    * 局部变量

*/


-- 系统变量
-- 
/*
由系统定义的变量，属于服务器层面的
全局变量必须添加 global 关键字，
会话变量添加 session 关键字，省略不写为会话级别变量

*/


-- 全局变量
/*
作用域：所有连接会话，修改全局变量值，重启mysql服务后恢复默认值。持久改变需要修改配置文件

*/


# 查看所有的全局变量
SHOW GLOBAL VARIABLES;

# 通过关键字模糊过滤全局变量
SHOW GLOBAL VARIABLES LIKE '%sys%';

# 查看指定的系统全局变量
SELECT @@global.autocommit;

# 修改全局变量值
-- 语法1
SET @@global.autocommit = 0;

-- 语法2
SET GLOBAL autocommit = 1;


-- 会话
/*
作用域：当前连接会话

*/

# 查看所有的会话变量
SHOW SESSION VARIABLES;

SHOW VARIABLES;

# 通过关键字模糊过滤会话变量
SHOW SESSION VARIABLES LIKE '%dir%';

# 查看指定的系统会话变量
SELECT @@datadir;

SELECT @@session.transaction_isolation;

# 修改会话变量值
-- 语法1
SET @@transaction_isolation = 'read-uncommitted';
SELECT @@transaction_isolation;

-- 语法2
SET SESSION transaction_isolation = 'read-committed';


-- 自定义变量
-- 
/*
由用户定义的变量
作用域：当前连接会话

## 使用步骤
1. 声明且初始化
1. 赋值
1. 使用(查看、运算等)


## 用户变量

### 赋值操作符 = 和 :=

### 声明用户变量并初始化
SET @变量名 = 值;
SET @变量名 := 值;
SELECT @变量名 := 值;

### 赋值(更新变量值)
-- 语法1
SET @变量名 = 值;
SET @变量名 := 值;
SELECT @变量名 := 值;

-- 语法2
SELECT 字段 INTO @变量名 FROM 表名;

### 赋值
SELECT 字段 INTO @变量名
FROM 表名        


### 使用用户变量
SELECT @变量名


*/


## 局部变量
/*
作用域：声明、赋值、使用都在begin ... end块代码块内
*/


# 声明局部变量
DECLARE 变量名 类型; -- 是否有默认值?？

# 声明局部变量并初始化
DECLARE 变量名 类型 DEFAULT 值;


# 赋值(更新变量值)
-- 语法1
SET 变量名 = 值;
SET 变量名 := 值;
SELECT 变量名 := 值;

-- 语法2
SELECT 字段 INTO 局部变量名 FROM 表名;

# 使用局部变量
SELECT 局部变量名;


# 案例：声明两个变量，求和并打印
-- 用户变量
SET @x = 1;
SET @y = 6;
SET @z = @x + @y;
SELECT @z;


-- 局部变量
/*
局部变量若不指定初始化值，则值均为null
*/

CREATE 存储过程|函数 ...
BEGIN
    DECLARE m INT DEFAULT 10; 
    DECLARE n INT DEFAULT 20;
    DECLARE s INT; -- s 值为null
    SET s = m + n;
    SELECT s;
END



/*
## 用户变量、局部变量对比

变量类型    作用域                     定义位置                语法                                      
用户变量    当前会话                   会话的任何地方          @变量名，不用指定类型
局部变量    在begin ... and代码块中    在begin ... and代码块中 begin ... and的首行，不加@，需要指定类型


*/
