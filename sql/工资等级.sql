CREATE TABLE job_grades (
    grade_level VARCHAR(3),
    lowest_sal  int,
    highest_sal int
);

INSERT INTO job_grades VALUES
('A', 1000, 2999),
('B', 3000, 5999),
('C', 6000, 9999),
('D', 10000, 14999),
('E', 15000, 24999),
('F', 25000, 40000)
;
