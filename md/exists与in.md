exists 与 in
==

## 示例
```mysql
-- 对表B 查询涉及 id，使用索引，故表B效率高，可用大表 -->外小内大

SELECT * FROM A
WHERE exists (SELECT * FROM B WHERE A.id = B.id);
```


```mysql
-- 对表A查询涉及id，使用索引，故表A效率高，可用大表 -->外大内小

SELECT * FROM A
WHERE A.id IN (SELECT id FROM B);
```

1. EXISTS 是对外表做 loop 循环，每次 LOOP 循环再对内表（子查询）进行查询，
那么因为对内表的查询使用的索引（内表效率高，故可用大表），而外表有多大都需要遍历，不可避免（尽量用小表），
故内表大的使用 EXISTS，可加快效率；

查询 EXISTS 对外表采用遍历方式逐条查询，每次查询都会比较 EXISTS 的条件语句，

当 EXISTS 里的条件语句返回记录行时则条件为真。此次返回当前遍历到的记录，
反之，如果 EXISTS 里的条件语句不能返回记录行，则丢弃当前遍历到的记录。

EXISTS 在子查询表大但只需验证是否存在对应关系时更高效，它支持“短路”机制，一旦找到匹配项就结束子查询，不必遍历完整个子查询表。

2. IN 是把外表 和 内表做 hash 连接，先查询内表，再把内表结果与外表匹配，`IN ()` 查询是从缓存中取数据。
对外表使用索引（外表效率高，可用大表），而内表多大都需要查询，不可避免，故外表大的使用 IN，可加快效率。
3. 如果查询的两个表大小相当，那么用 IN 和 EXISTS 差别不大。
如果两个表中一个较小，一个是大表，则子查询表大的用 EXISTS，子查询表小的用 IN。

结论：
* 单纯的理解EXISTS比IN语句的效率要高的说法其实是不准确的，要区分情景:
* 如果查询的两个表大小相当，那么用 EXISTS 和 IN 差别不大。
* 如果两个表中一个较小，一个是大表，则子查询表大的用 EXISTS，子查询表小的用 IN。
* 让大表尽量使用索引

## MySQL中的EXISTS和IN效率对比
参考 https://zhuanlan.zhihu.com/p/422028607

这里使用的MySQL版本是8.0。在MySQL 8.0 版本中两者的效率几乎是一致的。

1.  准备数据
   * 学生表  
    ![](/images/exists_vs_in_01.jpg)
   * 班级表  
    ![](/images/exists_vs_in_02.jpg)
2. 测试比较
   1. 先测试一下外层表是小表的时候，in和exists的查询效率  
   ![](/images/exists_vs_in_03.jpg)
   2. 先测试一下外层表是大表的时候，in和exists的查询效率  
      ![](/images/exists_vs_in_04.jpg)


可以看到上面的测试结果，两者效率相差不是很明显，可能通过上面的数据测试，有的小伙伴可能并不相信，只是巧合吧，来，接下来上菜，哦不，上图，有图有真相：
![](/images/exists_vs_in_05.jpg)

![](/images/exists_vs_in_06.png)