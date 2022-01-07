event事件计划--计划任务
==

## Table Of Contents
* [event是什么](#event是什么)
* [创建事件计划](#创建事件计划)
* [查看所有事件](#查看所有事件)
* [删除事件](#删除事件)


参考 https://dev.mysql.com/doc/refman/8.0/en/create-event.html

## event是什么
类似Linux的crontab，计划任务。可以指定何时执行指定的事件。

需要开启了 event scheduler都会执行event。

* 查看是否开启了event scheduler
    ```mysql
    SHOW VARIABLES LIKE 'event%';
    /*
    Variable_name    Value   
    ---------------  --------
    event_scheduler  ON      
    */
    ```

## 创建事件计划
* 语法
    ```sql
    CREATE
        [DEFINER = user]
        EVENT
        [IF NOT EXISTS]
        event_name
        ON SCHEDULE schedule
        [ON COMPLETION [NOT] PRESERVE]
        [ENABLE | DISABLE | DISABLE ON SLAVE]
        [COMMENT 'string']
        DO event_body;
    
    schedule: {
        AT timestamp [+ INTERVAL interval] ...
      | EVERY interval
        [STARTS timestamp [+ INTERVAL interval] ...]
        [ENDS timestamp [+ INTERVAL interval] ...]
    }
    
    interval:
        quantity {YEAR | QUARTER | MONTH | DAY | HOUR | MINUTE |
                  WEEK | SECOND | YEAR_MONTH | DAY_HOUR | DAY_MINUTE |
                  DAY_SECOND | HOUR_MINUTE | HOUR_SECOND | MINUTE_SECOND}
    ```

* 示例：在2006-02-10 23:59:00 向test.totals表中插入一条记录
    ```mysql
    CREATE EVENT e_totals
    ON SCHEDULE AT '2006-02-10 23:59:00'
    DO INSERT INTO test.totals VALUES (NOW());
    ```

* 示例：每天执行的事件
    ```mysql
    delimiter $
    
    CREATE EVENT e_daily
    ON SCHEDULE EVERY 1 DAY
    COMMENT 'Saves total number of sessions then clears the table each day'
    DO
    BEGIN
        INSERT INTO site_activity.totals (time, total)
            SELECT CURRENT_TIMESTAMP, COUNT(*)
            FROM site_activity.sessions;
        DELETE FROM site_activity.sessions;
    END $
    
    delimiter ;
    ```

## 查看所有事件
```mysql
SHOW EVENTS;
```

## 删除事件
```sql
DROP EVENT <even_name>;
```