mysql高级.查询截取分析
==


## 查询优化
* 永远小表驱动大表，相当于让外层循环的次数更少
* 优化原则：小表驱动大表，即少的数据集驱动多的数据集

### 小表驱动大表示例
```mysql
-- 示例：A表、B表
CREATE TABLE A (
    id INT,
    cname VARCHAR(32)
);

CREATE TABLE B (
    id INT,
    score INT
);

ALTER TABLE A ADD INDEX idx_a_id (id);
ALTER TABLE B ADD INDEX idx_b_id (id);
```

* 用in优于exists情况
    ```sql
    SELECT * FROM A WHERE id IN (SELECT id FROM B)
    
    -- 等价于：
    FOR (SELECT id FROM B) {
        SELECT * FROM A WHERE A.id = B.id
    }
        
    /*
    当B表的数据集小于A表的数据集时，用in优于exists
    */
    ```

* 用exists优于in情况
    ```sql
    SELECT * FROM A WHERE EXISTS (SELECT 1 FROM B WHERE B.id = A.id)
    
    -- 等价于
    FOR (SELECT * FROM A) {
        SELECT 1 FROM B WHERE B.id = A.id
    }
    
    /*
    当A表的数据集小于B表的数据集时，用exists优于in
    
    注意：
    A表与B表的id字段应建立索引
    
    EXISTS子句理解：
    将主查询的数据，放到子查询中做条件验证，只保留验证结果为true的主数据
    */
    ```

### order by排序优化
* order by子句尽量使用index方式排序，避免使用filesort方式排序
* 尽可能在左营列上完成排序操作，满足索引最佳左前缀法则


### order by排序方式案例
```text
order by的两种排序方式：index、filesort
index效率 > filesort效率

因为
index: 只扫描索引完成排序 
filesort: 扫描表数据完成排序
```

* 表结构
    ```mysql
    CREATE TABLE taba (
        age INT,
        birth TIMESTAMP NOT NULL
    );
    
    
    INSERT INTO taba (age, birth) VALUES
    (22, NOW()),
    (23, NOW()),
    (24, NOW());
    
    -- 建立索引
    CREATE INDEX idx_taba_age_birth ON taba (age, birth);
    
    SHOW INDEX FROM taba;
    ```
* 情况1_0
    ```mysql
    -- 1_0
    EXPLAIN
    SELECT * FROM taba
    WHERE age = 20;
    ```
    ![](../images/order_by_1_0.png)  
    **观察与分析**  
    ```text
    用到了索引age一个字段
    ```
* 情况1_1
    ```mysql
    -- 1_1
    EXPLAIN
    SELECT * FROM taba 
    WHERE age > 20
    ORDER BY age;
    ```
    ![](../images/order_by_1_1.png)  
    **观察与分析**  
    ```text
    排序方式：
    Extra为
    用到了索引age,birth
    ```
* 情况1_2
    ```mysql
    -- 1_2
    EXPLAIN
    SELECT * FROM taba
    WHERE age > 20
    ORDER BY age, birth;
    ```
    ![](../images/order_by_1_2.png)  
    **观察与分析**  
    ```text
    排序方式：
    Extra为
    用到了索引age,birth
    ```
<span id = "order_by_1_3"></span>
* 情况1_3
    ```mysql
    -- 1_3
    EXPLAIN
    SELECT * FROM taba
    WHERE age > 20
    ORDER BY birth;
    ```
    ![](../images/order_by_1_3.png)  
    **观察与分析**  
    ```text
    排序方式：
    Extra为
    用到了索引age,birth
    ```
* 情况1_4
    ```mysql
    -- 1_4
    EXPLAIN
    SELECT * FROM taba
    WHERE age > 20
    ORDER BY birth, age;
    ```
    ![](../images/order_by_1_4.png)  
    **观察与分析**  
    ```text
    排序方式：
    Extra为
    用到了索引age,birth
    ```
* 情况2_1
    ```mysql
    -- 2_1
    EXPLAIN
    SELECT * FROM taba 
    ORDER BY birth;
    ```
    ![](../images/order_by_2_1.png)  
    **观察与分析**  
    ```text
    排序方式：index、filesort
    Extra为Using index; Using filesort
    用到了索引age,birth
    ```
* 情况2_2
    ```mysql
    -- 2_2
    EXPLAIN
    SELECT * FROM taba
    WHERE birth > '2019-11-06 00:00:00'
    ORDER BY birth;
    ```
    ![](../images/order_by_2_2.png)  
    **观察与分析**  
    ```text
    排序方式：index、filesort
    Extra为Using where; Using index; Using filesort
    用到了索引age,birth
    ```

* 情况2_3
    ```mysql
    -- 2_3
    EXPLAIN
    SELECT * FROM taba
    WHERE birth > '2019-11-06 00:00:00'
    ORDER BY age;
    ```
    ![](../images/order_by_2_3.png)  
    
    **观察与分析**  
    ```text
    排序方式：index
    Extra为Using where; Using index
    用到了索引age,birth
    ```
    [与1_3的比较，把where条件与order by字段调换](#order_by_1_3)  
    
* 情况2_4
    ```mysql
    -- 2_4
    EXPLAIN
    SELECT * FROM taba
    ORDER BY age ASC, birth DESC;
    ```
    ![](../images/order_by_2_4.png)  
    
    **观察与分析**  
    ```text
    排序方式同时使用了：index、filesort
    Extra为Using index; Using filesort
    用到了索引age,birth
    ①先用索引age排序(index)，在①基础上，再对birth读表数据排序(filesort)
    ```
    
#### 如何让order by使用index方式排序
```text
以下任意一种情况
```
* order by语句满足索引最佳左前缀法则(索引最左前列)
* 使用where子句与order by子句条件组合满足索引最佳左前缀法则



## 慢查询日志


## 指数据脚本


## show profiles


## 全局查询日志

