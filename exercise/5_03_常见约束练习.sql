-- 常见约束练习



# 1.向表emp2的id列中添加PRIMARY KEY约束
ALTER TABLE emp2 ADD PRIMARY KEY (id);

# 2.向表dept2的id列中添加UNIQUE约束（约束名my_dept_id_uq）
ALTER TABLE CONSTRAINT my_dept_id_uq dept2 ADD UNIQUE (id);

# 3.向表emp2中添加列dept_id，并在其中定义FOREIGN KEY约束，与之相关联的列是dept2表中的id列。
ALTER TABLE emp2 ADD CONSTRAINT emp2__dept_id_fk_dept2__id FOREIGN KEY (dept_id) REFERENCES dept2 (id); 


            位置		    支持的约束类型			    是否可以起约束名
列级约束：	列的后面	    语法都支持，但外键没有效果	不可以
表级约束：	所有列的下面	默认和非空不支持，其他支持	可以（主键没有效果）



