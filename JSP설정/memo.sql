
create table memo (
    idx number not null primary key,
    writer VARCHAR2(50) not null,
    memo VARCHAR2(255) not null, 
    post_date date default SYSDATE
);


select max(idx)+1 from memo;
select nvl(max(idx)+1,1) from memo; 

insert into memo (idx, writer, memo)
values ((select nvl(max(idx)+1,1) from memo), 'kim','memo01' );
insert into memo (idx, writer, memo)
values ((select nvl(max(idx)+1,1) from memo), 'park','memo02' );

select * from memo;

commit;

