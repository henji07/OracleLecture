--1. 단일 함수
--1-1. 문자 함수 
--LOWER, UPPER, INITCAP
SELECT DNO
     , LOWER(DNAME)
     , UPPER(DNAME)
     , INITCAP(DNAME)
    FROM DEPT;
    
SELECT *
    FROM DEPT;
    
--부서명이 erp인 정보를 조회
--부서명의 대, 소문자를 모를 때 
SELECT DNO
     , DNAME
    FROM DEPT
    WHERE LOWER(DNAME) = 'erp';

--1-2.문자 연산 함수
--CONCAT
SELECT CONCAT(DNO, ' : ' || DNAME || ' : ' || LOC)
    FROM DEPT;

SELECT DNO || ' : ' || DNAME || ' : ' || LOC
    FROM DEPT;

--SUBSTR
--SUBSTR(n, cnt)은 n번째 글자부터 cnt개를 가져온다. 
SELECT SUBSTR(ORDERS, 1, 3)
    FROM PROFESSOR;

SELECT *
    FROM PROFESSOR
    WHERE SUBSTR(ORDERS, 1, 1) = '정';
    
SELECT ENAME 
     , SUBSTR(ENAME, 2)     --두 번째 글자부터 모두
     , SUBSTR(ENAME, -2)    --뒤에서 두 번째 글자부터 모두
     , SUBSTR(ENAME, 1, 2)  --첫 번째 글자부터 두 글자
     , SUBSTR(ENAME, -2, 2) --뒤에서 두 번째 글자부터 두 글자 
    FROM EMP;
    
--LENGTH, LENGTHB
SELECT DNAME 
     , LENGTH(DNAME)
     , LENGTHB(DNAME)
    FROM DEPT;
    
--현재 오라클이 사용중인 문자셋 AL32UTF8 => 한글 3byte
SELECT *
    FROM NLS_DATABASE_PARAMETERS
    WHERE PARAMETER = 'NLS_CHARACTERSET'
       OR PARAMETER = 'NLS_NCHAR_CHARACTERSET';

--INSTR 
--DUAL 테이블: 오라클에서 제공해주는 가상의 기본 테이블
--           간단하게 날짜나 연산 또는 결과값을 보기 위해 사용
--           원래 DUAL 테이블 소유자는 SYS로 되어있는데 모든 USER에서 접근 가능 
SELECT INSTR('DATABASE', 'A')       --첫 번째 A의 위치
     , INSTR('DATABASE', 'A', 3)    --세 번째 글자인 T 다음의 첫 번째 A의 위치 
     , INSTR('DATABASE', 'A', 1, 3) --첫 번째 글자 D 다음의 세 번째 A의 위치
     , SYSDATE 
     , 1 + 2
    FROM DUAL;
    
--TRIM
SELECT TRIM('조'FROM '조병조')              --both 생략, 앞뒤의 조를 제거
     , TRIM(leading '조' FROM '조병조')     --앞에 있는 조 제거
     , TRIM(trailing '조' FROM '조병조')    -- 뒤에 있는 조 제거 
     , TRIM(' 조 병 조 ')                  -- 앞 뒤 공백 제거 
    FROM DUAL;
    
--LPAD, PRAD : CHARSET이 한글을 3byte로 잡아도 컴퓨터에서는 2byte로 사용하기 때문에
--             한글연산 자체는 2byte로 진행된다. 
SELECT LPAD(ENAME, 10, '*') --사원명 앞에 *을 붙여서 총 길이를 10으로 만듦
     , RPAD(ENAME, 10, '*') --사원명 뒤에 *을 붙여서 총 길이를 10으로 만듦
    FROM EMP;
    
--직원이름을 출력하는데 마지막 글자만 제거해서 출력(SUBSTR, LENGTH)
SELECT SUBSTR(ENAME, 1, LENGTH(ENAME) - 1)
    FROM EMP;

--1-3. 문자열 치환 함수 
--TRANSLATE, REPLACE
SELECT TRANSLATE('World Of Warcraft', 'Wo', '--')   --문자 단위로 동작하기 때문에 모든 W, o 치환
     , REPLACE('World Of Warcraft', 'Wo', '--')     --문자열 단위로 동작하기 때문에 Wo가 치환
    FROM DUAL;
    
--1-4. 숫자 함수
--ROUND(지정한 자리수까지 반올림)
SELECT ROUND(123.454678, 3)
    FROM DUAL;

--TRUNC(지정한 자리수 뒤의 숫자 버림)
SELECT TRUNC(123.454678, 3)
    FROM DUAL;
    
--MOD(나머지 값)
SELECT MOD(10, 4)
    FROM DUAL;

--POWER(몇 제곱값)
SELECT POWER(10, 3)
    FROM DUAL;
    
--CEIL, FLOOR(제일 가까운 정수 값)
SELECT CEIL(2.59)
     , FLOOR(2.59)
    FROM DUAL;
    
--ABS(절대값)
SELECT ABS(10)
     , ABS(-10)
    FROM DUAL;

--SQRT(제곱근 값)
SELECT SQRT(9)
     , SQRT(25)
     , SQRT(100)
    FROM DUAL;

--SIGN(부호판단)   
SELECT SIGN(-123)
     , SIGN(52)
     , SIGN(0)
    FROM DUAL;
    
--1-4. 날짜 연산
SELECT SYSDATE
     , SYSDATE + 100    --100일 후의 날짜
     , SYSDATE - 100    --100일 이전의 날짜
     , SYSDATE + 3 / 24 --3시간 후의 날짜
     , SYSDATE - 5 / 24 --5시간 이전의 날짜 
     , SYSDATE - TO_DATE('20220413', 'YYYY/MM/DD') --두 날짜간 차이 일수(시간, 분, 초 땜누에 정확히 나오지 않음)
     , TRUNC(SYSDATE) - TO_DATE('20220413', 'YYYY/MM/DD') --TLUNC -> 시분초 초기화 => 365로 정확히 나옴 
    FROM DUAL;
    
--1-5.날짜 함수
--ROUND
SELECT ROUND(SYSDATE, 'MM')
    FROM DUAL;
    
SELECT ROUND(TO_DATE('20230424 00:00:00', 'yyyymmdd HH24:mi:SS'), 'mm')
    FROM DUAL;

--TRUNC
SELECT TRUNC(SYSDATE)
    FROM DUAL;
    
SELECT TRUNC(SYSDATE, 'YYYY')
    FROM DUAL;
    
--MONTHS_BETWEEN
SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('2023/02/13', 'yyyy/MM/dd'))
    FROM DUAL;
    
--ADD MONTHS
SELECT ADD_MONTHS(SYSDATE, 3)
    FROM DUAL;
    
--NEXT_DAY
SELECT NEXT_DAY(SYSDATE, '수요일')
    FROM DUAL;
    
--LAST DAY
SELECT LAST_DAY(TO_DATE('20210618', 'yyyyMMdd'))
    FROM DUAL;

--사원들의 입사일과 입사 100일 후의 날짜와 10년 뒤 날짜 
SELECT HDATE 
     , HDATE + 100 
     , ADD_MONTHS(HDATE, 120)
    FROM EMP;