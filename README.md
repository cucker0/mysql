MySQL核心技术
==


# Table Of Contents
* [数据库和SQL概述](md/数据库和SQL概述.md)
* [Mysql安装与使用](md/Mysql安装与使用.md)
* [mysql备份与还原](md/mysql备份与还原.md)
    * [备份常用操作](md/mysql备份与还原.md#备份常用操作)
    * [还原常用操作](md/mysql备份与还原.md#还原常用操作)
    * [增量备份](md/mysql备份与还原.md#增量备份)
    * [增量备份后的还原操作](md/mysql备份与还原.md#增量备份后的还原操作) 

---

**SQL语言**
* [本次测试练习的表关系模型](/md/1_01_sql常见规则_测试表模型.md#本次测试练习的表关系模型)
* [语法常见规则](md/1_01_sql常见规则_测试表模型.md#语法常见规则)
* [**DQL数据查询语言**](md/2_01_DQL数据查询语言.基础查询.md)
    <details>
    <summary>基础查询</summary>
    
    * [基础查询](md/2_01_DQL数据查询语言.基础查询.md#基础查询)
        * [基本语法](md/2_01_DQL数据查询语言.基础查询.md#基本语法)
        * [查询表中的单个字段](md/2_01_DQL数据查询语言.基础查询.md#查询表中的单个字段)
        * [查询表中的多个字段](md/2_01_DQL数据查询语言.基础查询.md#查询表中的多个字段)
        * [查询表中的所有字段](md/2_01_DQL数据查询语言.基础查询.md#查询表中的所有字段)
        * [查询常量值](md/2_01_DQL数据查询语言.基础查询.md#查询常量值)
        * [查询表达式](md/2_01_DQL数据查询语言.基础查询.md#查询表达式)
        * [查询函数](md/2_01_DQL数据查询语言.基础查询.md#查询函数)
        * [起别名](md/2_01_DQL数据查询语言.基础查询.md#起别名)
        * [distinct去重](md/2_01_DQL数据查询语言.基础查询.md#distinct去重)
        * [+的作用](md/2_01_DQL数据查询语言.基础查询.md#的作用)
    </details>
        
    <details>
    <summary>条件查询</summary>
    
    * [条件查询](md/2_02_DQL数据查询语言.条件查询.md#条件查询)
        * [条件查询分类 >, <, =, <>, !=, >=, <=, <=>; and, or, not; like, between A and B, in (set), is null, is not null](md/2_02_DQL数据查询语言.条件查询.md#条件查询分类)
        * [按条件表达式筛选](md/2_02_DQL数据查询语言.条件查询.md#按条件表达式筛选)
        * [按逻辑表达式筛选](md/2_02_DQL数据查询语言.条件查询.md#按逻辑表达式筛选)
        * [模糊查询](md/2_02_DQL数据查询语言.条件查询.md#模糊查询)
            * [escape '标识符' 显示指定转义](md/2_02_DQL数据查询语言.条件查询.md#模糊查询)
    </details>
    
    <details>
    <summary>排序查询</summary>
     
    * [排序查询](md/2_03_DQL数据查询语言.排序查询.md)
        * [排序查询语法](md/2_03_DQL数据查询语言.排序查询.md#排序查询语法)
    </details>
        
    <details>
    <summary>常见函数</summary>
        
    * [常见函数](md/2_04_DQL数据查询语言.常见函数.md)
        * [函数概念](md/2_04_DQL数据查询语言.常见函数.md#函数概念)
        * [函数分类](md/2_04_DQL数据查询语言.常见函数.md#函数分类)
        * [单行函数](md/2_04_DQL数据查询语言.常见函数.md#单行函数)
            * [字符串函数](md/2_04_DQL数据查询语言.常见函数.md#字符串函数)
            * [数值函数](md/2_04_DQL数据查询语言.常见函数.md#数值函数)
                * [数值基本函数](md/2_04_DQL数据查询语言.常见函数.md#数值基本函数)
                * [角度与弧度互转函数](md/2_04_DQL数据查询语言.常见函数.md#角度与弧度互转函数)
                * [三角函数](md/2_04_DQL数据查询语言.常见函数.md#三角函数)
                * [指数与对数函数](md/2_04_DQL数据查询语言.常见函数.md#指数与对数函数)
                * [进制间的转换函数](md/2_04_DQL数据查询语言.常见函数.md#进制间的转换函数)
            * [日期、时间函数](md/2_04_DQL数据查询语言.常见函数.md#日期时间函数)
                * [日期、时间函数](md/2_04_DQL数据查询语言.常见函数.md#日期时间函数)
                * [日期与时间戳的转换](md/2_04_DQL数据查询语言.常见函数.md#日期与时间戳的转换)
                * [获取月份、星期、星期数、天数等函数](md/2_04_DQL数据查询语言.常见函数.md#获取月份星期星期数天数等函数)
                * [日期的操作函数](md/2_04_DQL数据查询语言.常见函数.md#日期的操作函数)
                * [计算日期和时间的函数](md/2_04_DQL数据查询语言.常见函数.md#计算日期和时间的函数)
                * [日期、时间的格式化与解析](md/2_04_DQL数据查询语言.常见函数.md#日期时间的格式化与解析)
                * [format匹配模式字母定义](md/2_04_DQL数据查询语言.常见函数.md#format匹配模式字母定义)
            * [MySql信息函数](md/2_04_DQL数据查询语言.常见函数.md#MySql信息函数)
            * [其他函数](md/2_04_DQL数据查询语言.常见函数.md#其他函数)
            * [流程分支控制函数](md/2_04_DQL数据查询语言.常见函数.md#流程分支控制函数)
    </details>
    
    <details>
    <summary>分组函数</summary>
    
    * [分组函数](md/2_05_DQL数据查询语言.分组函数.md)
        * [分组函数概念与功能](md/2_05_DQL数据查询语言.分组函数.md#分组函数概念与功能)
        * [分组函数概览与总结 SUM, AVG, MAX, MIN, COUNT](md/2_05_DQL数据查询语言.分组函数.md#分组函数概览与总结)
        * [count(*)与count(id)与count(字段)](md/2_05_DQL数据查询语言.分组函数.md#count与countid与count字段)
    </details>
    
    <details>
    <summary>分组查询</summary>
    
    * [分组查询](md/2_06_DQL数据查询语言.分组查询.md)
        * [分组查询语法, group by \[having\]](md/2_06_DQL数据查询语言.分组查询.md#分组查询语法)
        * [分组查询特点](md/2_06_DQL数据查询语言.分组查询.md#分组查询特点)
        * [分组前筛选 where、分组后筛选比较having](md/2_06_DQL数据查询语言.分组查询.md#分组前筛选分组后筛选比较)
        * [分组查询示例](md/2_06_DQL数据查询语言.分组查询.md#分组查询示例)
        * [MySQL获取分组后的top 1和top N记录方法](./exercise/MySQL获取分组后的top%201和top%20N记录.sql)
    </details>
    
    <details>
    <summary>连接查询</summary>
    
    * [连接查询](md/2_07_DQL数据查询语言.连接查询.md)
        * [连接查询分类](md/2_07_DQL数据查询语言.连接查询.md#连接查询分类)
        * [SQL-92连接语法(仅支持内连接)](md/2_07_DQL数据查询语言.连接查询.md#SQL-92连接语法仅支持内连接)
            * [SQL-92语法](md/2_07_DQL数据查询语言.连接查询.md#SQL-92语法)
            * [笛卡尔乘积现象(交叉连接)](md/2_07_DQL数据查询语言.连接查询.md#笛卡尔乘积现象交叉连接)
            * [等值连接](md/2_07_DQL数据查询语言.连接查询.md#等值连接)
            * [非等值连接](md/2_07_DQL数据查询语言.连接查询.md#非等值连接)
            * [自连接(自身内连接)](md/2_07_DQL数据查询语言.连接查询.md#自连接自身内连接)
        * [SQL:1999连接语法](md/2_07_DQL数据查询语言.连接查询.md#SQL1999连接语法)
            * [SQL-92与SQL:1999对比](md/2_07_DQL数据查询语言.连接查询.md#SQL-92与SQL1999对比)
            * [SQL:1999连接语法结构](md/2_07_DQL数据查询语言.连接查询.md#SQL1999连接语法结构)
            * [SQL:1999连接类型分类](md/2_07_DQL数据查询语言.连接查询.md#SQL1999连接类型分类)
            * [内连接](md/2_07_DQL数据查询语言.连接查询.md#内连接)
                * [SQL:1999内连特点](md/2_07_DQL数据查询语言.连接查询.md#SQL1999内连特点)
            * [外连接](md/2_07_DQL数据查询语言.连接查询.md#外连接)
                * [外连接特点](md/2_07_DQL数据查询语言.连接查询.md#外连接特点)
            * [全外连接](md/2_07_DQL数据查询语言.连接查询.md#全外连接)
                * [full outer join全外连接替代方案](md/2_07_DQL数据查询语言.连接查询.md#full-outer-join全外连接替代方案)
            * [交叉链接(即笛卡尔乘积)](md/2_07_DQL数据查询语言.连接查询.md#交叉链接即笛卡尔乘积)
        * [连接查询总结](md/2_07_DQL数据查询语言.连接查询.md#连接查询总结)
    </details>
    
    <details>
    <summary>子查询</summary>
    
    * [子查询](md/2_08_DQL数据查询语言.子查询.md)
        * [子查询分类](md/2_08_DQL数据查询语言.子查询.md#子查询分类)
        * [where或having后面](md/2_08_DQL数据查询语言.子查询.md#where或having后面)
            * [where或having后面子查询特点, in/not in,  any/some,  all](md/2_08_DQL数据查询语言.子查询.md#where或having后面子查询特点)
            * [标量子查询](md/2_08_DQL数据查询语言.子查询.md#标量子查询)
            * [列子查询](md/2_08_DQL数据查询语言.子查询.md#列子查询)
            * [行子查询](md/2_08_DQL数据查询语言.子查询.md#行子查询)
        * [select后面](md/2_08_DQL数据查询语言.子查询.md#select后面)
        * [from后面](md/2_08_DQL数据查询语言.子查询.md#from后面)
        * [exists后面](md/2_08_DQL数据查询语言.子查询.md#exists后面)
    </details>
    
    <details>
    <summary>limit分页查询</summary>
    
    * [limit分页查询](md/2_09_DQL数据查询语言.分页查询.md)
        * [分页查询语法](md/2_09_DQL数据查询语言.分页查询.md#分页查询语法)
        * [分页查询特点](md/2_09_DQL数据查询语言.分页查询.md#分页查询特点)
        * [分页查询案例](md/2_09_DQL数据查询语言.分页查询.md#分页查询案例)
    </details>
    
    <details>
    <summary>union联合查询</summary>
    
    * [union联合查询](md/2_10_DQL数据查询语言.union联合查询_DQL查询语句总结.md)
        * [union联合查询语法](md/2_10_DQL数据查询语言.union联合查询_DQL查询语句总结.md#union联合查询语法)
        * [union联合查询语法应用场景](md/2_10_DQL数据查询语言.union联合查询_DQL查询语句总结.md#union联合查询语法应用场景)
        * [union联合查询特点](md/2_10_DQL数据查询语言.union联合查询_DQL查询语句总结.md#union联合查询特点)
        * [union联合查询案例](md/2_10_DQL数据查询语言.union联合查询_DQL查询语句总结.md#union联合查询案例)
    </details>
    
    * [DQL查询语句总结](md/2_10_DQL数据查询语言.union联合查询_DQL查询语句总结.md#DQL查询语句总结)
* [**DML表数据操作语言(表的记录操作)**](md/3_01_DML表数据操作语言.md)
    * [查询语句 (DQL数据查询语言)](md/2_01_DQL数据查询语言.基础查询.md)
    
    <details>
    <summary>插入语句</summary>
    
    * [插入语句](md/3_01_DML表数据操作语言.md#插入语句)
        * [values多行插入](md/3_01_DML表数据操作语言.md#values多行插入)
        * [set单行插入](md/3_01_DML表数据操作语言.md#set单行插入)
        * [values多行插入、set单行插入对比](md/3_01_DML表数据操作语言.md#values多行插入set单行插入对比)
    </details>
    
    <details>
    <summary>修改语句</summary>
    
    * [修改语句](md/3_01_DML表数据操作语言.md#修改语句)
        * [修改表数据语法](md/3_01_DML表数据操作语言.md#修改表数据语法)
        * [单表修改记录示例](md/3_01_DML表数据操作语言.md#单表修改记录示例)
        * [多表连接修改记录示例](md/3_01_DML表数据操作语言.md#多表连接修改记录示例)
    </details>
    
    <details>
    <summary>删除语句</summary>
    
    * [删除语句](md/3_01_DML表数据操作语言.md#删除语句)
        * [delete删除记录语法](md/3_01_DML表数据操作语言.md#delete删除记录语法)
        * [truncate清空表删除所有记录](md/3_01_DML表数据操作语言.md#truncate清空表删除所有记录)
        * [delete删除记录示例](md/3_01_DML表数据操作语言.md#delete删除记录示例)
        * [truncate清空表删除所有记录示例](md/3_01_DML表数据操作语言.md#truncate清空表删除所有记录示例)
        * [delete删除记录、truncate清空表删除所有记录对比](md/3_01_DML表数据操作语言.md#delete删除记录truncate清空表删除所有记录对比)
    </details>
    
* [**DDL数据定义语言(库和表的管理)**](md/4_01_DDL数据定义语言.库的管理.md)
    <details>
    <summary>库的管理(database)</summary>
    
    * [库的管理](md/4_01_DDL数据定义语言.库的管理.md)
        * [库的创建](md/4_01_DDL数据定义语言.库的管理.md#库的创建)
        * [库的修改](md/4_01_DDL数据定义语言.库的管理.md#库的修改)
        * [库的删除](md/4_01_DDL数据定义语言.库的管理.md#库的删除)
        * [查看库的创建sql](md/4_01_DDL数据定义语言.库的管理.md#查看库的创建sql)
    </details>
    
    <details>
    <summary>表的管理(table)</summary>
    
    * [表的管理](md/4_02_DDL数据定义语言.表的管理.md)
        * [COMMENT注释](md/4_02_DDL数据定义语言.表的管理.md#COMMENT注释)
        * [表的创建](md/4_02_DDL数据定义语言.表的管理.md#表的创建)
        * [表的修改](md/4_02_DDL数据定义语言.表的管理.md#表的修改)
        * [表的删除](md/4_02_DDL数据定义语言.表的管理.md#表的删除)
        * [表的复制](md/4_02_DDL数据定义语言.表的管理.md#表的复制)
        * [查看表的创建sql和表结构](md/4_02_DDL数据定义语言.表的管理.md#查看表的创建sql和表结构)
    </details>
    
    <details>
    <summary>常见数据类型</summary>
    
    * [常见数据类型](md/4_03_DDL数据定义语言.常见数据类型.md)
        * [数据类型分类](md/4_03_DDL数据定义语言.常见数据类型.md#数据类型分类)
        * [整型](md/4_03_DDL数据定义语言.常见数据类型.md#整型)
            * [整型占用空间、值范围](md/4_03_DDL数据定义语言.常见数据类型.md#整型占用空间值范围)
            * [整型特点](md/4_03_DDL数据定义语言.常见数据类型.md#整型特点)
            * [整型示例](md/4_03_DDL数据定义语言.常见数据类型.md#整型示例)
        * [小数](md/4_03_DDL数据定义语言.常见数据类型.md#小数)
            * [小数分类](md/4_03_DDL数据定义语言.常见数据类型.md#小数分类)
            * [小数值范围](md/4_03_DDL数据定义语言.常见数据类型.md#小数值范围)
            * [小数示例](md/4_03_DDL数据定义语言.常见数据类型.md#小数示例)
        * [bit类型](md/4_03_DDL数据定义语言.常见数据类型.md#bit类型)
        * [字符型](md/4_03_DDL数据定义语言.常见数据类型.md#字符型)
            * [字符型分类](md/4_03_DDL数据定义语言.常见数据类型.md#字符型分类)
            * [char、varchar比较](md/4_03_DDL数据定义语言.常见数据类型.md#charvarchar比较)
        * [日期时间型](md/4_03_DDL数据定义语言.常见数据类型.md#日期时间型)
            * [日期时间型分类](md/4_03_DDL数据定义语言.常见数据类型.md#日期时间型分类)
            * [datetime、timestamp比较](md/4_03_DDL数据定义语言.常见数据类型.md#datetimetimestamp比较)
        * [java数据类型与mysql数据类型对应表](md/4_03_DDL数据定义语言.常见数据类型.md#java数据类型与mysql数据类型对应表)
    </details>
    
    <details>
    <summary>JSON数据类型</summary>
    
    * [初识mysql json](md/json_mysql.md)
        * [什么是mysql json](md/json_mysql.md#什么是mysql-json)
            * [json类型数据的使用场景](md/json_mysql.md#json类型数据的使用场景)
            * [示例](md/json_mysql.md#示例)
            * [包含json类型字段的表的设计原则](md/json_mysql.md#包含json类型字段的表的设计原则)
            * [json数据类型与json格式的字符串相比的优点](md/json_mysql.md#json数据类型与json格式的字符串相比的优点)
        * [docs](md/json_mysql.md#docs)
        * [以json值建立索引](md/json_mysql.md#以json值建立索引)
        * [建表](md/json_mysql.md#建表)
        * [插入JSON字段](md/json_mysql.md#插入JSON字段)
        * [以json字段内的某个值作为连接查询的条件](#以json字段内的某个值作为连接查询的条件)
        * [JSON字段值的CRUD(增查改删)](#JSON字段值的CRUD)
            * [插入JSON值](md/json_mysql.md#插入JSON值)
            * [查询JSON值](md/json_mysql.md#查询JSON值)
            * [更新JSON值](md/json_mysql.md#更新JSON值)
            * [删除JSON值](md/json_mysql.md#删除JSON值)
    * [JSON Function 列表参考](md/json_functions.md#JSON-Function-Reference)
    * [JSON path的表示](md/json_functions.md#JSON-path)
    * [Functions That Create JSON Values](md/json_functions.md#Functions-That-Create-JSON-Values)
        * [JSON_ARRAY()](md/json_functions.md#JSON_ARRAY)
        * [JSON_OBJECT()](md/json_functions.md#JSON_OBJECT)
        * [JSON_QUOTE()](md/json_functions.md#JSON_QUOTE)
    * [Functions That Search JSON Values](md/json_functions.md#Functions-That-Search-JSON-Values)
        * [column->path](md/json_functions.md#column-path)
        * [column->>path](md/json_functions.md#column-path)
        * [JSON_EXTRACT()](md/json_functions.md#JSON_EXTRACT)
        * [JSON_CONTAINS()](md/json_functions.md#JSON_CONTAINS)
        * [JSON_CONTAINS_PATH()](md/json_functions.md#JSON_CONTAINS_PATH)
        * [JSON_KEYS(json_doc[, path])](md/json_functions.md#JSON_KEYSjson_doc-path)
        * [类似JSON_VALUES()函数的SQL](md/json_functions.md#类似JSON_VALUES函数的SQL)
        * [JSON_OVERLAPS()](md/json_functions.md#JSON_OVERLAPS)
        * [JSON_SEARCH()](md/json_functions.md#JSON_SEARCH)
        * [JSON_VALUE()](md/json_functions.md#JSON_VALUE)
        * [value MEMBER OF(json_array)](md/json_functions.md#value-MEMBER-OFjson_array)
    * [Functions That Modify JSON Values](md/json_functions.md#Functions-That-Modify-JSON-Values)
        * [JSON_ARRAY_APPEND()](md/json_functions.md#JSON_ARRAY_APPEND)
        * [JSON_ARRAY_INSERT()](md/json_functions.md#JSON_ARRAY_INSERT)
        * [JSON_INSERT()](md/json_functions.md#JSON_INSERT)
        * [JSON_REPLACE()](md/json_functions.md#JSON_REPLACE)
        * [JSON_SET()](md/json_functions.md#JSON_SET)
        * [JSON_SET(), JSON_INSERT(), JSON_REPLACE()的对比](md/json_functions.md#JSON_SET-JSON_INSERT-JSON_REPLACE的对比)
        * [JSON_REMOVE()](md/json_functions.md#JSON_REMOVE)
        * [JSON_MERGE()](md/json_functions.md#JSON_MERGE)
        * [JSON_MERGE_PATCH()](md/json_functions.md#JSON_MERGE_PATCH)
        * [JSON_MERGE_PRESERVE()](md/json_functions.md#JSON_MERGE_PRESERVE)
        * [JSON_MERGE_PATCH()对比JSON_MERGE_PRESERVE()](md/json_functions.md#JSON_MERGE_PATCH对比JSON_MERGE_PRESERVE)
        * [JSON_UNQUOTE()](md/json_functions.md#JSON_UNQUOTE)
    * [Functions That Return JSON Value Attributes](md/json_functions.md#Functions-That-Return-JSON-Value-Attributes)
        * [JSON_DEPTH(json_doc)](md/json_functions.md#JSON_DEPTHjson_doc)
        * [JSON_LENGTH(json_doc[, path])](md/json_functions.md#JSON_LENGTHjson_doc-path)
        * [JSON_TYPE(json_val)](md/json_functions.md#JSON_TYPEjson_val)
        * [JSON_VALID(val)](md/json_functions.md#JSON_VALIDval)
    * [JSON Table Functions](md/json_functions.md#JSON-Table-Functions)
        * [JSON_TABLE()](md/json_functions.md#JSON_TABLE)
    * [JSON Schema Validation Functions](md/json_functions.md#JSON-Schema-Validation-Functions)
        * [JSON_SCHEMA_VALID()](md/json_functions.md#JSON_SCHEMA_VALID)
        * [JSON_SCHEMA_VALIDATION_REPORT()](md/json_functions.md#JSON_SCHEMA_VALIDATION_REPORT)
    * [JSON Utility Functions](md/json_functions.md#JSON-Utility-Functions)
        * [JSON_PRETTY(json_val)](md/json_functions.md#JSON_PRETTYjson_val)
        * [JSON_STORAGE_FREE(json_val)](md/json_functions.md#JSON_STORAGE_FREEjson_val)
        * [JSON_STORAGE_SIZE(json_val)](md/json_functions.md#JSON_STORAGE_SIZEjson_val)
        * [CAST()、CONVERT()](md/json_functions.md#CASTCONVERT)
    </details>
    
    <details>
    <summary>常见约束</summary>
    
    * [常见约束](md/4_04_DDL数据定义语言.常见约束.md)
        * [按功能分类(6大约束)](md/4_04_DDL数据定义语言.常见约束.md#按功能分类6大约束)
        * [按作用范围分类](md/4_04_DDL数据定义语言.常见约束.md#按作用范围分类)
        * [添加约束的时机](md/4_04_DDL数据定义语言.常见约束.md#添加约束的时机)
        * [主键约束、唯一约束、外键约束对比](md/4_04_DDL数据定义语言.常见约束.md#主键约束唯一约束外键约束对比)
        * [约束语法](md/4_04_DDL数据定义语言.常见约束.md#约束语法)
        * [创建表时添加约束](md/4_04_DDL数据定义语言.常见约束.md#创建表时添加约束)
        * [修改表时添加约束](md/4_04_DDL数据定义语言.常见约束.md#修改表时添加约束)
        * [修改表时删除约束](md/4_04_DDL数据定义语言.常见约束.md#修改表时删除约束)
        * [自增长列(标识列)](md/4_04_DDL数据定义语言.常见约束.md#自增长列标识列)
        * [foreign key外键约束](md/4_04_DDL数据定义语言.常见约束.md#foreign-key外键约束)
            * [外键特点](md/4_04_DDL数据定义语言.常见约束.md#外键特点)
            * [表之间的关系与外键约束与外键约束](md/4_04_DDL数据定义语言.常见约束.md#表之间的关系与外键约束)
            * [sql外键on delete和on update](md/4_04_DDL数据定义语言.常见约束.md#sql外键on-delete和on-update)
            * [删除被关联的父表或修改其表结构方法](md/4_04_DDL数据定义语言.常见约束.md#删除被关联的父表或修改其表结构方法)
            * [使用外键约束的优点与缺点](md/使用外键约束的优点与缺点.md)
    </details>
    
* [**DCL数据控制语言**](md/5_01_DCL数据控制语言.TCL事务控制语言.md)
    <details>
    <summary>mysql用户与权限管理</summary>
    
    * [mysql用户与权限管理](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md)
        * [ 用户管理](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#用户管理)
            * [ 用户帐号](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#用户帐号)
            * [ 创建用户](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#创建用户)
            * [ 用户重命名](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#用户重命名)
            * [ 锁定、解锁用户](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#锁定解锁用户)
            * [ 删除用户](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#删除用户)
            * [ 修改密码](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#修改密码)
        * [ 权限管理](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#权限管理)
            * [ grant授权语法](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#grant授权语法)
                * [ 权限类别](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#权限类别)
            * [ revoke回收授权](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#revoke回收授权)
            * [ 查看指定用户的授权信息](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#查看指定用户的授权信息)
        * [ 其他](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#其他)
            * [ 破解数据库密码](/md/5_02_DCL数据控制语言.mysql用户与权限管理.md#破解数据库密码)
    </details>
      
    <details>
    <summary>TCL事务控制语言</summary>
    
    * [TCL事务控制语言](md/5_01_DCL数据控制语言.TCL事务控制语言.md#TCL事务控制语言)
        * [事务特点(ACID)](md/5_01_DCL数据控制语言.TCL事务控制语言.md#事务特点ACID)
        * [事务的使用](md/5_01_DCL数据控制语言.TCL事务控制语言.md#事务的使用)
        * [事务的创建](md/5_01_DCL数据控制语言.TCL事务控制语言.md#事务的创建)
        * [隐式事务](md/5_01_DCL数据控制语言.TCL事务控制语言.md#隐式事务)
        * [显式事务](md/5_01_DCL数据控制语言.TCL事务控制语言.md#显式事务)
        * [显式事务语法](md/5_01_DCL数据控制语言.TCL事务控制语言.md#显式事务语法)
        * [savepoint设置保存点，与rollback搭配使用](md/5_01_DCL数据控制语言.TCL事务控制语言.md#savepoint设置保存点与rollback搭配使用)
        * [事务隔离级别对比](md/5_01_DCL数据控制语言.TCL事务控制语言.md#事务隔离级别对比)
        * [查看事务隔离级别](md/5_01_DCL数据控制语言.TCL事务控制语言.md#查看事务隔离级别)
        * [设置事务隔离级别](md/5_01_DCL数据控制语言.TCL事务控制语言.md#设置事务隔离级别)
        * [查看引擎](md/5_01_DCL数据控制语言.TCL事务控制语言.md#查看引擎)
        * [关闭当前会话的自动提交事务功能](md/5_01_DCL数据控制语言.TCL事务控制语言.md#关闭当前会话的自动提交事务功能)
        * [事务测试](md/5_01_DCL数据控制语言.TCL事务控制语言.md#事务测试)
    </details>
    
* [view视图](md/6_01_view视图.md)
    <details>
    <summary>view视图</summary>
    
    * [使用场景](md/6_01_view视图.md#使用场景)
    * [使用视图好处](md/6_01_view视图.md#使用视图好处)
    * [view视图与表对比](md/6_01_view视图.md#view视图与表对比)
    * [view视图的生命周期](md/6_01_view视图.md#view视图的生命周期)
    * [创建视图](md/6_01_view视图.md#创建视图)
    * [修改视图的sql语句](md/6_01_view视图.md#修改视图的sql语句)
    * [查看视图](md/6_01_view视图.md#查看视图)
    * [删除视图](md/6_01_view视图.md#删除视图)
    * [视图虚拟表数据可更新情况](md/6_01_view视图.md#视图虚拟表数据可更新情况)
    * [具备以下特点的视图不可更行(增删改)](md/6_01_view视图.md#具备以下特点的视图不可更行增删改)
    </details>
    
* [变量](md/7_01_变量.md)
    * [变量分类](md/7_01_变量.md#变量分类)
    <details>
    <summary>系统变量</summary>
    
    * [系统变量](md/7_01_变量.md#系统变量)
        * [全局变量](md/7_01_变量.md#全局变量)
        * [会话变量](md/7_01_变量.md#会话变量)
    </details>
    
    <details>
    <summary>自定义变量</summary>
    
    * [自定义变量](md/7_01_变量.md#自定义变量)
        * [使用步骤](md/7_01_变量.md#使用步骤)
        * [用户变量](md/7_01_变量.md#用户变量)
        * [局部变量](md/7_01_变量.md#局部变量)
    </details>
    
    * [全局变量、会话变量、用户变量、局部变量对比](md/7_01_变量.md#全局变量会话变量用户变量局部变量对比)
    
* [存储过程(procedure)、用户定义函数(function)](md/8_01_存储过程、用户定义函数.md)
    * [存储过程、函数对比](md/8_01_存储过程、用户定义函数.md#存储过程函数对比)
    
    <details>
    <summary>存储过程(procedure)</summary>
    
    * [存储过程](md/8_01_存储过程、用户定义函数.md#存储过程)
        * [创建存储过程语法](md/8_01_存储过程、用户定义函数.md#创建存储过程语法)
        * [创建存储过程示例](md/8_01_存储过程、用户定义函数.md#创建存储过程示例)
        * [创建存储过程示例](md/8_01_存储过程、用户定义函数.md#创建存储过程示例)
        * [查看存储过程](md/8_01_存储过程、用户定义函数.md#查看存储过程)
        * [删除存储过程](md/8_01_存储过程、用户定义函数.md#删除存储过程)
        * [修改存储过程(不能修改参数或存储过程主体，只能修改存储过程特性)](md/8_01_存储过程、用户定义函数.md#修改存储过程不能修改参数或存储过程主体只能修改存储过程特性)
        * [在存储过程中遍历查询结果集](md/8_01_存储过程、用户定义函数.md#在存储过程中遍历查询结果集)
    </details>
    
    <details>
    <summary>用户自定义函数(function)</summary>
    
    * [用户自定义函数](md/8_02_用户定义函数.md)
        * [函数创建语法](md/8_02_用户定义函数.md#函数创建语法)
        * [调用用户自定义函数语法](md/8_02_用户定义函数.md#调用用户自定义函数语法)
        * [创建函数示例](md/8_02_用户定义函数.md#创建函数示例)
        * [查看用户自定义函数](md/8_02_用户定义函数.md#查看用户自定义函数)
        * [删除自定义用户函数](md/8_02_用户定义函数.md#删除自定义用户函数)
        * [修改用户自定义函数(不能更改函数体和参数列表，只能更改函数特性)](md/8_02_用户定义函数.md#修改用户自定义函数不能更改函数体和参数列表只能更改函数特性)
    </details>
    
* [流程控制结构](md/9_01_流程控制结构.md)
    * [流程控制结构分类](md/9_01_流程控制结构.md#流程控制结构分类)
    
    <details>
    <summary>分支结构</summary>
    
    * [分支结构](md/9_01_流程控制结构.md#分支结构)
        * [if函数](md/9_01_流程控制结构.md#if函数)
        * [IFNULL(expr1,expr2)](md/9_01_流程控制结构.md#IFNULLexpr1expr2)
        * [if分支](md/9_01_流程控制结构.md#if分支)
        * [case结构](md/9_01_流程控制结构.md#case结构)
    </details>
    
    <details>
    <summary>循环结构</summary>
    
    * [循环结构](md/9_01_流程控制结构.md#循环结构)
        * [循环控制](md/9_01_流程控制结构.md#循环控制)
        * [while循环](md/9_01_流程控制结构.md#while循环)
        * [loop无限循环](md/9_01_流程控制结构.md#loop无限循环)
        * [repeat循环](md/9_01_流程控制结构.md#repeat循环)
        * [循环示例](md/9_01_流程控制结构.md#循环示例)
    </details>

---

**mysql高级**  

[相关脑图_html版](md/mysql_zhouyang.html)  
[相关脑图_MindManager版](md/mysql_zhouyang_yuan.mmap)  
<details>
<summary>mysql架构介绍</summary>

* [mysql架构介绍](md/mysql高级_01.mysql架构介绍.md#mysql架构介绍)
    * [高级mysql主要工作内容](md/mysql高级_01.mysql架构介绍.md#高级mysql主要工作内容)
    * [修改mysql.cnf配置文件](md/mysql高级_01.mysql架构介绍.md#修改mysql.cnf配置文件)
    * [主要配置文件](md/mysql高级_01.mysql架构介绍.md#主要配置文件)
        * [主要日志文件](md/mysql高级_01.mysql架构介绍.md#主要日志文件)
        * [数据文件](md/mysql高级_01.mysql架构介绍.md#数据文件)
    * [mysql逻辑架构](md/mysql高级_01.mysql架构介绍.md#mysql逻辑架构)
    * [MyiSAM与InnoDB引擎对比](md/mysql高级_01.mysql架构介绍.md#MyiSAM与InnoDB引擎对比)
</details>

<details>
<summary>索引优化分析</summary>

* [引入索引话题](md/mysql高级_02.索引优化分析.md#引入索引话题)
    * [mysql性能下降、sql慢可能原因](md/mysql高级_02.索引优化分析.md#mysql性能下降sql慢可能原因)
    * [sql的执行顺序](md/mysql高级_02.索引优化分析.md#sql的执行顺序)
[7种join连接查询](./2_07_DQL数据查询语言.连接查询.md#连接查询总结)
* [索引简介](md/mysql高级_02.索引优化分析.md#索引简介)
    * [索引分类](md/mysql高级_02.索引优化分析.md#索引分类)
    * [索引类型](md/mysql高级_02.索引优化分析.md#索引类型)
    * [索引名命名规范](md/mysql高级_02.索引优化分析.md#索引名的命名规范)
    * [增查改删索引](md/mysql高级_02.索引优化分析.md#增查改删索引)
    * [需要创建索引情况](md/mysql高级_02.索引优化分析.md#需要创建索引情况)
    * [不适合建索引的情况](md/mysql高级_02.索引优化分析.md#不适合建索引的情况)
* [mysql性能分析和相关指标](md/mysql高级_02.索引优化分析.md#mysql性能分析和相关指标)
    * [explain + sql语句 分析](md/mysql高级_02.索引优化分析.md#explain--sql语句-分析)
    * [explain查询结果各字段含义列表](md/mysql高级_02.索引优化分析.md#explain查询结果各字段含义列表)
    * [explain查询结果各字段含义详解](md/mysql高级_02.索引优化分析.md#explain查询结果各字段含义详解)
        * [id](md/mysql高级_02.索引优化分析.md#id)
        * [select_type](md/mysql高级_02.索引优化分析.md#select_type)
        * [table](md/mysql高级_02.索引优化分析.md#table)
        * [type](md/mysql高级_02.索引优化分析.md#type)
            * [type性能比较](md/mysql高级_02.索引优化分析.md#type性能比较)
        * [possible_keys](md/mysql高级_02.索引优化分析.md#possible_keys)
        * [key](md/mysql高级_02.索引优化分析.md#key)
        * [key_len](md/mysql高级_02.索引优化分析.md#key_len)
        * [Extra](md/mysql高级_02.索引优化分析.md#Extra)
            * [Extra性能比较](md/mysql高级_02.索引优化分析.md#Extra性能比较)
    * [explain示例](md/mysql高级_02.索引优化分析.md#explain示例)
* [连接查询索引优化](md/mysql高级_02.索引优化分析.md#连接查询索引优化)
    * [单表查询分析](md/mysql高级_02.索引优化分析.md#单表查询分析)
    * [两表连接查询分析](md/mysql高级_02.索引优化分析.md#两表连接查询分析)
        * [两表join连接查询优化总结](md/mysql高级_02.索引优化分析.md#两表join连接查询优化总结)
    * [三表连接查询分析](md/mysql高级_02.索引优化分析.md#三表连接查询分析)
        * [三表join连接查询优化总结](md/mysql高级_02.索引优化分析.md#三表join连接查询优化总结)
* [索引失效案例](md/mysql高级_02.索引优化分析.md#索引失效案例)
    * [全值匹配我最爱](md/mysql高级_02.索引优化分析.md#全值匹配我最爱)
    * [最佳左前缀法则](md/mysql高级_02.索引优化分析.md#最佳左前缀法则)
    * [不在索引列上做任何操作](md/mysql高级_02.索引优化分析.md#不在索引列上做任何操作)
    * [索引范围条件右边的索引列失效](md/mysql高级_02.索引优化分析.md#索引范围条件右边的索引列失效)
    * [尽量使用覆盖索引](md/mysql高级_02.索引优化分析.md#尽量使用覆盖索引)
    * [使用不等于(!=或者<>)时索引失效导致全表扫描](md/mysql高级_02.索引优化分析.md#使用不等于=或者时索引失效导致全表扫描)
    * [is null、is not null无法使用索引](md/mysql高级_02.索引优化分析.md#is-nullis-not-null无法使用索引)
    * [like以通配符开头，索引失效导致全表扫描](md/mysql高级_02.索引优化分析.md#like以通配符开头索引失效导致全表扫描)
    * [解决like '%字符串%' 索引失效方法:覆盖索引](md/mysql高级_02.索引优化分析.md#解决like-字符串-索引失效方法覆盖索引)
        * [情况8_5_1: 未建索引](md/mysql高级_02.索引优化分析.md#情况8_5_1-未建索引)
        * [情况8_5_2: 建立索引，index (name, age)](md/mysql高级_02.索引优化分析.md#情况8_5_2-建立索引index-name-age)
        * [解决like'%字符串%'索引不被使用问题的方法小结](md/mysql高级_02.索引优化分析.md#解决like字符串索引不被使用问题的方法小结)
    * [字符串不加单引号索引失效](md/mysql高级_02.索引优化分析.md#字符串不加单引号索引失效)
    * [少用or，用它连接时索引失效](md/mysql高级_02.索引优化分析.md#少用or用它连接时索引失效)
    * [索引案例小结](md/mysql高级_02.索引优化分析.md#索引案例小结)
    * [索引优化小总结口诀](md/mysql高级_02.索引优化分析.md#索引优化小总结口诀)
* [索引使用示例](md/mysql高级_02.索引优化分析.md#索引使用示例)
    * [根据上面创建的索引idx_test03_c1_c2_c3_c4 (c1, c2, c3, c4), 分析以下SQL语句使用索引的情况](md/mysql高级_02.索引优化分析.md#根据上面创建的索引idx_test03_c1_c2_c3_c4-c1-c2-c3-c4-分析以下SQL语句使用索引的情况)
    * [小结](md/mysql高级_02.索引优化分析.md#小结)
* [索引优化一般性建议](md/mysql高级_02.索引优化分析.md#索引优化一般性建议)
</details>

<details>
<summary>查询截取分析</summary>

* [查询优化](md/mysql高级_03.查询截取分析.md#查询优化)
    * [小表驱动大表示例](md/mysql高级_03.查询截取分析.md#小表驱动大表示例)
    * [order by关键字优化](md/mysql高级_03.查询截取分析.md#order-by关键字优化)
        * [order by排序方式案例](md/mysql高级_03.查询截取分析.md#order-by排序方式案例)
        * [如何让order by使用index方式排序](md/mysql高级_03.查询截取分析.md#如何让order-by使用index方式排序)
        * [filesort排序的两种算法](md/mysql高级_03.查询截取分析.md#filesort排序的两种算法)
            * [双路排序算法](md/mysql高级_03.查询截取分析.md#双路排序算法)
            * [单路算法](md/mysql高级_03.查询截取分析.md#单路算法)
        * [order by相关的优化策略](md/mysql高级_03.查询截取分析.md#order-by相关的优化策略)
        * [order by关键字小结](md/mysql高级_03.查询截取分析.md#order-by关键字小结)
    * [group by关键字优化](md/mysql高级_03.查询截取分析.md#group-by关键字优化)
* [慢查询日志](md/mysql高级_03.查询截取分析.md#慢查询日志)
    * [临时开启慢查询日志](md/mysql高级_03.查询截取分析.md#临时开启慢查询日志)
    * [永久开启慢查询日志](md/mysql高级_03.查询截取分析.md#永久开启慢查询日志)
    * [查看慢查询日志](md/mysql高级_03.查询截取分析.md#查看慢查询日志)
    * [mysqldumpshow慢查询日志分析工具](md/mysql高级_03.查询截取分析.md#mysqldumpshow慢查询日志分析工具)
        * [mysqldumpshow工作常用参考](md/mysql高级_03.查询截取分析.md#mysqldumpshow工作常用参考)
* [批量插入数据脚本](md/mysql高级_03.查询截取分析.md#批量插入数据脚本)
* [show profiles、show profile性能查看与分析](md/mysql高级_03.查询截取分析.md#show-profilesshow-profile性能查看与分析)
    * [开启性能收集功能](md/mysql高级_03.查询截取分析.md#开启性能收集功能)
    * [show profiles](md/mysql高级_03.查询截取分析.md#show-profiles)
    * [show profile](md/mysql高级_03.查询截取分析.md#show-profile)
    * [日常开发需要注意的事项](md/mysql高级_03.查询截取分析.md#日常开发需要注意的事项)
* [Performance Schema性能查看与分析](md/mysql高级_03.查询截取分析.md#Performance-Schema性能查看与分析)
    * [使用Performance Schema准备工作](md/mysql高级_03.查询截取分析.md#使用Performance-Schema准备工作)
    * [执行要分析性能的SQL语句](md/mysql高级_03.查询截取分析.md#执行要分析性能的SQL语句)
    * [Performance Schema查看性能与分析](md/mysql高级_03.查询截取分析.md#Performance-Schema查看性能与分析)
* [sys Schema性能查看与分析](md/mysql高级_03.查询截取分析.md#sys-Schema性能查看与分析)
* [全局日志](md/mysql高级_03.查询截取分析.md#全局日志)
</details>

<details>
<summary>锁机制</summary>

* [mysql锁定义](md/mysql高级_04.锁机制.md#mysql锁定义)
* [锁的分类](md/mysql高级_04.锁机制.md#锁的分类)
* [MyISAM表锁](md/mysql高级_04.锁机制.md#MyISAM表锁)
    * [手动加表锁语法](md/mysql高级_04.锁机制.md#手动加表锁语法)
    * [查看表上加过的锁](md/mysql高级_04.锁机制.md#查看表上加过的锁)
    * [释放表锁(所有表)](md/mysql高级_04.锁机制.md#释放表锁所有表)
    * [表读锁案例](md/mysql高级_04.锁机制.md#表读锁案例)
    * [表写锁案例](md/mysql高级_04.锁机制.md#表写锁案例)
    * [表锁分析](md/mysql高级_04.锁机制.md#表锁分析)
* [InnoDB行锁](md/mysql高级_04.锁机制.md#InnoDB行锁)
    * [innodb表的表锁、行锁](md/mysql高级_04.锁机制.md#innodb表的表锁行锁)
    * [准备工作](md/mysql高级_04.锁机制.md#准备工作)
    * [行锁对于操作同一行将会阻塞](md/mysql高级_04.锁机制.md#行锁对于操作同一行将会阻塞)
    * [行锁对操作不同的行互不影响](md/mysql高级_04.锁机制.md#行锁对操作不同的行互不影响)
    * [无索引行锁升级为表锁](md/mysql高级_04.锁机制.md#无索引行锁升级为表锁)
    * [表中存在了一个行锁，其他会话再上表锁将被阻塞](md/mysql高级_04.锁机制.md#表中存在了一个行锁其他会话再上表锁将被阻塞)
    * [间隙锁危害](md/mysql高级_04.锁机制.md#间隙锁危害)
    * [innodb表手动锁定行](md/mysql高级_04.锁机制.md#innodb表手动锁定行)
    * [行锁分析](md/mysql高级_04.锁机制.md#行锁分析)
    * [补充](md/mysql高级_04.锁机制.md#补充)
        * [充实示例1](md/mysql高级_04.锁机制.md#充实示例1)
        * [充实示例2](md/mysql高级_04.锁机制.md#充实示例2)
    * [InnoDB表优化建议](md/mysql高级_04.锁机制.md#InnoDB表优化建议)
* [BDB页锁](md/mysql高级_04.锁机制.md#BDB页锁)
</details>

<details>
<summary>Mysql_InnoDB引擎的行锁和表锁</summary>
  
* [简介](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#简介)
* [行锁和表锁](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#行锁和表锁)
    * [锁的一些概念](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#锁的一些概念)
    * [行锁的类型](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#行锁的类型)
        * [加共享锁语法](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#加共享锁语法)
        * [加排它锁语法](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#加排它锁语法)
    * [行锁的实现](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#行锁的实现)
    * [示例0](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#示例0)
    * [示例1](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#示例1)
    * [示例2](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#示例2)
* [InnoDB四种锁共存逻辑关系](md/mysql高级_04.锁机制.Mysql_InnoDB引擎的行锁和表锁.md#InnoDB四种锁共存逻辑关系)
</details>

---

* 其他
    * [MySQL DBA技能](md/mysql_DBA技能.md)
    * [NavicatPremium客户端工具](md/NavicatPremium.md)
    * [SQLYog客户端工具](md/SQLYog.md)
    * [MySQL、PostgreSQL 、Oracle在线资料](https://www.techonthenet.com/mysql/index.php)
    * [sql分析方法](md/sql分析方法.md)
    * [primary key类型的选择](md/primary_key_and_type.md)
    * [Character Sets, Collations, Unicode](md/CharacterSets,Collations,Unicode.md)
        * [基本概念](md/CharacterSets,Collations,Unicode.md#基本概念)
        * [Collation Naming Conventions](md/CharacterSets,Collations,Unicode.md#Collation-Naming-Conventions)
        * [Server Character Set and Collation](md/CharacterSets,Collations,Unicode.md#Server-Character-Set-and-Collation)
        * [Database Character Set and Collation](md/CharacterSets,Collations,Unicode.md#Database-Character-Set-and-Collation)
        * [Table Character Set and Collation](md/CharacterSets,Collations,Unicode.md#Table-Character-Set-and-Collation)
        * [Column Character Set and Collation](md/CharacterSets,Collations,Unicode.md#Column-Character-Set-and-Collation)
        * [Character String Literal Character Set and Collation](md/CharacterSets,Collations,Unicode.md#Character-String-Literal-Character-Set-and-Collation)
        * [Connection Character Sets and Collations](md/CharacterSets,Collations,Unicode.md#Connection-Character-Sets-and-Collations)
