set global local_infile = true;
SET SQL_SAFE_UPDATES = 0;

-- show databases;
create database if not exists technothlon;
-- show databases;
use technothlon;
-- show tables;
drop table if exists qp_data;
drop table if exists exam_data;
drop table if exists sec1_marks;
drop table if exists sec2_marks;
drop table if exists sec3_marks;
drop table if exists total_marks;
drop table if exists stud_performance;
drop table if exists final_table;

# Creating the table to store the data of questions
create table if not exists qp_data(
    que int, 
    difficulty	int, 
    deduction_or_reasoning	int, 
    numerical_logic int, 
    logical_intuition int, 
    trial_and_error	int,
    visualisation int,
    total int
);

load data local infile '"A:\Desktop\PROJECTS\Techanalysis\QP_data.csv"'
	into table  qp_data
    fields terminated by ','
    lines terminated by '\n'
    ignore 1 lines;
    
-- select * from qp_data;

# Creating the table to store the data of students
create table if not exists exam_data(
	roll_num int, Q1 int, Q2 int, Q3 int, Q4 int, Q5 int,
    Q6 int, Q7 int, Q8 int, Q9 int, Q10 int,
    Q11 int, Q12 int, Q13 int, Q14 int, Q15 int,
    Q16 int, Q17 int, Q18 int, Q19 int, Q20 int
);
-- describe techno_data;
-- show tables;

load data local infile '"A:\Desktop\PROJECTS\Techanalysis\exam_data.csv"'
	into table  exam_data
    fields terminated by ','
    lines terminated by '\n'
    ignore 1 lines;

-- select * from exam_data;

# ------------------------------------------------------------------------------------------------  #
# ----------------------------------------- OPERATIONS -------------------------------------------  #
# ------------------------------------------------------------------------------------------------  #

/*
	The marking scheme is as follows:
		Section 1 
			6 Questions
            Fibonacci
				- A Fibonacci Series is a series of numbers in which the nth term is the sum of the (n-1)th and (n-2)th terms. 
                  The series goes like 1, 1, 2, 3, 5, 8 ...
				- For correct answers, the sequence starts from 2 and increases according to the sequence. 
                  For example, for 3 consecutive questions correctly, 
                  the marks you will get for the first question is 2, 
                  the second question is 3 and the third question is 5. 
				- However, if you leave a question or answer a question wrong,the sequence is broken, 
                  and you will start again from 2.
				- Wrong answers have negative marks and the sequence starts from the first term. 
				  If you get four wrong answers consecutively, you get -1, -1, -2 and -3 respectively.
                
        Section 2
			6 Questions
            Shield Me
				You get 5 marks for answering correctly and 4 marks are deducted for answering incorrectly, 
                but if you have solved the previous question correctly then there is no negative marking for the current question.
				For example:
				If Your sequence is RWRW then your score is 5+0+5+0 = 10
				But if your sequence is RWWR then your score would be 5+0-4+ 5 = 6
				And if your sequence is RWUW then your score is 5+0+0-4 = 1
				Where (R -> right answer, W-> wrong answer, U-> Unattempted)
            
		Section 3 
			8 Questions
            Boomerang
				If a question is solved correctly, you will be awarded 4 marks. 
                If you do not attempt then Zero, 
                otherwise, if wrong, then -1.
*/

# MARKING SCHEME

-- Section 1
create table if not exists sec1_marks(
	roll_num int, 
    Q1 int, Q2 int, Q3 int, Q4 int, Q5 int, Q6 int,
    sec1 int
);

insert into sec1_marks (roll_num, Q1, Q2, Q3, Q4, Q5, Q6)
	select roll_num, Q1, Q2, Q3, Q4, Q5, Q6	from exam_data;
    
