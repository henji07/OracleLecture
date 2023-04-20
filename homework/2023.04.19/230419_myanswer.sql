--1) 어제 만든 SCORE_STGR 테이블의 SNO 컬럼에 INDEX를 추가하세요.
CREATE INDEX SNO_INDEX
    ON SCORE_STGR (SNO);

--2) 어제 만든 ST_COURSEPF 테이블의 SNO, CNO, PNO 다중 컬럼에 INDEX를 추가하세요.
CREATE INDEX STC_SNO_CNO_PNO_INDEX
ON ST_COURSEPF(SNO, CNO, PNO);

--뷰 이름은 자유
--1) 학생의 평점 4.5 만점으로 환산된 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE VIEW EX_VIEW (
      SNO
    , SNAME
    , SYEAR
    , MAJOR
    , AVR
) AS (
    SELECT SNO
         , SNAME
         , SYEAR
         , MAJOR
         , ROUND(AVR*(4.5/4.0),2)
        FROM STUDENT
);

--2) 각 과목별 기말고사 평균 점수를 검색할 수 있는 뷰를 생성하세요.
CREATE VIEW AVG_RESULT(
      CNO
    , CNAME
    , RESULT
) AS (
    SELECT CNO
         , C.CNAME
         , ROUND(AVG(SC.RESULT),2)
        FROM COURSE C
        NATURAL JOIN SCORE SC
        GROUP BY CNO, C.CNAME
);

--3) 각 사원과 관리자의 이름을 검색할 수 있는 뷰를 생성하세요.
CREATE VIEW ENAME_DIRECTOR (
      ENO
    , ENAME
    , MGR
    , BENO
    , BENAME
)AS(
    SELECT A.ENO 사원번호
         , A.ENAME 사원이름
         , A.MGR 사수번호
         , B.ENO 사수사원번호
         , B.ENAME 사수이름
        FROM EMP A
        JOIN EMP B
        ON A.MGR = B.ENO
);

--4) 각 과목별 기말고사 평가 등급(A~F)까지와 해당 학생 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW RE_GRADE (
    SNO
    , STNAME
    , STYEAR
    , STMAJOR
    , SCRESULT
    , SGGRADE
) AS (
        SELECT SNO
             , ST.SNAME
             , ST.SYEAR
             , ST.MAJOR
             , SC.RESULT
             , SG.GRADE
            FROM STUDENT ST
            NATURAL JOIN SCORE SC
            JOIN SCGRADE SG
            ON SC.RESULT BETWEEN SG.LOSCORE AND SG.HISCORE
);
  
--5) 물리학과 교수의 과목을 수강하는 학생의 명단을 검색할 뷰를 생성하세요.
CREATE VIEW PY_ST (
      CNO
    , CNAME
    , PNAME
    , SECTION
    , SNO
    , SNAME
) AS (
        SELECT CNO
             , CR.CNAME
             , PR.PNAME
             , PR.SECTION
             , SNO
             , ST.SNAME
            FROM STUDENT ST
            NATURAL JOIN SCORE SC
            NATURAL JOIN COURSE CR
            NATURAL JOIN PROFESSOR PR
            WHERE PR.SECTION = '물리'
);

--1) 4.5 환산 평점이 가장 높은 3인의 학생을 검색하세요.
SELECT ROWNUM
     , A.SNO
     , A.SNAME
     , A.AVR
    FROM (
            SELECT SNO  
             , SNAME
             , ROUND(AVR*(4.5/4.0),2) AS AVR
            FROM STUDENT 
            ORDER BY AVR*(4.5/4.0) DESC
         )A
    WHERE ROWNUM <= 3;

--2) 기말고사 과목별 평균이 높은 3과목을 검색하세요.
SELECT ROWNUM
     , A.CNO
     , A.CNAME
     , A.AVR
    FROM (
            SELECT CNO
             , CR.CNAME
             , ROUND(AVG(SC.RESULT),2)AVR
            FROM SCORE SC
            NATURAL JOIN COURSE CR
            GROUP BY CNO, CR.CNAME
            ORDER BY AVG(SC.RESULT) DESC
          )A
WHERE ROWNUM <= 3;

