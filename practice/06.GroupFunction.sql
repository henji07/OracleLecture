--1. 그룹 함수
--1-1. MAX
--전체 학생 중 최대 평점 
SELECT MAX(AVR)
    FROM STUDENT;
    
--전공별 최대 평점
SELECT MAX(AVR)
     , MAJOR
    FROM STUDENT
    GROUP BY MAJOR;
    
--전공별로 학년별로 최대 평점
SELECT ST.SNO
     , ST.SNAME
     , MAXAVR.AVR
     , MAXAVR.MAJOR
     , MAXAVR.SYEAR
    FROM STUDENT ST
    JOIN
        (
        SELECT MAX(AVR)AS AVR
             , MAJOR
             , SYEAR
            FROM STUDENT
            GROUP BY MAJOR, SYEAR
            HAVING MAJOR = '화학'
            AND MAX(AVR) > 2.5
            )MAXAVR
    ON ST.AVR = MAXAVR.AVR
    AND ST.MAJOR = MAXAVR.MAJOR
    AND ST.SYEAR = MAXAVR.SYEAR;
    
--기말고사 성적 중 과목별 가장 높은 점수 조회 
SELECT CNO
     , MAX(RESULT) 
    FROM SCORE 
    GROUP BY CNO;
    
--과목 이름까지 나오게 하기 
SELECT SC.CNO
     , C.CNAME
     , SC.MAXRESULT
    FROM COURSE C
    JOIN (           
            SELECT CNO
                 , MAX(RESULT) AS MAXRESULT
            FROM SCORE 
            GROUP BY CNO
          ) SC
    ON C.CNO = SC.CNO;
    
--SNO, SNAME까지 가져오기
SELECT SC.SNO
     , ST.SNAME
     , C.CNAME
     , MXRS.CNO
     , MXRS.MAXRESULT
    FROM SCORE SC
    JOIN (           
            SELECT CNO
                 , MAX(RESULT) AS MAXRESULT
            FROM SCORE 
            GROUP BY CNO          
          ) MXRS
    ON SC.CNO = MXRS.CNO 
    AND SC.RESULT = MXRS.MAXRESULT
    JOIN STUDENT ST
    ON SC.SNO = ST.SNO
    JOIN COURSE C
    ON C.CNO = SC.CNO
    ORDER BY SC.CNO;

--GROUP BY 통계함수 함께 사용
--SELECT절에 통계함수
--GROUP BY절에 통계함수 어떤 기준으로 통계를 낼 건지 
--GROUP BY절에 특정 컬럼을 지정하면 그 컬럼의 값이 같은 데이터들끼리 모아서 통계를 내준다. 
--예로 SCORE 테이블에 CNO을 GROUP BY절에 작성하면 
--CNO이 같은, 결국 같은 과목의 데이터만 모아서 통게를 내주는 식으로 진행된다. 

--1-2. MIN 
--기말고사 성적이 전체 과목 중 최저 값 조회 
--테이블 전체 데이터의 통계를 낼 때는 GROUP BY를 사용할 필요가 없다. 
SELECT MIN(RESULT)
    FROM SCORE;
    
--부서별 연봉 최저값
SELECT DNO
     , MIN(SAL)
    FROM EMP
    GROUP BY DNO;
    
--부서 이름까지 나오게
SELECT D.DNO
     , D.DNAME
     , E.MINSAL
    FROM DEPT D
    JOIN (
            SELECT DNO
                 , MIN(SAL) AS MINSAL --서브쿼리 통계함수는 별칭 무조건!
                FROM EMP
                GROUP BY DNO          
          ) E
    ON D.DNO = E.DNO;

--사원 이름까지
SELECT MS.DNO
     , D.DNAME
     , E.ENO
     , E.ENAME
     , MS.MINSAL
    FROM EMP E
    JOIN (           
            SELECT DNO
                 , MIN(SAL) AS MINSAL
            FROM EMP
            GROUP BY DNO          
          ) MS
    ON E.DNO = MS.DNO 
    AND E.SAL = MS.MINSAL
    JOIN DEPT D
    ON E.DNO = D.DNO;
    
