-- 1. Which is the most profitable title?

SELECT 
    f.Title,
    f.FilmID, 
    SUM(t.TicketPrice) AS TotalRevenue,
    ROUND(AVG(SessionAttendance.PeoplePerSession)) AS AveragePeoplePerSession
FROM 
    Films AS f
JOIN 
    Sessions AS s ON f.FilmID = s.FilmID
JOIN 
    Tickets AS t ON s.SessionsID = t.SessionID
JOIN 
    (SELECT 
        SessionID, 
        COUNT(TicketID) AS PeoplePerSession 
     FROM 
        Tickets 
     GROUP BY 
        SessionID) AS SessionAttendance ON s.SessionsID = SessionAttendance.SessionID
GROUP BY 
    f.Title, 
    f.FilmID
ORDER BY 
    TotalRevenue DESC
LIMIT 1;

-- 2. Percentage of people that buy popcorn & soft drinks?

WITH PopcornPurchases AS (
    SELECT DISTINCT ct.TicketID
    FROM Consumables_tickets AS ct
    JOIN Consumables AS c ON ct.ConsumableID = c.ConsumableID
    WHERE c.ConsumableName = 'Popcorn'
),
SoftDrinkPurchases AS (
    SELECT DISTINCT ct.TicketID
    FROM Consumables_tickets AS ct
    JOIN Consumables AS c ON ct.ConsumableID = c.ConsumableID
    WHERE c.ConsumableName IN ('Water', 'Cola', 'Iced tea')
)
SELECT 
    FLOOR(
        (COUNT(DISTINCT pp.TicketID) / (SELECT COUNT(*) FROM Tickets)) * 100
    ) AS PercentageOfPopcornAndSoftDrinkBuyers
FROM 
    PopcornPurchases AS pp
JOIN 
    SoftDrinkPurchases AS sdp ON pp.TicketID = sdp.TicketID;


-- 3. At which session is there the most number of people?

SELECT 
    cin.CinemaID,
    cin.CinemaName,
    cin.CinemaLocation,
    s.SessionsID AS SessionID,
    f.Title AS FilmTitle,
    COUNT(t.TicketID) AS NumberOfPeople
FROM 
    Tickets t
JOIN 
    Sessions s ON t.SessionID = s.SessionsID
JOIN 
    Films f ON s.FilmID = f.FilmID
JOIN 
    Cinema cin ON s.CinemaID = cin.CinemaID
GROUP BY 
    cin.CinemaID, cin.CinemaName, cin.CinemaLocation, s.SessionsID, f.Title
ORDER BY 
    NumberOfPeople DESC
LIMIT 1;


-- 4. Show the revenue per session.

SELECT 
    s.SessionsID,
    SUM(t.TicketPrice) AS TicketSalesRevenue,
    SUM(c.ConsumablePrice * ct.ConsumablesQuantity) AS ConsumableSalesRevenue,
    SUM(t.TicketPrice) + SUM(c.ConsumablePrice * ct.ConsumablesQuantity) AS TotalSessionRevenue
FROM 
    Sessions AS s
LEFT JOIN 
    Tickets AS t ON s.SessionsID = t.SessionID
LEFT JOIN 
    Consumables_tickets AS ct ON t.TicketID = ct.TicketID
LEFT JOIN 
    Consumables AS c ON ct.ConsumableID = c.ConsumableID
GROUP BY 
    s.SessionsID;



--  5. Present a detailed report for each film.

SELECT 
    f.Title, 
    d.DirectorName, 
    GROUP_CONCAT(DISTINCT a.ActorName ORDER BY a.ActorName SEPARATOR ', ') AS Actors, 
    p.ProducerName,
    c1.Genre, 
    l.Language,
    COUNT(DISTINCT s.SessionsID) AS NumberOfSessions,
    COUNT(t.TicketID) AS TicketsSold,
    SUM(t.TicketPrice) AS TotalTicketSales,
    SUM(ct.ConsumablesQuantity * c.ConsumablePrice) AS TotalConsumableSales,
    (COUNT(t.TicketID) / (MAX(cin.CinemaCapacity) * COUNT(DISTINCT s.SessionsID))) * 100 AS AttendancePercentage,
    (
        SELECT GROUP_CONCAT(most_consumable ORDER BY most_consumable) 
        FROM (
            SELECT 
                c.ConsumableName AS most_consumable,
                COUNT(*) AS consumable_count
            FROM 
                Films AS f_inner
            JOIN Sessions AS s ON f_inner.FilmID = s.FilmID
            JOIN Tickets AS t ON s.SessionsID = t.SessionID
            JOIN Consumables_tickets AS ct ON t.TicketID = ct.TicketID
            JOIN Consumables AS c ON ct.ConsumableID = c.ConsumableID
            WHERE f_inner.Title = f.Title
            GROUP BY 
                most_consumable
            ORDER BY 
                consumable_count DESC
            LIMIT 1
        ) AS subquery
    ) AS MostRepeatedConsumable
FROM 
    Films AS f
JOIN Directors AS d ON f.DirectorID = d.DirectorID
JOIN Producers AS p ON f.ProducerID = p.ProducerID
JOIN Film_Actors AS fa ON f.FilmID = fa.FilmID
JOIN Actors AS a ON fa.ActorID = a.ActorID
JOIN Film_Categories AS fc ON f.FilmID = fc.FilmID
JOIN Categories AS c1 ON fc.CategoryID = c1.CategoryID
JOIN Film_Languages AS fl ON f.FilmID = fl.FilmID
JOIN Languages AS l ON fl.LanguageID = l.LanguageID
JOIN Sessions AS s ON f.FilmID = s.FilmID
JOIN Tickets AS t ON s.SessionsID = t.SessionID
JOIN Consumables_tickets AS ct ON t.TicketID = ct.TicketID
JOIN Consumables AS c ON ct.ConsumableID = c.ConsumableID
JOIN Cinema AS cin ON s.CinemaID = cin.CinemaID
GROUP BY 
    f.Title, d.DirectorName, p.ProducerName, c1.Genre, l.Language;
