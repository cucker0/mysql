JSON Functions
==

## Table Of Contents
* [JSON Function Reference](#JSON-Function-Reference)
* [JSON path](#JSON-path)
* [Functions That Create JSON Values](#Functions-That-Create-JSON-Values)
    * [JSON_ARRAY()](#JSON_ARRAY)
    * [JSON_OBJECT()](#JSON_OBJECT)
    * [JSON_QUOTE()](#JSON_QUOTE)
* [Functions That Search JSON Values](#Functions-That-Search-JSON-Values)
    * [column->path](#column-path)
    * [column->>path](#column-path)
    * [JSON_EXTRACT()](#JSON_EXTRACT)
    * [JSON_CONTAINS()](#JSON_CONTAINS)
    * [JSON_CONTAINS_PATH()](#JSON_CONTAINS_PATH)
    * [JSON_KEYS(json_doc[, path])](#JSON_KEYSjson_doc-path)
    * [类似JSON_VALUES()函数的SQL](#类似JSON_VALUES函数的SQL)
    * [JSON_OVERLAPS()](#JSON_OVERLAPS)
    * [JSON_SEARCH()](#JSON_SEARCH)
    * [JSON_VALUE()](#JSON_VALUE)
    * [value MEMBER OF(json_array)](#value-MEMBER-OFjson_array)
* [Functions That Modify JSON Values](#Functions-That-Modify-JSON-Values)
    * [JSON_ARRAY_APPEND()](#JSON_ARRAY_APPEND)
    * [JSON_ARRAY_INSERT()](#JSON_ARRAY_INSERT)
    * [JSON_INSERT()](#JSON_INSERT)
    * [JSON_REPLACE()](#JSON_REPLACE)
    * [JSON_SET()](#JSON_SET)
    * [JSON_SET(), JSON_INSERT(), JSON_REPLACE()的对比](#JSON_SET-JSON_INSERT-JSON_REPLACE的对比)
    * [JSON_REMOVE()](#JSON_REMOVE)
    * [JSON_MERGE()](#JSON_MERGE)
    * [JSON_MERGE_PATCH()](#JSON_MERGE_PATCH)
    * [JSON_MERGE_PRESERVE()](#JSON_MERGE_PRESERVE)
    * [JSON_MERGE_PATCH()对比JSON_MERGE_PRESERVE()](#JSON_MERGE_PATCH对比JSON_MERGE_PRESERVE)
    * [JSON_UNQUOTE()](#JSON_UNQUOTE)
* [Functions That Return JSON Value Attributes](#Functions-That-Return-JSON-Value-Attributes)
    * [JSON_DEPTH(json_doc)](#JSON_DEPTHjson_doc)
    * [JSON_LENGTH(json_doc[, path])](#JSON_LENGTHjson_doc-path)
    * [JSON_TYPE(json_val)](#JSON_TYPEjson_val)
    * [JSON_VALID(val)](#JSON_VALIDval)
* [JSON Table Functions](#JSON-Table-Functions)
    * [JSON_TABLE()](#JSON_TABLE)
* [JSON Schema Validation Functions](#JSON-Schema-Validation-Functions)
    * [JSON_SCHEMA_VALID()](#JSON_SCHEMA_VALID)
    * [JSON_SCHEMA_VALIDATION_REPORT()](#JSON_SCHEMA_VALIDATION_REPORT)
* [JSON Utility Functions](#JSON-Utility-Functions)
    * [JSON_PRETTY(json_val)](#JSON_PRETTYjson_val)
    * [JSON_STORAGE_FREE(json_val)](#JSON_STORAGE_FREEjson_val)
    * [JSON_STORAGE_SIZE(json_val)](#JSON_STORAGE_SIZEjson_val)
    * [CAST()、CONVERT()](#CASTCONVERT)


## JSON Function Reference
[reference](https://dev.mysql.com/doc/refman/8.0/en/json-function-reference.html)

Name	|Description	|Introduced（开始引入的版本）	|Deprecated（是否废弃）| Example
:--- |:--- |:--- |:--- |:--- 
->	|Return value from JSON column after evaluating path; equivalent to JSON_EXTRACT().<br>获取JSON指定key或index下标的值，值由双引号包裹	 | | |`rest->"$.age"` <br>等价于 `JSON_EXTRACT(rest, "$.age")` <br>类似于js中的 rest["age"] <br>获取json数组下标的值：`rest->"$[4][1]"`
->>	|Return value from JSON column after evaluating path and unquoting the result; <br>equivalent to JSON_UNQUOTE(JSON_EXTRACT()).<br>获取JSON指定key的值，值为对象，没有双引号包裹	 | | |rest->>"$.age"  <br>等价于 JSON_UNQUOTE(JSON_EXTRACT(rest, "$.age"))  
JSON_ARRAY()	|Create JSON array	<br>创建json数组 | | |`SELECT JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME());` 
JSON_ARRAY_APPEND()	|Append data to JSON document  <br>追加元素到JSON数组中 | | | 
JSON_ARRAY_INSERT()	|Insert into JSON array	<br>插入元素到JSON数组中	 | | | 
JSON_CONTAINS()	|Whether JSON document contains specific object at path	<br>在json文档指定的路径下是否包含给定的对象	 | | | 
JSON_CONTAINS_PATH()	|Whether JSON document contains any data at path	<br>json文档给定的一个或多个path是否包含数据| | | 
JSON_DEPTH()	|Maximum depth of JSON document	<br>JSON文档的最大深度 | | | 
JSON_EXTRACT()	|Return data from JSON document <br>获取JSON文档指定path的值 | | | 
JSON_INSERT()	|Insert data into JSON document	<br>插入数据到json文档中指定的path处，若path存在，则不插入| | | 
JSON_KEYS()	|Array of keys from JSON document <br>获取指定JSON文档（或给定path处）的key集合，返回结果为数组 | | | 
JSON_LENGTH()	|Number of elements in JSON document <br>获取JSON文档的元素个数 | | | 
JSON_MERGE()	|Merge JSON documents, preserving duplicate keys. <br>Deprecated synonym for JSON_MERGE_PRESERVE()	<br>合并多个JSON|	|Yes |`SELECT JSON_MERGE('[1, 2]', '[true, false]');` <br>结果为[1, 2, true, false] 
JSON_MERGE_PATCH()	|Merge JSON documents, replacing values of duplicate keys。	<br>合并多个JSON，相同的path会被后面的JSON对应的值覆盖 |8.0.3 | |`SELECT JSON_MERGE_PATCH('[1, 2]', '[true, false]');` <br>结果为[true, false] <br>`SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}');` <br>结果为 {"id": 47, "name": "x"}
JSON_MERGE_PRESERVE()	|Merge JSON documents, preserving duplicate keys <br>合并多个JSON，保存重复的key | | | 
JSON_OBJECT()	|Create JSON object	<br>创建JSON对象| | |`SELECT JSON_OBJECT('id', 87, 'name', 'carrot');` 
JSON_OVERLAPS()	|Compares two JSON documents, <br>returns TRUE (1) if these have any key-value pairs or array elements in common, <br>otherwise FALSE (0) <br>比较两个JSON，主要有一个key-value对或元素相同，返回true(1)，否则返回false(0) |8.0.17 | |`SELECT JSON_OVERLAPS("[1,3,5,7]", "[2,6,7]");` <br>结果为1 <br>`SELECT JSON_OVERLAPS('{"a":1,"b":10,"d":10}', '{"a":5,"e":10,"f":1,"d":20}');`  <br>结果为0
JSON_PRETTY()	|Print a JSON document in human-readable format	<br>打印友好格式化的JSON| | | 
JSON_QUOTE()	|Quote JSON document <br>给JSON文档加双引号包裹| | |`SELECT JSON_QUOTE('[1, 2, 3]');` <br>结果为 "[1, 2, 3]"  
JSON_REMOVE()	|Remove data from JSON document	<br>删除JSON文档中的数据| | |`SET @j = '["a", ["b", "c"], "d"]';` <br>`SELECT JSON_REMOVE(@j, '$[1]');` <br>结果为 ["a", "d"]   
JSON_REPLACE()	|Replace values in JSON document <br>替换JSON中指定path的值| | |`SET @j = '{ "a": 1, "b": [2, 3]}';`  <br>`SELECT JSON_REPLACE(@j, '$.a', 10, '$.c', '[true, false]');` <br>结果为{"a": 10, "b": [2, 3]}
JSON_SCHEMA_VALID()	|Validate JSON document against JSON schema; <br>returns TRUE/1 if document validates against schema, <br>or FALSE/0 if it does not	|8.0.17 | | 
JSON_SCHEMA_VALIDATION_REPORT()	|Validate JSON document against JSON schema; <br>returns report in JSON format on outcome on validation <br>including success or failure and reasons for failure	|8.0.17	| | 
JSON_SEARCH()	|Path to value within JSON document	<br>搜索给定对象在JSON中的path| | |`SET @j = '["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]';` <br>`SELECT JSON_SEARCH(@j, 'one', 'abc');` <br>结果为"$[0]" <br>`SELECT JSON_SEARCH(@j, 'all', 'abc');` <br>结果为["$[0]", "$[2].x"]  
JSON_SET()	|Insert data into JSON document	<br>插入或更新JSON文档数据（path存在则更新，否则插入），并返回操作后的JSON| | |`SET @j = '{ "a": 1, "b": [2, 3]}';` <br>`SELECT JSON_SET(@j, '$.a', 10, '$.c', '[true, false]');` <br>结果为{"a": 10, "b": [2, 3], "c": "[true, false]"} 
JSON_STORAGE_FREE()	|Freed space within binary representation of JSON column value following partial update	<br>显示JSON数据部分更新后，该字段的空闲存储空间(单位：bit)| | | 
JSON_STORAGE_SIZE()	|Space used for storage of binary representation of a JSON document	<br>显示存储JSON文档占用的空间(单位：bit)| | | 
JSON_TABLE()	|Return data from a JSON expression as a relational table <br>以关系表的形式从JSON表达式返回数据| | | 
JSON_TYPE()	|Type of JSON value <br>返回JSON值的类型| | | 
JSON_UNQUOTE()	|Unquote JSON value	 <br>JSON值不使用双引号包裹| | | 
JSON_VALID()	|Whether JSON value is valid <br>判断JSON值是否合法| | | 
JSON_VALUE()	|Extract value from JSON document at location pointed to by path provided; <br>return this value as VARCHAR(512) or specified type	<br>获取JSON中指定path的值，并转为指定的类型|8.0.21	| | 
value MEMBER OF()	|Returns true (1) if first operand matches any element of JSON <br>array passed as second operand, <br>otherwise returns false (0) <br>判断给定的对象是不是JSON的成员|8.0.17 | |`SELECT 'ab' MEMBER OF('[23, "abc", 17, "ab", 10]');` <br>结果为1
JSON_ARRAYAGG() |Aggregates a result set as a single JSON array whose elements consist of the rows. <br>将结果集聚合为单个JSON数组，该数组的元素由查询出的记录中的字段组成。 | | | 
JSON_OBJECTAGG() |Takes two column names or expressions as arguments, the first of these being used as a key and the second as a value, and returns a JSON object containing key-value pairs. <br>将两个列名或表达式作为参数，第一个作为key，第二个作为value，并返回包含key-value对的JSON对象。| | | 


## JSON path
path写法总结：
* path 需要使用双引号包裹(或用单引号包裹)。
* 以`$`开头。`$`表示JSON本身。可以直接写`"$"`
* key写法：.key  
    `'$.*'` 表示所有key  
    `'$.*.*'`
* 数组下标：[index]，
    * 暂时不支持`-1`这种倒序写法。
    * index范围：>= 0的整数
    * `'$[*]'` 所有下标
    
## Functions That Create JSON Values
### JSON_ARRAY()
创建JSON数组，即list(类似Java，python中的list)

* 语法
    ```text
    JSON_ARRAY([val[, val] ...])
    ```
* 示例
    ```mysql
    SELECT JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME());

    /* 结果：
    JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME())  
    ---------------------------------------------
    [1, "abc", null, true, "02:29:18.000000"]    
    */
    ```

### JSON_OBJECT()
创建JSON对象，即JSON map（类似python中的dict）

* 语法
    ```text
    JSON_OBJECT([key, val[, key, val] ...])
    ```
    
* 示例


### JSON_QUOTE()
使用双引号包裹整个JSON值，即JSON对象做JSON字符串化

* 语法
    ```text
    JSON_QUOTE(string)
    ```
    若参数为`NULL`，则返回`NULL`
    
* 示例
    ```mysql
    SELECT JSON_QUOTE('null'), JSON_QUOTE('"null"');

    /* 结果：
    JSON_QUOTE('null')  JSON_QUOTE('"null"')  
    ------------------  ----------------------
    "null"              "\"null\""    
    */
    
    SELECT JSON_QUOTE('[1, 2, 3]'), JSON_QUOTE('{"total": 2300}');
    /* 结果：
    JSON_QUOTE('[1, 2, 3]')  JSON_QUOTE('{"total": 2300}')  
    -----------------------  -------------------------------
    "[1, 2, 3]"              "{\"total\": 2300}"                       
    */
    ```

## Functions That Search JSON Values
* 测试用到的表及SQL
    ```mysql
    CREATE TABLE jemp (
       g INT,
       c JSON
    );
    
    INSERT INTO jemp(g, c) VALUES
    (1, '{"id": 1, "name": "Niki"}'),
    (2, '{"id": 2, "name": "Wilma"}'),
    (3, '{"id": 3, "name": "Barney"}'),
    (4, '{"id": 4, "name": "Betty"} ')
    ;
    ```


### column->path
获取JSON_doc中指定path的值，返回的值被双引号包裹

column->path 是 JSON_EXTRACT(json_doc, path)别名写法，它们是等价的，注意此时 JSON_EXTRACT 函数有两上参数。

* 语法
    ```text
    // JSON对象获取key对应的值 (map/dict类型)
    column->"$.key"
    column->'$.key'
    column->"$.key.key2"
    
    // JSON数组获取元素的值 (list类型)
    column->"$[index_number]"
    column->"$[0][2]"
    column->"$[0][*]"  // 等价于 column->"$[0]"

    // JSON内有对象与数组的组合(包含map、list)
    column->"$.key[index_number].key2"
    如：
    column->"$.data[0].hostname"
    ```
 
* map类型的JSON的值的操作

    * 查询JSON的值，JSON值作为查询条件，以JSON值排序
        ```mysql
        SELECT c, JSON_EXTRACT(c, "$.id"), g 
        FROM jemp
        WHERE JSON_EXTRACT(c, "$.id") > 1
        ORDER BY JSON_EXTRACT(c, "$.name")
        ;
        /*
        c                            JSOn_EXTRACt(c, "$.id")       g  
        ---------------------------  -----------------------  --------
        {"id": 3, "name": "Barney"}  3                               3
        {"id": 4, "name": "Betty"}   4                               4
        {"id": 2, "name": "Wilma"}   2                               2
        */
        
        -- 等价于 上面的写法
        SELECT c, c->"$.id", g
        FROM jemp
        WHERE c->"$.id" > 1
        ORDER BY c->"$.name"
        ;
        
        /*
        c                            c->"$.id"       g  
        ---------------------------  ---------  --------
        {"id": 3, "name": "Barney"}  3                 3
        {"id": 4, "name": "Betty"}   4                 4
        {"id": 2, "name": "Wilma"}   2                 2
        */
        ```
    
    * JSON值作为WHERE的匹配条件
        ```mysql
        ALTER TABLE jemp ADD COLUMN n INT;
        UPDATE jemp SET n=1 WHERE c->"$.id" = 4;
        
        SELECT c, c->"$.id", g, n
        FROM jemp
        WHERE c->"$.id" > 1
        ORDER BY c->"$.name"
        ;
        /*
        c                            c->"$.id"       g       n  
        ---------------------------  ---------  ------  --------
        {"id": 3, "name": "Barney"}  3               3    (NULL)
        {"id": 4, "name": "Betty"}   4               4         1
        {"id": 2, "name": "Wilma"}   2               2    (NULL)
        */
        
      
       ## JSON值作为WHERE的匹配条件
        DELETE FROM jemp WHERE c->"$.id" = 4;
        
        SELECT c, c->"$.id", g, n
        FROM jemp
        WHERE JSON_EXTRACT(c, "$.id") > 1
        ORDER BY c->"$.name"
        ;
        /*
        c                            c->"$.id"       g       n  
        ---------------------------  ---------  ------  --------
        {"id": 3, "name": "Barney"}  3               3    (NULL)
        {"id": 2, "name": "Wilma"}   2               2    (NULL)
        */
        ```
    
    * 多层key
        ```mysql
        INSERT INTO jemp(c, g) VALUES
        ('{"kkk": {"kk": {"k": 111}}, "jjj": {"jj": {"j": 222}}}', 5);
        
        SELECT c->"$.kkk.kk" FROM jemp WHERE g=5;
        /*
        c->"$.kkk.kk"  
        ---------------
        {"k": 111}     
        */
        DELETE FROM jemp WHERE c->"$.kkk.kk.k" = 111;
      ```
      
* list类型的JSON的值的操作
    ```mysql
    ## 数组
    INSERT INTO jemp(c, g) VALUES
    ("[3,10,5,17,44]", 33),
    ("[3,10,5,17,[22,44,66]]", 34);
    
    SELECT c->"$[4]" FROM jemp WHERE g >=33 AND g <= 34;
    /*
    c->"$[4]"     
    --------------
    44            
    [22, 44, 66] 
    */
    
    SELECT * FROM jemp WHERE c->"$[0]" = 3;
    /*
         g  c                                  n  
    ------  ----------------------------  --------
        33  [3, 10, 5, 17, 44]              (NULL)
        34  [3, 10, 5, 17, [22, 44, 66]]    (NULL)
    */
    ```
    
    * 多维数组
        ```mysql
        ### 多维数组
        SELECT * FROM jemp
        WHERE c->"$[4][1]" IS NOT NULL;
        /*
             g  c                                  n  
        ------  ----------------------------  --------
            34  [3, 10, 5, 17, [22, 44, 66]]    (NULL)
        */
        ```

* map与list组合型的JSON
    ```mysql
    ### map与list组合
    INSERT INTO jemp(c, g) VALUES
    ('{"data": [{"hostname": "webserv1", "ip": "172.17.0.2"}, 11, 22, 33], "code": 0}', 35),
    ('{"data": [{"hostname": "webserv2", "ip": "172.17.0.3"}, 44, 55, 66], "code": 0}', 36);
    
    SELECT c->"$.data[0].hostname" FROM jemp WHERE g = 35;
    ```

### column->>path
获取JSON文档中指定path的值，并去掉值包裹值的双引号，返回的值不包含外层的双引号。

这是JSON_UNQUOTE( JSON_EXTRACT(column, path) )的改进版

下面三种写法，返回的值都是一样的
```text
column->>path
JSON_UNQUOTE(column -> path)
JSON_UNQUOTE( JSON_EXTRACT(column, path) )
```

* 示例
    ```mysql
    SELECT c->"$.name" AS 'name' FROM jemp WHERE g > 2 AND g < 5;
    /*
    name      
    ----------
    "Barney"  
    "Betty"  
    */
    
    -- 以下两条SQL等价，查询结果也一样
    SELECT JSON_UNQUOTE(c->"$.name") AS 'name' FROM jemp WHERE g > 2 AND g < 5;
    SELECT c->>"$.name" AS 'name' FROM jemp WHERE g>2 AND g < 5;
    /*
    name    
    --------
    Barney  
    Betty  
    */
    ```

* 示例2
    ```mysql
    INSERT INTO jemp(c, g) VALUES
    ('[3, 10, 5, "x", 44]', 37),
    ('[3, 10, 5, 17, [22, "y" , 66]]', 38)
    ;
    
    SELECT c->'$[3]', c->'$[4][1]' FROM jemp 
    WHERE g = 37 OR g = 38;
    /*
    c->'$[3]'  c->'$[4][1]'  
    ---------  --------------
    "x"        (NULL)        
    17         "y"           
    */
    
    SELECT c->>'$[3]', c->>'$[4][1]' FROM jemp 
    WHERE g = 37 OR g = 38;
    /*
    c->>'$[3]'  c->>'$[4][1]'  
    ----------  ---------------
    x           (NULL)         
    17          y              
    */
    ```

### JSON_EXTRACT()
获取json_doc指定path下的值。

* 语法
    ```text
    JSON_EXTRACT(json_doc, path[, path] ...)
    ```
* 示例
    ```mysql
    SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[1]');
    /*
    json_extract('[10, 20, [30, 40]]', '$[1]')  
    --------------------------------------------
    20                                          
    */
    
    -- JSON_EXTRACT() 获取多个path位置的值，返回值组合成一个json数组
    SELECT JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[1]', '$[3]');
    /*
    json_extract('[10, 20, [30, 40], 50]', '$[1]', '$[3]')  
    --------------------------------------------------------
    [20, 50]                                                
    */
    
    SELECT JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[2][*]');
    /*
    JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[2][*]')  
    ---------------------------------------------------
    [30, 40]                                           
    */
    ```

* 有意思的例子(`'$[*][*]'`, `'$.*'`, `'$.*.*'`)
    ```mysql
    SELECT JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[*][*]');
    /*
    JSON_EXTRACT('[10, 20, [30, 40], 50]', '$[*][*]')  
    ---------------------------------------------------
    [30, 40]                                           
    */
    
    SELECT JSON_EXTRACT('[10, 20, [30, 40], 50, [311, 411]]', '$[*][*]');
    /*
    JSON_EXTRACT('[10, 20, [30, 40], 50, [311, 411]]', '$[*][*]')  
    ---------------------------------------------------------------
    [30, 40, 311, 411]                                             
    */
    
    -- '$.*' 获取所有的值
    SELECT JSON_EXTRACT('{"k1":11, "k2": [22, 33]}', '$.*');
    /*
    json_extract('{"k1":11, "k2": [22, 33]}', '$.*')  
    --------------------------------------------------
    [11, [22, 33]]                                    
    */
    
    -- '$.*.*'
    SELECT JSON_EXTRACT('{"k1":11, "k2": {"k21":21, "k22":22}}', '$.*.*');
    /*
    JSON_EXTRACT('{"k1":11, "k2": {"k21":21, "k22":22}}', '$.*.*')  
    ----------------------------------------------------------------
    [21, 22]                                                        
    */
    ```

### JSON_CONTAINS()
判断给定的json_doc是否被包含在target json_doc中。

如果指定path，则表示 判断给定的json_doc是否被包含在target json_doc 指定的path中。

返回值：1：是
      0：否

* 语法
    ```text
    JSON_CONTAINS(target, candidate[, path])
    ```
    * target  
        一个json_doc
    * candidate  
        json_doc
        
* 示例
    ```mysql
    SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1', '$.a');
    /*
    json_contains('{"a":1, "b":2, "c":{"d":4}}', '1', '$.a')  
    ----------------------------------------------------------
                                                             1
    */
    
    SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1', '$.b');
    /*
    JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1', '$.b')  
    ----------------------------------------------------------
                                                             0
    */
    
    SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.b');
    /*
    json_contains('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.b')  
    ----------------------------------------------------------------
    */
    
    SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.c');
    /*
    JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"d":4}', '$.c')  
    ----------------------------------------------------------------
                                                                   1
    */
    
    SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1');
    /*
    JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '1')  
    ---------------------------------------------------
                                                      0
    */
    
    SELECT JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"a":1}');
    /*
    JSON_CONTAINS('{"a":1, "b":2, "c":{"d":4}}', '{"a":1}')  
    ---------------------------------------------------------
                                                            1
    */
    
    SELECT JSON_CONTAINS('[11, 22, 33, 44]', '[44]');
    /*
    JSON_CONTAINS('[11, 22, 33, 44]', '[44]')  
    -------------------------------------------
                                              1
    */
    
    SELECT JSON_CONTAINS('[11, 22, 33, 44]', '44');
    /*
    JSON_CONTAINS('[11, 22, 33, 44]', '44')  
    -----------------------------------------
                                            1
    */
    
    SELECT JSON_CONTAINS('[11, 22, 33, 44]', '[11, 33]');
    /*
    JSON_CONTAINS('[11, 22, 33, 44]', '[11, 33]')  
    -----------------------------------------------
                                                  1
    */
    
    SELECT JSON_CONTAINS('[11, 22, 33, 44]', '11', '$[0]');
    /*
    JSON_CONTAINS('[11, 22, 33, 44]', '11', '$[0]')  
    -------------------------------------------------
                                                    1
    */
    ```

### JSON_CONTAINS_PATH()
判断在json_doc指定的一个path或多个path是否有数据。

* 语法
    ```text
    JSON_CONTAINS_PATH(json_doc, one_or_all, path[, path] ...)
    ```
    * one_or_all
        该参数的可选值：`'one'`, `'all'` .
    * 'one'  
        如果在指定的path中只要有一个path有数据，则返回`1`，否则返回`0`
    * 'all'  
        如果在指定的path中所有的path都有数据，则返回`1`，否则返回`0`
* 示例
    ```mysql
    SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a', '$.e');
    /*
    json_contains_path('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a', '$.e')  
    ------------------------------------------------------------------------
                                                                           1
    */
    
    SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'all', '$.a', '$.e');
    /*
    JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'all', '$.a', '$.e')  
    ------------------------------------------------------------------------
                                                                           0
    */
    
    SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.c.d');
    /*
    json_contains_path('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.c.d')  
    -------------------------------------------------------------------
                                                                      1
    */
    
    SELECT JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a.d');
    /*
    JSON_CONTAINS_PATH('{"a":1, "b":2, "c":{"d":4}}', 'one', '$.a.d')  
    -------------------------------------------------------------------
                                                                      0
    */
    ```

### JSON_KEYS(json_doc[, path])
返回JSON对象的key集合，值为JSON数组。

默认返回顶层的keys，也可以指定获取keys的path

当传入的 json_doc 为JSON数组时，返回值为NULL

* 示例
    ```mysql
    SELECT JSON_KEYS('{"a": 1, "b": {"c": 30}}');
    /*
    JSON_KEYS('{"a": 1, "b": {"c": 30}}')  
    ---------------------------------------
    ["a", "b"]  
    */
    
    SELECT JSON_KEYS('[11, 22, 33, {"k1": 100}]');
    -- 结果为 NULL
    
    SELECT c FROM jemp WHERE g = 5;
    /*
    c                                                       
    --------------------------------------------------------
    {"jjj": {"jj": {"j": 222}}, "kkk": {"kk": {"k": 111}}}  
    */
    
    SELECT JSON_KEYS(c) FROM jemp WHERE g = 5;
    /*
    JSON_KEYs(c)    
    ----------------
    ["jjj", "kkk"]  
    */
    
    SELECT JSON_KEYS(c, "$.kkk.kk") FROM jemp WHERE g = 5;
    /*
    JSON_KEYS(c, "$.kkk.kk")  
    --------------------------
    ["k"]                     
    */
    ```

### 类似JSON_VALUES()函数的SQL
获取json_doc对象的所有值，返回一个json数组。

MySQL中暂未提供 JSON_VALUES() 函数，但可以通过其它的方式达到同样的效果

* 语法
    ```text
    json_doc->'$.*'
    
    json_doc->>'$.*'
    
    JSON_EXTRACT(json_doc, '$.*')
    ```

* 示例
    ```mysql
    SELECT c FROM jemp WHERE g = 1;
    /*
    c                           
    ----------------------------
    {"id": 1, "name": "Nicki"}  
    */
    
    -- 类似 JSON_VALUES()，Mysql暂未提供 JSON_VALUES()函数
    SELECT c->'$.*' FROM jemp WHERE g = 1;
    SELECT c->>'$.*' FROM jemp WHERE g = 1;
    /*
    c->'$.*'      
    --------------
    [1, "Nicki"]  
    */
    
    -- 等同上面的SQL效果
    SELECT JSON_EXTRACT(c, '$.*') FROM jemp WHERE g = 1;
    /*
    JSON_extract(c, '$.*')  
    ------------------------
    [1, "Nicki"]            
    */

    ```

### JSON_OVERLAPS()
比较两个JSON_doc是否有相同的key-value或数组元素，

如果有返回true(1)，否则false(0)。

* 语法
    ```text
    JSON_OVERLAPS(json_doc1, json_doc2)
    ```
    * When comparing objects, the result is true if they have at least one key-value pair in common.
    
* 示例
    ```mysql
    SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '[2, 5, 7]');
    /*
    JSON_OVERLAPS('[1, 3, 5, 7]', '[2, 5, 7]')  
    --------------------------------------------
                                               1
    */
    
    SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 7]');
    /*
    JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 7]')  
    ------------------------------------------------
                                                   1
    */
    
    SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 300]');
    /*
    JSON_OVERLAPS('[1, 3, 5, 7]', '[100, 200, 300]')  
    --------------------------------------------------
                                                     0
    */
    
    SELECT JSON_OVERLAPS('[1, 3, 5, 7]', '1');
    /*
    JSON_OVERLAPS('[1, 3, 5, 7]', '1')  
    ------------------------------------
                                       1
    */
    
    -- 部分匹配视为不匹配
    SELECT JSON_OVERLAPS('[[1,2], [3,4], 5]', '[1, [2,3]]');
    /*
    JSON_OVERLAPS('[[1,2], [3,4], 5]', '[1, [2,3]]')  
    --------------------------------------------------
                                                     0
    */
    
    -- When comparing objects, the result is true if they have at least one key-value pair in common.
    SELECT JSON_OVERLAPS('{"a":1, "b":10, "d":10}', '{"c":1, "e":10, "f":1, "d":10}');
    /*
    JSON_OVERLAPS('{"a":1,"b":10,"d":10}', '{"c":1,"e":10,"f":1,"d":10}')  
    -----------------------------------------------------------------------
                                                                         1
    */
    
    SELECT JSON_OVERLAPS('{"a":1, "b":10, "d":10}', '{"a":5, "e":10, "f":1, "d":20}');
    /*
    JSON_OVERLAPS('{"a":1, "b":10, "d":10}', '{"a":5, "e":10, "f":1, "d":20}')  
    ----------------------------------------------------------------------------
                                                                               0
    */
    
    SELECT JSON_OVERLAPS('5', '5');
    /*
    JSON_OVERLAPS('5', '5')  
    -------------------------
                            1
    */
    
    SELECT JSON_OVERLAPS('5', '6');
    /*
    JSON_OVERLAPS('5', '6')  
    -------------------------
                            0
    */
    
    SELECT JSON_OVERLAPS('[4, 5, 6, 7]', '6');
    /*
    JSON_OVERLAPS('[4,5,6,7]', '6')  
    ---------------------------------
                                    1
    */
    
    SELECT JSON_OVERLAPS('[4, 5, "6", 7]', '6');
    /*
    JSON_OVERLAPS('[4,5,"6",7]', '6')  
    -----------------------------------
                                      0
    */
    
    SELECT JSON_OVERLAPS('[4, 5, 6, 7]', '"6"');
    /*
    JSON_OVERLAPS('[4, 5, 6, 7]', '"6"')  
    --------------------------------------
                                         0
    */
    ```

### JSON_SEARCH()
获取给定的 字符串 在 json_doc中的path。


* 语法
    ```text
    JSON_SEARCH(json_doc, one_or_all, search_str[, escape_char[, path] ...])
    ```
    * 当 `json_doc`、`search_str` 或 `path`中任意一个为NULL时，将返回`NULL`。
    * 当`path`不存在于`json_doc`，或 `search_str` 不存在于`json_doc`时，返回`NULL`
    * `json_doc`不合法、给定的任意一个`path`不合法、`one_or_all`参数不是`'one'`或`'all'`、
        `escape_char`参数不是一个常量表达式时，将发生错误。
        
    * `'one'`  
        `search_str`在json_doc匹配到第一个`path`时终止搜索，并返回该`path`。
    * `'all'`  
        返回所有 `search_str`在json_doc匹配到的`path`结果，不包括重复的`path`。  
        如果有多个`path`则自动把结果包装为json数组。
    * `search_str`中可以包含通配符，  
        例如：`%`, `_` 与SQL中的LIKE操作类似。  
        `%`：匹配0个或多个任意字符。
        `_`：匹配一个任意的字符。  
        如果要使用`%`, `_`的字面含义，可以在其见面加转义符，默认的转义符为`\ `
    * `escape_char`  
        指定转义符，必须是一个常量表达式。用法类似SQL中的`ESCAPE`

* 示例
    ```mysql
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'one',  'abc');
    /*
    JSON_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'one',  'abc')  
    ---------------------------------------------------------------------------------------
    "$[0]"                                                                                 
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'abc');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'abc')  
    ---------------------------------------------------------------------------------------
    ["$[0]", "$[2].x"]                                                                     
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'haha');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all',  'haha')  
    ---------------------------------------------------------------------------------------
    NULL
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 10);
    /*
    json_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 10)  
    -----------------------------------------------------------------------------------
    "$[1][0].k"                                                                        
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$')  
    ------------------------------------------------------------------------------------------------
    "$[1][0].k"                                                                                     
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*]');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*]')  
    ---------------------------------------------------------------------------------------------------
    "$[1][0].k"                                                                                        
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$**.k');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$**.k')  
    ----------------------------------------------------------------------------------------------------
    "$[1][0].k"                                                                                         
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*][0].k');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[*][0].k')  
    --------------------------------------------------------------------------------------------------------
    "$[1][0].k"                                                                                             
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1]');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1]')  
    ---------------------------------------------------------------------------------------------------
    "$[1][0].k"                                                                                        
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1][0]');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '10', NULL, '$[1][0]')  
    ------------------------------------------------------------------------------------------------------
    "$[1][0].k"                                                                                           
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'abc', NULL, '$[2]');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'abc', NULL, '$[2]')  
    ----------------------------------------------------------------------------------------------------
    "$[2].x"                                                                                            
    */
    
    -- 通配符查找（模糊查找）
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%d%');
    /*
    json_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%d%')  
    --------------------------------------------------------------------------------------
    ["$[1][1]", "$[3].y"]                                                                 
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%');
    /*
    json_search('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%')  
    --------------------------------------------------------------------------------------
    ["$[0]", "$[2].x", "$[3].y"]                                                          
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%', '', '$[3]');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', '%b%', '', '$[3]')  
    --------------------------------------------------------------------------------------------------
    "$[3].y"                                                                                          
    */
    
    SELECT JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'd_f');
    /*
    JSON_SEARCH('["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]', 'all', 'd_f')  
    --------------------------------------------------------------------------------------
    "$[1][1]"                                                                             
    */
    
    -- 转义特殊字符
    SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a%bc');
    /*
    JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a%bc')  
    -------------------------------------------------------------------------------------------------
    ["$[0]", "$[1]", "$[3].x"]                                                                       
    */
    
    SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\%bc');
    /*
    JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\%bc')  
    --------------------------------------------------------------------------------------------------
    "$[3].x"                                                                                          
    */
    
    -- 显示指定%转义为字面意思
    SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a$%bc', '$');
    /*
    JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a$%bc', '$')  
    -------------------------------------------------------------------------------------------------------
    "$[3].x"                                                                                               
    */
    
    SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a_bc');
    /*
    JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a_bc')  
    -------------------------------------------------------------------------------------------------
    ["$[0]", "$[1]", "$[3].x"]                                                                       
    */
    
    -- _转义为字面意思
    SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\_bc');
    /*
    JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a\_bc')  
    --------------------------------------------------------------------------------------------------
    "$[0]"                                                                                            
    */
    
    SELECT JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a`_bc', '`');
    /*
    JSON_SEARCH('["a_bc", "agbc", [{"k": "10"}, "def"], {"x":"a%bc"}, {"y":"bcd"}]', 'all', 'a`_bc', '`')  
    -------------------------------------------------------------------------------------------------------
    "$[0]"                                                                                                 
    */
    ```
  
### JSON_VALUE()
从指定的json_doc中 提取path处的值，返回提取的值，若指定返回的类型，返回的值会自动转换为指定的类型。

* 语法
    ```text
    JSON_VALUE(json_doc, path [RETURNING type] [on_empty] [on_error])
    
    Option:
        RETURNING type: 返回的类型。这里 RETURNING是SQL关键字，不能少。能指定的就是type
        on_empty:
            {NULL | ERROR | DEFAULT value} ON EMPTY
      
        on_error:
            {NULL | ERROR | DEFAULT value} ON ERROR
    ```
    
    * type支持的类型
        * FLOAT
        * DOUBLE
        * DECIMAL
        * SIGNED
        * UNSIGNED
        * DATE
        * TIME
        * DATETIME
        * YEAR (MySQL 8.0.22 and later)
        * YEAR (values of one or two digits are not supported.)
        * CHAR
        * JSON
    
* 下面个两个写法是等价
    ```mysql
    SELECT JSON_VALUE(json_doc, path RETURNING type);
    
    SELECT CAST(
        JSON_UNQUOTE( JSON_EXTRACT(json_doc, path) )
        AS type
    );
    ```

* 示例
    ```mysql
    SELECT JSON_VALUE('{"fname":"Joe", "lname":"Palmer"}', '$.fname');
    /*
    json_value('{"fname":"Joe", "lname":"Palmer"}', '$.fname')  
    ------------------------------------------------------------
    Joe                                                         
    */
    
    SELECT JSON_VALUE('{"item":"shoes", "price":"49.9502"}', '$.price' RETURNING DECIMAL(4,2)) AS 'price';
    /*
     price  
    --------
       49.95
    */
    ```

* JSON_VALUE()可用于简化在JSON列上创建索引的过程
    ```mysql
    -- JSON_VALUE() 简化在JSON列上创建索引过程
    -- t1、t2表 两表创建的索引效果相当.
    CREATE TABLE t1(
        j JSON,
        INDEX i1 ( (JSON_VALUE(j, '$.id' RETURNING UNSIGNED)) )
    );
    
    EXPLAIN SELECT * FROM t1 WHERE JSON_VALUE(j, '$.id' RETURNING UNSIGNED) = 123;
    /*
        id  select_type  table   partitions  type    possible_keys  key     key_len  ref       rows  filtered  Extra   
    ------  -----------  ------  ----------  ------  -------------  ------  -------  ------  ------  --------  --------
         1  SIMPLE       t1      (NULL)      ref     i1             i1      9        const        1    100.00  (NULL)  
                                                                                                                       
    */
    
    CREATE TABLE t2 (
        j JSON,
        g INT GENERATED ALWAYS AS (j->"$.id"),
        INDEX i1 (g)
    );
    
    EXPLAIN SELECT * FROM t2 WHERE g  = 123;
    /*
        id  select_type  table   partitions  type    possible_keys  key     key_len  ref       rows  filtered  Extra   
    ------  -----------  ------  ----------  ------  -------------  ------  -------  ------  ------  --------  --------
         1  SIMPLE       t2      (NULL)      ref     i1             i1      5        const        1    100.00  (NULL)  
    */
    ```

### value MEMBER OF(json_array)
判断value是否为给定的json数组的元素。

返回true(1)，  
false(0)

Returns true (1) if value is an element of json_array, otherwise returns false (0).

value must be a scalar or a JSON document; 

if it is a scalar, the operator attempts to treat it as an element of a JSON array.

* 语法
    ```text
    value MEMBER OF(json_array)
    ```
    * value必须是一个标量或json_doc。
    * 如果value是一个标量，则尝试把它当json数组的元素来处理

* 示例
    ```mysql
    SELECT 17 MEMBER OF('[23, "abc", 17, "ab", 10]');
    /*
    17 member of('[23, "abc", 17, "ab", 10]')  
    -------------------------------------------
                                              1
    */
    
    SELECT 'ab' MEMBER OF('[23, "abc", 17, "ab", 10]');
    /*
    'ab' member of('[23, "abc", 17, "ab", 10]')  
    ---------------------------------------------
                                                1
    */
    
    -- 部分匹配不算匹配
    SELECT 7 MEMBER OF('[23, "abc", 17, "ab", 10]');
    /*
    7 member of('[23, "abc", 17, "ab", 10]')  
    ------------------------------------------
                                             0
    */
    
    SELECT 'a' MEMBER OF('[23, "abc", 17, "ab", 10]');
    /*
    'a' MEMBER OF('[23, "abc", 17, "ab", 10]')  
    --------------------------------------------
                                               0
    */
    
    -- 不执行字符串自动转数字
    SELECT 17 MEMBER OF('[23, "abc", "17", "ab", 10]'), 
    "17" MEMBER OF('[23, "abc", 17, "ab", 10]');
    /*
    17 MEMBER OF('[23, "abc", "17", "ab", 10]')  "17" MEMBER OF('[23, "abc", 17, "ab", 10]')  
    -------------------------------------------  ---------------------------------------------
                                              0                                              0
    */
    
    SELECT CAST('[4, 5]' AS JSON) MEMBER OF('[[3, 4], [4, 5]]');
    /*
    cast('[4, 5]' as json) member of('[[3, 4], [4, 5]]')  
    ------------------------------------------------------
                                                         1
    */
    
    SELECT JSON_ARRAY(4, 5) MEMBER OF('[[3, 4], [4, 5]]');
    /*
    Json_ARRAY(4, 5) member of('[[3, 4], [4, 5]]')  
    ------------------------------------------------
                                                   1
    */
    ```

* 其它示例
    ```bash
    mysql> SET @a = CAST('{"a":1}' AS JSON);
    mysql> SET @b = JSON_OBJECT("b", 2);
    mysql> SET @c = JSON_ARRAY(17, @b, "abc", @a, 23);
    mysql> SELECT @a MEMBER OF(@c), @b MEMBER OF(@c);
    +------------------+------------------+
    | @a MEMBER OF(@c) | @b MEMBER OF(@c) |
    +------------------+------------------+
    |                1 |                1 |
    +------------------+------------------+
    ```

## Functions That Modify JSON Values
### JSON_ARRAY_APPEND()
在JSON数组末尾追加元素。并返回修改后的JSON文档。

* 语法
    ```text
    JSON_ARRAY_APPEND(json_doc, path, val[, path, val] ...)
    ```
    * 当不传任何参数时，返回NULL
    * json_doc不合法、或 path不合法、或path表达式中包含了`*` 和 `**`时，将发生错误。（下面的函数基本符合这条规则）


* 更新JSON数组值
    ```mysql
    SELECT c FROM jemp WHERE g = 38;
    /*
    c                              
    -------------------------------
    [3, 10, 5, 17, [22, "y", 66]]  
    */
    
    SELECT JSON_ARRAY_APPEND(c, "$[4]", 99) FROM jemp
    WHERE g = 38;
    /*
    JSON_ARRAY_APPEND(c, "$[4]", 99)   
    -----------------------------------
    [3, 10, 5, 17, [22, "y", 66, 99]]  
    */
    
    -- 更新JSON数组值
    UPDATE jemp SET c = JSON_ARRAY_APPEND(c, "$[4]", 99) WHERE g = 38;
    ```

* JSON_ARRAY_APPEND()函数其它用法示例
    ```mysql
    SELECT JSON_ARRAY_APPEND(c->"$[4]", "$[1]", 88) FROM jemp WHERE g = 38;
    SELECT JSON_ARRAY_APPEND(c->>"$[4]", "$[1]", 88) FROM jemp WHERE g = 38;
    -- 上面两个SQL，查询结果都相同
    /*
    JSON_ARRAY_APPEND(c->"$[4]", "$[1]", 88)  
    ------------------------------------------
    [22, ["y", 88], 66, 99]                   
    */    

    SELECT JSON_ARRAY_APPEND(c, "$[0]", 518) FROM jemp
    WHERE g = 38;
    /*
    JSON_ARRAY_APPEND(c, "$[0]", 518)     
    --------------------------------------
    [[3, 518], 10, 5, 17, [22, "y", 66]]  
    */
    
    SELECT JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1]", 1);
    /*
    JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1]", 1)  
    --------------------------------------------------------
    ["a", ["b", "c", 1], "d"]    
    */
    
    SELECT JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[0]", 2);
    /*
    JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[0]", 2)  
    --------------------------------------------------------
    [["a", 2], ["b", "c"], "d"]   
    */
    
    SELECT JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1][0]", 3);
    /*
    JSON_ARRAY_APPEND('["a", ["b", "c"], "d"]', "$[1][0]", 3)  
    -----------------------------------------------------------
    ["a", [["b", 3], "c"], "d"]                                
    */
    
    SELECT JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.b", 'x');
    /*
    JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.b", 'x')  
    ----------------------------------------------------------------
    {"a": 1, "b": [2, 3, "x"], "c": 4}                              
    */
    
    SELECT JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.c", 'yy');
    /*
    JSON_ARRAY_APPEND('{"a": 1, "b": [2, 3], "c": 4}', "$.c", 'yy')  
    -----------------------------------------------------------------
    {"a": 1, "b": [2, 3], "c": [4, "yy"]}                            
    */
    
    -- 操作JSON对象本身
    SELECT JSON_ARRAY_APPEND('{"a": 1}', '$', 'z');
    /*
    JSON_ARRAY_APPEND('{"a": 1}', '$', 'z')  
    -----------------------------------------
    [{"a": 1}, "z"]                          
    */

    -- 多个path-value对 JSON_ARRAY_APPEND操作
    SELECT JSON_ARRAY_APPEND('[11, 22, 33, 44]', '$[0]', 66, '$[2]', 77);
    /*
    JSON_ARRAY_APPEND('[11, 22, 33, 44]', '$[0]', 66, '$[2]', 77)  
    ---------------------------------------------------------------
    [[11, 66], 22, [33, 77], 44]                                   
    */
    ```

### JSON_ARRAY_INSERT()
插入数据到JSON数组的指定path处，并返回更新后的json_doc。

* 语法
    ```text
    JSON_ARRAY_INSERT(json_doc, path, val[, path, val] ...)
    ```
* JSON数组指定位置插入值
    ```mysql
    SELECT c FROM jemp WHERE g = 36;
    /*
    c                                                                                
    ---------------------------------------------------------------------------------
    {"code": 0, "data": [{"ip": "172.17.0.3", "hostname": "webserv2"}, 44, 55, 66]}  
    */
    
    -- 在c["data"]数组的第三个位子插入777
    SELECT JSON_ARRAY_INSERT(c, "$.data[2]", 777) FROM jemp WHERE g = 36;
    /*
    JSON_ARRAY_INSERT(c, "$.data[2]", 777)                                                
    --------------------------------------------------------------------------------------
    {"code": 0, "data": [{"ip": "172.17.0.3", "hostname": "webserv2"}, 44, 777, 55, 66]}  
    */
    
    UPDATE jemp SET c = JSON_ARRAY_INSERT(c, "$.data[2]", 777)
    WHERE g = 36;
    ```

* 其它示例
    ```mysql
    SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1]', 'x');
    /*
    JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1]', 'x')  
    ----------------------------------------------------------------
    ["a", "x", {"b": [1, 2]}, [3, 4]]                               
    */
    
    -- 下标越界，直接插到数组的最后
    SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[100]', 'x');
    /*
    JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[100]', 'x')  
    ------------------------------------------------------------------
    ["a", {"b": [1, 2]}, [3, 4], "x"]                                 
    */
    
    SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1].b[0]', 'x');
    /*
    JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[1].b[0]', 'x')  
    ---------------------------------------------------------------------
    ["a", {"b": ["x", 1, 2]}, [3, 4]]                                    
    */
    
    -- 插入多个path-value对时，其执行过程从左到右，一对一对path-value来插入的，前面操作path-value会改变数组的下标
    SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[0]', 'x', '$[2][1]', 'y');
    /*
    JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[0]', 'x', '$[2][1]', 'y')  
    --------------------------------------------------------------------------------
    ["x", "a", {"b": [1, 2]}, [3, 4]]                                               
    */
    
    SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[2][1]', 'y', '$[0]', 'x');
    -- 上面的写法与下面的等价
    SELECT JSON_ARRAY_INSERT(
            (SELECT JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[2][1]', 'y')), 
            '$[0]', 
            'x'
        );
    /*
    JSON_ARRAY_INSERT('["a", {"b": [1, 2]}, [3, 4]]', '$[2][1]', 'y', '$[0]', 'x')  
    --------------------------------------------------------------------------------
    ["x", "a", {"b": [1, 2]}, [3, "y", 4]]                                          
    */
    ```

### JSON_INSERT()
插入数据到JSON文档中，并返回更新后的json_doc。

json_doc可以是JSON对象，也可以是JSON数组，当更适JSON对象类型的操作。


* 语法
    ```text
    JSON_INSERT(json_doc, path, val[, path, val] ...)
    ```
    * 插入多对 path-value时，从左到有求值，前一对path-value求值返回的结果作为后一对path-value求值的json_doc
    * 当path存在时，插入操作将被忽略
    
* 示例
    ```mysql
    SELECT c FROM jemp WHERE g = 36;
    /*
    {"code": 0, "data": [{"ip": "172.17.0.3", "hostname": "webserv2"}, 44, 777, 55, 66]}  
    */
    
    -- c["data[0]"] 添加网关key-value对，key: gateway, value: "172.17.0.1"
    UPDATE jemp SET c = JSON_INSERT(c, '$.data[0].gateway', '172.17.0.1')
    WHERE g = 36;
    ```
* 其他示例
    ```mysql
    SELECT JSON_INSERT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', '[true, false]');
    /*
    JSON_INSERT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', '[true, false]')  
    --------------------------------------------------------------------------
    {"a": 1, "b": [2, 3], "c": "[true, false]"}                               
    
    -- 因为 '$.a' path已经存在，所以JSON_INSERT操作忽略。
    -- '$.c' path不存在，所以JSON_INSERT操作执行成功
    */
    
    SELECT JSON_INSERT( '{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', CAST('[true, false]' AS JSON) );
    /*
    JSON_INSERT( '{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', CAST('[true, false]' as JSON) )  
    ------------------------------------------------------------------------------------------
    {"a": 1, "b": [2, 3], "c": [true, false]}                                                 
    */
    
    -- JSON数组的插入
    SELECT JSON_INSERT('[11, 22, 33]', '$[100]', 99);
    /*
    JSON_INSERT('[11, 22, 33]', '$[100]', 99)  
    -------------------------------------------
    [11, 22, 33, 99]                           
    */
    ```


### JSON_REPLACE()
更新(替换)json_doc现有的值，并返回更新后的json_doc

* 语法
    ```text
    JSON_REPLACE(json_doc, path, val[, path, val] ...)
    ```
    * 插入多对 path-value时，从左到右求值，前一对path-value求值返回的结果作为后一对path-value求值的json_doc
    * 当path不存在时，忽略JSON_REPLACE操作，结果不产生影响。即不替换

* 示例
    ```mysql
    SELECT c FROM jemp WHERE g = 1;
    /*
    c                          
    ---------------------------
    {"id": 1, "name": "Niki"}  
    */
    
    -- 更新name Niki为Nicki
    UPDATE jemp SET c = JSON_REPLACE(c, '$.name', 'Nicki');
    ```
    
* 其它操作示例
    ```mysql
    SELECT JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
    /*
    JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
    --------------------------------------------------------------
    {"a": 10, "b": [2, 3]}                                        
    */
    ```

### JSON_SET()
插入或更新json_doc的值，并返回更新后的json_doc

* 语法
    ```text
    JSON_SET(json_doc, path, val[, path, val] ...)
    ```
    * 插入多对 path-value时，从左到有求值，前一对path-value求值返回的结果作为后一对path-value求值的json_doc

* 示例
    ```mysql
    SELECT JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
    /*
    JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
    ----------------------------------------------------------
    {"a": 10, "b": [2, 3], "c": 66}                           
    */
    ```
    
### JSON_SET(), JSON_INSERT(), JSON_REPLACE()的对比
* JSON_SET()  
    replaces existing values and adds nonexisting values.
    
    值存在则替换(path存在)，否则添加该值

* JSON_INSERT()  
    inserts values without replacing existing values.
    
    插入值，不替换已存在的值
    
* JSON_REPLACE()  
    replaces only existing values.
    
    只替换已存在的值
    
* 示例
    ```mysql
    SELECT JSON_INSERT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
    /*
    JSON_INSErT('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
    -------------------------------------------------------------
    {"a": 1, "b": [2, 3], "c": 66}                               
    */
    
    SELECT JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
    /*
    JSON_REPLACE('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
    --------------------------------------------------------------
    {"a": 10, "b": [2, 3]}                                        
    */
    
    -- JSON_SET() 相当于是JSON_INSERT()和JSON_REPLACE() 的合并版
    SELECT JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66);
    /*
    JSON_SET('{ "a": 1, "b": [2, 3]}', '$.a', 10, '$.c', 66)  
    ----------------------------------------------------------
    {"a": 10, "b": [2, 3], "c": 66}                           
    */
    ```

### JSON_REMOVE()
从json_doc中删除指定path处的值。

* 语法
    ```text
    JSON_REMOVE(json_doc, path[, path] ...)
    ```
    * 删除多个path时，从左到有求值，前一对path求值返回的结果作为后一对path求值的json_doc
    
* 示例
    ```mysql
    -- 删除 g=35的 code key-value
    SELECT c FROM jemp WHERE g = 35;
    /*
    c                                                                                
    ---------------------------------------------------------------------------------
    {"code": 0, "data": [{"ip": "172.17.0.2", "hostname": "webserv1"}, 11, 22, 33]}  
    */
    
    UPDATE jemp SET c = JSON_REMOVE(c, '$.code');
    ```
* 其他示例
    ```mysql
    SELECT JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]');
    /*
    JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]')  
    -----------------------------------------------
    ["a", "d"]                                     
    */
    SELECT JSON_REMOVE('["a", ["b", "c"], "d"]', '$[0]', '$[1][0]');
    /*
    JSON_REMOVE('["a", ["b", "c"], "d"]', '$[0]', '$[1][0]')  
    ----------------------------------------------------------
    [["b", "c"]]                                              
    */
    ```

### JSON_MERGE()
合并两个或多个json_doc（对相同的path不覆盖，直接新增），返回合并后的json_doc。

MySQL 8.0.3已经被弃用。

可以使用 JSON_MERGE_PRESERVE() 代替。

* 语法
    ```text
    JSON_MERGE(json_doc, json_doc[, json_doc] ...)
    ```

* 示例
    ```mysql
    SELECT JSON_MERGE('[1, 2]', '[true, false]');
    /*
    JSON_MERGE('[1, 2]', '[true, false]')  
    ---------------------------------------
    [1, 2, true, false]                    
    */
    
    SELECT JSON_MERGE('{"k1":11, "k2":22}', '{"k1":33, "k2":44}');
    /*
    JSON_MERGE('{"k1":11, "k2":22}', '{"k1":33, "k2":44}')  
    --------------------------------------------------------
    {"k1": [11, 33], "k2": [22, 44]}                        
    */
    ```

### JSON_MERGE_PATCH()
合并两个或多个json_doc，对相同的path，第二json_doc将覆盖第一个json_doc，最后返回合并后的json_doc。

* 语法
    ```text
    JSON_MERGE_PATCH(json_doc, json_doc[, json_doc] ...)
    ```
* 示例
    ```mysql
    SELECT JSON_MERGE_PATCH('[1, 2]', '[true, false]');
    /*
    JSON_MERGE_PATCH('[1, 2]', '[true, false]')  
    ---------------------------------------------
    [true, false]                                
    */
    
    SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}');
    /*
    JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}')  
    -------------------------------------------------
    {"id": 47, "name": "x"}                          
    */
    
    SELECT JSON_MERGE_PATCH('1', 'true');
    /*
    JSON_MERGE_PATCH('1', 'true')  
    -------------------------------
    true                         
    */
    
    -- JSON对象、JSON数组 进行JSON_MERGE_PATCH()操作，第二参数直接覆盖第一个参数
    SELECT JSON_MERGE_PATCH('[1, 2]', '{"id": 47}');
    /*
    JSON_MERGE_PATCH('[1, 2]', '{"id": 47}')  
    ------------------------------------------
    {"id": 47}                                
    */
    
    SELECT JSON_MERGE_PATCH('{"id": 47}', '[1, 2]');
    /*
    JSON_MERGE_PATCH('{"id": 47}', '[1, 2]')  
    ------------------------------------------
    [1, 2]                                    
    */
    
    SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "c":4}');
    /*
    JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "c":4}')  
    ------------------------------------------------------
    {"a": 3, "b": 2, "c": 4}                              
    */
    
    -- 多个json_doc合并
    SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "b":4}', '{"a":5, "d":6}');
    /*
    JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "b":4}', '{"a":5, "d":6}')  
    ------------------------------------------------------------------------
    {"a": 5, "b": 4, "d": 6}                                                
    */
    
    SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"b":null}');
    /*
    json_merge_patch('{"a":1, "b":2}', '{"b":null}')  
    --------------------------------------------------
    {"a": 1}                                          
    */
    
    SELECT JSON_MERGE_PATCH('{"a":{"x":1}}', '{"a":{"y":2}}');
    /*
    json_merge_patch('{"a":{"x":1}}', '{"a":{"y":2}}')  
    ----------------------------------------------------
    {"a": {"x": 1, "y": 2}}                             
    */
    ```

### JSON_MERGE_PRESERVE()
合并两个或多个json_doc（把所有的元素都保留下来），返回合并后的json_doc。


* 语法
    ```text
    JSON_MERGE_PRESERVE(json_doc, json_doc[, json_doc] ...)
    ```
    * 相邻的两个json数组 合并为 一个json数组.
    * 相邻的两个json对象 合并为 一个json对象.
    *  一个标量值与一个json数组合并时，标量值将自动包装为json数组，再进行合并.
    * 一个json数组与一个json对象合并时，json对象将自动包装成json数组，再进行合并.
* 示例
    ```mysql
    SELECT JSON_MERGE_PRESERVE('[1, 2]', '[true, false]');
    /*
    JSON_MERGE_PREserve('[1, 2]', '[true, false]')  
    ------------------------------------------------
    [1, 2, true, false]                             
    */
    
    SELECT JSON_MERGE_PRESERVE('{"name":"x"}', '{"id":47}');
    /*
    json_merge_preserve('{"name":"x"}', '{"id":47}')  
    --------------------------------------------------
    {"id": 47, "name": "x"}                           
    */
    
    -- 标量值 JSON_MERGE_PRESERVE()操作，会合并为 json数组
    SELECT JSON_MERGE_PRESERVE("1", "true");
    /*
    json_merge_preserve("1", "true")  
    ----------------------------------
    [1, true]                         
    */
    
    SELECT JSON_MERGE_PRESERVE('[1, 2]', '{"id":47}');
    /*
    json_merge_preserve('[1, 2]', '{"id":47}')  
    --------------------------------------------
    [1, 2, {"id": 47}]                          
    */
    
    SELECT JSON_MERGE_PRESERVE('{"id":47}', '[1, 2]');
    /*
    json_merge_preserve('{"id":47}', '[1, 2]')  
    --------------------------------------------
    [{"id": 47}, 1, 2]                          
    */
    
    SELECT JSON_MERGE_PRESERVE('{"a":1, "b":2}', '{"a":3, "c":4}');
    /*
    json_merge_preserve('{"a":1, "b":2}', '{"a":3, "c":4}')  
    ---------------------------------------------------------
    {"a": [1, 3], "b": 2, "c": 4}                            
    */
    
    SELECT JSON_MERGE_PRESERVE('[1, 2]', '[true, false]', '[33, 44]');
    /*
    JSON_MERGE_PRESERVE('[1, 2]', '[true, false]', '[33, 44]')  
    ------------------------------------------------------------
    [1, 2, true, false, 33, 44]                                 
    */
    ```
    
### JSON_MERGE_PATCH()对比JSON_MERGE_PRESERVE()
* JSON_MERGE_PATCH() 
    removes any member in the first object with a matching key in the second object  
    第一个json对象与第二个json对象有相同的key，第一json对象中相同key部分的成员值将被删除，再合并。
    provided that the value associated with the key in the second object is not JSON null.  
    前提条件是，第二json对象相关联的key值不为NULL。

* If the second object has a member with a key matching a member in the first object,   
    在第二json对象与第一个json对象有相同的key的情况下：  
    * JSON_MERGE_PATCH()  
        replaces the value in the first object with the value in the second object,   
        JSON_MERGE_PATCH()函数 用第二json对象对应的值替换(覆盖)第一json对象的值
    * JSON_MERGE_PRESERVE()
        appends the second value to the first value.  
        JSON_MERGE_PRESERVE()函数 将第二json对象对应的值追加到第一json对象的值上，这两个值合并为局部的json数组
* 示例
    ```mysql
    SELECT JSON_MERGE_PATCH('{"a":1, "b":2}', '{"a":3, "c":4}', '{"a":5, "b":6}') AS 'Patch',
    JSON_MERGE_PRESERVE('{"a":1, "b":2}', '{"a":3, "c":4}', '{"a":5, "b":6}') AS 'Preserve';
    /*
    Patch                     Preserve                               
    ------------------------  ---------------------------------------
    {"a": 5, "b": 6, "c": 4}  {"a": [1, 3, 5], "b": [2, 6], "c": 4}  
    */
    ```

### JSON_UNQUOTE()
取消JSON值的引号，并返回处理后的结果，此结果是一个utf8mb4字符串。

* 语法
    ```text
    JSON_UNQUOTE(json_val)
    ```
* 特殊字符转义序列

    Escape Sequence	|Character Represented by Sequence（序列表示的字符）
    :--- |:--- 
    \"	|A double quote (") character
    \b	|A backspace character
    \f	|A formfeed character
    \n	|A newline (linefeed) character
    \r	|A carriage return character
    \t	|A tab character
    \\	|A backslash (\) character
    \uXXXX	|UTF-8 bytes for Unicode value XXXX
    
* 示例
    ```mysql
    SELECT JSON_UNQUOTE('"abc"');
    /*
    JSON_UNQUOTE('"abc"')  
    -----------------------
    abc                    
    */
    
    SELECT JSON_UNQUOTE('[1, 2, 3]');
    /*
    JSON_UNQUOTE('[1, 2, 3]')  
    ---------------------------
    [1, 2, 3]                  
    */
    ```
    
    ```bash
    mysql> SELECT @@sql_mode;
    +-----------------------------------------------------------------------------------------------------------------------+
    | @@sql_mode                                                                                                            |
    +-----------------------------------------------------------------------------------------------------------------------+
    | ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION |
    +-----------------------------------------------------------------------------------------------------------------------+
    
    mysql> SELECT JSON_UNQUOTE('"\\t\\u0032"');
    +------------------------------+
    | JSON_UNQUOTE('"\\t\\u0032"') |
    +------------------------------+
    |       2                           |
    +------------------------------+
    
    mysql> SET @@sql_mode = 'NO_BACKSLASH_ESCAPES';
    mysql> SELECT JSON_UNQUOTE('"\\t\\u0032"');
    +------------------------------+
    | JSON_UNQUOTE('"\\t\\u0032"') |
    +------------------------------+
    | \t\u0032                     |
    +------------------------------+
    
    mysql> SELECT JSON_UNQUOTE('"\t\u0032"');
    +----------------------------+
    | JSON_UNQUOTE('"\t\u0032"') |
    +----------------------------+
    |       2                         |
    +----------------------------+
    ```

## Functions That Return JSON Value Attributes
### JSON_DEPTH(json_doc)
获取json_doc的最大的深度，返回值是一个整数(>= 1)。

* 函数特点
    * 空json数组（[]）、空json对象（{}）、标量的深度都为1。
    * 只包含一层标量元素的非空json数组，深度为2。
    * 只包含一层key-valuer的json对象，深度为2
    * 其他情况下的json_doc的深度都 > 2 。

* 示例
    ```mysql
    SELECT JSON_DEPTH('[]'), JSON_DEPTH('{}'), JSON_DEPTH('11');
    /*
    json_depth('[]')  json_depth('{}')  json_depth('11')  
    ----------------  ----------------  ------------------
                   1                 1                   1
    */
    
    SELECT JSON_DEPTH('hello world');
    /*
    错误代码： 3141
    Invalid JSON text in argument 1 to function json_depth: "Invalid value." at position 0.
    */
    
    SELECT JSON_DEPTH('[10, 20]'), JSON_DEPTH('[[], {}]');
    /*
    json_depth('[10, 20]')  json_depth('[[], {}]')  
    ----------------------  ------------------------
                         2                         2
    */
    
    SELECT JSON_DEPTH('[10, {"a":20}]');
    /*
    json_depth('[10, {"a":20}]')  
    ------------------------------
                                 3
    */
    ```

### JSON_LENGTH(json_doc[, path])
获取json_doc的长度，如果还是指定了path，则获取json_doc的path处的值的长度。

返回值类型为整数。

* 函数特点
    * 标量的长度为1。
    * json数组的长度为元素个数。
    * json对象的长度为其成员的数量(第一层的key-value对的对数)。
    * 长度不计算嵌套的json数组或json对象的长度。

* 示例
    ```mysql
    SELECT JSON_LENGTH('[1, 2, {"a":3}]');
    /*
    json_length('[1, 2, {"a":3}]')  
    --------------------------------
                                   3
    */
    
    SELECT JSON_LENGTH('{"a":1, "b":{"c":30}}');
    /*
    json_length('{"a":1, "b":{"c":30}}')  
    --------------------------------------
                                         2
    */
    
    -- 获取json_doc指定path处的值的长度
    SELECT JSON_LENGTH('{"a":1, "b":{"c":30}}', '$.b');
    /*
    JSON_LENGTH('{"a":1, "b":{"c":30}}', '$.b')  
    ---------------------------------------------
                                                1
    */
    ```

### JSON_TYPE(json_val)
获取json_val的类型（一个用`utf8mb4`指示的类型）。

* 示例
    ```mysql
    SELECT JSON_TYPE('{"a":[10, true]}');
    /*
    json_type('{"a":[10, true]}')  
    -------------------------------
    OBJECT                         
    */
    
    SELECT JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a'));
    /*
    json_type(json_extract('{"a":[10, true]}', '$.a'))  
    ----------------------------------------------------
    ARRAY                                               
    */
    
    SELECT JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[0]'));
    /*
    JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[0]'))  
    -------------------------------------------------------
    INTEGER                                                
    */
    
    SELECT JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[1]'));
    /*
    JSON_TYPE(JSON_EXTRACT('{"a":[10, true]}', '$.a[1]'))  
    -------------------------------------------------------
    BOOLEAN                                                
    */
    
    SELECT JSON_TYPE(NULL);
    /*
    json_type(NULL)  
    ---------------
    NULL
    */
    
    SELECT JSON_TYPE(10);
    
    
    ## Functions That Return JSON Value Attributes  --end
    /*
    错误代码： 3146
    Invalid data type for JSON data in argument 1 to function json_type; a JSON string or JSON type is required.
    */
    ```
* json_type()可返回的类型
    * Purely JSON types:
        ```text
        OBJECT: JSON objects
        
        ARRAY: JSON arrays
        
        BOOLEAN: The JSON true and false literals
        
        NULL: The JSON null literal
        ```
        
    * Numeric types:
        ```text
        INTEGER: MySQL TINYINT, SMALLINT, MEDIUMINT and INT and BIGINT scalars
        
        DOUBLE: MySQL DOUBLE FLOAT scalars
        
        DECIMAL: MySQL DECIMAL and NUMERIC scalars
        ```
    * Temporal types:
        ```text
        DATETIME: MySQL DATETIME and TIMESTAMP scalars
  
        DATE: MySQL DATE scalars
  
        TIME: MySQL TIME scalars
        ```
    * String types:
        ```text
        STRING: MySQL utf8 character type scalars: CHAR, VARCHAR, TEXT, ENUM, and SET
        ```
    * Binary types:
        ```text
        BLOB: MySQL binary type scalars including BINARY, VARBINARY, BLOB, and BIT
        ```
    * All other types:
        ```text
        OPAQUE (raw bits)
        ```
### JSON_VALID(val)
判断val是否为合法的json。  
1：是
0：不是

* 示例
    ```mysql
    SELECT JSON_VALID('{"a":1}');
    /*
    json_valid('{"a":1}')  
    -----------------------
                          1
    */
    
    SELECT JSON_VALID('hello'), JSON_VALID('"hello"');
    /*
    json_valid('hello')  json_valid('"hello"')  
    -------------------  -----------------------
                      0                        1
    */
    ```

## JSON Table Functions
### JSON_TABLE()
从JSON_doc中提取数据，并将其作为具有指定列的关系表返回。

* 语法
    ```text
    JSON_TABLE(
        expr,
        path COLUMNS (column_list)
    )   [AS] alias
    
    column_list:
        column[, column][, ...]
    
    column:
        name FOR ORDINALITY
        |  name type PATH string path [on_empty] [on_error]
        |  name type EXISTS PATH string path
        |  NESTED [PATH] path COLUMNS (column_list)
    
        on_empty:
            {NULL | DEFAULT json_string | ERROR} ON EMPTY
        
        on_error:
            {NULL | DEFAULT json_string | ERROR} ON ERROR
    ```
    * NESTED嵌套

* 示例
    ```mysql
    SELECT * FROM 
    JSON_TABLE(
        '[{"c1": null}]',
        '$[*]' COLUMNS (c1 INT PATH '$.c1' ERROR ON ERROR)
    ) AS jt;
    /*
        c1  
    --------
      (NULL)
    */
    
    SELECT * FROM 
    JSON_TABLE(
        '[{"a":3}, {"a":2}, {"b":1}, {"a":0}, {"a":[1, 2]}]',
        '$[*]' COLUMNS(
            rowid FOR ORDINALITY,
            ac VARCHAR(100) PATH '$.a' 
                DEFAULT '111' ON EMPTY 
                DEFAULT '999' ON ERROR,
            aj JSON PATH '$.a'
                DEFAULT '{"x":333}' ON EMPTY,
            bx INT EXISTS PATH '$.b'
        )
    ) AS tt;
    /*
     rowid  ac      aj              bx  
    ------  ------  ----------  --------
         1  3       3                  0
         2  2       2                  0
         3  111     {"x": 333}         1
         4  0       0                  0
         5  999     [1, 2]             0
    */
    
    SELECT * FROM 
    JSON_TABLE(
        '[{"x":2, "y":"8"}, {"x":"3", "y":"7"}, {"x":"4", "y":6}]',
        '$[*]' COLUMNS(
            xval VARCHAR(100) PATH "$.x",
            yval VARCHAR(100) PATH "$.y"
        )
    ) AS jt1;
    /*
    xval    yval    
    ------  --------
    2       8       
    3       7       
    4       6       
    */
    
    SELECT * FROM 
    JSON_TABLE(
        '[{"x":2, "y":"8"}, {"x":"3", "y":"7"}, {"x":"4", "y":6}]',
        '$[1]' COLUMNS(
            xval VARCHAR(100) PATH "$.x",
            yval VARCHAR(100) PATH "$.y"
        )
    ) AS jt1;
    /*
    xval    yval    
    ------  --------
    3       7       
    */
    
    -- NESTED嵌套
    SELECT * FROM 
    JSON_TABLE(
        '[{"a":1, "b":[11, 111]}, {"a":2, "b":[22, 222]}, {"a":3}]',
        '$[*]' COLUMNS(
            a INT PATH '$.a',
            NESTED PATH '$.b[*]' COLUMNS(
                b INT PATH '$'
            )
        )
    ) AS jt
    WHERE b IS NOT NULL
    ;
    /*
         a       b  
    ------  --------
         1        11
         1       111
         2        22
         2       222
    */
    
    SELECT * FROM 
    JSON_TABLE(
        '[{"a":1, "b":[11, 111]}, {"a":2, "b":[22, 222]}]',
        '$[*]' COLUMNS(
            a INT PATH '$.a',
            NESTED PATH '$.b[*]' COLUMNS(
                b1 INT PATH '$'
            ),
            NESTED PATH '$.b[*]' COLUMNS(
                b2 INT PATH '$'
            )
        )
    ) AS jt;
    /*
         a      b1      b2  
    ------  ------  --------
         1      11    (NULL)
         1     111    (NULL)
         1  (NULL)        11
         1  (NULL)       111
         2      22    (NULL)
         2     222    (NULL)
         2  (NULL)        22
         2  (NULL)       222
    */
    
    SELECT * FROM 
    JSON_TABLE(
        '[
            {
                "a":"a_val", 
                "b":[{"c":"c_val", "d":[1,2]}]
            },
            {
                "a":"a_val", 
                "b":[
                    {"c":"c_val", "d":[11]}, 
                    {"c":"c_val", "d":[22]}
                ]
            }
        ]',
        '$[*]' COLUMNS(
            top_ord FOR ORDINALITY,
            apath VARCHAR(10) PATH '$.a',
            NESTED PATH '$.b[*]' COLUMNS(
                bpath VARCHAR(10) PATH '$.c',
                `ord` FOR ORDINALITY,
                NESTED PATH '$.d[*]' COLUMNS(
                    lpath VARCHAR(10) PATH '$'
                )
            )
        )
    ) AS jt;
    /*
    top_ord  apath   bpath      ord  lpath   
    -------  ------  ------  ------  --------
          1  a_val   c_val        1  1       
          1  a_val   c_val        1  2       
          2  a_val   c_val        1  11      
          2  a_val   c_val        2  22      
    */
    ```

## JSON Schema Validation Functions
json模式验证函数

### JSON_SCHEMA_VALID()
根据指定的json模式 验证 json_doc

* 语法
    ```text
    JSON_SCHEMA_VALID(schema, document)
    ```
    * schema  
        必须是一个合法的json对象。

* 示例
    ```mysql
    SELECT JSON_SCHEMA_VALID(
        '{
            "id": "http://json-schema.org/geo",
            "$schema": "http://json-schema.org/draft-04/schema#",
            "description": "A geographical coordinate",
            "type": "object",
            "properties": {
                "latitude": {
                    "type": "number",
                    "minimum": -90,
                    "maximum": 90
                },
                "longitude": {
                    "type": "number",
                    "minimum": -180,
                    "maximum": 180
                }
            },
            "required": ["latitude", "longitude"]
        }',
        '{"latitude":63.444697, "longitude":10.445118}'
    ) AS is_scheme_valid;
    /*
    is_scheme_valid  
    -----------------
                    1
    */
    
    SELECT JSON_SCHEMA_VALID(
        '{
            "id": "http://json-schema.org/geo",
            "$schema": "http://json-schema.org/draft-04/schema#",
            "description": "A geographical coordinate",
            "type": "object",
            "properties": {
                "latitude": {
                    "type": "number",
                    "minimum": -90,
                    "maximum": 90
                },
                "longitude": {
                    "type": "number",
                    "minimum": -180,
                    "maximum": 180
                }
            },
            "required": ["latitude", "longitude"]
        }',
        '{}'
    ) AS is_scheme_valid;
    /*
    is_scheme_valid  
    -----------------
                    0
    */
    
    SELECT JSON_SCHEMA_VALID(
        '{
            "id": "http://json-schema.org/geo",
            "$schema": "http://json-schema.org/draft-04/schema#",
            "description": "A geographical coordinate",
            "type": "object",
            "properties": {
                "latitude": {
                    "type": "number",
                    "minimum": -90,
                    "maximum": 90
                },
                "longitude": {
                    "type": "number",
                    "minimum": -180,
                    "maximum": 180
                }
            }
        }',
        '{}'
    ) AS is_scheme_valid;
    /*
    is_scheme_valid  
    -----------------
                    1
    */
    
    -- 当值类型为string时，schema支持正常表达式
    SELECT JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"abcd"');
    /*
    JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"abcd"')  
    --------------------------------------------------------------------
                                                                       1
    */
    
    SELECT JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"aecd"');
    /*
    JSON_SCHEMA_VALID('{"type":"string", "pattern":"ab.*"}', '"aecd"')  
    --------------------------------------------------------------------
                                                                       0
    */
    ```

* JSON_SCHEMA_VALID()可用于强制执行`CHECK`约束。

    创建一个包含check约束的表
    ```mysql
    CREATE TABLE geo (
        coordinate JSON,
        CHECK(
            JSON_SCHEMA_VALID(
                '{
                    "type": "object",
                    "properties": {
                        "latitude":{"type":"number", "minimum":-90, "maximum":90},
                        "longitude":{"type":"number", "minimum":-180, "maximum":180}
                    },
                    "required": ["latitude", "longitude"]
                }',
                coordinate
            )
        )
    );
    ```
    * required  
        要求的条件
    
    插入合法的数据
    ```bash
    mysql> INSERT INTO geo VALUES('{"latitude":59, "longitude":18}');
    Query OK, 1 row affected (0.00 sec)
    ```
    
    插入latitude超出范围的数据
    ```bash
    mysql> INSERT INTO geo VALUES('{"latitude":91, "longitude":0}');
    ERROR 3819 (HY000): Check constraint 'geo_chk_1' is violated.
    mysql> SHOW WARNINGS\G
    *************************** 1. row ***************************
      Level: Error
       Code: 3934
    Message: The JSON document location '#/latitude' failed requirement 'maximum' at JSON Schema location '#/properties/latitude'.
    *************************** 2. row ***************************
      Level: Error
       Code: 3819
    Message: Check constraint 'geo_chk_1' is violated.
    2 rows in set (0.00 sec)
    ```
    
    插入缺少longitude的数据
    ```bash
    mysql> INSERT INTO geo VALUES('{"longitude":120}');
    ERROR 3819 (HY000): Check constraint 'geo_chk_1' is violated.
    mysql> SHOW WARNINGS\G
    *************************** 1. row ***************************
      Level: Error
       Code: 3934
    Message: The JSON document location '#' failed requirement 'required' at JSON Schema location '#'.
    *************************** 2. row ***************************
      Level: Error
       Code: 3819
    Message: Check constraint 'geo_chk_1' is violated.
    2 rows in set (0.00 sec)
    ```

### JSON_SCHEMA_VALIDATION_REPORT()
根据指定的json模式 验证 json_doc，返回结果为json的形式报告


* 语法
    ```text
    JSON_SCHEMA_VALIDATION_REPORT(schema, document)
    ```
* 示例
    ```mysql
    SELECT JSON_PRETTY(JSON_SCHEMA_VALIDATION_REPORT(
        '{
            "id": "http://json-schema.org/geo",
            "$schema": "http://json-schema.org/draft-04/schema#",
            "description": "A geographical coordinate",
            "type": "object",
            "properties": {
                "latitude": {
                    "type": "number",
                    "minimum": -90,
                    "maximum": 90
                },
                "longitude": {
                    "type": "number",
                    "minimum": -180,
                    "maximum": 180
                }
            },
            "required": ["latitude", "longitude"]
        }',
        '{"latitude":63.444697, "longitude":310}'
    ) ) AS "report";
    /*
    report                                                                                                                                                    --------------------------------------------------------------------------------------------------------------------------------------
    {
      "valid": false,   
      "reason": "The JSON document location '#/longitude' failed requirement 'maximum' at JSON Schema location  '#/properties/longitude'",
      "schema-location": "#/properties/longitude",
      "document-location": "#/longitude",
      "schema-failed-keyword": "maximum"
    */
    ```
    
    ```bash
    mysql> SELECT JSON_PRETTY(JSON_SCHEMA_VALIDATION_REPORT(
        ->     '{
        '>         "id": "http://json-schema.org/geo",
        '>         "$schema": "http://json-schema.org/draft-04/schema#",
        '>         "description": "A geographical coordinate",
        '>         "type": "object",
        '>         "properties": {
        '>             "latitude": {
        '>                 "type": "number",
        '>                 "minimum": -90,
        '>                 "maximum": 90
        '>             },
        '>             "longitude": {
        '>                 "type": "number",
        '>                 "minimum": -180,
        '>                 "maximum": 180
        '>             }
        '>         },
        '>         "required": ["latitude", "longitude"]
        '>     }',
        ->     '{"latitude":63.444697, "longitude":310}'
        -> ) ) \G;
    *************************** 1. row ***************************
    JSON_PRETTY(JSON_SCHEMA_VALIDATION_REPORT(
        '{
            "id": "http://json-schema.org/geo",
            "$schema": "http://json-schema.org/draft-04/schema#",
            "description": "A geographical coordinate",
            "type": "object",
            "properties":: {
      "valid": false,
      "reason": "The JSON document location '#/longitude' failed requirement 'maximum' at JSON Schema location '#/properties/longitude'",
      "schema-location": "#/properties/longitude",
      "document-location": "#/longitude",
      "schema-failed-keyword": "maximum"
    }
    1 row in set (0.00 sec)
    
    ERROR: 
    No query specified
    ```

## JSON Utility Functions
json工具类函数

### JSON_PRETTY(json_val)
打印漂亮的json_val。更适合人阅读的json格式

* 示例
    ```mysql
    SELECT JSON_PRETTY('{"k1":11, "k2":22}');
    /*
    json_pretty('{"k1":11, "k2":22}')  
    -----------------------------------
    {                                  
      "k1": 11,                        
      "k2": 22                         
    }     
    */
    ```

### JSON_STORAGE_FREE(json_val)
显示json列值在更新后，释放了多少空间，返回的值为整数，单位为：bit(位)，单位不显示。

更新json列值的函数：JSON_SET(), JSON_REPLACE(), JSON_REMOVE()

* 示例
    ```mysql
    CREATE TABLE jtable (jcol JSON);
    INSERT INTO jtable VALUES
    ('{"a":10, "b":"wxyz", "c":"[true, false]"}');
    
    SELECT JSON_STORAGE_FREE(jcol) FROM jtable;
    /*
    JSON_STORAGE_FREE(jcol)  
    -------------------------
                            0
    */
    
    UPDATE jtable SET jcol = JSON_SET(jcol, "$.a", 10, "$.b", "wxyz", "$.c", 1);
    SELECT JSON_STORAGE_FREE(jcol) FROM jtable;
    /*
    JSON_STORAGE_FREE(jcol)  
    -------------------------
                           14
    */
    ```


### JSON_STORAGE_SIZE(json_val)
获取json_doc以二进制存储所占用的字节数(bytes)。

* 示例
    ```mysql
    SELECT JSON_STORAGE_SIZE('{"a":1000, "b":"wxyz", "c":"[1, 3, 5, 7]"}') AS 'size';
    /*
      size  
    --------
          47
    */

    SELECT jcol, JSON_STORAGE_SIZE(jcol) AS Size, JSON_STORAGE_FREE(jcol) AS Free 
    FROM jtable;
    /*
    jcol                              Size    Free  
    ------------------------------  ------  --------
    {"a": 10, "b": "wxyz", "c": 1}      48        14
    */
    ```

### CAST()、CONVERT()
用于将值转换为指定的类型

[参考官网 Cast Functions and Operators](https://dev.mysql.com/doc/refman/8.0/en/cast-functions.html)