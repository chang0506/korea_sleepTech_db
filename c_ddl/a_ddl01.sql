### c_ddl 폴더 >> a_ddl01 파일 생성

### DDL 문법 정리 ###
# create, alter, drop, truncate

-- 데이터 베이스 생성 --
### create: 데이터베이스 생성, 데이터를 저장하고 관리하는 첫 단계
# 기본 형태
# create database 데이터베이스명;
create database example;
create database school;

-- 테이블 생성 --
### create: 테이블 생성, 테이블에 저장될 데이터의 형태와 특성을 정의
# 데이터타입, 제약조건, 기본값 등의 설정 가능
# 기본 형태
# create table `데이터베이스`.`테이블명` (
#	컬럼 1 데이터타입 [선택적 옵션],
#	컬럼 2 데이터타입 [선택적 옵션],
#	컬럼 3 데이터타입 [선택적 옵션],
# 	...
#);

CREATE TABLE `school`.`students` (
    student_id INT,
    student_id INT,
    student_name CHAR(8),
    student_gender CHAR(8)
);

-- cf) 문자 인코딩 추가한 테이블 생성
# : UTF-8 문자 인코딩을 사용하여 한글 등의 문자 정보를 올바르게 저장할 수 있도록 설정
CREATE TABLE `school`.`students_encoding` (
    student_id INT,
    student_name CHAR(8),
    student_gender CHAR(8)
)  DEFAULT CHARACTER SET=UTF8;

#) cf) 데이터베이스명은 중복될 수 X, 같은 이름의 DB 생성 불가!

-- 데이터베이스 & 테이블 삭제 --
# drop: 데이터베이스와 테이블의 구조와 데이터 전체를 삭제
# 기본 형태
# drop database `데이터베이스명`;
# drop table `데이터베이스명`.`테이블명`;

drop table `school`.`students`;
drop database `school`;
drop database `korea_it`;
drop database `korea_it_encoding`;