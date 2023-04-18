--1) 각 학과별 학생 수를 검색하세요
SELECT MAJOR
     , COUNT(*) AS 학생수
    FROM STUDENT
    GROUP BY MAJOR;

--2) 화학과와 생물학과 학생 4.5 환산 평점의 평균을 각각 검색하세요
SELECT MAJOR
     , ROUND(AVG(AVR*(4.5/4.0)),2) 환산점수
    FROM STUDENT
    WHERE MAJOR IN ('화학', '생물')
    GROUP BY MAJOR;
    
--3) 부임일이 10년 이상 된 직급별(정교수, 조교수, 부교수) 교수의 수를 검색하세요
SELECT ORDERS
     , COUNT(*)
    FROM PROFESSOR
    WHERE(MONTHS_BETWEEN(SYSDATE, HIREDATE)/12) >= 10
    GROUP BY ORDERS;

--4) 과목명에 화학이 포함된 과목의 학점수 총합을 검색하세요
SELECT CNAME
     , SUM(ST_NUM)
    FROM COURSE 
    WHERE CNAME LIKE '%화학%'
    GROUP BY CNAME;

--5) 학과별 기말고사 평균을 성적순(성적 내림차순)으로 검색하세요
SELECT CNO
     , AVG(RESULT)
    FROM SCORE
    GROUP BY CNO
    ORDER BY AVG(RESULT) DESC;
    
SELECT ST.MAJOR
     , AVG(RESULT)
    FROM SCORE SC
    JOIN STUDENT ST
    ON SC.SNO = ST.SNO
    GROUP BY ST.MAJOR
    ORDER BY AVG(RESULT) DESC;

--6) 30번 부서의 업무별 연봉의 평균을 검색하세요(소수점 두자리까지 표시)
SELECT JOB
     , ROUND(AVG(SAL),2) 연봉평균
    FROM EMP
    WHERE DNO = '30'
    GROUP BY JOB;

--7) 물리학과 학생 중에 학년별로 성적이 가장 우수한 학생의 평점을 검색하세요 - 학과, 학년, 평점
SELECT MAJOR
     , SYEAR
     , MAX(AVR)
    FROM STUDENT
    WHERE MAJOR = '물리'
    GROUP BY MAJOR, SYEAR
    ORDER BY SYEAR;

--1) 화학과를 제외하고 학과별로 학생들의 평점 평균을 검색하세요
SELECT MAJOR
     , ROUND(AVG(AVR),2) 평균
    FROM STUDENT
    WHERE MAJOR NOT IN ('화학')
    GROUP BY MAJOR;

--2) 화학과를 제외한 각 학과별 평균 평점 중에 평점이 2.0 이상인 정보를 검색하세요
SELECT MAJOR
     , AVG(AVR)
    FROM STUDENT
    WHERE MAJOR NOT IN ('화학')
    GROUP BY MAJOR
    HAVING AVG(AVR) >= 2.0;
    
--3) 기말고사 평균이 60점 이상인 학생의 정보를 검색하세요
SELECT ST.SNO
     , ST.SNAME
     , AR.AVGRE
    FROM STUDENT ST
    JOIN (
            SELECT SNO
                 , AVG(RESULT) AS AVGRE
                FROM SCORE
                GROUP BY SNO
                HAVING AVG(RESULT) >= 60
          ) AR
    ON ST.SNO = AR.SNO;
    
SELECT SC.SNO
     , ST.SNAME
     ,ROUND(AVG(SC.RESULT),2)
    FROM SCORE SC
    JOIN STUDENT ST
    ON SC.SNO = ST.SNO
    GROUP BY SC.SNO, ST.SNAME
    HAVING ROUND(AVG(SC.RESULT),2) >= 60;

--4) 강의 학점이 3학점 이상인 교수의 정보를 검색하세요 -  sum / 2개 이상 강의도 있기 때문에 그룹 바이
SELECT P.PNO
     , P.PNAME
     , P.SECTION
     , SUMST.SUMST_NUM
    FROM PROFESSOR P
    JOIN (
        SELECT PNO
             , SUM(ST_NUM) AS SUMST_NUM
            FROM COURSE
            GROUP BY PNO
            HAVING SUM(ST_NUM) >= 3
          )SUMST
    ON P.PNO = SUMST.PNO;
    
SELECT C.PNO
     , P.PNAME
     , SUM(C.ST_NUM)
    FROM COURSE C
    JOIN PROFESSOR P
    ON C.PNO = P.PNO
    GROUP BY C.PNO, P.PNAME
    HAVING SUM(C.ST_NUM) >= 3;
    
--5) 기말고사 평균 성적이 핵 화학과목보다 우수한 과목의 과목명과 담당 교수명을 검색하세요 - join 많음
SELECT C.CNO
     , C.CNAME
     , P.PNO
     , P.PNAME
     , ART.AVGRE
    FROM COURSE C
    JOIN PROFESSOR P
    ON C.PNO = P.PNO
    JOIN (
            SELECT CNO
                 , AVG(RESULT)AVGRE
                FROM SCORE
                GROUP BY CNO
          ) ART
    ON C.CNO = ART.CNO
    AND ART.AVGRE > (
                        SELECT AVG(RESULT)
                            FROM (
                                     SELECT SC.CNO
                                          , SC.RESULT
                                        FROM SCORE SC
                                        JOIN COURSE CR
                                        ON SC.CNO = CR.CNO
                                        WHERE CNAME = '핵화학'          
                                 )
                            GROUP BY CNO
                    );
      
SELECT SC.CNO
     , C.CNAME
     , C.PNO
     , ROUND(AVG(SC.RESULT),2) AS RESAVG
    FROM SCORE SC
    JOIN COURSE C
    ON SC.CNO = C.CNO
    GROUP BY SC.CNO, C.CNAME, C.PNO;
    
--6) 근무 중인 직원이 4명 이상인 부서를 검색하세요(부서번호, 부서명, 인원 수)
SELECT D.DNO 부서번호
     , D.DNAME 부서명
     , CD.CT 인원수
    FROM DEPT D
    JOIN (
            SELECT DNO
                 , COUNT(*) AS CT
                FROM EMP
                GROUP BY DNO
                HAVING COUNT(*) >= 4
         ) CD
    ON D.DNO = CD.DNO;

SELECT D.DNO
     , D.DNAME
     , COUNT(*)
    FROM 


--7) 업무별 평균 연봉이 3000 이상인 업무를 검색하세요
SELECT JOB
     , ROUND(AVG(SAL),2)
    FROM EMP
    GROUP BY JOB
    HAVING AVG(SAL) >= 3000;

--8) 각 학과의 학년별 인원중 인원이 5명 이상인 학년을 검색하세요
SELECT MAJOR
     , SYEAR
     , COUNT(*)
    FROM STUDENT
    GROUP BY MAJOR, SYEAR
    HAVING COUNT(*) >= 5;