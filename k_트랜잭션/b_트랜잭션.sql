use `트랜잭션`;


create table if not exists users (
  id int AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) not NULL,
  password VARCHAR(50) not NULL
);

create table if not exists user_setting (
  id int AUTO_INCREMENT PRIMARY KEY,
  user_id int,
  dark_mode boolean,
  Foreign Key (user_id) REFERENCES users(id) on delete cascade
);

# on delete cascade
# : 외래 키 제약 조건
# - 부모 테이블의 행이 삭제될 때(사용자가 삭제: 탈퇴)
# - , 참조하는 자식 테이블의 행도 자동으로 삭제되도록 설정하는 옵션
# >> 참조 무결성 유지!

create table if not exists logs (
  id int AUTO_INCREMENT PRIMARY KEY,
  message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

select * from users;
select * from user_setting;
select * from logs;

start TRANSACTION;

-- 1단계: 사용자 등록
insert into users (username, password) values ('jch', '1234');
savepoint step1; # 저장 위치명 지정

-- 2단계: 설정 추가
insert into user_setting (user_id, dark_mode)
VALUES
  (last_insert_id(), true);

  # cf) last_insert_id(): 마지막으로 자동 증가된 ID값을 반환
  #                     >> users 테이블의 id값을 반환!
savepoint step2;

-- 3단계: 로그 저장
insert into logs (message) VALUES ('회원가입 시도');

rollback to savepoint step1;
# >> 에러 발생했다고 가정! (2단계가 문제 > 1단계는 유지 / 2단계만 취소)
commit; -- 이후 다른 작업 이어가기 가능 (전체 종료 시 커밋)