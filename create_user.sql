create user c##dbms_project identified by ashraf;
grant connect,resource,
   create view,
   create trigger
to c##dbms_project;
grant
   unlimited tablespace
to c##dbms_project;
