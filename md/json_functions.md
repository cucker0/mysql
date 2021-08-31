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
JSON_INSERT()	|Insert data into JSON document	<br>插入数据到json文档中指定的path下，若path存在，则不插入| | | 
JSON_KEYS()	|Array of keys from JSON document <br>获取指定JSON文档（或给定path下）的key集合，返回结果为数组 | | | 
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
MEMBER OF()	|Returns true (1) if first operand matches any element of JSON <br>array passed as second operand, <br>otherwise returns false (0) <br>判断给定的对象是不是JSON的成员|8.0.17 | |`SELECT 'ab' MEMBER OF('[23, "abc", 17, "ab", 10]');` <br>结果为1
JSON_ARRAYAGG() |Aggregates a result set as a single JSON array whose elements consist of the rows. <br>将结果集聚合为单个JSON数组，该数组的元素由查询出的记录中的字段组成。 | | | 
JSON_OBJECTAGG() |Takes two column names or expressions as arguments, the first of these being used as a key and the second as a value, and returns a JSON object containing key-value pairs. <br>将两个列名或表达式作为参数，第一个作为key，第二个作为value，并返回包含key-value对的JSON对象。| | | 


## 创建JSON值的函数
### JSON_ARRAY()
* 语法
    ```text
    JSON_ARRAY([val[, val] ...])
    ```