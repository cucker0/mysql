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












