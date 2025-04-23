create database if not exists board_db DEFAULT CHARACTER set utf8mb4 collate utf8mb4_general_ci;

use board_db;

create table if not exists post (
  id int AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) not NULL,
  content TEXT not NULL,
  author VARCHAR(50) not null,
  created_at DATETIME not NULL DEFAULT CURRENT_TIMESTAMP
);
drop table post;
select * from post;