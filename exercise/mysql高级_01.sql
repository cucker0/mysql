DECLARE a INT DEFAULT 10;

SELECT a;

SHOW GLOBAL VARIABLES LIKE 'max_connections';


SHOW TABLES;


DESC book;

CREATE UNIQUE INDEX idx_book_name_price ON book (`name`, price);

SHOW INDEX FROM book;

DROP INDEX idx_book_name_price ON book;

DROP INDEX idx_book_name_price ON book;


ALTER TABLE book ADD PRIMARY KEY (id);

ALTER TABLE book ADD UNIQUE INDEX idx_book_name (`name`);

ALTER TABLE book ADD INDEX idx_book_price (`name`, price);

ALTER TABLE book ADD FULLTEXT idx_book_content (content);



-- 创建区政图
CREATE DATABASE testdb;

USE testdb;

CREATE TABLE area_map (
    id INT PRIMARY KEY AUTO_INCREMENT,
    stat VARCHAR(32) NOT NULL,  -- 州/镇
    city VARCHAR(32),  -- 市
    province VARCHAR(20),  -- 省
    postcode INT  -- 邮编
);

DESC area_map;


INSERT INTO area_map (stat, city, province, postcode) VALUES
('aa镇', 'anqing市', 'anhui省', 246000),
('bb镇', 'anqing市', 'anhui省', 246100),
('cc镇', 'anqing市', 'anhui省', 246200),
('aa镇', 'bengbu市', 'anhui省', 233000),
('bb镇', 'bengbu市', 'anhui省', 233100),
('cc镇', 'bengbu市', 'anhui省', 233200),
('aa镇', 'chizhou市', 'anhui省', 247100),
('bb镇', 'chizhou市', 'anhui省', 247200),
('cc镇', 'chizhou市', 'anhui省', 247300),
('aa镇', 'changle市', 'fujian省', 350200),
('bb镇', 'changle市', 'fujian省', 350300),
('cc镇', 'changle市', 'fujian省', 350400),
('aa镇', 'fuzhou市', 'fujian省', 350000),
('bb镇', 'fuzhou市', 'fujian省', 350100),
('cc镇', 'fuzhou市', 'fujian省', 350200),
('aa镇', 'zhangzhou市', 'fujian省', 363000),
('bb镇', 'zhangzhou市', 'fujian省', 363000),
('cc镇', 'zhangzhou市', 'fujian省', 363000),
('aa镇', 'baiyin市', 'gansu省', 730100),
('bb镇', 'baiyin市', 'gansu省', 730200),
('cc镇', 'baiyin市', 'gansu省', 730300),
('aa镇', 'duhuang市', 'gansu省', 736200),
('bb镇', 'duhuang市', 'gansu省', 736300),
('cc镇', 'duhuang市', 'gansu省', 736400),
('aa镇', 'gannan州', 'gansu省', 747000),
('bb镇', 'gannan州', 'gansu省', 747100),
('cc镇', 'gannan州', 'gansu省', 747200);



SELECT province, city, stat, postcode
FROM area_map
ORDER BY province, city, stat;


-- explain分析sql语句
EXPLAIN
SELECT province, city, stat, postcode
FROM area_map
ORDER BY province, city, stat;





