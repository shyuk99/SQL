-- 유저목록
SELECT * FROM ALL_USERS;

-- 현재 유저 권한 확인
SELECT * FROM USER_SYS_PRIVS;

-- 계정생성
CREATE USER USER01 IDENTIFIED BY USER01; -- ID : USER01 PW : USER01

-- 권한부여 (접속권한, 테이블, 뷰, 시퀀스, 프로시저, 생성권한)
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE PROCEDURE TO USER01; -- USER01에게 부여

-- 테이블스페이스 (데이터를 저장하는 물리적인 공간) 지정
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
-- 수정한다 유저 USER01 기본 테이블스페이스는 USERS이고, 무제한으로 사용한다 ON USERS테이블스페이스를

-- 권한회수
REVOKE CREATE SESSION FROM USER01; -- 접속권한 회수

-- 계정삭제
DROP USER USER01;

----------------------------------------------------------------------------------------------------------------
-- ROLE - 권한의 그룹을 통한 권한부여
CREATE USER USER01 IDENTIFIED BY USER01;

GRANT CONNECT, RESOURCE TO USER01; -- CONNECT = 접속롤, RESOURCE = 개발롤 DBA = 관리자권한

-- 테이블스페이스 (데이터를 저장하는 물리적인 공간) 지정
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;






