/*
Select ssn from employee where lname='Smith' and fname='John';

Select * from dependent where essn = (select ssn from employee where lname='Smith' and fname ='John');
SELECT dependent_name, d.bdate, relationship from employee e, dependent d where e.ssn=d.essn and lname='Smith' and fname='John';

Select Pname from PROJECT p , WORKS_ON w, employee e where w.essn=e.ssn and w.pno=p.pnumber and lname='Smith' and fname='John';

Select fname, lname from Employee e where e.ssn not in(select essn from works_on where pno=10)
*/

/*
List the ssn and bdate of employees who have a last name of smith or a last name of wallace
SELECT ssn, bdate FROM EMPLOYEE WHERE Lname='Smith' OR Lname='Wallace';

find the sns of those employes who work on the "reoganization" project for at least 10 hours

SELECT SSN FROM EMPLOYEE e, WORKS_ON w, PROJECT p WHERE P.pnumber=w.pno and P.pname='Reorganization' AND w.hours>=10 and e.ssn=w.essn
*/


/*
number 1
For each employee working for the ‘Research’ department, find the full name and the salary, and order the result by the salary in descending order.
*/
SELECT fname, lname, salary
FROM EMPLOYEE
WHERE dno IN (SELECT dnumber 
                FROM DEPARTMENT 
                WHERE dname = 'Research')
ORDER BY salary DESC;

/*
number 2
List the ssn of employees who work on both ‘ProductX’ and ‘ProductY’.
*/
SELECT essn FROM WORKS_ON
WHERE pno in (SELECT pnumber 
                FROM PROJECT 
                WHERE pname='ProductX' OR pname='ProductY')
GROUP BY essn HAVING count(essn)>=2;

/*
number  3
For each project in ‘Houston’, find the project name, and its controlling department name.
*/
SELECT p.pname, d.dname 
FROM PROJECT p, DEPARTMENT d 
WHERE p.plocation='Houston' AND p.dnum=d.dnumber;

/*
number 4
List the ssn, lname of employees who do not work on the project “Computerization”. Order the results by lname in ascending order.

*/
SELECT ssn, lname 
FROM employee 
WHERE ssn NOT IN (SELECT essn 
                    FROM works_on w, project p 
                    WHERE ssn=essn AND w.pno=p.pnumber AND p.pname= 'Computerization')
ORDER BY lname asc;

/*
number 5
*/
SELECT p1.pname, p2.pname
FROM PROJECT p1 JOIN PROJECT p2
ON p1.plocation=p2.plocation
AND p1.pnumber < p2.pnumber;

/*
6
List the ssn, fname, lname, dname and hours of all employees who work >= 10 hours per week on the project ‘ProductY’.
*/

SELECT SSN, fname, lname, dname, hours 
FROM ((Employee JOIN Department on Dno=Dnumber) 
    JOIN works_on on ssn=essn) 
    JOIN project on Pno=pnumber
WHERE HOURS>=10 AND pname='ProductY';

/*
7
List fname, lname, dname for those employees who have worked on a project with the project name starting with ‘Product’. 
Make sure to list each employee only once.
*/

SELECT DISTINCT fname, lname, dname 
FROM ((Employee JOIN Department on Dno=Dnumber) 
        JOIN works_on on ssn=essn) 
        JOIN PROJECT ON pno=pnumber 
WHERE pname LIKE 'Product%';

/*
8
For each department with its average employee salary > $32,000, retrieve the department name and the number of employees working for that department.
*/

SELECT dname, count(*)
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.dno=d.dnumber 
GROUP BY dname 
HAVING avg(salary)>32000;

/*
9
Get the project number and name for the projects that involve all the employees in the department of ‘Administrator’.
*/

SELECT pnumber, pname
FROM ((Employee join Department on Dno=Dnumber) 
JOIN works_on on ssn=essn) 
JOIN project on Pno=pnumber 
WHERE dname = 'Administration' 
GROUP BY pnumber, pname 
HAVING count(*)= (SELECT count(*) 
                    FROM (employee join department on dno=dnumber) 
                    WHERE dname='Administration' 
                    GROUP BY dno);


/*
10
For each supervisor, list the supervisor's bdate, salary and the number of employees they supervise directly. 
Order the result in ascending order of bdate (oldest appears first).
*/
WITH SUPERVISORS AS (SELECT superssn, count(*) AS count_d 
                        FROM employee 
                        GROUP BY superssn 
                        HAVING count(*)>0)
SELECT bdate, salary, count_d  
FROM SUPERVISORS, employee 
WHERE employee.ssn=supervisors.superssn 
ORDER BY bdate ASC;
