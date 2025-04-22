create database jdbc_db;

use jdbc_db;

create table member (
  id int AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(100)
);

insert into member
VALUES
  (null, '전창현', 'qwe123'),
  (null, '문창배', 'asd456'),
  (null, '진우태', 'zxc789');

SELECT * from member;