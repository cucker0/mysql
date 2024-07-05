SQLYog
==

## 简介
```text
SQLyog是业界著名的Webyog公司(美国Idera Inc)出品的一款简洁高效、功能强大的图形化MySQL数据库管理工具。
使用SQLyog可以快速直观地让您从世界的任何角落通过网络来维护远端的MySQL数据库。

SQLyog相比其它类似的MySQL数据库管理工具其有如下特点:
1、基于C++和MySQLAPI编程；
2、方便快捷的数据库同步与数据库结构同步工具；
3、易用的数据库、数据表备份与还原功能；
4、支持导入与导出XML、HTML、CSV等多种格式的数据；
5、直接运行批量SQL脚本文件，速度极快；
6、新版本更是增加了强大的数据迁移。
7、收费
```

* SQLyog Community Edition Download
>https://github.com/webyog/sqlyog-community/wiki/Downloads

## 快捷键
```text
* 连接
Ctrl + M   创建一个新的连接
Ctrl + N   使用当前设置新建连接
Ctrl + F4   断开当前连接

* 对象浏览器
F5   刷新对象浏览器(默认)
Ctrl + B   设置焦点于对象浏览器

* SQL 窗口
Ctrl + T   新建查询编辑器
Ctrl + E   设置焦点于 SQL 窗口
Ctrl + Y   重做 
Ctrl + Z   撤销  
Ctrl + X   剪切    
Ctrl + V   粘贴 
Ctrl + H   替换
Ctrl + G   转到
Ctrl + O   在 SQL 窗口打开一个 SQL 文档
Ctrl + Shift + U  使选择内容大写
Ctrl + Shift + L  使选择内容小写
Ctrl + Shift + C  注释 SQL 窗口选择内容
Ctrl + Shift + R  从选择内容删除注释
Ctrl + Shift + T  插入模板
Ctrl + Enter   列出所有的标签
Ctrl + Space  列出匹配的标签

* 执行查询
F8   执行当前查询并编辑结果集
F9   执行当前查询(默认)
Ctrl + F9   执行选定查询(默认)
Shift + F9     执行全部查询(默认)
F5  执行选中语句（可设置开启）
F9  刷新对象浏览器(可设置开启，即显示结果窗口)


* 粘贴 SQL 语句
Alt + Shift + I  插入语句
Alt + Shift + U  更新语句
Alt + Shift + D  删除语句
Alt + Shift + S  选择语句

* 结果
F11   插入更新对话框
Ctrl + R   设置焦点于结果面板中的活动标签
Ctrl + L   切换结果窗口/表数据以表格/文本方式显示 
Ctrl + Alt + C    以 CSV, SQL, Excel 等导出表数据
Ctrl + Alt + E    以 SQL 转储文件备份数据
Ctrl + Shift + M  从 CSV 导入数据
Ctrl + Shift + E  导出结果集
Alt + 1...n     在结果窗口中选择第n个标签

* 显示/隐藏
Ctrl + 1   显示/隐藏 对象浏览器
Ctrl + 2   显示/隐藏 结果面板
Ctrl + 3   显示/隐藏 查询窗口

* 数据库/数据表
Ctrl + D   创建数据库
F6   更改 数据库/数据表的结构/索引/视图/存储过程/函数/触发器/事件
F2   重命名 数据表/视图/触发器/事件 
Shift + Del    截断 数据库/数据表
F7   管理索引窗口
F10   关联/外键
Ctrl + Alt + R   重新排序字段  
Ctrl + Alt + T   数据表诊断
Ctrl + Alt + F   刷新对话框
Ctrl + Shift + Alt + S 以 HTML 格式创建数据库架构 
Ctrl + Shift + Q  从 SQL 转储文件恢复数据库

* 增强工具
Ctrl + W   数据库同步向导
Ctrl + Q   架构同步工具
Ctrl + Alt + O   数据迁移工具包
Ctrl + Alt + N    通知服务向导
Ctrl + Alt + S    计划备份
Ctrl + K   查询创建器   
Ctrl + Alt + D    架构设计器

* 用户管理
Ctrl + U   添加用户
Ctrl + Alt + U   编辑用户 
Ctrl + Shift + W  管理用户权限

* 个人文件夹
Ctrl + Shift + F  添加当前 SQL 语句到个人文件夹

* 其它
F1   帮助
F12   格式化当前行所在的SQL
Ctrl + F12    格式化选中的SQL
Shift + F12   格式化所有SQL
Ctrl + C   复制 
Ctrl + A   全选
Ctrl + F/F3  查找 (SQL 窗口/以文本方式显示的结果窗口和表数据)  
Ctrl + S   保存 
Ctrl + PgUp  切换到上一标签
Ctrl + PgDown  切换到下一标签
DEL   删除选定
Alt + L   关闭标签
Alt + F4   退出程序

```

## 常规设置
### 设置Tab键为四个空格
```text
1. 打开 SQLyog 软件，选择 工具--> 首选项

2. 在 字体编辑器栏，设置选项卡插入方式为：插入空间，数字改为：4

3. 将 SQL格式工具栏 中缩进设置为 4 空格，至此，我们在使用 SQLyog 输入SQL语句时，就可以放心大胆使用 Tab 缩进了
```

### 定制尺寸宽度设置为0
```text
默认，从SQLyog复制出来的内容每行最左端会多两个空格。

避免这种情况设置方法：

工具--> 首选项--> 概述
导出项 -- 定制尺寸，设置为 0

```

### 其他
* 查看表时，字段后显示的 xB，表示该字段名称所有的字符个数，包括括号符号等