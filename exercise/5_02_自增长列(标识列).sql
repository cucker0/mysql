-- 自增长列(标识列)



/*
功能：不用手动插入值，系统提供默认的序列值

关键字：AUTO_INCREMENT

可用alter table table_name AUTO_INCREMENT=n命令来重设自增的起始值，n从1开始

## 特点
* 标识列必须与主键搭配吗？ --不一定，但必须是一个key
* 一个表最多只能有一个标识列
* 标识列的类型只能是数值型的，可以是整型、浮点型。当类型为浮点型是当整型来处理序列值
* 默认的步长值、起始值都为1，是全局的变量
* 表示列可以通过 set auto auto_increment_increment = 步长值; 设置步长
    可以通过 手动插入值来设置起始值
* 设置为标识列的类自动添加了非null值约束
* 自动产生的自增序列值为正整数

*/


SHOW VARIABLES LIKE '%auto_increment%';

# 创建表示设置自增涨列(标识列)
CREATE TABLE tab_increment (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20),
    seat FLOAT
);

SHOW CREATE TABLE tab_increment;

INSERT INTO tab_increment VALUES 
(NULL, 'sary', 1.0),
(NULL, 'coco', 2.0),
(NULL, 'eliby', 1.0)
;

SELECT * FROM tab_increment;

INSERT INTO tab_increment (`name`, seat) VALUES 
('jency', 1.0),
('pooker', 2.0),
('marry', 1.0)


-- float类型的自增长列
CREATE TABLE tab_increment2 (
    id INT,
    `name` VARCHAR(20),
    seat FLOAT UNIQUE AUTO_INCREMENT
);

SHOW CREATE TABLE tab_increment2;

INSERT INTO  tab_increment2 (id, NAME) VALUES
(3, 'gogo'),
(4, 'bili'),
(5, 'kiki')
;
INSERT INTO  tab_increment2 VALUES (5, 'kiki', 5.2);
INSERT INTO  tab_increment2 VALUES (7, 'aa1', NULL);

SELECT * FROM tab_increment2;


-- 
CREATE TABLE tab_increment3 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cname VARCHAR(32)
);

SHOW CREATE TABLE tab_increment3;

INSERT INTO tab_increment3 VALUES (-10, 'dada');

SELECT * FROM tab_increment3;

INSERT INTO tab_increment3 VALUES (NULL, 'didi'); -- 1


DELETE FROM tab_increment3;
ALTER TABLE tab_increment3 AUTO_INCREMENT=1; -- 可设置AUTO_INCREMENT的=值







