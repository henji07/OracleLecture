--1) 평점이 3.0에서 4.0사이의 학생을 검색하라(between and)
SELECT *
    FROM STUDENT
    WHERE AVR BETWEEN 3.0 AND 4.0
    ORDER BY MAJOR, AVR;

--2) 1994년에서 1995년까지 부임한 교수의 명단을 검색하라(between and)
SELECT *
    FROM PROFESSOR
    WHERE HIREDATE BETWEEN TO_DATE('19940101', 'yyyyMMdd HH24:mi:ss') 
                    AND TO_DATE('19951231', 'yyyyMMdd HH24:mi:ss')
    ORDER BY HIREDATE;
    
-- 날짜 형식 변경하려면    
ALTER SESSION SET NLS_DATE_FORMAT = 'yyyyMMdd HH24:mi:ss';

--3) 화학과와 물리학과, 생물학과 학생을 검색하라(in)
SELECT *
    FROM STUDENT
    WHERE MAJOR IN('화학', '물리', '생물');

--4) 정교수와 조교수를 검색하라(in)
SELECT *
    FROM PROFESSOR
    WHERE ORDERS IN('정교수', '조교수');

--5) 학점수가 1학점, 2학점인 과목을 검색하라(in)
SELECT *
    FROM COURSE
    WHERE ST_NUM IN (1, 2);

--6) 1, 2학년 학생 중에 평점이 2.0에서 3.0사이인 학생을 검색하라(between and)
SELECT *
    FROM STUDENT
    WHERE SYEAR IN(1, 2)
      AND AVR BETWEEN 2.0 AND 3.0
    ORDER BY SYEAR, AVR;

--7) 화학, 물리학과 학생 중 1, 2 학년 학생을 성적순으로 검색하라(in)
SELECT *
    FROM STUDENT
    WHERE MAJOR IN('화학', '물리')
      AND SYEAR IN(1, 2)
    ORDER BY SYEAR, AVR DESC;

--8) 부임일이 1995년 이전인 정교수를 검색하라(to_date)
SELECT *
    FROM PROFESSOR
    WHERE HIREDATE < TO_DATE('19950101', 'yyyyMMdd HH24:mi:ss');

--1) 송강 교수가 강의하는 과목을 검색한다
SELECT PR.PNO
     , PR.PNAME
     , CR.CNO
     , CR.CNAME
    FROM PROFESSOR PR
    JOIN COURSE CR
    ON PR.PNO = CR.PNO
    AND PNAME = '송강';

--2) 화학 관련 과목을 강의하는 교수의 명단을 검색한다
SELECT PR.PNO
     , PR.PNAME
     , CR.CNO
     , CR.CNAME
    FROM PROFESSOR PR
    JOIN COURSE CR
    ON PR.PNO = CR.PNO
    WHERE CNAME LIKE '%화학%';

--3) 학점이 2학점인 과목과 이를 강의하는 교수를 검색한다
SELECT CR.*
     , PR.PNAME
    FROM COURSE CR
    JOIN PROFESSOR PR
    ON CR.PNO = PR.PNO
    WHERE ST_NUM = 2;

--4) 화학과 교수가 강의하는 과목을 검색한다
SELECT CR.*
     , PR.PNAME
     , PR.SECTION
    FROM COURSE CR
    JOIN PROFESSOR PR
    ON CR.PNO = PR.PNO
    WHERE SECTION = '화학';

--5) 화학과 1학년 학생의 기말고사 성적을 검색한다
SELECT SC. SNO
     , ST.SNAME
     , ST.SYEAR
     , SC.CNO
     , ST.MAJOR
     , SC.RESULT
    FROM SCORE SC 
    JOIN STUDENT ST
    ON SC.SNO = ST.SNO
    WHERE MAJOR = '화학'
      AND SYEAR = 1
    ORDER BY SC.CNO, SC.RESULT DESC;

--6) 일반화학 과목의 기말고사 점수를 검색한다
SELECT CR.CNO
     , CR.CNAME
     , SC.SNO
     , SC.RESULT
    FROM COURSE CR
    JOIN SCORE SC
    ON CR.CNO = SC.CNO
    WHERE CNAME = '일반화학'
    ORDER BY RESULT DESC;
    
--7) 화학과 1학년 학생의 일반화학 기말고사 점수를 검색한다
SELECT ST.SNO
     , ST.MAJOR
     , ST.SNAME
     , ST.SYEAR
     , SC.CNO
     , CR.CNAME
     , SC.RESULT
    FROM STUDENT ST
    JOIN SCORE SC
    ON ST.SNO = SC.SNO
    JOIN COURSE CR
    ON SC.CNO = CR.CNO
    WHERE ST.MAJOR = '화학'
      AND ST.SYEAR = 1
      AND CR.CNAME = '일반화학';
      
