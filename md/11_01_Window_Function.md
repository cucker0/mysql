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
    <tr rowspan="3">
        <td>序号函数</td>
        <td>ROW_NUMBER()</td>
        <td>顺序排列后的行号</td>
    </tr>
    <tr>
        <td>RANK()</td>
        <td>顺序排列，值相同的的并列序号，会跳过重复的序号，如1,1,3</td>
    </tr>
    <tr>
        <td>DENSE_RANK()</td>
        <td>顺序排列，值相同的的并列序号，不会跳过重复的序号，如1,1,2</td>
    </tr>
</tbody>
</table>
