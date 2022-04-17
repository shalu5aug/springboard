/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

select name from Facilities
where membercost = 0

name	
Badminton Court
Table Tennis
Snooker Table
Pool Table


/* Q2: How many facilities do not charge a fee to members? */

select count(name) from Facilities
where membercost = 0

Ans : 4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select facid, name, membercost,monthlymaintenance from Facilities
where membercost < (monthlymaintenance*20)/100.0

facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
2	Badminton Court	0.0	50
3	Table Tennis	0.0	10
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80
7	Snooker Table	0.0	15
8	Pool Table	0.0	15


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

select * from Facilities where facid in (1, 5)

facid	name	membercost	guestcost	initialoutlay	monthlymaintenance	
1	Tennis Court 2	5.0	25.0	8000	200
5	Massage Room 2	9.9	80.0	4000	3000


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

select name as Facility, monthlymaintenance as cost,
Case 
when monthlymaintenance > 100 then 'Expensive'
else 'Cheap' end as 'monthly maintenance'
from Facilities

Ans:
Facility	cost	monthly maintenance	
Tennis Court 1	200	Expensive
Tennis Court 2	200	Expensive
Badminton Court	50	Cheap
Table Tennis	10	Cheap
Massage Room 1	3000	Expensive
Massage Room 2	3000	Expensive
Squash Court	80	Cheap
Snooker Table	15	Cheap
Pool Table	15	Cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
firstname	surname	max(joindate)	

select firstname, surname , max(joindate)
from Members

GUEST	GUEST	2012-09-26 18:08:45

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select distinct concat_ws(' ', M.firstname, M.surname) as Name,  F.name
from Members as M
inner join Bookings as B
using (memid)
inner join Facilities as F
on F.facid = B.facid
where name like '%Tennis%'
order by M.firstname

Name	Facility	
Anna Mackenzie	Table Tennis
Anne Baker	Tennis Court 1
Anne Baker	Table Tennis
Anne Baker	Tennis Court 2
Burton Tracy	Tennis Court 2
Burton Tracy	Table Tennis
Burton Tracy	Tennis Court 1
Charles Owen	Tennis Court 1
Charles Owen	Table Tennis
Charles Owen	Tennis Court 2
Darren Smith	Table Tennis
Darren Smith	Tennis Court 2
David Jones	Tennis Court 1
David Jones	Table Tennis
David Pinker	Tennis Court 1
David Farrell	Tennis Court 1
David Farrell	Tennis Court 2
David Jones	Tennis Court 2
David Pinker	Table Tennis
Douglas Jones	Tennis Court 1
Erica Crumpet	Table Tennis
Erica Crumpet	Tennis Court 1
Florence Bader	Tennis Court 2
Florence Bader	Table Tennis
Florence Bader	Tennis Court 1
Gerald Butters	Table Tennis
Gerald Butters	Tennis Court 2
Gerald Butters	Tennis Court 1
GUEST GUEST	Tennis Court 1
GUEST GUEST	Table Tennis
GUEST GUEST	Tennis Court 2
Henrietta Rumney	Tennis Court 2
Henry Worthington-Smyth	Table Tennis
Jack Smith	Table Tennis
Jack Smith	Tennis Court 1
Jack Smith	Tennis Court 2
Janice Joplette	Table Tennis
Janice Joplette	Tennis Court 1
Janice Joplette	Tennis Court 2
Jemima Farrell	Table Tennis
Jemima Farrell	Tennis Court 2
Jemima Farrell	Tennis Court 1
Joan Coplin	Tennis Court 1
Joan Coplin	Table Tennis
John Hunt	Table Tennis
John Hunt	Tennis Court 1
John Hunt	Tennis Court 2
Matthew Genting	Table Tennis
Matthew Genting	Tennis Court 1
Millicent Purview	Tennis Court 2
Millicent Purview	Table Tennis
Nancy Dare	Tennis Court 1
Nancy Dare	Table Tennis
Nancy Dare	Tennis Court 2
Ponder Stibbons	Tennis Court 1
Ponder Stibbons	Table Tennis
Ponder Stibbons	Tennis Court 2
Ramnaresh Sarwin	Tennis Court 1
Ramnaresh Sarwin	Tennis Court 2
Ramnaresh Sarwin	Table Tennis
Tim Rownam	Tennis Court 1
Tim Boothe	Table Tennis
Tim Boothe	Tennis Court 2
Tim Boothe	Tennis Court 1
Tim Rownam	Table Tennis
Tim Rownam	Tennis Court 2
Timothy Baker	Tennis Court 1
Timothy Baker	Tennis Court 2
Timothy Baker	Table Tennis
Tracy Smith	Tennis Court 2
Tracy Smith	Tennis Court 1
Tracy Smith	Table Tennis





