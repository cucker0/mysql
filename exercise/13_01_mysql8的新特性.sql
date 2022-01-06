# mysql 8的新特性

## VALUES
VALUES ROW(1,-2,3), ROW(5,7,9), ROW(4,6,8);
/*
column_0  column_1  column_2  
--------  --------  ----------
       1        -2           3
       5         7           9
       4         6           8
*/


-- 
VALUES ROW(1,-2,3), ROW(5,7,9), ROW(4,6,8)
ORDER BY column_1;
/*
column_0  column_1  column_2  
--------  --------  ----------
       1        -2           3
       5         7           9
       4         6           8
*/

--
VALUES 
    ROW("q", 42, '2019-12-18'),
    ROW(23, "abc", 98.6),
    ROW(27.0002, "Mary Smith", '{"a": 10, "b": 25}')
;
/*
column_0  column_1    column_2            
--------  ----------  --------------------
q         42          2019-12-18          
23        abc         98.6                
27.0002   Mary Smith  {"a": 10, "b": 25}  
*/

-- 
VALUES 
    ROW(1,2), 
    ROW(3,4), 
    ROW(5,6)
UNION 
VALUES 
    ROW(10,15),
    ROW(20,25)
;
/*
column_0  column_1  
--------  ----------
       1           2
       3           4
       5           6
      10          15
      20          25
*/