update sec1_marks
set sec1 =
	case
		when Q1 = 0 then 0
		when Q1 = 1 then 2
        else -1
	end+
    case
		when Q2 = 0 then 0
		when Q2 = 1 and Q1 = 1 then 3
        when Q2 = -1 then -1
        else 2
	end+
    case
		when Q3 = 0 then 0
        when Q3 = 1 and	
					(Q2 = 0 or Q2 = -1) then 2
		when Q3 = 1 and 
					Q2 = 1 and
							(Q1 = 0 or Q1 = -1) then 3
		when Q3 = 1 and
					Q2 = 1 and 
							Q1 = 1 then 5
		when Q3 = -1 and
					(Q2 = 1 or Q2 = 0) then -1
		when Q3 = -1 and
					Q2 = -1 and
							(Q1 = 1 or Q1 = 0) then -1
		else -2
	end+
    case
		when Q4 = 0 then 0
        when Q4 = 1 and
					(Q3 = 0 or Q3 = -1) then 2
		when Q4 = 1 and
					Q3 = 1 and
							(Q2 = 0 or Q2 = -1) then 3
		when Q4 = 1 and
					Q3 = 1 and
							Q2 = 1 and
									(Q1 = 0 or Q1 = -1) then 5
		when Q4 = 1 and
					Q3 = 1 and
							Q2 = 1 and 
									Q1 = 1 then 8
		when Q4 = -1 and
					(Q3 = 1 or Q3 = 0) then -1
        when Q4 = -1 and
					Q3 = -1 and
							(Q2 = 1 or Q2 = 0) then -1
		when Q4 = -1 and
					Q3 = -1 and
							Q2 = -1 and
									(Q1 = 1 or Q1 = 0) then -2
		else -3
	end+
    case
		when Q5 = 0 then 0
        when Q5 = 1 and
					(Q4 = 0 or Q4 = -1) then 2
		when Q5 = 1 and
					Q4 = 1 and
							(Q3 = 0 or Q3 = -1) then 3
		when Q5 = 1 and
					Q4 = 1 and
							Q3 = 1 and
									(Q2 = 0 or Q2 = -1) then 5
		when Q5 = 1 and
					Q4 = 1 and
							Q3 = 1 and
									Q2 = 1 and
											(Q1 = 0 or Q1 = -1) then 8
		when Q5 = 1 and
					Q4 = 1 and
							Q3 = 1 and
									Q2 = 1 and
											Q1 = 1 then 13
		when Q5 = -1 and
					(Q4 = 0 or Q4 = 1) then -1
		when Q5 = -1 and
					Q4 = -1 and
							(Q3 = 0 or Q3 = 1) then -1
		when Q5 = -1 and
					Q4 = -1 and
							Q3 = -1 and
									(Q2 = 0 or Q2 = 1) then -2
		when Q5 = -1 and
					Q4 = -1 and
							Q3 = -1 and
									Q2 = -1 and
											(Q1 = 0 or Q1 = 1) then -3
		else -5
	end+
    case
		when Q6 = 0 then 0
        when Q6 = 1 and
					(Q5 = 0 or Q5 = -1) then 2
		when Q6 = 1 and
					Q5 = 1 and
							(Q4 = 0 or Q4 = -1) then 3
		when Q6 = 1 and
					Q5 = 1 and
							Q4 = 1 and
									(Q3 = 0 or Q3 = -1) then 5
		when Q6 = 1 and
					Q5 = 1 and 
							Q4 = 1 and
									Q3 = 1 and
											(Q2 = 0 or Q2 = -1) then 8
		when Q6 = 1 and
					Q5 = 1 and 
							Q4 = 1 and
									Q3 = 1 and
											Q2 = 1 and
													(Q1 = 0 or Q1 = -1) then 13
		when Q6 = 1 and
					Q5 = 1 and 
							Q4 = 1 and
									Q3 = 1 and
											Q2 = 1 and
													Q1 = 1 then 21
        when Q6 = -1 and
					(Q5 = 0 or Q5 = 1) then -1
		when Q6 = -1 and
					Q5 = -1 and
							(Q4 = 0 or Q4 = 1) then -1
		when Q6 = -1 and
					Q5 = -1 and
							Q4 = -1 and
									(Q3 = 0 or Q3 = 1) then -2
		when Q6 = -1 and
					Q5 = -1 and 
							Q4 = -1 and
									Q3 = -1 and
											(Q2 = 0 or Q2 = 1) then -3
		when Q6 = -1 and
					Q5 = -1 and 
							Q4 = -1 and
									Q3 = -1 and
											Q2 = -1 and
													(Q1 = 0 or Q1 = 1) then -5
		else -8
	end;
    
-- select * from sec1_marks;
        
-- Section 2
create table if not exists sec2_marks(
	roll_num int, 
    Q7 int, Q8 int, Q9 int, Q10 int, Q11 int, Q12 int,
    sec2 int
);

insert into sec2_marks (roll_num, Q7, Q8, Q9, Q10, Q11, Q12)
	select roll_num, Q7, Q8, Q9, Q10, Q11, Q12 from exam_data;
    