/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


select F.name as Facility, concat_ws(' ',M.firstname,M.surname) as Name, slots,
	case when memid = 0 then (slots * F.guestcost) 
		 when memid !=0 then (slots * F.membercost) end as cost
from Bookings
left join Facilities as F
using(facid)
left join Members as M
using(memid)
where starttime like '2012-09-14%'


/* Q9: This time, produce the same result as in Q8, but using a subquery. */


select sub1.Facility, sub1.Name, sub1.cost
from
(select F.name as Facility, concat_ws(' ',M.firstname,M.surname) as Name, 
case when memid = 0 then (sum * F.guestcost) 
		 when memid !=0 then (sum * F.membercost) end as cost
from(
    select facid, memid, sum(slots) as sum
from Bookings
where  starttime like '2012-09-14%'
group by facid, memid) as sub
left join Facilities as F
using(facid)
left join Members as M
using(memid)) as sub1
where sub1.cost >30

Facility	Name	cost	
Tennis Court 1	GUEST GUEST	150.0
Tennis Court 2	GUEST GUEST	225.0
Massage Room 1	GUEST GUEST	480.0
Massage Room 1	Jemima Farrell	59.4
Massage Room 2	GUEST GUEST	320.0
Squash Court	GUEST GUEST	140.0


/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

select month, year, facid, tot_slots,member,
case when member = 'Member' then ((tot_slots *F.membercost)-F.monthlymaintenance)
     else ((tot_slots * F.guestcost)-F.monthlymaintenance ) end as cost

from 
(select 
extract(month from starttime) as month,
extract(year from starttime) as year,
facid,
sum(slots) as tot_slots,
case  
	when memid = 0 then 'Guest'
	else 'Member' 
end as member
from Bookings 
group by facid, member,month, year) as sub
left join Facilities  as F
using(facid)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

select distinct M.firstname as mem_firstname , M.surname as mem_surname, sub_query.firstname as rec_firstname , sub_query.surname as rec_surname
from Members as M
left join 
(select distinct N.recommendedby , sub.firstname, sub.surname
            from Members as N 
           left join 
            (select firstname , surname, memid  from Members 
                     ) as sub
			on sub.memid = N.recommendedby
			where recommendedby != ' ') as sub_query
on M.recommendedby = sub_query.recommendedby

where M.recommendedby != ' '

/* Q12: Find the facilities with their usage by member, but not guests */

select M.firstname, M.surname, F.name,
extract(month from B.starttime) as month,
extract(year from B.starttime) as year,
count(B.slots) as 'Total Slots'
from Members as M
inner join Bookings as B
using(memid)
left join Facilities as F
on F.facid = B.facid
where memid !=0
group by B.facid, B.memid , year , month