--3) 학과별, 학년별, 기말고사 평균이 순위 3까지를 검색하세요.(학과, 학년, 평균점수 검색)
SELECT ROWNUM
     , A.MAJOR
     , A.SYEAR
     , A.RESULT
    FROM (
            SELECT ST.MAJOR
                 , ST.SYEAR
                 , AVG(SC.RESULT)RESULT
                FROM STUDENT ST
                JOIN SCORE SC
                ON ST.SNO = SC.SNO
                GROUP BY ST.MAJOR, ST.SYEAR
                ORDER BY AVG(SC.RESULT) DESC
               
          ) A
      WHERE ROWNUM <= 3;

--4) 기말고사 성적이 높은 과목을 담당하는 교수 3인을 검색하세요.(교수이름, 과목명, 평균점수 검색)
SELECT ROWNUM
     , A.PNAME
     , A.CNAME
     , A.RESULT
    FROM (
            SELECT PNAME
                 , CNAME
                 , AVG(SC.RESULT)RESULT
                FROM SCORE SC
                JOIN COURSE CR
                ON SC.CNO = CR.CNO
                JOIN PROFESSOR PR
                ON CR.PNO = PR.PNO
                GROUP BY PNAME, CNAME
                ORDER BY AVG(SC.RESULT) DESC
          )A
      WHERE ROWNUM <= 3;

--5) 교수별로 현재 수강중인 학생의 수를 검색하세요.
SELECT P.PNAME
     , CR.CNAME
     , COUNT(DISTINCT(ST.SNO))
    FROM SCORE SC
    JOIN STUDENT ST
    ON SC.SNO = ST.SNO
    JOIN COURSE CR
    ON SC.CNO = CR.CNO
    JOIN PROFESSOR P
    ON CR.PNO = P.PNO
    GROUP BY P.PNAME, CR.CNAME
    ORDER BY COUNT(ST.SNO) DESC;

--1) CNO이 PK인 COURSE_PK 테이블을 생성하세요.(1번 방식으로)
CREATE TABLE COURSE_PK(
    CNO VARCHAR2(8) PRIMARY KEY,
    CNAME VARCHAR2(20),
    ST_NUM NUMBER,
    PNO VARCHAR2(8) 
);

--2) PNO이 PK인 PROFESSOR_PK 테이블을 생성하세요.(2번 방식으로)
CREATE TABLE PROFESSOR_PK (
    PNO VARCHAR2(8),
    PNAME VARCHAR2(20),
    SECTION VARCHAR2(20),
    ORDERS VARCHAR2(10),
    HIREDATE DATE,
    CONSTRAINT PK_PRO_PNO PRIMARY KEY(PNO)
);

--3) PF_TEMP 테이블에 PNO을 PK로 추가하세요.
ALTER TABLE PF_TEMP
    ADD CONSTRAINT PK_PNO PRIMARY KEY(PNO);

--4) COURSE_PROFESSOR 테이블에 CNO, PNO을 PK로 추가하세요.
ALTER TABLE COURSE_PROFESSOR
    ADD CONSTRAINT PK_CNO_PNO PRIMARY KEY(CNO, PNO);

--5) BOARD_NO(NUMBER)를 PK로 가지면서 
--   BOARD_TITLE(VARCHAR2(200)), BOARD_CONTENT(VARCHAR2(2000)), 
--   BOARD_WRITER(VARCHAR2(20)), BOARD_FRGT_DATE(DATE), 
--   BOARD_LMDF_DATE(DATE) 컬럼을 갖는 T_BOARD 테이블을 생성하세요.
CREATE TABLE T_BOARD (
    BOARD_NO NUMBER PRIMARY KEY,
    BOARD_TITLE VARCHAR2(200), 
    BOARD_CONTENT VARCHAR2(2000), 
    BOARD_WRITER VARCHAR2(20), 
    BOARD_FRGT_DATE DATE, 
    BOARD_LMDF_DATE DATE
);

--6) BOARD_NO(NUMBER), BOARD_FILE_NO(NUMBER)를 PK로 가지면서 
--   BOARD_FILE_NM(VARCHAR2(200)), BOARD_FILE_PATH(VARCHAR2(2000)),
--   ORIGIN_FILE_NM(VARCHAR2(200)) 컬럼을 갖는 T_BOARD_FILE 테이블을 생성하세요.
CREATE TABLE T_BOARD_FILE (
    BOARD_NO NUMBER PRIMARY KEY, 
    BOARD_FILE_NO NUMBER,
    BOARD_FILE_NM VARCHAR2(200), 
    BOARD_FILE_PATH VARCHAR2(2000),
    ORIGIN_FILE_NM VARCHAR2(200)
);