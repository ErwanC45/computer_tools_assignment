spool c:\w26\projectgroup.txt
set echo ON
connect sys/sys as sysdba
SELECT to_char(sysdate,'DD Month YYYY Day Year HH:MI:SS') FROM dual;
drop user c##projectgroup cascade;
drop user c##shivani cascade;
drop user c##solange cascade;
drop user c##toa cascade;
create user c##projectgroup identified by 1234;
grant connect, resource to c##projectgroup;
grant create view to c##projectgroup;
alter user c##projectgroup quota 100m on users;
create user c##shivani identified by 1234;
grant connect, resource to c##shivani;
alter user c##shivani quota 100m on users;
create user c##solange identified by 1234;
grant connect, resource to c##solange;
alter user c##solange quota 100m on users;
create user c##toa identified by 1234;
grant connect, resource to c##toa;
alter user c##toa quota 100m on users;

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
    servicename varchar2(40) constraint service_servicename_nn not null,
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
    VALUES (service_sequence.NEXTVAL, 'Homeopathy Information',staff_sequence.currval, 130,TO_DSINTERVAL ('0 00:30:00'));
insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL, 'Wellness Circuit',staff_sequence.currval, 90,TO_DSINTERVAL ('0 00:40:00'));

insert into staff(staffid,staffname,hiredate,staffphone,job,staffemail)
    values (staff_sequence.NEXTVAL,'Pamela',SYSDATE,4386771234,'OWNER','staff_pamela@hotmail.com');
insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL, 'Reiki',staff_sequence.currval, 59.99, TO_DSINTERVAL('0 00:30:00'));
insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL, 'Card Reading',staff_sequence.currval, 49.99,TO_DSINTERVAL ('0 00:20:00'));
insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL, 'Children Holistics Wellness',staff_sequence.currval, 69.99,TO_DSINTERVAL ('0 01:00:00'));
insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL, 'Harmonic Egg',staff_sequence.currval, 149.99,TO_DSINTERVAL ('0 00:50:00'));

insert into staff(staffid,staffname,hiredate,staffphone,job,staffemail)
    values (staff_sequence.NEXTVAL,'Sarah',SYSDATE,5144092540,'Consultant','staff_sarah@gmail.com');
insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL, 'Sound Bath',staff_sequence.currval, 100, TO_DSINTERVAL('0 01:00:00'));
 
insert into staff(staffid,staffname,hiredate,staffphone,job,staffemail)
    values (staff_sequence.NEXTVAL,'Valerie',SYSDATE,4380981210,'Yoga Instructor','staff_valerie@yahoo.com');
insert into service ( serviceid, servicename,staffid,price, duration)
    VALUES (service_sequence.NEXTVAL, 'Yoga',staff_sequence.currval, 100,TO_DSINTERVAL ('0 02:0:00'));

commit;

insert into client
    values(clientid_seq.nextval,'HARRY','harry@gmail.com',4893992657);
insert into client
    values(clientid_seq.nextval,'ALEX','alex@gmail.com',4892227865);
insert into client
    values(clientid_seq.nextval,'smith','smith@gmail.com',4732229876);
insert into client
    values(clientid_seq.nextval,'KATIE','katie@gmail.com',4214879999);
insert into client
    values(clientid_seq.nextval,'Knie','knie@gmail.com',4222840222);
insert into client
    values(clientid_seq.nextval,'PERY','pery@gmail.com',4784265356);
insert into client
    values(clientid_seq.nextval,'taylor','taylor@gmail.com',4892223176);
insert into client
    values(clientid_seq.nextval,'Justin','justin@gmail.com',3786541198);
insert into client
    values(clientid_seq.nextval,'MISTER','mister@gmail.com',3894765342);
insert into client
    values(clientid_seq.nextval,'KIM','kim@gmail.com',4241110909);

update client
    set clientname = 'HENRY', clientemail = 'henry@gmail.com'
    where clientid = 60;

update client
    set clientname = 'MARY', clientemail = 'mary@gmail.com'
    where clientid = 80;

commit;

savepoint A;
delete from client
    where clientid = 90;
delete from client
    where clientid = 100;
rollback to A;

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

Select serviceid, servicename, duration, price, service.staffid, staff.staffid, staffname
    from service, staff
    where service.staffid = staff.staffid;

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

commit;

-- Views

CREATE OR REPLACE VIEW service_detail AS
SELECT service.serviceid, servicename, service.staffid, staffname, appointmentdate, status
    FROM service, staff, appointment
    WHERE service.staffid = staff.staffid AND service.serviceid = appointment.serviceid;

desc service_detail;
SELECT * FROM service_detail;
GRANT SELECT, INSERT, UPDATE, DELETE ON service_detail TO c##toa;