firstname	surname	name	month	year	Total Slots	
Tracy	Smith	Tennis Court 1	7	2012	21
Tracy	Smith	Tennis Court 1	8	2012	6
Tracy	Smith	Tennis Court 1	9	2012	3
Tim	Rownam	Tennis Court 1	7	2012	4
Tim	Rownam	Tennis Court 1	8	2012	1
Tim	Rownam	Tennis Court 1	9	2012	1
Janice	Joplette	Tennis Court 1	7	2012	10
Janice	Joplette	Tennis Court 1	8	2012	5
Janice	Joplette	Tennis Court 1	9	2012	4
Gerald	Butters	Tennis Court 1	7	2012	22
Gerald	Butters	Tennis Court 1	8	2012	23
Gerald	Butters	Tennis Court 1	9	2012	12
Burton	Tracy	Tennis Court 1	7	2012	4
Burton	Tracy	Tennis Court 1	8	2012	16
Burton	Tracy	Tennis Court 1	9	2012	11
Nancy	Dare	Tennis Court 1	7	2012	4
Nancy	Dare	Tennis Court 1	8	2012	13
Nancy	Dare	Tennis Court 1	9	2012	8
Tim	Boothe	Tennis Court 1	8	2012	4
Ponder	Stibbons	Tennis Court 1	8	2012	1
Charles	Owen	Tennis Court 1	8	2012	10
Charles	Owen	Tennis Court 1	9	2012	7
David	Jones	Tennis Court 1	8	2012	8
David	Jones	Tennis Court 1	9	2012	17
Anne	Baker	Tennis Court 1	8	2012	3
Anne	Baker	Tennis Court 1	9	2012	3
Jemima	Farrell	Tennis Court 1	9	2012	1
Jack	Smith	Tennis Court 1	8	2012	12
Jack	Smith	Tennis Court 1	9	2012	10
Florence	Bader	Tennis Court 1	9	2012	1
Timothy	Baker	Tennis Court 1	8	2012	5
Timothy	Baker	Tennis Court 1	9	2012	9
David	Pinker	Tennis Court 1	8	2012	4
David	Pinker	Tennis Court 1	9	2012	12
Matthew	Genting	Tennis Court 1	9	2012	1
Joan	Coplin	Tennis Court 1	9	2012	7
Ramnaresh	Sarwin	Tennis Court 1	9	2012	5
Douglas	Jones	Tennis Court 1	9	2012	9
David	Farrell	Tennis Court 1	9	2012	6
John	Hunt	Tennis Court 1	9	2012	4
Erica	Crumpet	Tennis Court 1	9	2012	1
Darren	Smith	Tennis Court 2	7	2012	15
Darren	Smith	Tennis Court 2	8	2012	1
Darren	Smith	Tennis Court 2	9	2012	3
Tracy	Smith	Tennis Court 2	7	2012	2
Tim	Rownam	Tennis Court 2	7	2012	5
Tim	Rownam	Tennis Court 2	8	2012	1
Janice	Joplette	Tennis Court 2	7	2012	7
Janice	Joplette	Tennis Court 2	9	2012	1
Gerald	Butters	Tennis Court 2	7	2012	1
Gerald	Butters	Tennis Court 2	8	2012	1
Gerald	Butters	Tennis Court 2	9	2012	1
Burton	Tracy	Tennis Court 2	7	2012	1
Burton	Tracy	Tennis Court 2	8	2012	2
Nancy	Dare	Tennis Court 2	7	2012	4
Nancy	Dare	Tennis Court 2	8	2012	7
Tim	Boothe	Tennis Court 2	7	2012	6
Tim	Boothe	Tennis Court 2	8	2012	25
Tim	Boothe	Tennis Court 2	9	2012	21
Ponder	Stibbons	Tennis Court 2	8	2012	17
Ponder	Stibbons	Tennis Court 2	9	2012	14
Charles	Owen	Tennis Court 2	8	2012	19
Charles	Owen	Tennis Court 2	9	2012	22
David	Jones	Tennis Court 2	8	2012	13
David	Jones	Tennis Court 2	9	2012	17
Anne	Baker	Tennis Court 2	8	2012	16
Anne	Baker	Tennis Court 2	9	2012	19
Jemima	Farrell	Tennis Court 2	8	2012	1
Jack	Smith	Tennis Court 2	9	2012	1
Florence	Bader	Tennis Court 2	8	2012	3
Florence	Bader	Tennis Court 2	9	2012	5
Timothy	Baker	Tennis Court 2	8	2012	3
Timothy	Baker	Tennis Court 2	9	2012	4
Ramnaresh	Sarwin	Tennis Court 2	9	2012	11
Henrietta	Rumney	Tennis Court 2	9	2012	1
David	Farrell	Tennis Court 2	9	2012	1
Millicent	Purview	Tennis Court 2	9	2012	1
John	Hunt	Tennis Court 2	9	2012	4
Darren	Smith	Badminton Court	7	2012	38
Darren	Smith	Badminton Court	8	2012	55
Darren	Smith	Badminton Court	9	2012	39
Tracy	Smith	Badminton Court	7	2012	5
Tracy	Smith	Badminton Court	8	2012	17
Tracy	Smith	Badminton Court	9	2012	10
Tim	Rownam	Badminton Court	7	2012	1
Tim	Rownam	Badminton Court	8	2012	1
Tim	Rownam	Badminton Court	9	2012	2
Gerald	Butters	Badminton Court	7	2012	4
Gerald	Butters	Badminton Court	8	2012	8
Gerald	Butters	Badminton Court	9	2012	8
Burton	Tracy	Badminton Court	8	2012	1
Burton	Tracy	Badminton Court	9	2012	1
Nancy	Dare	Badminton Court	7	2012	2
Nancy	Dare	Badminton Court	8	2012	4
Nancy	Dare	Badminton Court	9	2012	4
Tim	Boothe	Badminton Court	7	2012	1
Tim	Boothe	Badminton Court	8	2012	9
Tim	Boothe	Badminton Court	9	2012	2
Ponder	Stibbons	Badminton Court	8	2012	6
Ponder	Stibbons	Badminton Court	9	2012	10
firstname	surname	name	month	year	Total Slots	 
Charles	Owen	Badminton Court	8	2012	4
Charles	Owen	Badminton Court	9	2012	2
David	Jones	Badminton Court	8	2012	4
David	Jones	Badminton Court	9	2012	4
Anne	Baker	Badminton Court	8	2012	1
Anne	Baker	Badminton Court	9	2012	9
Jemima	Farrell	Badminton Court	8	2012	3
Jemima	Farrell	Badminton Court	9	2012	4
Jack	Smith	Badminton Court	8	2012	6
Jack	Smith	Badminton Court	9	2012	6
Florence	Bader	Badminton Court	8	2012	5
Florence	Bader	Badminton Court	9	2012	4
Timothy	Baker	Badminton Court	8	2012	3
Timothy	Baker	Badminton Court	9	2012	4
David	Pinker	Badminton Court	8	2012	2
David	Pinker	Badminton Court	9	2012	5
Anna	Mackenzie	Badminton Court	8	2012	3
Anna	Mackenzie	Badminton Court	9	2012	27
Ramnaresh	Sarwin	Badminton Court	9	2012	7
Douglas	Jones	Badminton Court	9	2012	2
Henry	Worthington-Smyth	Badminton Court	9	2012	4
Millicent	Purview	Badminton Court	9	2012	2
Hyacinth	Tupperware	Badminton Court	9	2012	1
John	Hunt	Badminton Court	9	2012	2
Erica	Crumpet	Badminton Court	9	2012	2
Darren	Smith	Table Tennis	7	2012	12
Darren	Smith	Table Tennis	8	2012	9
Darren	Smith	Table Tennis	9	2012	7
Tracy	Smith	Table Tennis	7	2012	13
Tracy	Smith	Table Tennis	8	2012	7
Tracy	Smith	Table Tennis	9	2012	8
Tim	Rownam	Table Tennis	7	2012	22
Tim	Rownam	Table Tennis	8	2012	30
Tim	Rownam	Table Tennis	9	2012	17
Janice	Joplette	Table Tennis	7	2012	1
Janice	Joplette	Table Tennis	8	2012	6
Janice	Joplette	Table Tennis	9	2012	2
Gerald	Butters	Table Tennis	8	2012	1
Burton	Tracy	Table Tennis	8	2012	18
Burton	Tracy	Table Tennis	9	2012	6
Nancy	Dare	Table Tennis	8	2012	4
Nancy	Dare	Table Tennis	9	2012	1
Tim	Boothe	Table Tennis	8	2012	4
Ponder	Stibbons	Table Tennis	8	2012	1
Ponder	Stibbons	Table Tennis	9	2012	2
Charles	Owen	Table Tennis	8	2012	18
Charles	Owen	Table Tennis	9	2012	6
David	Jones	Table Tennis	8	2012	7
David	Jones	Table Tennis	9	2012	4
Anne	Baker	Table Tennis	8	2012	1
Jemima	Farrell	Table Tennis	8	2012	4
Jemima	Farrell	Table Tennis	9	2012	8
Jack	Smith	Table Tennis	8	2012	3
Jack	Smith	Table Tennis	9	2012	2
Florence	Bader	Table Tennis	8	2012	12
Florence	Bader	Table Tennis	9	2012	30
Timothy	Baker	Table Tennis	8	2012	9
Timothy	Baker	Table Tennis	9	2012	15
David	Pinker	Table Tennis	8	2012	4
David	Pinker	Table Tennis	9	2012	13
Matthew	Genting	Table Tennis	8	2012	5
Matthew	Genting	Table Tennis	9	2012	21
Anna	Mackenzie	Table Tennis	9	2012	16
Joan	Coplin	Table Tennis	9	2012	21
Ramnaresh	Sarwin	Table Tennis	9	2012	3
Henry	Worthington-Smyth	Table Tennis	9	2012	3
Millicent	Purview	Table Tennis	9	2012	6
John	Hunt	Table Tennis	9	2012	1
Erica	Crumpet	Table Tennis	9	2012	2
Darren	Smith	Massage Room 1	7	2012	13
Darren	Smith	Massage Room 1	8	2012	9
Darren	Smith	Massage Room 1	9	2012	6
Tracy	Smith	Massage Room 1	7	2012	3
Tracy	Smith	Massage Room 1	8	2012	1
Tracy	Smith	Massage Room 1	9	2012	2
Tim	Rownam	Massage Room 1	7	2012	37
Tim	Rownam	Massage Room 1	8	2012	23
Tim	Rownam	Massage Room 1	9	2012	20
Janice	Joplette	Massage Room 1	7	2012	5
Janice	Joplette	Massage Room 1	8	2012	3
Janice	Joplette	Massage Room 1	9	2012	4
Gerald	Butters	Massage Room 1	7	2012	8
Gerald	Butters	Massage Room 1	8	2012	13
Gerald	Butters	Massage Room 1	9	2012	11
Burton	Tracy	Massage Room 1	7	2012	4
Burton	Tracy	Massage Room 1	8	2012	18
Burton	Tracy	Massage Room 1	9	2012	9
Nancy	Dare	Massage Room 1	7	2012	3
Nancy	Dare	Massage Room 1	8	2012	7
Nancy	Dare	Massage Room 1	9	2012	9
Tim	Boothe	Massage Room 1	7	2012	4
Tim	Boothe	Massage Room 1	8	2012	17
Tim	Boothe	Massage Room 1	9	2012	15
Ponder	Stibbons	Massage Room 1	8	2012	13
Ponder	Stibbons	Massage Room 1	9	2012	6
Charles	Owen	Massage Room 1	8	2012	8
Charles	Owen	Massage Room 1	9	2012	3
David	Jones	Massage Room 1	8	2012	10
David	Jones	Massage Room 1	9	2012	9
Anne	Baker	Massage Room 1	8	2012	1
firstname	surname	name	month	year	Total Slots	 
Anne	Baker	Massage Room 1	9	2012	2
Jemima	Farrell	Massage Room 1	8	2012	9
Jemima	Farrell	Massage Room 1	9	2012	20
Jack	Smith	Massage Room 1	8	2012	11
Jack	Smith	Massage Room 1	9	2012	16
Timothy	Baker	Massage Room 1	8	2012	7
Timothy	Baker	Massage Room 1	9	2012	17
David	Pinker	Massage Room 1	8	2012	1
David	Pinker	Massage Room 1	9	2012	2
Matthew	Genting	Massage Room 1	8	2012	2
Matthew	Genting	Massage Room 1	9	2012	23
Anna	Mackenzie	Massage Room 1	9	2012	1
Joan	Coplin	Massage Room 1	9	2012	1
Ramnaresh	Sarwin	Massage Room 1	9	2012	8
Henry	Worthington-Smyth	Massage Room 1	9	2012	1
Hyacinth	Tupperware	Massage Room 1	9	2012	1
John	Hunt	Massage Room 1	9	2012	3
Erica	Crumpet	Massage Room 1	9	2012	2
Tim	Rownam	Massage Room 2	7	2012	1
Tim	Rownam	Massage Room 2	9	2012	1
Janice	Joplette	Massage Room 2	7	2012	1
Janice	Joplette	Massage Room 2	8	2012	1
Gerald	Butters	Massage Room 2	7	2012	1
Nancy	Dare	Massage Room 2	7	2012	1
Nancy	Dare	Massage Room 2	8	2012	2
Nancy	Dare	Massage Room 2	9	2012	2
Charles	Owen	Massage Room 2	9	2012	2
David	Jones	Massage Room 2	8	2012	3
David	Jones	Massage Room 2	9	2012	1
Anne	Baker	Massage Room 2	8	2012	2
Jack	Smith	Massage Room 2	9	2012	1
Florence	Bader	Massage Room 2	9	2012	2
Matthew	Genting	Massage Room 2	8	2012	1
Joan	Coplin	Massage Room 2	9	2012	2
Ramnaresh	Sarwin	Massage Room 2	9	2012	3
Darren	Smith	Squash Court	7	2012	8
Darren	Smith	Squash Court	8	2012	5
Darren	Smith	Squash Court	9	2012	1
Tracy	Smith	Squash Court	7	2012	2
Tracy	Smith	Squash Court	8	2012	1
Tracy	Smith	Squash Court	9	2012	3
Janice	Joplette	Squash Court	7	2012	6
Janice	Joplette	Squash Court	8	2012	3
Janice	Joplette	Squash Court	9	2012	5
Gerald	Butters	Squash Court	7	2012	3
Gerald	Butters	Squash Court	8	2012	4
Gerald	Butters	Squash Court	9	2012	2
Burton	Tracy	Squash Court	7	2012	3
Burton	Tracy	Squash Court	8	2012	24
Burton	Tracy	Squash Court	9	2012	8
Tim	Boothe	Squash Court	7	2012	1
Tim	Boothe	Squash Court	8	2012	6
Tim	Boothe	Squash Court	9	2012	5
Ponder	Stibbons	Squash Court	9	2012	2
Charles	Owen	Squash Court	8	2012	4
Charles	Owen	Squash Court	9	2012	3
David	Jones	Squash Court	8	2012	4
David	Jones	Squash Court	9	2012	4
Anne	Baker	Squash Court	8	2012	21
Anne	Baker	Squash Court	9	2012	28
Jemima	Farrell	Squash Court	8	2012	6
Jemima	Farrell	Squash Court	9	2012	2
Jack	Smith	Squash Court	8	2012	4
Jack	Smith	Squash Court	9	2012	5
Florence	Bader	Squash Court	9	2012	2
Timothy	Baker	Squash Court	8	2012	2
Timothy	Baker	Squash Court	9	2012	3
David	Pinker	Squash Court	8	2012	1
David	Pinker	Squash Court	9	2012	2
Anna	Mackenzie	Squash Court	9	2012	2
Joan	Coplin	Squash Court	9	2012	1
Ramnaresh	Sarwin	Squash Court	9	2012	2
Douglas	Jones	Squash Court	9	2012	1
Henrietta	Rumney	Squash Court	9	2012	2
David	Farrell	Squash Court	9	2012	1
Millicent	Purview	Squash Court	9	2012	1
Hyacinth	Tupperware	Squash Court	9	2012	1
John	Hunt	Squash Court	9	2012	1
Darren	Smith	Snooker Table	7	2012	5
Darren	Smith	Snooker Table	8	2012	3
Darren	Smith	Snooker Table	9	2012	4
Tracy	Smith	Snooker Table	7	2012	22
Tracy	Smith	Snooker Table	8	2012	17
Tracy	Smith	Snooker Table	9	2012	6
Janice	Joplette	Snooker Table	7	2012	23
Janice	Joplette	Snooker Table	8	2012	25
Janice	Joplette	Snooker Table	9	2012	20
Gerald	Butters	Snooker Table	7	2012	9
Gerald	Butters	Snooker Table	8	2012	13
Gerald	Butters	Snooker Table	9	2012	12
Burton	Tracy	Snooker Table	7	2012	4
Burton	Tracy	Snooker Table	8	2012	12
Burton	Tracy	Snooker Table	9	2012	4
Nancy	Dare	Snooker Table	7	2012	2
Nancy	Dare	Snooker Table	8	2012	10
Nancy	Dare	Snooker Table	9	2012	11
Tim	Boothe	Snooker Table	7	2012	3
Tim	Boothe	Snooker Table	8	2012	23
Tim	Boothe	Snooker Table	9	2012	17
Ponder	Stibbons	Snooker Table	8	2012	9
firstname	surname	name	month	year	Total Slots	 
Ponder	Stibbons	Snooker Table	9	2012	11
Charles	Owen	Snooker Table	8	2012	6
Charles	Owen	Snooker Table	9	2012	16
David	Jones	Snooker Table	8	2012	2
Jemima	Farrell	Snooker Table	8	2012	14
Jemima	Farrell	Snooker Table	9	2012	7
Jack	Smith	Snooker Table	8	2012	2
Jack	Smith	Snooker Table	9	2012	3
Florence	Bader	Snooker Table	8	2012	11
Florence	Bader	Snooker Table	9	2012	22
David	Pinker	Snooker Table	8	2012	7
David	Pinker	Snooker Table	9	2012	9
Matthew	Genting	Snooker Table	9	2012	1
Anna	Mackenzie	Snooker Table	9	2012	7
Joan	Coplin	Snooker Table	9	2012	10
Ramnaresh	Sarwin	Snooker Table	9	2012	18
Henrietta	Rumney	Snooker Table	9	2012	14
David	Farrell	Snooker Table	9	2012	1
Millicent	Purview	Snooker Table	9	2012	1
Hyacinth	Tupperware	Snooker Table	9	2012	5
Darren	Smith	Pool Table	7	2012	9
Darren	Smith	Pool Table	8	2012	12
Darren	Smith	Pool Table	9	2012	7
Tracy	Smith	Pool Table	7	2012	15
Tracy	Smith	Pool Table	8	2012	28
Tracy	Smith	Pool Table	9	2012	18
Tim	Rownam	Pool Table	7	2012	62
Tim	Rownam	Pool Table	8	2012	97
Tim	Rownam	Pool Table	9	2012	82
Janice	Joplette	Pool Table	7	2012	10
Janice	Joplette	Pool Table	8	2012	13
Janice	Joplette	Pool Table	9	2012	4
Gerald	Butters	Pool Table	7	2012	2
Gerald	Butters	Pool Table	8	2012	1
Gerald	Butters	Pool Table	9	2012	3
Burton	Tracy	Pool Table	7	2012	2
Burton	Tracy	Pool Table	8	2012	20
Burton	Tracy	Pool Table	9	2012	8
Nancy	Dare	Pool Table	7	2012	2
Nancy	Dare	Pool Table	8	2012	10
Nancy	Dare	Pool Table	9	2012	7
Tim	Boothe	Pool Table	7	2012	1
Tim	Boothe	Pool Table	8	2012	15
Tim	Boothe	Pool Table	9	2012	9
Ponder	Stibbons	Pool Table	8	2012	7
Ponder	Stibbons	Pool Table	9	2012	5
Charles	Owen	Pool Table	9	2012	1
David	Jones	Pool Table	8	2012	5
David	Jones	Pool Table	9	2012	3
Anne	Baker	Pool Table	8	2012	7
Anne	Baker	Pool Table	9	2012	5
Jemima	Farrell	Pool Table	9	2012	1
Jack	Smith	Pool Table	8	2012	5
Jack	Smith	Pool Table	9	2012	2
Florence	Bader	Pool Table	8	2012	8
Florence	Bader	Pool Table	9	2012	15
Timothy	Baker	Pool Table	8	2012	33
Timothy	Baker	Pool Table	9	2012	52
David	Pinker	Pool Table	8	2012	4
David	Pinker	Pool Table	9	2012	5
Matthew	Genting	Pool Table	8	2012	2
Matthew	Genting	Pool Table	9	2012	16
Anna	Mackenzie	Pool Table	8	2012	5
Anna	Mackenzie	Pool Table	9	2012	65
Joan	Coplin	Pool Table	9	2012	11
Ramnaresh	Sarwin	Pool Table	9	2012	13
Douglas	Jones	Pool Table	9	2012	2
Henrietta	Rumney	Pool Table	9	2012	3
David	Farrell	Pool Table	9	2012	25
Henry	Worthington-Smyth	Pool Table	9	2012	33
Millicent	Purview	Pool Table	9	2012	5
Hyacinth	Tupperware	Pool Table	9	2012	8


