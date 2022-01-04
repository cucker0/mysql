Window Function窗口函数
==

参考 https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html

窗口函数列表


Name	Description
CUME_DIST()	Cumulative distribution value
DENSE_RANK()	Rank of current row within its partition, without gaps
FIRST_VALUE()	Value of argument from first row of window frame
LAG()	Value of argument from row lagging current row within partition
LAST_VALUE()	Value of argument from last row of window frame
LEAD()	Value of argument from row leading current row within partition
NTH_VALUE()	Value of argument from N-th row of window frame
NTILE()	Bucket number of current row within its partition.
PERCENT_RANK()	Percentage rank value
RANK()	Rank of current row within its partition, with gaps
ROW_NUMBER()	Number of current row within its partition


<table>
<thead>
    <tr>
        <th>函数分类</th>
        <th>函数</th>
        <th>描述</th>
    </tr>
</thead>

<tbody>
    <tr>
        <td rowspan="3">序号函数</td>
        <td>ROW_NUMBER()</td>
        <td>顺序排列后的行号</td>
    </tr>
    <tr>
        <td>RANK()</td>
        <td>顺序排名，值相同的的并列序号，会跳过重复的序号，如1,1,3</td>
    </tr>
    <tr>
        <td>DENSE_RANK()</td>
        <td>顺序排名，值相同的的并列序号，不会跳过重复的序号，如1,1,2</td>
    </tr>
    <tr>
        <td rowspan="2">分布函数</td>
        <td>PERCENT_RANK()</td>
        <td>等级值百分比</td>
    </tr>
    <tr>
        <td>CUME_DIST()</td>
        <td>累计分布值</td>
    </tr>
    <tr>
        <td rowspan="2">前后函数</td>
        <td>LAG(expr [, N[, default]])</td>
        <td>返回当前行的前N行的expr值</td>
    </tr>
    <tr>
        <td>LEAD(expr [, N[, default]])</td>
        <td>返回当前行的后N行的expr值</td>
    </tr>
    <tr>
        <td rowspan="2">首尾函数</td>
        <td>FIRST_VALUE(expr)</td>
        <td>返回第一行的expr值</td>
    </tr>
    <tr>
        <td>LAST_VALUE(expr)</td>
        <td>返回最后一行的expr值</td>
    </tr>
    <tr>
        <td rowspan="2">其他函数</td>
        <td>NTH_VALUE(expr, N)</td>
        <td>返回第N行的expr值</td>
    </tr>
    <tr>
        <td>NTILE(N)</td>
        <td>将分区中的有序数据分为N个桶，给桶编上序号</td>
    </tr>
</tbody>
</table>
