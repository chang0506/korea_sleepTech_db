### 스프링 부트 폴더 최상단 query.sql ###

CREATE DATABASE IF NOT EXISTS `springboot_db`;

USE `springboot_db`;

-- 주문 관리 시스템 (트랜잭션, 트리거, 인덱스, 뷰 학습) --
CREATE TABLE IF NOT EXISTS `products` (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `stocks` (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Foreign Key (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS `orders` (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- EX) 주문 대기 상태 -- 담당자가 주문 승인 시 상태 변경
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    Foreign Key (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS `order_items` (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL, -- orders 테이블 참조 (주문의 공통 상태를 저장)
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL, -- 주문 수량
    Foreign Key (order_id) REFERENCES orders(id),
    Foreign Key (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS `order_logs` (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    Foreign Key (order_id) REFERENCES orders(id)
);

# 초기 데이터 삽입 스크립트 #
-- 기본 상품 등록
INSERT INTO products (name, price)
VALUES
    ('슬립테크 매트리스', 120),
    ('수면 측정기기', 45),
    ('아로마 수면램프', 30);
-- 재고 등록
INSERT INTO stocks (product_id, quantity)
VALUES
    (1, 100),
    (2, 30),
    (3, 45);

# 인덱스 추가 (제품먕 순서로 빠르게 검색하는 인덱스 추가)
CREATE INDEX idx_product_name ON products(name);

# 주문 요약 뷰 생성
CREATE OR REPLACE VIEW order_summary AS
SELECT
    o.id AS order_id, o.user_id, p.name AS product_name, oi.quantity, p.price,
    (oi.quantity * p.price) AS total_price
FROM
    orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id;
# 주문 생성 트리거
DELIMITER // -- 구분 문자 변경 (기본값 ;)
CRAETE TRIGGER trg_after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_logs(order_id, message)
    VALUES (NEW.id, CONCAT('주문이 생성되었습니다. 주문 ID: ', NEW.id));
END ; 
//
DELIMITER ;

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
    CONSTRAINT chk_category CHECK (
        category IN (
            'NOVEL',
            'ESSAY',
            'POEM',
            'MAGAZINE'
        )
    )
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
    FOREIGN KEY (post_id) REFERENCES post (id) ON DELETE CASCADE
);

SELECT * FROM post;

SELECT * FROM comment;

-- users(사용자) 테이블 --
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME
);

SELECT * FROM users;

-- authority(권한) 관련 테이블 --
# 권한 관리 테이블 설계(정규화 방식)
# : 권한 종류를 roles 테이블로 분리
#   , 이를 참조하여 user_roles에 저장
# > 역할 이름을 고유값으로 관리, role_id를 통해 연결
CREATE TABLE IF NOT EXISTS roles (
	role_id BIGINT AUTO_INCREMENT PRIMARY KEY, -- 역할 고유 ID
    role_name VARCHAR(50) NOT NULL UNIQUE      -- 역할 이름 (ex. ADMIN, USER), 중복 불가
);

# 해당 테이블은 사용자와 역할의 관계를 나타내는 중간 테이블
# : 사용자 한 명이 여러 역할을 가질 수 있고
#   , 하나의 역할도 여러 사용자에게 부여될 수 있음
# > 다대다(ManyToMany) 관계
CREATE TABLE IF NOT EXISTS user_roles (
	user_id BIGINT NOT NULL,
	role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id), -- 복합 기본키: 중복 매핑 방지
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

SELECT * FROM roles;

SELECT * FROM user_roles;

-- log(기록) 테이블 --
# 권한 변경 시 기록(로그) 테이블에 자동 저장
CREATE TABLE IF NOT EXISTS role_change_logs(
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL, -- 권한이 변경된 사용자 ID(PK)
    email VARCHAR(255) NOT NULL, -- 사용자 이메일
    prev_roles TEXT,
    new_roles TEXT,
    changed_by VARCHAR(255) NOT NULL, -- 변경을 수행한 관리자 이메일
    change_type VARCHAR(20) NOT NULL, -- 변경 유형(ADD, REMOVE, UPDATE 등)
    change_reason VARCHAR(255), -- 변경 사유(필요 시 사용)
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE
);

SELECT * FROM role_change_logs;

------------------------------------------
# 파일 시템

CREATE Table if not exists posts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) not NULL,
    content Text Not NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
);

CREATE Table if not exists communities (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) not NULL,
    content Text Not NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
);

create table if not exists upload_files (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    original_name VARCHAR(255) not NULL, -- 사용자가 업로드한 원래 이름
    file_name VARCHAR(255) not NULL, -- 서버에 저장된 이름
    file_path VARCHAR(500) not NULL, -- 전체 경로 또는 상대 경로
    file_type VARCHAR(100), -- MIME 타입 (image/png)
    file_size BIGINT NOT null, -- 파일 크기(bytes)

    target_id BIGINT not NULL,
    target_type ENUM('POST', 'COMMUNITY') not NULL,

    index idx_target (target_type, target_id)
);

select * from posts;