update sec2_marks
set sec2 = 
    case
        when Q7 = 1 then 5
        else 0
    end +
    case
		when Q8 = 1 then 5
        when Q8 = -1 and Q7 = -1 then -4
        else 0
	end+
    case 
		when Q9 = 1 then 5
        when Q9 = -1 and (Q8 = -1 or (Q8 = 0 and Q7 = -1)) then -4
        else 0
	end+
    case 
		when Q10 = 1 then 5
        when Q10 = -1 and (Q9 = -1 or (Q9 = 0 and (Q8 = -1 or (Q8 = 0 and Q7 = -1)))) then -4
        else 0
	end+
    case
		when Q11 = 1 then 5
        when Q11 = -1 and (Q10 = -1 or (Q10 = 0 and (Q9 = -1 or (Q9 = 0 and (Q8 = -1 or (Q8 = 0 and Q7 = -1)))))) then -4
        else 0
    end+
    case 
		when Q12 = 1 then 5
        when Q12 = -1 and (Q11 = -1 or (Q11 = 0 and (Q10 = -1 or (Q10 = 0 and (Q9 = -1 or (Q9 = 0 and (Q8 = -1 or (Q8 = 0 and Q7 = -1)))))))) then -4
        else 0
	end;
    
-- select * from sec2_marks;

-- Section 3
create table if not exists sec3_marks(
	roll_num int, 
    Q13 int, Q14 int, Q15 int, Q16 int, Q17 int, Q18 int, Q19 int, Q20 int,
    sec3 int
);

insert into sec3_marks (roll_num, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20)
	select roll_num, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20 from exam_data;
    
update sec3_marks
set sec3 = 
    case
        when Q13 = 1 then 4
        when Q13 = -1 then -1
        else 0
    end +
    case
        when Q14 = 1 then 4
        when Q14 = -1 then -1
        else 0
    end +
    case
        when Q15 = 1 then 4
        when Q15 = -1 then -1
        else 0
    end +
    case
        when Q16 = 1 then 4
        when Q16 = -1 then -1
        else 0
    end +
    case
        when Q17 = 1 then 4
        when Q17 = -1 then -1
        else 0
    end +
    case
        when Q18 = 1 then 4
        when Q18 = -1 then -1
        else 0
    end +
    case
        when Q19 = 1 then 4
        when Q19 = -1 then -1
        else 0
    end +
    case
        when Q20 = 1 then 4
        when Q20 = -1 then -1
        else 0
    end;

-- select * from sec3_marks;	

-- Total Marks
-- Creating the total_marks table by joining the three tables
create table if not exists total_marks as
	select
		sec1_marks.roll_num,
		sec1_marks.sec1 as sec1,
		sec2_marks.sec2 as sec2,
		sec3_marks.sec3 as sec3
	from
		sec1_marks
	join
		sec2_marks on sec1_marks.roll_num = sec2_marks.roll_num
	join
		sec3_marks on sec1_marks.roll_num = sec3_marks.roll_num;

-- select * from total_marks;

alter table total_marks
	add total int;
    
update total_marks
	set total = sec1+sec2+sec3;
    
-- select * from total_marks;

# Performance table
create table if not exists stud_performance(
	roll_num int primary key,
    stu_difficulty decimal(18,16), 
    stu_deduction_or_reasoning decimal(18,16),
    stu_numerical_logic decimal(18,16),
    stu_logical_intuition decimal(18,16),
    stu_trial_and_error decimal(18,16),
    stu_visualisation decimal(18,16)
);

load data local infile '"A:\Desktop\PROJECTS\Techanalysis\student_performance_data.csv"'
	into table  stud_performance
    fields terminated by ','
    lines terminated by '\n'
    ignore 1 lines;
    
-- select * from stud_performance;

# Final table with all data of performances and total marks.
create table if not exists final_table as
select
    sp.roll_num,
    sp.stu_difficulty as difficulty,
    sp.stu_deduction_or_reasoning as deduction_or_reasoning,
    sp.stu_numerical_logic as numerical_logic,
    sp.stu_logical_intuition as logical_intuition,
    sp.stu_trial_and_error as trial_and_error,
    sp.stu_visualisation as visualisation,
    tm.total
from 
    stud_performance sp
join 
    total_marks tm on sp.roll_num = tm.roll_num;

select * from final_table;