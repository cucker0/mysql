JSON Functions
==


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
JSON_MERGE_PATCH()	|Merge JSON documents, replacing values of duplicate keys。	<br>合并多个JSON，相同的path会被后面的JSON对应的值覆盖 | | |`SELECT JSON_MERGE_PATCH('[1, 2]', '[true, false]');` <br>结果为[true, false] <br>`SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}');` <br>结果为 {"id": 47, "name": "x"}
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
* 数组下标：[index]，
    * 暂时不支持`-1`这种倒序写法。
    * index范围：>= 0的整数
    
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
获取JSON文档中指定path的值，返回的值被双引号包裹

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

### JSON_EXTRACT(json_doc, path[, path] ...)



### JSON_CONTAINS(target, candidate[, path])

### JSON_CONTAINS_PATH(json_doc, one_or_all, path[, path] ...)

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


### JSON_OVERLAPS()
比较两个JSON文本是否有相同的key-value或数组元素，

如果有返回true(1)，否则false(0)。

* 语法
    ```text
    JSON_OVERLAPS(json_doc1, json_doc2)
    ```

### JSON_SEARCH(json_doc, one_or_all, search_str[, escape_char[, path] ...])

### JSON_VALUE(json_doc, path)

### value MEMBER OF(json_array)


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
    * 插入多对 path-value时，从左到有求值，前一对path-value求值返回的结果作为后一对path-value求值的json_doc
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
    
    值存在则替换，否则添加该值

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
* 示例
    ```mysql
    SELECT JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]');
    /*
    JSON_REMOVE('["a", ["b", "c"], "d"]', '$[1]')  
    -----------------------------------------------
    ["a", "d"]                                     
    */
    ```

### JSON_MERGE()

* 语法
    ```text
    JSON_MERGE(json_doc, json_doc[, json_doc] ...)
    ```

### JSON_MERGE_PATCH()

* 语法
    ```text
    JSON_MERGE_PATCH(json_doc, json_doc[, json_doc] ...)
    ```

### JSON_MERGE_PATCH()对比JSON_MERGE_PRESERVE()



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