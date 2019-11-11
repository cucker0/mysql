mysql高级.Mysql_InnoDB引擎的行锁和表锁
==


## 简介
InnoDB与MyISAM的最大不同有两点：一是支持事务(transaction)；二是采用了行级锁  
[参考资料](https://blog.csdn.net/luzhensmart/article/details/81675527)

## 行锁和表锁
```text
在mysql的InnoDB引擎支持行锁，与Oracle不同，mysql的行锁是通过索引加载的，
要是对应的SQL语句没有走索引，则会全表扫描，

行锁则无法实现，取而代之的是表锁。
```

### 锁的一些概念
* 表锁：不会出现死锁，发生锁冲突几率高，并发低。
* 行锁：会出现死锁，发生锁冲突几率低，并发高。
* 锁冲突
    ```text
    例如说事务A将某几行上锁后，事务B又对其上锁，锁不能共存否则会出现锁冲突。
    （但是共享锁可以共存，共享锁和排它锁不能共存，排它锁和排他锁也不可以）
    ```
* 死锁
    ```text
    例如说两个事务，事务A锁住了1~5行，同时事务B锁住了6~10行，
    此时事务A请求锁住6~10行，就会阻塞直到事务B施放6~10行的锁，
    而随后事务B又请求锁住1~5行，事务B也阻塞直到事务A释放1~5行的锁。
    死锁发生时，会产生Deadlock错误。
    ```
    
### 行锁的类型
* 共享锁(读锁)
    ```text
    当一个事务对某几行加了读锁时，
    允许其他事务对这几行进行读操作，但不允许其进行写操作，
    也不允许其他事务给这几行加排它锁，但允许加读锁。
    ```
* 排它锁(写锁)
    ```text
    当一个事务对某几行加了写锁时，不允许其他事务写，但允许读；
    更不允许其他事务给这几行上任何锁，包括写锁
    ```

#### 加共享锁语法
```mysql
lock in share mode;

-- 示例
select  math from zje where math > 60 lock in share mode;

```

#### 加排它锁语法
```mysql
for update;

-- 示例
select math from zje where math > 60 for update;
```

### 行锁的实现
* 行锁必须有索引才能实现，否则会自动锁全表，那就是是表锁了
* 两个事务不能锁同一个索引
    ```mysql
    -- 事务A先执行：
    select math from zje where math>60 for update;
     
    -- 事务B再执行：
    select math from zje where math<60 for update;
    /*
    这样的话，事务B是会阻塞的。如果事务B把 math索引换成其他索引就不会阻塞，
    但注意，换成其他索引锁住的行不能和math索引锁住的行有重复。  
    */
    ```
* insert、delete、update在事务中都会自动默认加上排它锁
* 普通SELECT语句，InnoDB不会加任何锁


### 示例0
```text
由于InnoDB预设的是Row-Level Lock，所以只有「明确」的指定主键，MySQL才会执行Row lock (只锁住被选取的行) ，
否则MySQL将会执行Table Lock (将整个表给锁住)。

举个例子:
假设有个表单products，里面有id、name字段，id是主键。

注: FOR UPDATE仅适用于InnoDB，且必须在事务区块(BEGIN/COMMIT)中才能生效
```

* 例1: (明确指定主键，并且有此数据，row lock)
    ```mysql
    set autocommit = 0;
    begin;
    SELECT * FROM products WHERE id = '3' FOR UPDATE;
    commit;
    
    SELECT * FROM products WHERE id = '3' and type=1 FOR UPDATE;
    ```
* 例2: (明确指定主键，若查无此数据，无lock)
    ```mysql
    SELECT * FROM products WHERE id = '-1' FOR UPDATE;
    ```
* 例3: (无主键，table lock)
    ```mysql
    SELECT * FROM products WHERE name = 'Mouse' FOR UPDATE;
    ```
* 例4: (主键不明确，table lock)
    ```mysql
    SELECT * FROM products WHERE id <> '3' FOR UPDATE;
    ```
* 例5: (主键不明确，table lock)
    ```mysql
    SELECT * FROM products WHERE id LIKE '3' FOR UPDATE;
    ```


### 示例1
```text
假设kid 是表table 的 一个索引字段，且值不唯一
```
* 情况1：如果kid 有多个值为12的记录
    ```mysql
    update table  set name = 'feie' where kid=12;  
    -- 会锁表
    ```
* 情况2：如果kid有唯一的值为1的记录
    ```mysql
    update table  set name= 'feie' where kid=1;  
    -- 不会锁表
    ```
* 总结
```text
用索引字段做为条件进行修改时， 是否表锁的取决于这个索引字段能否确定记录唯一， 
当索引值对应记录不唯一，会进行锁表，相反则行锁。
```

### 示例2
```text
如果有两个delete
索引字段: kid1、kid2
```

* 情况1
    * 会话1
        ```mysql
        delete from table where  kid1=1 and kid2=2;
        ```
    * 会话2
        ```mysql
        delete from table where  kid1=1 and kid2=3;
        ```
    **不会锁表的**
    
* 情况2
    * 会话1
        ```mysql
        delete from table where  kid1=1 and kid2=2;
        ```
    * 会话2
        ```mysql
        delete from table where  kid1=1 ;
        ```
    **会锁表**
    
* 总结：同一个表，如果进行删除操作时，尽量让删除条件统一，否则会相互影响造成锁表

## InnoDB四种锁共存逻辑关系

`#` |共享锁(S) |排它锁(X) |意向共享锁(IS) |意向排它锁(IX)
:--- |:--- |:--- |:--- |:--- 
共享锁(S) |兼容 |冲突 |兼容 |冲突 
排它锁(X) |冲突 |冲突 |冲突 |冲突 
意向共享锁(IS) |兼容 |冲突 |兼容 |兼容 
意向排它锁(IX) |冲突 |冲突 |兼容 |兼容 
 
```text
如果一个事务请求的锁模式与当前的锁兼容，InnoDB就将请求的锁授予该事务；
反之，如果两者不兼容，该事务就要等待锁释放。

意向锁是InnoDB自动加的，不需用户干预。
对于UPDATE、DELETE和INSERT语句，InnoDB会自动给涉及数据集加排他锁（X)；
对于普通SELECT语句，InnoDB不会加任何锁；
```

```text
当一个事务需要给自己需要的某个资源加锁的时候，如
果遇到一个共享锁正锁定着自己需要的资源的时候，自己可以再加一个共享锁，不过不能加排他锁。
但是，如果遇到自己需要锁定的资源已经被一个排他锁占有之后，
则只能等待该锁定释放资源之后自己才能获取锁定资源并添加自己的锁定。

而意向锁的作用就是当一个事务在需要获取资源锁定的时候，
如果遇到自己需要的资源已经被排他锁占用的时候，该事务可以需要锁定行的表上面添加一个合适的意向锁。
如果自己需要一个共享锁，那么就在表上面添加一个意向共享锁。
而如果自己需要的是某行（或者某些行）上面添加一个排他锁的话，则先在表上面添加一个意向排他锁。
意向共享锁可以同时并存多个，但是意向排他锁同时只能有一个存在。
所以，可以说InnoDB的锁定模式实际上可以分为四种：共享锁(S)，排他锁(X)，意向共享锁(IS)、意向排他锁(IX)
```
