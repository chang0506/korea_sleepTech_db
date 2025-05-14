### 스프링 부트 폴더 최상단 query.sql ###

CREATE DATABASE IF NOT EXISTS `springboot_db`;

USE `springboot_db`;

-- test 테이블 --
CREATE TABLE IF NOT EXISTS test (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

SELECT * FROM test;

-- student 테이블 --
CREATE TABLE IF NOT EXISTS student (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

SELECT * FROM student;

-- book 테이블 --
CREATE TABLE IF NOT EXISTS book (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    writer VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    content VARCHAR(500) NOT NULL,
    category VARCHAR(255) NOT NULL,
    CONSTRAINT chk_category CHECK (category IN ('NOVEL', 'ESSAY', 'POEM', 'MAGAZINE'))
);

SELECT * FROM book;

-- post(게시물) 테이블 --
CREATE TABLE IF NOT EXISTS post (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL
);

-- comment(댓글) 테이블 --
CREATE TABLE IF NOT EXISTS comment (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_id BIGINT,
    content VARCHAR(255) NOT NULL,
    commenter VARCHAR(255) NOT NULL,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE
);

SELECT * FROM post;
SELECT * FROM comment;

CREATE TABLE IF NOT EXISTS users (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME
);

use springboot_db;

show tables;


-- authority(권한) 관련 테이블 --
# 권한 관리 테이블 설계(정규화 방식)
# : 권한 종류를 roles 테이블로 분리
# 	, 이를 참조하여 user_roles 테이블에 저장
# > 역할 이름을 고유값으로 관리, role_id를 통해 연결
CREATE TABLE IF NOT EXISTS roles (
	role_id BIGINT AUTO_INCREMENT PRIMARY KEY, -- 역할 고유 ID
    role_name VARCHAR(50) NOT NULL UNIQUE 	   -- 역할 이름 (ex. ADMIN, USER), 중복 불가
);

INSERT INTO roles (role_name)
VALUES
('USER'), ('ADMIN'), ('MANAGER');

SELECT * FROM roles;
SELECT * FROM user_roles;

# 해당 테이블은 사용자와 역할의 관계를 나타내는 중간 테이블
# : 사용자 한 명이 여러 역할을 가질 수 있고,
#	, 하나의 역할도 여러 사용자에게 부여될 수 있음
# > 다대다(ManyToMany) 관계
CREATE TABLE IF NOT EXISTS user_roles (
	user_id BIGINT NOT NULL,
	role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id), -- 복합 기본키: 중복 매핑 방지
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE  
);

