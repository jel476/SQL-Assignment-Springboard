


/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */


SELECT * 
FROM `Facilities` 
WHERE `membercost` > 0


/* Q2: How many facilities do not charge a fee to members? */

SELECT count(*) 
FROM `Facilities` 
WHERE `membercost` = 0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

Select facid, name, membercost, monthlymaintenance
FROM `Facilities`
WHERE `membercost` < (`monthlymaintenance` *.20)
AND `membercost` > 0


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

Select *
FROM `Facilities`
WHERE `facid` < 6
AND `facid` != 4 
AND `facid` != 3
AND `facid` != 2
AND `facid` != 0


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

Select name, monthlymaintenance,
CASE WHEN `monthlymaintenance` > 100 THEN 'expensive'
ELSE 'cheap' END AS cost
FROM `Facilities`



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM `Members`
ORDER BY joindate

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT name, CONCAT(firstname, ' ', surname) AS membername
FROM Bookings
JOIN Facilities ON Bookings.facid = Facilities.facid
JOIN Members ON Bookings.memid = Members.memid
WHERE Members.memid > 0 
ORDER BY membername

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


SELECT name, CONCAT(firstname, ' ', surname) AS membername,
CASE WHEN Bookings.memid > 0 THEN Facilities.membercost * Bookings.slots ELSE Facilities.guestcost * Bookings.slots END As totalcost
FROM Bookings
JOIN Facilities ON Bookings.facid = Facilities.facid 
JOIN Members ON Bookings.memid = Members.memid
WHERE 
CASE WHEN Bookings.memid > 0 THEN Facilities.membercost * Bookings.slots ELSE Facilities.guestcost * Bookings.slots END > 30 AND Bookings.starttime LIKE '2012-09-14%'

/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT name, CONCAT(firstname, ' ', surname) AS membername,
CASE WHEN BookingZ.memid > 0 THEN Facilities.membercost * BookingZ.slots ELSE Facilities.guestcost * BookingZ.slots END As totalcost
FROM (
    SELECT *
    FROM Bookings
    WHERE starttime like '2012-09-14%') BookingZ
JOIN Facilities ON BookingZ.facid = Facilities.facid 
JOIN Members ON BookingZ.memid = Members.memid
WHERE 
CASE WHEN BookingZ.memid > 0 THEN Facilities.membercost * BookingZ.slots ELSE Facilities.guestcost * BookingZ.slots END > 30


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */



SELECT BookingZ.name, SUM(BookingZ.totalcost) as revenue
FROM(
    Select name,
    CASE WHEN Bookings.memid > 0 THEN Facilities.membercost * Bookings.slots ELSE Facilities.guestcost * Bookings.slots END As 			   totalcost 
    FROM Bookings
JOIN Facilities ON Bookings.facid = Facilities.facid 
JOIN Members ON Bookings.memid = Members.memid) BookingZ
GROUP BY 1
HAVING revenue <1000
ORDER BY 2