/* Q13: Find the facilities usage by month, but not guests */

select F.name as Facility,
extract(month from starttime) as month,
extract(year from starttime) as year,
count(slots) as total_slots
from Bookings as B
left join Facilities as F
using(facid)
where memid !=0
group by B.facid, year, month


Facility	month	year	total_slots	
Tennis Court 1	7	2012	65
Tennis Court 1	8	2012	111
Tennis Court 1	9	2012	132
Tennis Court 2	7	2012	41
Tennis Court 2	8	2012	109
Tennis Court 2	9	2012	126
Badminton Court	7	2012	51
Badminton Court	8	2012	132
Badminton Court	9	2012	161
Table Tennis	7	2012	48
Table Tennis	8	2012	143
Table Tennis	9	2012	194
Massage Room 1	7	2012	77
Massage Room 1	8	2012	153
Massage Room 1	9	2012	191
Massage Room 2	7	2012	4
Massage Room 2	8	2012	9
Massage Room 2	9	2012	14
Squash Court	7	2012	23
Squash Court	8	2012	85
Squash Court	9	2012	87
Snooker Table	7	2012	68
Snooker Table	8	2012	154
Snooker Table	9	2012	199
Pool Table	7	2012	103
Pool Table	8	2012	272
Pool Table	9	2012	408

