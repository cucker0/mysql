# 列出所有数据库
SHOW DATABASES;

# 切换到指定库
USE 库名

# 列出当前库的所有表
SHOW TABLES;

# 列出其他库的所有表
SHOW TABLES FROM 库名;

# 创建表
CREATE TABLES 表名 (
    id VARCHAR (32),
    age INT,
    NAME VARCHAR (30),
    birthday DATE,
    列名 列类型,
    列名 列类型,
    ...
);
    

# 查看mysql版本
-- 方式1，登入到mysql服务端
SELECT VERSION();

-- 方式2，未登入服务端
mysql --version
或
mysql -V

