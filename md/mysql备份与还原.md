mysql备份与还原
==

# Table Of Contents
* [备份常用操作](#备份常用操作)
* [还原常用操作](#还原常用操作)
* [增量备份](#增量备份)
* [增量备份后的还原操作](#增量备份后的还原操作)


## 备份常用操作
* 备份前手动锁表操作
    * 锁定所有库的所有表为只读，加全局读锁（适用于事务引擎、MyISAM引擎表）
        ```
        FLUSH TABLES WITH READ LOCK;
        ```
    * 锁定指定的表
        ```mysql 
        lock tables 表名1 read/write, 表名2  read/write;
        
        -- read: 只读
        -- write: 不允许读和写
        ```
    * 查看表上加了的锁
        ```
        SHOW OPEN TABLES [WHERE `database` = '库名'[ AND `table` = '表名']];
        ```
* 数据库还原后，手动释放表锁(所有表)
    ```
    unlock tables;
    ```

* 备份命令mysqldump格式
    ```text
    格式：mysqldump -h主机名  -P端口 -u用户名 -p密码 --no-defaults 数据库名 > 文件名.sql 
    ```

* **备份MySQL数据库为带不删除表的格式**
    ```text
    备份MySQL数据库为带删除表的格式，能够让该备份覆盖已有数据库而不需要手动删除原有数据库
    
    注意：默认是开启的
    也就是备份出来的sql文件中，在创建表前添加了删除表操作语句，这在用测试库备份的sql文件用到生产还原是要特别注意！！！
    DROP TABLE IF EXISTS `表名`; 
    
    加--skip-add-drop-table 选项可以在建表前不加删表语句
    -l, --lock-tables   Lock all tables for read.即，默认是开启只读表锁，所以在备份过程中其他连接会话是不能更新数据的
                        (Defaults to on; use --skip-lock-tables to disable.)
    --single-transaction  备份数据之前会启动一个事务，确保拿到一致性视图。由于MVCC的支持，这个过程中的数据是可以正常更新的。仅支持innodb
    -q, --quick  Don't buffer query, dump directly to stdout.该选项用于转储大的表，它强制mysqldump从服务器一次一行地检索表中的行而不是检索所有行并在输出前将它缓存到内存中
    ```
    ```bash
    mysqldump --skip-add-drop-table -uusername -ppassword databasename > backupfile.sql
    ```
    ![](../images/mysqldump_1.png)  

* 直接将MySQL数据库压缩备份
    ```bash
    mysqldump -hhostname -uusername -ppassword databasename | gzip > backupfile.sql.gz
    ```

* 备份指定数据库的部分表
    ```bash
    mysqldump -hhostname -uusername -ppassword 数据库名 specific_table1 specific_table2 > backupfile.sql
    ```

* 同时备份多个库
    ```bash
    mysqldump -hhostname -uusername -ppassword --databases databasename1 databasename2 databasename3 > multibackupfile.sql
    ```
* 仅备份数据库结构
    ```bash
    mysqldump --no-data --databases databasename1 databasename2 databasename3 > structurebackupfile.sql
    ```

* 备份服务器上所有数据库
    ```bash
    mysqldump -A > allbackupfile.sql
    或
    mysqldump --all-databases > allbackupfile.sql
    ```
    
* 将指定的数据库转移到新服务器(远程服务器)
    ```bash
    mysqldump -uusername -ppassword databasename |mysql -h远程Host -uUser -p -C 目标服务器上的databasename
    ```

* `select ... from <table> into outfile`导出表数据

    只能数据库服务器上执行，  
    作用：将表中数据导出，不包括表结构。  
    
    语法
    ```
    SELECT ... FROM <table> INTO OUTFILE 'file_name'
    [CHARACTER SET charset_name]
    [export_options]
    
    export_options:
    [{FIELDS | COLUMNS}
    [TERMINATED BY 'string']  // 指定字段的分隔符
    [[OPTIONALLY] ENCLOSED BY 'char']  // 导出的字段内容使用什么符号包裹
    [ESCAPED BY 'char']  // 转义字符
    ]
    [LINES
    [STARTING BY 'string']  // 行的起始符
    [TERMINATED BY 'string']  // 行的结束符
    ]
    ```
    file_name  // 指定保存查询结果的文件路径，要求给文件所在的目录权限为 777
    
    **示例**
    
    1. 查看要导出数据的表 t1
        ```
        mysql> select * from t1;
        +------+--------+
        | id   | name   |
        +------+--------+
        |    1 | wang   |
        |    2 | steven |
        |    3 | tiger  |
        |    4 | lilu   |
        +------+--------+
        4 rows in set (0.00 sec)
        ```
    
    2. 导出 select 的查询结果
        ```bash
        mysql -h 10.10.10.2 -u root -p -P 3306 -Ne "USE <dbname>; SELECT * FROM t1 INTO OUTFILE '/opt/t1.txt' FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '*' LINES TERMINATED BY '\n';"
        ```
    
    3. 查看 /opt/t1.txt 文件
        ```bash
        ~# more /opt/t1.txt
        1,"wang"
        2,"steven"
        3,"tiger"
        4,"lilu"
        ```
    
    4. 创建要导入的表 t2
        ```mysql
        create table t2 as select * from t1 where 1=2;
        ```
    
    5. 将 /opt/t1.txt 数据导入 t2
        ```mysql
        mysql> LOAD DATA INFILE '/opt/t1.txt' INTO TABLE t2 FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '*' LINES TERMINATED BY '\n';
        ```
    6. 查看导入的数据
        ```
        mysql> select * from t2;
        +------+--------+
        | id   | name   |
        +------+--------+
        |    1 | wang   |
        |    2 | steven |
        |    3 | tiger  |
        |    4 | lilu   |
        +------+--------+
        ```
    
* 通过 select 方式生成 insert into 语句
    1. 创建要运行的 sql 脚本
    
        cat /opt/runsql.sh
        ```mysql
        use mysys; \
        SELECT CONCAT("INSERT INTO book (`id`, `name`, `price`, `authorId`, `publishDate`) VALUES(", 
        "'", `id`, "', ",
        "'", `name`, "', ",
        "'", `price`, "', ",
        "'", `authorId`, "', ",
        "'", `publishDate`, "'",
        ");"
        ) 
        AS 'select_2_insert-into' FROM book ORDER BY id ASC;
        ```
    
    2. 执行 mysql 命令(可以在客户端)
        ```bash
        mysql -h <host> -u root -P 3306 -p -N < /opt/runsql.sh > /opt/ret.sql
        ```
        -N  // 不显示列名这一行。
        < /opt/runsql.sh  // 执行 /opt/runsql.sh 脚本中的 sql 命令
        > /opt/ret.sql  // 把查询结果 导出到 /opt/ret.sql 文件
        
        例如上面的测试结果为
        ```mysql
        INSERT INTO book (`id`, `name`, `price`, `authorId`, `publishDate`) VALUES('1', '???', '37.10', '1', '2019-04-01 00:00:00');
        INSERT INTO book (`id`, `name`, `price`, `authorId`, `publishDate`) VALUES('2', '??????', '26.90', '2', '2017-08-01 00:00:00');
        INSERT INTO book (`id`, `name`, `price`, `authorId`, `publishDate`) VALUES('3', '????', '32.40', '3', '2012-01-01 00:00:00');
        ```

## 还原常用操作
* 还原指定的数据库
    ```bash
    mysql -hhostname -uusername -ppassword databasename < backupfile.sql
    ```

* 还原压缩的MySQL数据库
    ```bash
    gunzip < backupfile.sql.gz | mysql -uusername -ppassword databasename
    ```

* 导入数据库
    ```text
    常用source命令，用use进入到某个数据库，后面的参数为脚本文件。
    ```
    ```bash
    mysql> use <database_name>;
    mysql> source /data/test.sql;
    ```

## 增量备份
```text
优点：没有重复数据，备份量不大，时间短。
缺点：需要上次全备份及全备份之后所有的增量备份才能恢复。
MySQL没有提供直接的增量备份方法，但是可以通过mysql的二进制文件(binary logs)间接实现增量备份

增量备份的原理就是使用了mysql的bin log志。mysql增量备份必修开启二进制日志。

二进制日志对备份的作用
======================
* 二进制日志文件保存了所有更新或者可能更新数据库的操作
* 二进制日志在启动MySQL服务器后开始记录，
    并在文件达到max_binlog_size所设置的大小或者接收到flush logs命令后重新创建新的日志文件。
* 只需要定时执行flush logs方法重新创建新的日志，生成二进制文件序列，
    并及时把这些日志保存到安全的地方就完成了一个时间段的增量备份
```

* --master-data和--single-transaction
    ```text
    在mysqldump中使用--master-data=2，会记录binlog文件和position的信息。
    --single-transaction会将隔离级别设置成repeatable-commited
    ```

1. 首先做一次完整备份
    ```bash
    mysql -hHost -uUser -p --single-transaction  --master-data=2  test > test.sql
    ```
    ```text
    这时候就会得到一个全备文件test.sql
    在sql文件中我们会看到：
    -- CHANGE MASTER TO MASTER_LOG_FILE='bin-log.000002', MASTER_LOG_POS=107;
    是指备份后所有的更改将会保存到bin-log.000002二进制文件中。
    ```

2. 切割bin-log
    ```mysql
    -- mysql命令
    flush logs;
    ```
    ```text
    在test库的t_student表中增加两条记录，
    然后执行flush logs命令。
    这时将会产生一个新的二进制日志文件bin-log.000003，
    bin-log.000002则保存了全备过后的所有更改，
    既增加记录的操作也保存在了bin-log.00002中。
    ```

3. 更新数据
    ```text
    再在test库中的a表中增加两条记录，然后误删除t_student表和a表。
    a中增加记录的操作和删除表a和t_student的操作都记录在bin-log.000003中。
    ```

4. 查看binlog日志
    ```bash  
    mysqlbinlog --no-defaults binlog日志名称 |more
    
    # --no-defaults: 不读取选项文件，如my.cnf配置了default_character_set，无法识别而参数报错
    ```
    **bin log示例**  
    ```text
    #at 数字: 表示position位置
    #191112 11:48:50  表示时间2019-11-12 11:48:50
    ```
    ```bash
    mysqlbinlog --no-defaults binlog.000004
    /*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
    /*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
    DELIMITER /*!*/;
    # at 4
    #191112 11:48:50 server id 1  end_log_pos 124 CRC32 0xe76a8edd 	Start: binlog v 4, server v 8.0.18 created 191112 11:48:50 at startup
    # Warning: this binlog is either in use or was not closed properly.
    ROLLBACK/*!*/;
    BINLOG '
    oivKXQ8BAAAAeAAAAHwAAAABAAQAOC4wLjE4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAACiK8pdEwANAAgAAAAABAAEAAAAYAAEGggAAAAICAgCAAAACgoKKioAEjQA
    CgHdjmrn
    '/*!*/;
    # at 124
    #191112 11:48:50 server id 1  end_log_pos 155 CRC32 0xf3ed079c 	Previous-GTIDs
    # [empty]
    SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
    DELIMITER ;
    # End of log file
    /*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
    /*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
    ```

## 增量备份后的还原操作
1. 首先导入全备数据
    ```bash
    mysql -hHost -uUser -p < test.sql
    ```
    ```mysql
    -- 也可以直接在mysql命令行下面用source导入
    source test.sql;
    ```
2. 恢复增量bin log
    ```text
    增量二进制日志恢复的顺序，要先恢复最先生成的二进制文件，然后依次执行
    ```
    1. 恢复bin-log.000002
        ```bash
        mysqlbinlog --no-defaults bin-log.000002 |mysql -hHost -uUser -p
        ```

    2. 恢复部分 bin-log.000003
        ```text
        查看binlog日志找到误删除的时间点，
        然后更加对应的时间点到bin-log.000003中找到相应的position点，
        需要恢复到误删除的前面一个position点。找到恢复点后，既可以开始恢复
        
        * 可以用如下参数来控制bin log的区间
            --start-position 开始点
            --stop-position 结束点
            或
            --start-date 开始时间  
            --stop-date  结束时间
        ```
        ```bash
        mysqlbinlog --no-defaults /var/lib/mysql/mysql-bin.000003 --stop-position=208 |mysql -hHost -uUser -p
        ```