CREATE OR REPLACE VIEW client_detail AS
SELECT clientID, clientname, clientemail, clientphone
    FROM client
    WITH READ ONLY;

desc client_detail;
SELECT * FROM client_detail;
GRANT SELECT, INSERT, UPDATE, DELETE ON client_detail TO c##shivani;

CREATE OR REPLACE VIEW appointment_detail AS   
    SELECT clientID, serviceID, AppointmentDate, Status
    FROM appointment
    WHERE serviceID = 600
    WITH CHECK OPTION;

desc appointment_detail;
SELECT * FROM appointment_detail;
GRANT SELECT, INSERT, UPDATE, DELETE ON appointment_detail TO c##solange;

connect c##toa/1234;

select * from c##projectgroup.service_detail;

savepoint b;
insert into c##projectgroup.service_detail (serviceid, servicename, staffid)
    values (900, 'mind and body relaxation', 1);

update c##projectgroup.service_detail
    set servicename = 'spa and body work'
    where serviceid = 200;

delete from c##projectgroup.service_detail
    where serviceid = 200;

select * from c##projectgroup.service_detail;
rollback to b;

connect c##shivani/1234

select * from c##projectgroup.client_detail;

-- insert 

insert into c##projectgroup.client_detail (clientid, clientname, clientemail, clientphone)
    values (200, 'NEHA', 'neha@gmail.com', 9876543211);

-- update

update c##projectgroup.client_detail
    set clientname = 'NEHA SHARMA'
    where clientid = 20;

-- DELETE

delete from c##projectgroup.client_detail
    where clientid = 30;


connect c##solange/1234

select*from c##projectgroup.appointment_detail;

savepoint c;

--insert

insert into c##projectgroup.appointment_detail(clientid,serviceid,appointmentdate,status)
    values(40,30,sysdate,'Completed');

insert into c##projectgroup.appointment_detail(clientid,serviceid,appointmentdate,status)
    values(40,600,sysdate,'Completed');

select*from c##projectgroup.appointment_detail;

--update

update c##projectgroup.appointment_detail
set status = 'Scheduled'
where serviceid = 600;

select*from c##projectgroup.appointment_detail;

update c##projectgroup.appointment_detail
set serviceid = 100
where clientid = 40;

rollback to c;

connect c##projectgroup/1234;

-- Using some single row functions

SELECT staffname, staffID, job, staffemail
    FROM staff
    where staffname = 'PAMELA';

SELECT staffname, staffID, job, staffemail
    FROM staff
    where UPPER(staffname) = 'PAMELA';

SELECT clientID, clientname, clientemail, REPLACE (clientemail, 'gmail', 'yahoo')
    FROM client;

SELECT serviceID, serviceName, FLOOR (price)
    FROM service;

SELECT serviceID, serviceName, CEIL (price)
    FROM service;

SELECT serviceID, serviceName, ROUND (price, 1)
    FROM service;

SELECT serviceID, serviceName, price, price*3 - (price*3/10) "3 sessions Package offer"
    FROM service;

SELECT serviceid, servicename, duration + TO_DSINTERVAL ('0 00:30:00') "30 min longer"
    FROM service;

-- Using some group functions

select staffid, count(serviceid)
    from service
    group by staffid;

select staffid, max(price), min(price), avg(price)
    from service
    group by  staffid
    having min(price)>= 90;
 
-- Sub queries
-- Let's try to find the names of the clients who have an appointment with Pamela today, doing it bottom up

-- First we need to find Pamela's staffID

SELECT staffid
    FROM staff
    WHERE staffname = 'Pamela';

-- Answer is 2
-- Now we need to find wich services she provides

SELECT serviceID
    FROM service
    WHERE staffid = '2';

-- Answer is 300, 400, 500, 600
-- Now lets find the clientID of the clients having these services today

SELECT DISTINCT clientID
    FROM appointment
    WHERE serviceID IN (300, 400, 500, 600);

-- Answer is 10, 20, 30, 90
-- Now we can find the names of these clients

SELECT (clientname)
    FROM client
    WHERE clientID IN (10, 20, 30, 90);

-- Now with subqueries

SELECT INITCAP (clientname)
    FROM client
    WHERE clientID IN (SELECT DISTINCT clientID
                        FROM appointment
                        WHERE serviceID IN (SELECT serviceID
                                            FROM service
                                            WHERE staffid = (SELECT staffid
                                                            FROM staff
                                                            WHERE staffname = 'Pamela')));


-- Set Operators
-- Let's find the names of everyone using the Wellness Center (staff + client)

SELECT INITCAP (staffname) AS name
    FROM staff
UNION
SELECT INITCAP (clientname) AS name
    FROM client;

spool off;
