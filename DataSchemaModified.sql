create table AppUser(
USERID serial primary key,
UserName varchar(100) not null,
AGE int check(age>0),
emotionalState text
);