--8) 화학과 1학년 학생이 수강하는 과목을 검색한다
SELECT DISTINCT ST.SNO
     , ST.SNAME
     , ST.SYEAR
     , ST.MAJOR
     , CR.CNO
     , CR.CNAME
    FROM STUDENT ST
    JOIN SCORE SC
    ON ST.SNO = SC.SNO
    JOIN COURSE CR
    ON SC.CNO = CR.CNO
    WHERE MAJOR = '화학'
      AND SYEAR = 1;

--9) 유기화학 과목의 평가점수가 F인 학생의 명단을 검색한다
SELECT ST.SNO
     , ST.SNAME
     , CR.CNO
     , CR.CNAME
     , SG.GRADE
    FROM STUDENT ST
    JOIN SCORE SC
    ON ST.SNO = SC.SNO
    JOIN COURSE CR
    ON SC.CNO = CR.CNO
    JOIN SCGRADE SG
    ON SC.RESULT BETWEEN LOSCORE AND HISCORE
    WHERE CNAME = '유기화학'
      AND GRADE = 'F';
      
--1) 학생중에 동명이인을 검색한다 (셀프조인)
SELECT A.SNO
     , A.SNAME
     , B.SNO
     , B.SNAME
    FROM STUDENT A
    JOIN STUDENT B
    ON A.SNAME = B.SNAME
    AND A.SNO != B.SNO;
    
--2) 전체 교수 명단과 교수가 담당하는 과목의 이름을 학과 순으로 검색한다
SELECT PR.PNO
     , PR.PNAME
     , CR.CNO
     , CR.CNAME
    FROM PROFESSOR PR
    LEFT JOIN COURSE CR 
    ON PR.PNO = CR.PNO
    ORDER BY CNAME;

--3) 이번 학기 등록된 모든 과목과 담당 교수의 학점 순으로 검색한다   
SELECT CR.CNO
     , CR.CNAME
     , CR.ST_NUM
     , PR.PNO
     , PR.PNAME
    FROM COURSE CR
    LEFT JOIN PROFESSOR PR
    ON CR.PNO = PR.PNO
    ORDER BY ST_NUM;
    
--1) 각 과목의 과목명과 담당 교수의 교수명을 검색하라
SELECT CR.CNO
     , CR.CNAME
     , PR.PNO
     , PR.PNAME
    FROM COURSE CR
    LEFT JOIN PROFESSOR PR
    ON CR.PNO = PR.PNO;

--2) 화학과 학생의 기말고사 성적을 모두 검색하라
SELECT ST.SNO
     , ST.SNAME
     , ST.MAJOR
     , SC.RESULT
    FROM STUDENT ST
    LEFT JOIN SCORE SC
    ON ST.SNO = SC.SNO
    WHERE MAJOR = '화학';
    
--3) 유기화학과목 수강생의 기말고사 시험점수를 검색하라
SELECT CR.CNO
     , CR.CNAME 
     , ST.SNO
     , ST.SNAME
     , SC.RESULT
    FROM COURSE CR
    JOIN SCORE SC
    ON CR.CNO = SC.CNO 
    JOIN STUDENT ST
    ON SC.SNO = ST.SNO
    WHERE CNAME = '유기화학';

--4) 화학과 학생이 수강하는 과목을 담당하는 교수의 명단을 검색하라
SELECT DISTINCT ST.SNO
     , ST.SNAME
     , ST.MAJOR
     , CR.CNO
     , CR.CNAME
     , PR.PNO
     , PR.PNAME
    FROM STUDENT ST
    JOIN SCORE SC
    ON ST.SNO = SC.SNO
    JOIN COURSE CR
    ON SC.CNO = CR.CNO
    JOIN PROFESSOR PR
    ON CR.PNO = PR.PNO
    WHERE MAJOR = '화학';

--5) 모든 교수의 명단과 담당 과목을 검색한다
SELECT PR.PNO
     , PR.PNAME
     , PR.SECTION
     , CR.CNO
     , CR.CNAME
    FROM PROFESSOR PR
    LEFT JOIN COURSE CR
    ON PR.PNO = CR.PNO;

--6) 모든 교수의 명단과 담당 과목을 검색한다(단 모든 과목도 같이 검색한다)
SELECT PR.PNO
     , PR.PNAME
     , PR.SECTION
     , CR.CNO
     , CR.CNAME
    FROM PROFESSOR PR
    FULL JOIN COURSE CR
    ON PR.PNO = CR.PNO;