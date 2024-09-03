그룹별 판매량, 비율 구하기

-- 그룹별 판매량과 비율 구하기
create table tb_statistic (
    id bigint auto_increment primary key ,
    seg varchar(255),
    tot_amt bigint
);

insert into tb_statistic(seg, tot_amt) values('GOLD', 100);
insert into tb_statistic(seg, tot_amt) values('GOLD', 200);
insert into tb_statistic(seg, tot_amt) values('SILVER', 300);
insert into tb_statistic(seg, tot_amt) values('SILVER', 700);
insert into tb_statistic(seg, tot_amt) values('PLATINUM', 800);
insert into tb_statistic(seg, tot_amt) values('PLATINUM', 1000);
insert into tb_statistic(seg) values('4_NULL');

select *
from tb_statistic;

-- 이렇게 짜는게 가독성도 좋고 명확하고 유지보수가 좋아보임
with total as (
    select sum(tot_amt) as total_amt
    from tb_statistic
)
select seg,
       sum(tot_amt) as tot_amt,
       -- 100 대신 100.0을 사용하는 이유는 정수 연산과 소수점 연산의 차이 때문
       -- SQL에서는 연산에 사용되는 숫자의 타입에 따라 결과가 달라질 수 있음
       -- 100.0을 사용하면 SQL은 나머지 계산이 부동 소수점 연산으로 처리될 것임을 보장
       ROUND((sum(tot_amt) / total.total_amt) * 100.0, 2) as ratio
from tb_statistic
join total
group by seg
order by seg;

/**
 크로스 조인은 두 테이블 간의 모든 가능한 조합(카티션 곱)을 생성합니다.
  조인 조건이 없거나, 조인 조건이 모든 행을 포함하는 경우에 발생
 서브쿼리가 단일 행을 반환하는 경우, 실질적으로 각 행에 서브쿼리의 결과가 결합됩니다.
 데이터 양이 많아지면 성능에 영향을 줄 수 있습니다.
 명시적인 조인 구문을 사용하는 것보다 이해하기 어려울 수 있습니다.
 */
SELECT
    seg,
    SUM(tot_amt) AS total_sales,
    SUM(tot_amt) * 100.0 / total_amt AS sales_percentage
FROM  tb_statistic m
-- 서브쿼리가 단일 행을 반환하는 경우, 실질적으로 각 행에 서브쿼리의 결과가 결합됩니다.
CROSS JOIN (SELECT SUM(tot_amt) total_amt FROM tb_statistic) total
GROUP BY seg;