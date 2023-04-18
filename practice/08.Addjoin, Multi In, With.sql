--1. 추가적인 조인 방식
--1-1. NATURAL JOIN 
--NATURAL JOIN에서는 조인되는 컬럼에 테이블의 별칭을 달아서 사용할 수 없다. 
--테이블 구조를 확실히 알지 못하고 어떤 컬럼이 조인될지 알지 못하면 쓰기 어려움 
SELECT SNO
     , SNAME
     , AVG(RESULT)
    FROM SCORE
    NATURAL JOIN STUDENT
    GROUP BY SNO, SNAME;
    
--학생별 기말고사 성적의 평균이 55점 이상인 학생번호, 학생이름, 기말고사 평균 조회(NATURAL JOIN)
SELECT SNO
     , SNAME
     , AVG(RESULT)
    FROM STUDENT
    NATURAL JOIN SCORE
    GROUP BY SNO, SNAME
    HAVING AVG(RESULT) >= 55;
    
--최대 급여가 4000만원 이상되는 부서의 번호, 부서 이름, 급여 조회
SELECT DNO
     , D.DNAME
     , MAX(E.SAL)
    FROM DEPT D
    NATURAL JOIN EMP E
    GROUP BY DNO, DNAME
    HAVING MAX(SAL) >= 4000;
    
--1-2. JOIN~USING
--JOIN~ON
SELECT SC.CNO
     , C.CNAME
     , AVG(SC.RESULT)
    FROM SCORE SC
    JOIN COURSE C
    ON SC.CNO = C.CNO
    GROUP BY SC.CNO, C.CNAME
    HAVING AVG(SC.RESULT) >= 53;
    
--JOIN~USING
SELECT CNO
     , C.CNAME
     , AVG(SC.RESULT)
    FROM SCORE SC
    JOIN COURSE C
    USING (CNO)
    GROUP BY CNO, C.CNAME
    HAVING AVG(SC.RESULT) >= 53;
    
--학점이 3점인 과목의 교수번호, 교수이름, 과목번호, 과목이름, 학점 
SELECT PNO
     , P.PNAME
     , C.CNO
     , C.CNAME
     , C.ST_NUM
    FROM PROFESSOR P
    JOIN COURSE C
    USING (PNO)
    WHERE C.ST_NUM >= 3;
    
--2.다중 컬럼 IN절
--DNO = 10이면서 JOB이 분석인 사원이나 DNO=20이면서 JOB이 개발인 사원 조회 
SELECT DNO 
     , ENO
     , ENAME
     , JOB
    FROM EMP
    WHERE(DNO, JOB) IN (('10', '분석'), ('20', '개발'));

--위 쿼리 뜻 
SELECT DNO 
     , ENO
     , ENAME
     , JOB
    FROM EMP
    WHERE(DNO = '10' AND JOB = '분석') OR (DNO = '20' AND JOB = '개발');
    
    
    
--잘못 작성한 쿼리
SELECT DNO 
     , ENO
     , ENAME
     , JOB
    FROM EMP
    WHERE DNO IN ('10', '20') 
      AND JOB IN ('분석', '개발');
      
--위 쿼리 뜻 
SELECT DNO 
     , ENO
     , ENAME
     , JOB
    FROM EMP
    WHERE (DNO = '10' AND (JOB = '분석' OR JOB = '개발'))
      OR  (DNO = '20' AND (JOB = '분석' OR JOB = '개발'));
      
--다중컬럼 IN절(CNO, PNO)을 이용해서 기말고사 성적의 평균이 48점 이상인 
--과목번호 과목명 교수번호 교수이름 기말고사의 성적 평균 조회 
SELECT CNO
     , C.CNAME
     , PNO
     , P.PNAME
     , AVG(SC.RESULT)
    FROM SCORE SC
    NATURAL JOIN COURSE C
    NATURAL JOIN PROFESSOR P 
    WHERE(CNO, PNO) IN 
                        (--기말고사 평균 48점 이상 CNO,PNO
                        SELECT CNO
                             , PNO
                            FROM SCORE SCC
                            NATURAL JOIN COURSE CC
                            NATURAL JOIN PROFESSOR PP
                            GROUP BY CNO, PNO
                            HAVING AVG(SCC.RESULT) >= 48
                        )
   GROUP BY CNO, C.CNAME, PNO, P.PNAME;

--사원의 정보를 다중 컬럼 IN을 이용해서 조회
--(DNO, MGR) 부서번호는 01, 02 사수번호 0001(서브쿼리 IN절로 묶어서)인
--사원번호, 사원이름, 사수번호, 부서번호 조회
SELECT ENO  
     , ENAME
     , MGR
     , DNO
    FROM EMP
    WHERE(DNO, MGR)IN 
                    (
                      SELECT DNO
                           , MGR
                        FROM EMP
                        WHERE DNO IN('01', '02') 
                         AND MGR = '0001' 
                    );

--3. WITH
--가상테이블 생성
WITH 
    DNO10 AS (SELECT * FROM DEPT WHERE DNO = '10'),
    JOBDEV AS (SELECT * FROM EMP WHERE JOB = '개발')
SELECT JOBDEV.ENO
     , JOBDEV.ENAME
     , JOBDEV.DNO
     , DNO10.DNAME
     , JOBDEV.JOB
    FROM JOBDEV
       , DNO10
    WHERE JOBDEV.DNO = DNO10.DNO;

--화학과 학생명단(STUDENT TABLE 컬럼 전체), 
--기말고사 성적 중 과목명에 화학이 포함되는 성적 정보를 가상 테이블로 생성
--(SCORE의 CNO, SNO, RESULT COURSE의 CNAME)
--학생별 화학이 포함된 과목의 기말고사 성적의 평균(학생번호, 학생이름, 평균성적)

WITH 
    STCHEMI AS (SELECT * FROM STUDENT WHERE MAJOR = '화학'),
    CRCHEMI AS (
                SELECT S.CNO
                     , C.CNAME
                     , S.SNO
                     , S.RESULT
                FROM COURSE C
                JOIN SCORE S
                ON C.CNO = S.CNO
                WHERE CNAME LIKE '%화학%')
SELECT SNO
     , STCHEMI.SNAME
     , ROUND(AVG(CRCHEMI.RESULT),2)
    FROM STCHEMI
    NATURAL JOIN CRCHEMI
    GROUP BY SNO, STCHEMI.SNAME;