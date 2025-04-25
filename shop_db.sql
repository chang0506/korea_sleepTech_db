create database shop_db;
use shop_db;

create table `user` (
  id int AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) not NULL
);

create table `order` (
  id int AUTO_INCREMENT PRIMARY KEY,
  user_id int,
  product_name VARCHAR(100) not NULL,
  amount int NOT NULL,
  # on delete CASCADE
  # : 부모 테이블의 행(레코드)이 삭제되면, 그 행을 참조하고 있는 자식 테이블의 행들도 함께 삭제
  Foreign Key (user_id) REFERENCES user(id) on delete CASCADE
);

SELECT * from `user`;
SELECT * from `order`;
