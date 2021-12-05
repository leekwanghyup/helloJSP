# 도서정보테이블 모델1

## 테이블 생성 
```sql

create table books(
    idx number primary key, 
    title varchar2(50), 
    author varchar2(20),
    price number default 0,
    amount number default 0
);

insert into books  values (
    (select nvl(max(idx)+1, 1) from books),
    'Java', 'hanbit', 30000, 50
) ;

insert into books  values (
    (select nvl(max(idx)+1, 1) from books),
    'PYTHON', 'samsung', 40000, 40
) ;

insert into books  values (
    (select nvl(max(idx)+1, 1) from books),
    'Spring', 'WikiBooks', 50000,30
) ;

commit;

select * from books;

-- nvl(A,B)
-- A가 null이면 B값을 기본값으로 사용한다. 

```