--잘못된 GROUP BY
--SELECT절에 컬럼이 하나 추가되는 순간 GROUP BY에도 추가해줘야 하기 때문에
--GROUP BY의 의미가 변질된다. 그래서 GROUP BY로 이미 묶여있는 데이터는
--서브쿼리로 빼서 별도의 테이블로 생각하고 사용한다. 
SELECT SNO
     , CNO
     , MAX(RESULT)
    FROM SCORE
    GROUP BY SNO, CNO;
    
--학생별 최대점수 
SELECT SNO
     , MAX(RESULT) AS MAXRES
    FROM SCORE
    GROUP BY SNO;
    
--학생별 최대 점수의 과목번호
SELECT MXRS.SNO
     , SC.CNO
     , MXRS.MAXRES
    FROM (
         SELECT SNO
              , MAX(RESULT) AS MAXRES
            FROM SCORE
            GROUP BY SNO
    )MXRS
    JOIN SCORE SC
    ON MXRS.SNO = SC.SNO
    AND MXRS.MAXRES = SC.RESULT
    ORDER BY SNO, CNO;
    
--1-3. SUM 
--각 부서별 보너스의 합계 
--COMM에 NULL값이 있는 부서가 존재하기 때문에 
--NVL로 NULL값을 처리한 COMM값으로 합계를 내야 한다. 
SELECT DNO
     , SUM(NVL(COMM, 0))
    FROM EMP
    GROUP BY DNO;

--1-4. COUNT 
--각 학과별 학년별 학생 수 
SELECT MAJOR 
     , SYEAR
     , COUNT(*)
    FROM STUDENT 
    GROUP BY MAJOR, SYEAR; 

--학과별 교수의 수 
SELECT SECTION 
     , COUNT(*)
    FROM PROFESSOR
    GROUP BY SECTION;
    
--1-5. AVG
--학과별 평점의 평균 
SELECT AVG(AVR)
    FROM STUDENT
    GROUP BY MAJOR;

--학과별 평점 평균의 최대값
--학과별 평점의 평균을 가져오는 쿼리 만들어진 가상 테이블의 전체 데이터를 사용해서
--통계를 내는 거니까 별도의 GROUP BY는 필요없다. 
SELECT MAX(AVG(AVR))
    FROM STUDENT
    GROUP BY MAJOR;

--1-6. HAVING절 : GROUP BY절에 명시된 컬럼들에 대한 조건 작성 
--DNO이 10, 20, 30인 부서의 평균 급여 
SELECT DNO 
     , AVG(SAL)
    FROM EMP
    GROUP BY DNO 
    HAVING DNO IN ('10', '20', '30');
    
--GROUP BY에 명시됐거나 통계함수가 아닌 컬럼은 HAVING절에 사용 불가 
SELECT DNO 
     , AVG(SAL)
    FROM EMP
    GROUP BY DNO 
    HAVING COMM > 600; --사용 못 함 
    
--AND/OR 여러 개의 조건을 붙일 수 있다. 
SELECT DNO 
     , AVG(SAL)
    FROM EMP
    GROUP BY DNO 
    HAVING DNO IN ('10', '20', '30')
    AND AVG(SAL) <= 3000;
    
--부서 중 평균급여가 가장 높은 부서번호와 평균급여(EMP테이블만 사용)
--그룹함수에 대한 조건은 WHERE절에서 사용불가 
SELECT DNO
     , AVG(SAL)
    FROM EMP
    GROUP BY DNO
    HAVING AVG(SAL) = (
                    SELECT MAX(AVG(SAL))
                        FROM EMP
                        GROUP BY DNO
                        );
    
--WHERE절에서 그룹함수 쓰는 방식은 그룹함수를 사용한 쿼리를 서브쿼리로 묶어서 테이블로 만든 후 사용한다.    
SELECT *
    FROM (
        SELECT DNO
             , AVG(SAL) AS AVG_SAL
            FROM EMP
            GROUP BY DNO
    )AVGSAL
    WHERE AVGSAL.AVG_SAL = (
                            SELECT MAX(AVG(SAL))
                                FROM EMP
                                GROUP BY DNO
                            );   
                            
--임용년도가 동일한 교수의 수를 조회 
SELECT TO_CHAR(HIREDATE, 'YYYY')
     , COUNT(*)
    FROM PROFESSOR
    GROUP BY TO_CHAR(HIREDATE, 'YYYY');