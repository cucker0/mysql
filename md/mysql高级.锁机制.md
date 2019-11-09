mysql高级.锁机制
==


## mysql锁定义
```text
锁是计算机协调多个进程或线程并发访问同一个资源的机制，防止对资源的争抢。
```

## 锁的分类
[LOCK TABLES、UNLOCK TABLES语法](https://dev.mysql.com/doc/refman/8.0/en/lock-tables.html)

### 从数据操作的类型分类
* 读锁(共享锁)
    ```text
    针对同一份数据，当前线程加了读锁，其他线程可以读取此数据，但不能写此数据
    ```

* 写锁(排它锁)
    ```text
    针对同一份数据，当前线程加了写锁，其他线程不能读、写此数据
    ```


### 从对数据操作的颗粒度分类
* 表锁
* 页锁
* 行锁

#### 表锁
```text
偏向MyISAM存储引擎，开销小，加锁快，无死锁，锁定粒度大，
发生锁冲突的概率最高，并发最低
```

#### 手动加表锁语法
```text
LOCK TABLES
    tbl_name [[AS] alias] lock_type
    [, tbl_name [[AS] alias] lock_type] ...

－－－－－
lock_type: {
    READ [LOCAL]
  | [LOW_PRIORITY] WRITE
}

常用：lock tables 表名1 read/write, 表名2  read/write;
```

#### 查看表上加过的锁
```mysql
SHOW OPEN TABLES [WHERE `database` = '库名'[ AND `table` = '表名']];
```

#### 释放表锁(所有表)
```mysql
unlock tables;
```

#### 表读锁案例
* 表结构
    ```mysql
    -- 表
    CREATE TABLE mylock (
        id INT PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(20)
    ) ENGINE MYISAM;
    
    INSERT INTO mylock (`name`) VALUES
    ('a'),
    ('b'),
    ('c'),
    ('d'),
    ('e'),
    ('f');
    
    SHOW CREATE TABLE mylock;
    
    SELECT * FROM mylock;
    ```

* 测试
```text
两个连接会话：session_1、session_2
```

case |session_1 |session_2 |备注
:--- |:--- |:--- |:--- 
session_1对mylock表加读锁，<br>此为表级锁 |lock table mylock read; <br>![][tread_0_s1_1] | | 
对当前定锁的表查询<br>当前锁定表:mylock |结论：<br>可查询 <br><br>![][tread_1_s1_1] |结论：<br>可查询 <br><br>![][tread_1_s2_1] | 
对其他未锁定表 |结论：<br>不能增、删、改、查 <br><br>![][tread_2_s1_1]|结论：<br>可查、增、改、删<br><br>![][tread_2_s2_1] <br><br>![][tread_2_s2_2] | 
对当前定锁的表更新 |结论：<br>不能增、改、删 <br><br>![][tread_3_s1_1] |结论：<br>增、改、删等更新操作将阻塞，直到该表锁被释放才能完成执行 <br><br>![][tread_3_s2_1] | 
释放当前锁定表的锁 |unlock tables; <br>![][tread_4_s1_1] |结论：<br>等到表锁释放后，才能被执行<br><br>![][tread_4_s2_1] |释放锁的操作<br>在任意的会话中执行都可以 

* MyISAM表读锁总结
    ```text
    当一个会话对表加了表级读锁，
    ## 当前会话
    对该表，只能进行查询操作，不能有更新操作(增删改)
    对其他表，不能进行任何操作(增删改查)
    
    ## 其他会话
    对该表，只能进行查询操作，更新操作(增删改等)会被阻塞，直到表锁被释放后才能被执行
    对其他表，可进行任何操作(增删改查)
    ```

#### 表写锁案例
* 测试
```text
两个连接会话：session_1、session_2
```

case |session_1 |session_2 |备注
:--- |:--- |:--- |:--- 
session_1对mylock表加写锁，<br>此为表级锁 |lock table mylock write; <br>![][twirte_s1_0] | | 
对其他表 |结论：<br>不能增、删、改、查等任何操作 <br><br>![][twirte_s1_1] |结论：<br>可增、删、改、查等任何操作 <br><br>![][twirte_s2_1] | 
对该表 |结论：<br>可增、删、改、查等任何操作 <br><br>![][twirte_s1_2] |结论：<br>任何操作都被会阻塞，直到表锁释放后，才能被执行 <br><br>![][twirte_s2_2] | 
释放当前锁定表的锁 |unlock tables;  <br>![][twirte_s1_3] |结论：等到表锁释放后，才能被执行<br>![][twirte_s2_3] | 


* MyISAM表写锁总结
    ```text
    当一个会话对表加了表级写锁，
    ## 当前会话
    对该表，可进行任何操作(增删改查)
    对其他表，不能进行任何操作(增删改查)
    
    ## 其他会话
    对该表，任何操作(增删改查)都会被阻塞，直到表锁被释放后才能被执行
    对其他表，可进行任何操作(增删改查)
    ```

***
<!--
定义URL变量
-->
[tread_0_s1_1]:../images/表读锁_0_s1_1.png
[tread_1_s1_1]:../images/表读锁_1_s1_1.png
[tread_1_s2_1]:../images/表读锁_1_s2_1.png
[tread_2_s1_1]:../images/表读锁_2_s1_1.png
[tread_2_s2_1]:../images/表读锁_2_s2_1.png
[tread_2_s2_2]:../images/表读锁_2_s2_2.png
[tread_3_s1_1]:../images/表读锁_3_s1_1.png
[tread_3_s2_1]:../images/表读锁_3_s2_1.png
[tread_4_s1_1]:../images/表读锁_4_s1_1.png
[tread_4_s2_1]:../images/表读锁_4_s2_1.png

[twirte_s1_0]:../images/表写锁_s1_0.png
[twirte_s1_1]:../images/表写锁_s1_1.png
[twirte_s1_2]:../images/表写锁_s1_2.png
[twirte_s1_3]:../images/表写锁_s1_3.png
[twirte_s2_1]:../images/表写锁_s2_1.png
[twirte_s2_2]:../images/表写锁_s2_2.png
[twirte_s2_3]:../images/表写锁_s2_3.png