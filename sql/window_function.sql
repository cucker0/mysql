-- 准备数据
CREATE DATABASE window_func;

USE window_func;

CREATE TABLE sales (
    `year` YEAR,
    country VARCHAR(32),
    product VARCHAR(32) NOT NULL,
    profit INT COMMENT '利润'
);

INSERT INTO sales (`year`, country, product, profit) VALUES
('2000', 'Finland', 'Computer', 1500),
('2000', 'Finland', 'Phone', 100),
('2000', 'India', 'Calculator', 75),
('2000', 'India', 'Calculator', 75),
('2000', 'India', 'Computer', 1200),
('2000', 'USA', 'Calculator', 75),
('2000', 'USA', 'Computer', 1500),
('2001', 'Finland', 'Phone', 10),
('2001', 'USA', 'Calculator', 50),
('2001', 'USA', 'Computer', 1500),
('2001', 'USA', 'Computer', 1200),
('2001', 'USA', 'TV', 150),
('2001', 'USA', 'TV', 100)
;


-- 容器操作演示2
CREATE TABLE sales2 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(16),
    country VARCHAR(16),
    sales_volume DECIMAL
);

INSERT INTO sales2 (city, country, sales_volume) VALUES
('北京', '海淀', 10.00),
('北京', '朝阳', 20.00),
('上海', '黄埔', 30.00),
('上海', '长宁', 10.00);

# 测试窗口函数
-- 准备数据
CREATE TABLE goods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    category VARCHAR(16),
    `name` VARCHAR(32),
    price DECIMAL(10, 2),
    stock INT,
    shelf_time DATETIME
);

INSERT INTO goods (category_id, category, `name`, price, stock, shelf_time) VALUES
(1, '女装/女士精品', 'T恤', 39.90, 1000, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '连衣裙', 79.90, 2500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '卫衣', 89.90, 1500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '牛仔裤', 89.90, 3500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '百褶裙', 29.90, 500, '2021-12-20 00:00:00'),
(1, '女装/女士精品', '呢绒外套', 399.90, 1200, '2021-12-20 00:00:00'),
(2, '户外运动', '自行车', 399.90, 1000, '2021-12-20 00:00:00'),
(2, '户外运动', '山地自行车', 1399.90, 2500, '2021-12-20 00:00:00'),
(2, '户外运动', '登山杖', 59.90, 1300, '2021-12-20 00:00:00'),
(2, '户外运动', '骑行装备', 399.90, 3500, '2021-12-20 00:00:00'),
(2, '户外运动', '运动外套', 799.90, 500, '2021-12-20 00:00:00'),
(2, '户外运动', '滑板', 499.90, 1200, '2021-12-20 00:00:00')
;