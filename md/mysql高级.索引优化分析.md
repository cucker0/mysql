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

依次从左往右


## [7种join连接查询](./2_07_DQL数据查询语言.连接查询.md#连接查询总结)


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
    >索引列的值必须唯一，但允许有一个null值。唯一键会创建唯一索引
* 复合索引
    >一个索引包含多个列

### 索引类型
* BTree索引
* Hash索引
* FullText全文索引
* RTree索引

### 增查改删索引
* 创建索引
    ```text
    可以在创建表时创建，
    也可以表创建后，再创建索引
    ```
    ```text
    CREATE [UNIQUE | FULLTEXT | SPATIAL] INDEX index_name
        [index_type]
        ON tbl_name (key_part,...)
        [index_option]
        [algorithm_option | lock_option] ...
    
    #######################################################  
    ## 说明
    { }: 必填项
    [ ]: 选填项
    
    索引类别: [UNIQUE | FULLTEXT | SPATIAL]
        UNIQUE: 唯一索引
        FULLTEXT: 全文索引
        SPATIAL: 空间索引
    
    key_part: {col_name [(length)] | (expr)} [ASC | DESC]
        默认为ASC升序排序
        如果是CHAR,VARCHAR类型，length可以小于字段实际长度；
        如果是BLOB和TEXT类型，必须指定length
    
    index_option:
        KEY_BLOCK_SIZE [=] value
      | index_type
      | WITH PARSER parser_name
      | COMMENT 'string'
      | {VISIBLE | INVISIBLE}
    
    index_type:
        USING {BTREE | HASH}
        默认为BTREE
        
    algorithm_option:
        ALGORITHM [=] {DEFAULT | INPLACE | COPY}
    
    lock_option:
        LOCK [=] {DEFAULT | NONE | SHARED | EXCLUSIVE}
    
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
    DROP INDEX 索引名 ON 表名;
    或
    ALTER TABLE 表名 DROP INDEX 索引名;
    ```

### 需要创建索引情况
* 主键自动建立唯一索引
* 频繁作为查询条件的字段、经常排序的字段，该字段应该创建索引
* 查询中与其它表关联的字段，外键关系建立索引
* 在高并发下，倾向建复合索引
* 用于排序的字段
* 查询中用于统计、分组的字段
* 表数据行数300万以上，适合开始建索引

### 不适合建索引的情况
* 表行数不多，表行数<300万
* 频繁增删改的表
* 数据重复且分布比较平均的字段。如性别
    ```text
    字段的值重复率低的字段建索引效果更高
    ```


## mysql性能分析
* 内置的Optimizer优化器
    ```text
    mysql内置有Optimizer sql优化器，主要功能：通过计算分析系统中收集到的统计信息，
    为客户端请求的Query查询提供它认为最有的执行计划，但有时可能不是DBA认为最有的
    ```
* mysql常见瓶颈
    * CPU资源不足，持续使用过高，一般发生在数据载入内存或从磁盘读取数据时
    * IO过载，磁盘IO瓶颈发生在载入数据远大于内存容量时
    * 服务器硬件性能瓶颈：top, free, iostat，vmstat, dstat查看性能

### explain + sql语句 分析
```text
使用explain sql语句，可以模拟优化器执行sql语句，
从而知道mysql是如何解析优化该sql语句的，分析sql语句、结构，进而找出可能的瓶颈
```    

* explain的功能
    * 查看表的读取顺序
    * 查看数据操作的操作类型
    * 查看可用的索引
    * 查看实际使用的索引
    * 查看表之间的引用
    * 查看每张表有多少行被优化器查询了

* 使用方法
```text
explain sql语句;

再查看相关的信息
```

* 各字段含义


