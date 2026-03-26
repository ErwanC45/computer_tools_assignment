spool c:\w26\projectgroup.txt
set echo ON
connect sys/sys as sysdba
SELECT to_char(sysdate,'DD Month YYYY Day Year HH:MI:SS') FROM dual;
drop user c##projectgroup cascade;
create user c##projectgroup identified by 1234;
grant connect, resource to c##projectgroup;
alter user c##projectgroup quota 100m on users;
connect c##projectgroup/1234;

-- Create tables and constraints
 
create table staff(
    staffID number(6,0),
    staffname varchar2(30),
    hiredate Date CONSTRAINT staff_hiredate_NN NOT NULL,
    staffphone NUMBER(10),
    job varchar2(20),
    staffemail VARCHAR2(50),
    constraint staff_staffID_PK primary key (staffID),
    CONSTRAINT staff_staffphone_uk UNIQUE (staffphone),
    CONSTRAINT staff_staffemail_uk UNIQUE (staffemail)
);

create table service (
    serviceID number constraint service_serviceID_pk primary key,
    servicename varchar2(100) constraint service_servicename_nn not null,
    staffID number, 
    duration INTERVAL DAY TO SECOND constraint service_duration_cc check(duration > TO_DSINTERVAL ('0 00:00:01')),
    price number constraint service_price_cc check (price>0), 
    constraint service_staffID_fk foreign key (staffID) references staff (staffID)
);

ALTER table SERVICE
ADD (room number);

create table client(
    clientID number, 
    clientname varchar2(50), 
    clientemail varchar2(50), 
    clientphone number, 
    birthdate date
);

ALTER table client
DROP COLUMN birthdate;

alter table client
add constraint client_clientID_pk primary key (clientID);

alter table client
add constraint client_clientemail_uk unique (clientemail);

alter table client
add constraint client_clientphone_uk unique (clientphone);

create table APPOINTMENT (
    ClientID NUMBER, 
    ServiceID NUMBER, 
    AppointmentDate DATE CONSTRAINT Appointment_AppointmentDate_NN NOT NULL, 
    Status varchar2 (10) CONSTRAINT Appointment_Status_NN NOT NULL CONSTRAINT Appointment_Status_CC CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')),
    CONSTRAINT Appointment_ClientID_ServiceID_PK PRIMARY KEY (ClientID, ServiceID),
    CONSTRAINT Appointment_ClientID_FK FOREIGN KEY (ClientID) REFERENCES Client (ClientID),
    CONSTRAINT Appointment_ServiceID_FK FOREIGN KEY (ServiceID) REFERENCES Service (ServiceID)
);

-- Verification

SELECT table_name FROM user_tables;
	desc STAFF
	desc CLIENT
	desc SERVICE
	desc APPOINTMENT
	SELECT constraint_name, constraint_type, table_name  FROM user_constraints;

-- Create the sequences and insert the values

CREATE SEQUENCE staff_sequence;
CREATE SEQUENCE clientid_seq start with 10 increment by 10;
CREATE SEQUENCE service_sequence START WITH 100 increment by 100;


insert into staff(staffid,staffname,hiredate,staffphone,job,staffemail)
values (staff_sequence.NEXTVAL,'Nadia',SYSDATE,5144241234,'OWNER','staff_nadia@gmail.com');
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  'homeopathy information',staff_sequence.currval, 130,TO_DSINTERVAL ('0 00:30:00'));
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  'wellness circuit',staff_sequence.currval, 90,TO_DSINTERVAL ('0 00:40:00'));

insert into staff(staffid,staffname,hiredate,staffphone,job,staffemail)
values (staff_sequence.NEXTVAL,'Pamela',SYSDATE,4386771234,'cleaner','staff_pamela@hotmail.com');
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  'reiki',staff_sequence.currval, 50, TO_DSINTERVAL('0 00:30:00'));
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  ' card reading',staff_sequence.currval, 50,TO_DSINTERVAL ('0 00:20:00'));
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  'children holistics wellness',staff_sequence.currval, 70,TO_DSINTERVAL ('0 01:00:00'));
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  'harmonic egg',staff_sequence.currval, 150,TO_DSINTERVAL ('0 00:50:00'));

insert into staff(staffid,staffname,hiredate,staffphone,job,staffemail)
values (staff_sequence.NEXTVAL,'Sarah',SYSDATE,5144092540,'manager','staff_sarah@gmail.com');
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  'sound bath',staff_sequence.currval, 100, TO_DSINTERVAL('0 01:00:00'));
 
insert into staff(staffid,staffname,hiredate,staffphone,job,staffemail)
values (staff_sequence.NEXTVAL,'Valerie',SYSDATE,4380981210,'massage','staff_valerie@yahoo.com');
    insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL,  'yoga',staff_sequence.currval, 100,TO_DSINTERVAL ('0 02:0:00'));

insert into client
values(clientid_seq.nextval,'HARRY','harry@gmail.com',4893992657);
insert into client
values(clientid_seq.nextval,'ALEX','alex@gmail.com',4892227865);
insert into client
values(clientid_seq.nextval,'SMITH','smith@gmail.com',4732229876);
insert into client
values(clientid_seq.nextval,'KATIE','katie@gmail.com',4214879999);
insert into client
values(clientid_seq.nextval,'KNIE','knie@gmail.com',4222840222);
insert into client
values(clientid_seq.nextval,'PERY','pery@gmail.com',4784265356);
insert into client
values(clientid_seq.nextval,'TAYLOR','taylor@gmail.com',4892223176);
insert into client
values(clientid_seq.nextval,'JUSTIN','justin@gmail.com',3786541198);
insert into client
values(clientid_seq.nextval,'MISTER','mister@gmail.com',3894765342);
insert into client
values(clientid_seq.nextval,'KIM','kim@gmail.com',4241110909);
select * from client;
update client
set clientname = 'HENRY', clientemail = 'henry@gmail.com'
where clientid = 60;
update client
set clientname = 'MARY', clientemail = 'mary@gmail.com'
where clientid = 80;
select * from client;
savepoint A;
delete from client
where clientid = 90;
delete from client
where clientid = 100;
select * from client;
rollback to A;
select * from client;
select clientname, clientemail, clientphone
from client
where clientname like 'K%';
select clientname, clientemail, clientphone
from client
where clientname like 'H%';
select clientname, clientemail, clientphone
from client
where clientname like '%I%';
select clientname, clientemail, clientphone
from client
where clientname like '%Y%';


insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (10,300, SYSDATE, 'Cancelled');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (10,400, SYSDATE, 'Cancelled');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (30,600, SYSDATE, 'Scheduled');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (30,200, SYSDATE, 'Scheduled');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (50,100, SYSDATE, 'Completed');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (20,500, SYSDATE, 'Scheduled');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (20,600, SYSDATE, 'Scheduled');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (90,100, SYSDATE, 'Completed');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (90,400, SYSDATE, 'Completed');

insert into Appointment (clientID, ServiceID, AppointmentDate, Status)
values (90,800, SYSDATE, 'Completed');


-- Verify

select * from staff;
select * from service;
select * from client;
select * from appointment;
