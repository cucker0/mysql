-- 流程控制经典案例


-- 题目
/*
article表结构如下:
CREATE TABLE article (
    id INT PRIMARY KEY AUTO_INCREMENT,
    content VARCHAR(20)
); 


向该表插入指定个数的记录，content为随机字符串

*/

USE test;

CREATE TABLE article (
    id INT PRIMARY KEY AUTO_INCREMENT,
    content VARCHAR(20)
); 

SELECT * FROM article;



DELIMITER $
DROP PROCEDURE IF EXISTS custom_insert$
CREATE PROCEDURE custom_insert(IN num INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    SET @str = 'abcdefghijklmnopqrstuvwxyz';
    WHILE i < num DO
        SET @len = CEIL(RAND() * 20); -- 获取随机长度
        SET @j = 1;
        SET @val = '';
        WHILE @j <= @len DO
            SET @r = SUBSTR(@str, CEIL(RAND() * 26), 1); -- 每次随机获取一个字母
            SET @val = CONCAT(@val, @r); -- 拼接
            SET @j = @j + 1;
        END WHILE;

        INSERT INTO article (content) VALUES (@val);
        SET i = i + 1;
    END WHILE;
    
END$

DELIMITER ;



CALL custom_insert(5);



