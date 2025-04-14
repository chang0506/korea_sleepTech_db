use baseball_league;

select * from players;

select * from teams;

# 1. 내부 조인
# : 타자인 선수와 해당 선수가 속한 팀 이름 가져오기
# - players 테이블에서 선수 이름
# - teams 테이블에서 팀 이름
SELECT
  P.name, T.name
FROM
  players P -- 기준 테이블
    inner join teams T
    on P.team_id = T.team_id
WHERE
  P.position = '타자';

# 2. 1990년 이후 창단된 팀의 선수 목록 가져오기
# teams 테이블에서 팀 이름
# players 테이블에서 선수 이름
SELECT
  T.name, P.name
FROM
  teams T
    join players P
    on P.team_id = T.team_id
WHERE
  T.founded_year >= 1990;

# 외부 조인
# 3. "모든 팀"과 그 팀에 속한 선수 목록 가져오기
select T.name team_name, P.name player_name
from teams T
  left join players P
  on T.team_id = P.team_id;

# 4. "모든 선수"와 해당 선수가 속한 팀 이름 가져오기
SELECT
  P.name player_name, T.name team_name
FROM
  players P
    left join teams T
    on T.team_id = P.team_id;

# 5. "모든 팀"과 해당 팀에 속한 타자 목록 가져오기  
SELECT
  T.name team_name, P.name player_name 
FROM
  teams T
    left join players P
    on T.team_id = P.team_id
WHERE
  P.position = '타자';
