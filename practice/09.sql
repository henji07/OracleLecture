--1. DML
--1-1. INSERT INTO
--일부 컬럼만 데이터를 저장 
INSERT INTO EMP(ENO, ENAME, JOB, HDATE, SAL)
VALUES(3006, '김구만', '개발', SYSDATE, 3000);
COMMIT;

--모든 컬럼의 데이터를 저장
INSERT INTO EMP
VALUES('3007', '임꺽정', '설계', '2008', SYSDATE, 3000, 200, '30');
COMMIT;

--COMMIT, ROLLBACK
--COMMIT은 작업의 완료
--ROLLBACK은 작업의 취소, COMMIT되기 전의 변경사항 모두 취소 
INSERT INTO EMP
VALUES('3008', '장길산', '분석', '2008', SYSDATE, 3000, 100, '20');
ROLLBACK;

INSERT INTO EMP
VALUES('3008', '장길산1', '분석', '2008', SYSDATE, 3000, 100, '20');

INSERT INTO EMP
VALUES('3009', '장길산2', '분석', '2008', SYSDATE, 3000, 100, '20');

INSERT INTO EMP
VALUES('3010', '장길산3', '분석', '2008', SYSDATE, 3000, 100, '20');

INSERT INTO EMP
VALUES('3011', '장길산4', '분석', '2008', SYSDATE, 3000, 100, '20');

ROLLBACK;

SELECT *
    FROM EMP;
    
--1-2. INSERT INTO 다량의 데이터 한번에 저장
CREATE TABLE EMP_COPY1(
    ENO VARCHAR2(4),
    ENAME VARCHAR2(20),
    JOB VARCHAR2(10),
    MGR VARCHAR2(4),
    HDATE DATE,
    SAL NUMBER(5),
    COMM NUMBER(5),
    DNO VARCHAR2(2)
);

--EMP 테이블에서 DNO이 30인 데이터들만 기져와서 저장 
INSERT INTO EMP_COPY1
SELECT * 
    FROM EMP 
    WHERE DNO = '30';
COMMIT;

SELECT * 
    FROM EMP_COPY1;
    
--COURSE_PRESS 테이블 
CREATE TABLE COURSE_PRESS(
    CNO VARCHAR2(8),
    CNAME VARCHAR2(20),
    ST_NUM NUMBER(1, 0),
    PNO VARCHAR2(8),
    PNAME VARCHAR2(20)
);

--COURSE_PRESS 테이블에 COURSE, PROFESSOR 조인해서 PNAME까지 저장
INSERT INTO COURSE_PRESS
SELECT C.CNO
     , C.CNAME
     , C.ST_NUM
     , C.PNO
     , P.PNAME
    FROM COURSE C
    LEFT JOIN PROFESSOR P
    ON C.PNO = P.PNO;
    
COMMIT;

SELECT * 
    FROM COURSE_PRESS;

--데이터 삭제하는 DELETE FROM
DELETE FROM COURSE_PRESS;
COMMIT;

--다시 넣기 
INSERT INTO COURSE_PRESS
SELECT C.CNO
     , C.CNAME
     , C.ST_NUM
     , C.PNO
     , P.PNAME
    FROM COURSE C
    LEFT JOIN PROFESSOR P
    ON C.PNO = P.PNO;
    
COMMIT;

--1-3. UPDATE SET
--전체 데이터 수정 
UPDATE EMP_COPY1
    SET
        MGR = '0001';
  
ROLLBACK;
        
SELECT *
    FROM EMP_COPY1;
    
--사원번호 3005번 보너스 1800으로 수정
UPDATE EMP_COPY1
    SET 
        COMM = 1800
    WHERE ENO = '3005';
    
--사원번호 3005번 보너스 1800으로 수정(연산 사용)
UPDATE EMP_COPY1
    SET 
        COMM = COMM * 3
    WHERE ENO = '3005';
    
--PROFESSOR테이블의 HIREDATE를 +20년 해서 업데이트
UPDATE PROFESSOR
    SET
        HIREDATE = ADD_MONTHS(HIREDATE,240);
COMMIT;

SELECT * 
    FROM PROFESSOR;

--EMP_COPY1의 데이터 삭제 
DELETE FROM EMP_COPY1;

--EMP 전체 데이터를 EMP_COPY1에 저장
INSERT INTO EMP_COPY1
SELECT * FROM EMP;

--30, 20번 부서 사원들 60부서로 통합 보너스가 현재 보너스의 *1.5
UPDATE EMP_COPY1
    SET DNO = '60',
        COMM = COMM*1.5
    WHERE DNO IN('20', '30');
    
--DEPT_COPY 테이블 생성
CREATE TABLE DEPT_COPY1
    AS SELECT * FROM DEPT;
    
SELECT * 
    FROM DEPT_COPY1;
    
--서브쿼리를 이용한 데이터 수정 
UPDATE DEPT_COPY1
    SET 
        (DNO, DNAME, LOC) = (
                            SELECT DNO
                                 , DNAME
                                 , LOC
                                FROM DEPT
                                WHERE DNO = '50'
                            )
    WHERE DNO IN ('20', '30');
    
--40번 부서의 DIRECTOR를 EMP테이블의 급여가 제일 높은 사원으로 업데이트 
UPDATE DEPT_COPY1
    SET 
        DIRECTOR = (
                    SELECT ENO
                        FROM EMP 
                        WHERE SAL =(
                                        SELECT MAX(SAL)
                                            FROM EMP
                                    )                
                    )
    WHERE DNO = '40';
    
--1-4. DELETE FROM 
--전체 데이터 삭제 => 조건절 생략 
DELETE FROM EMP_COPY1;

SELECT*FROM EMP_COPY1;

--일부 데이터 삭제 => WHERE절로 조건 추가 
DELETE FROM EMP_COPY1
WHERE JOB = '지원';

--WHERE절에 서브쿼리를 사용하여 특정 데이터 삭제 
--EMP_COPY1에서 급여가 4000이상되는 사원 정보 삭제 
DELETE FROM EMP_COPY1
    WHERE ENO IN (
                    SELECT ENO
                        FROM EMP_COPY1
                        WHERE SAL >= 4000
              );
              
--STUDENT테이블 참조하여 ST_COPY 테이블 생성
CREATE TABLE ST_COPY
    AS SELECT * FROM STUDENT;
    
SELECT * 
    FROM ST_COPY;
    
--SCORE 학생별 기말고사 성적 평균이 60이상인 학생정보 ST_COPY에서 삭제 
DELETE FROM ST_COPY
    WHERE SNO IN (
                    SELECT SNO
                        FROM SCORE 
                        GROUP BY SNO
                        HAVING AVG(RESULT) >= 60
                  );
SELECT *
    FROM ST_COPY
    WHERE SNO IN ('915301', '935602');
    
--1-5. LOCK
--수정 후 트랜잭션 완료 안함 
UPDATE EMP_COPY1
    SET ENAME = 'rrr'
    WHERE DNO = '60';
    
SELECT * FROM EMP_COPY1;

--SELECT DEADLOCK 구문 (데이터가 많을 경우)
SELECT A.*
     , B.*
     , C.*
    FROM STUDENT A,
         SCORE B,
         PROFESSOR C;