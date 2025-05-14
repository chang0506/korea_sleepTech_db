create database `test-db`
    DEFAULT CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';

use `test-db`;

create table restaurant (
  id int PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  address VARCHAR(255),
  phoneNumber VARCHAR(255)
);

create table menu (
  id int PRIMARY KEY AUTO_INCREMENT,
  restaurant_id int,
  name VARCHAR(255),
  price DOUBLE,
  desciption VARCHAR(255),
  Foreign Key (restaurant_id) REFERENCES restaurant(id) on delete CASCADE
);