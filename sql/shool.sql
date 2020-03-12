-- 创建表
--
CREATE TABLE major (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL COMMENT '专业名称',
    brief VARCHAR(255) NOT NULL COMMENT '专业简介'
) COMMENT='专业表';

-- [学生]与[专业]为多对一关系
CREATE TABLE student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL COMMENT '姓名',
    age INT COMMENT '年龄',
    major_id INT COMMENT '所选专业ID', -- 一个学生只能选择一个专业
    CONSTRAINT student__major_id__fk__major__id FOREIGN KEY (major_id) REFERENCES major (id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE course (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course VARCHAR(64) NOT NULL COMMENT '课程名',
    brief VARCHAR(255) NOT NULL COMMENT '简介'
) COMMENT='课程表';

CREATE TABLE teacher (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL COMMENT '姓名',
    age INT COMMENT '年龄'
);


-- 校卡表, [校卡]与[学生]为一对一关系
CREATE TABLE card (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `no` VARCHAR(64) NOT NULL UNIQUE COMMENT '卡编号',
    `status` ENUM ('on', 'off', 'deprecated') DEFAULT 'off' COMMENT '卡状态',
    -- 一张卡只能绑定一个学生。为了卡可以回收利用，所以要允许卡不绑定学生ID，也就是student_id要允许为NULL。UNIQUE约束列可以有多个NULL值
    -- 因为id唯一、student_id唯一(排除NULL值)，所以[校卡]与[学生]关系为 一对一关系
    student_id INT UNIQUE COMMENT '学生ID',

    CONSTRAINT card__student_id__fk__student__id FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='校卡表';

CREATE TABLE class (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `no` VARCHAR(16) NOT NULL COMMENT '班级编号',
    headteacher INT NOT NULL COMMENT '班主任', -- 每个班必须有班主任
    grade ENUM('g1', 'g2', 'g3', 'g4', 'g5', 'g6', 'g7', 'g8', 'g9', 'g10', 'g11', 'g12', 'freshman', 'sophomore', 'junior', 'senior'),
    -- 一个老师只能带一个班，或不带班，所以不能重复。(班级 与 班主任的关系：一对一关系)
    UNIQUE KEY headteacher__uniq (headteacher),
    CONSTRAINT class__headteacher__fk__teacher__id FOREIGN KEY (headteacher) REFERENCES teacher (id) ON UPDATE CASCADE
) COMMENT='班级表';


-- 选课表：[学生]与[课程]为多对多关系
CREATE TABLE select_courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT COMMENT '学生ID',
    course_id INT COMMENT '课程ID',
    -- 同一个学生选择同一门课程的记录不能重复。如果其他一些业务需求是可重复的，则不加unique约束
    UNIQUE KEY student_id__uniq__course_id (student_id, course_id),
    /*
    ON DELETE SET NULL：当删除了此记录关联的student记录时，此记录的student_id 设置为NULL
    ON UPDATE CASCADE：当更新了此记录关联的student记录的id值时，此记录的student_id 自动更新为相应的新值

    下面的作用类似
    */
    CONSTRAINT select_courses__student_id__fk__teacher__id FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT select_courses__course_id__fk__course__id FOREIGN KEY (course_id) REFERENCES course (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='学生选课关系表';

-- 老师授课表：[老师]与[课程]的多对多关系
CREATE TABLE teaching (
    id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT COMMENT '老师ID',
    course_id INT COMMENT '授课的课程ID',
    -- 同一个老师教同一门课的记录不能重复
    UNIQUE KEY teacher_id__uniq__course_id (teacher_id, course_id),
    CONSTRAINT teaching__teacher_id__fk__teacher__id FOREIGN KEY (teacher_id) REFERENCES teacher (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT teaching__course_id__fk__course__id FOREIGN KEY (course_id) REFERENCES course (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='老师授课表';

-- 教师给班级授课表: [老师]与[班级]的多对多关系
CREATE TABLE teaching4class (
    id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT COMMENT '老师ID',
    class_id INT COMMENT '班级ID',
    -- 同一个老师教同一班级的记录不能重复
    UNIQUE KEY teacher_id__uniq__class_id (teacher_id, class_id),
    CONSTRAINT teaching4class__teacher_id__fk__teacher__id FOREIGN KEY (teacher_id) REFERENCES teacher (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT teaching4class__class_id__fk__class__id FOREIGN KEY (class_id) REFERENCES class (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='教师给班级授课表';

-- 分班信息表: [班级]与[学生]的一对多关系
CREATE TABLE class_info (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT COMMENT '学生ID',
    class_id INT COMMENT '班级ID',
    -- 一个学生只能分在一个班，所以学生不能重复。
    UNIQUE KEY student_id__uniq (student_id), -- 也可以直接在student_id字段上加 UNIQUE 关键字
    CONSTRAINT class_info__student_id__fk__student__id FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT class_info__class_id__fk__class__id FOREIGN KEY (class_id) REFERENCES class (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='分班信息表';


-- 成绩表: [成绩]与[学生]为多对一关系
CREATE TABLE score (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT COMMENT '学生ID', -- 这里不加NOT NULL限制，主要是为了在删除学生记录时方便，直接删除学生时，此值允许设置为NULL
                                     -- 副作用：会导致多出一些无实际业务意义的记录
    course_id INT COMMENT '课程ID',
    score DOUBLE(5, 1) DEFAULT 0 COMMENT '得分',
    is_took_exam ENUM('true', 'false') DEFAULT 'true' COMMENT '是否参加了考试',
    term VARCHAR(16) COMMENT '学期，例：2020first，2020next',
    -- 同一学期，同一学生的同一课程成绩记录不能重复
    UNIQUE KEY term__uniq__student_id__course_id (term, student_id, course_id),
    CONSTRAINT score__student_id__fk__student__id FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT score__course_id__fk__course__id FOREIGN KEY (course_id) REFERENCES course (id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='成绩表';


-- 插入数据
--
INSERT INTO course (course, brief) VALUES
('高等数学', '主要内容包括：数列、极限、微积分、空间解析几何与线性代数、级数、常微分方程'),
('马克思主义思想概论', '主要内容：现代唯物主义、现代科学社会主义'),
('电路原理', '主要内容包括：电路模型和基本定律，线性电阻网络分析，正弦稳态电路分析，三相电路，互感电路与谐振电路，周期性非正弦稳态电路分析，双口网络，非线性电路，磁路等'),
('操作系统原理', '操作系统是计算机系统中最重要的系统软件，也是计算机专业的核心课程。'),
('java语言', 'Java是一门面向对象编程语言，吸收了C++语言的各种优点。Java具有简单性、面向对象、分布式、健壮性、安全性、平台独立与可移植性、多线程、动态性等特点'),
('政治经济学', '是研究一个社会生产、资本、流通、交换、分配和消费等经济活动、经济关系和经济规律的学科'),
('电动力学', '主要研究电磁场的基本属性、运动规律以及电磁场和带电物质的相互作用'),
('英语写作', '如何用英语写好记叙文，描写文，说明文以及议论文等')
;


INSERT INTO major (`name`, brief) VALUES
('金融学',  '金融学（Finance）是从经济学中分化出来的应用经济学科，是以融通货币和货币资金的经济活动为研究对象，具体研究个人、机构、政府如何获取、支出以及管理资金以及其他金融资产的学科。'),
('应用物理学', '本专业主要培养掌握物理学基本理论与方法，具有良好的数学基础和基本实验技能，掌握电子技术、计算机技术、光纤通信技术、生物医学物理等方面的应用基础知识'),
('英语', '英语专业是培养具有扎实的英语语言基础和较为广泛的科学文化知识，能在外事、经贸、文化、新闻出版、教育、科研、旅游等部门从事翻译、研究、教学、管理工作的英语高级专门人才的学科'),
('计算机科学与技术', '计算机科学与技术（Computer Science and Technology）是国家一级学科，下设信息安全、软件工程、计算机软件与理论、计算机系统结构、计算机应用技术、计算机技术等专业。')
;


INSERT INTO student (`name`, age, major_id) VALUES
('司空舒方', 19, 2),
('朱远悦', 18, 1),
('岳梦竹', 20, 3),
('郑清俊', 19, 4),
('童琨', 20, 4)
;

INSERT INTO card (`no`, `status`, student_id) VALUES
('sn1001', 'on', 1),
('sn1002', 'on', 2),
('sn1003', 'on', 5),
('sn1004', 'on', 4),
('sn1006', 'on', 3),
('sn1005', 'on', NULL)
;

INSERT INTO select_courses (student_id, course_id) VALUES
(1, 7),
(1, 2),
(1, 1),
(2, 2),
(2, 6),
(3, 2),
(3, 8),
(4, 2),
(5, 2),
(4, 4),
(5, 5),
(5, 1)
;