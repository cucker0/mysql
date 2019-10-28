sql分析方法
==


## 分析过程
1. 观察mysql、业务情况
    ```text
    观察mysql运行一天的情况，查看生产上慢sql情况
    ```
1. 开启慢查询日志
    ```text
    设置阈值，比如超过5秒的为慢sql，这步主要是开启慢sql并捕获
    ```
1. explain + 慢sql
1. show profile
1. DBA或运维负责人进行sql数据库服务器的参数调优


    
