mysql高级.索引优化分析
==


## 引入索引话题
### mysql性能下降、sql慢可能原因
* 查询语句写得烂
* 索引失效(单值索引、复合索引)
* 连接太多表进行查询
* 服务器、mysql参数设置不优(缓冲、线程数等)

### sql的执行顺序
![](../images/sql执行顺序.png)  

## 索引简介
```
索引(index)帮助mysql高效获取数据的数据结构。
索引是一种数据结构。

索引作用：给数据排好序、快速查找数据
索引可简单理解为：排好序的快速查找数据的数据结构

mysql索引一般使用的是Btree索引
```

* 索引优化
    ```text
    * 类似图书馆书目索引，提高数据检索效率，降低数据库的磁盘IO成本
  
    * 通过索引对数据进行排序，降低数据排序成本，降低了CPU的消耗，
        实际数据不动，通过索引与实际数据的映射
    ```

* 索引劣势
```text
* 索引也是一张表，该表保存了主键和索引字段，并指向了实体表的记录。索引需要占用磁盘空间
* 降低了更新表数据的速度，如insert、update、delete，因为索引也需要相应的进行更新
* 需要根据业务情况建立优秀的索引、优化SQL语句
```

### 索引分类
* 单值索引
    >一个索引只包含一个列，一个表可以有多个交单值索引
* 唯一索引
    >索引列的值必须唯一，但允许有一个null值
* 复合索引
    >一个索引包含多个列

### 增查删索引
* 创建索引
    ```text
    CREATE [UNIQUE] INDEX 索引名 ON 表名 (字段列表);
    
    UNIQUE: 唯一索引
    ```

    * alter方式
    ```text
    ALTER TABLE 表名 ADD PRIMARY KEY (column_list);
    
    ALTER TABLE 表名 ADD UNIQUE INDEX 索引名 (column_list);
    
    ALTER TABLE 表名 ADD INDEX 索引名 (column_list);
    
    ALTER TABLE 表名 ADD FULLTEXT 索引名 (column_list); -- 全文索引
    ```
* 查看索引
    ```text
    SHOW INDEX FROM 表名;
    ```
    
* 删除索引
    ```text
    DROP INDEX 索引名 ON book;
    ```



