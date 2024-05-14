USE MASTER
GO
DROP DATABASE IF EXISTS KGraph
GO
CREATE DATABASE KGraph
GO
USE KGraph
GO

-- Создание таблицы "Музыкальная группа" (MusicGroup)
CREATE TABLE MusicGroup (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    YearFormed INT,
    Country VARCHAR(100)
) AS NODE;

-- Создание таблицы "Альбом" (Album)
CREATE TABLE Album (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    ReleaseYear INT,
) AS NODE;

-- Создание таблицы "Жанр" (Genre)
CREATE TABLE Genre (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
) AS NODE;


CREATE TABLE Writes AS EDGE
CREATE TABLE Relates AS EDGE
CREATE TABLE Collaborates AS EDGE

-- Заполнение таблицы MusicGroup данными
INSERT INTO MusicGroup (ID, Name, YearFormed, Country) VALUES
(1, 'The Beatles', 1960, 'United Kingdom'),
(2, 'Queen', 1970, 'United Kingdom'),
(3, 'Led Zeppelin', 1968, 'United Kingdom'),
(4, 'Nirvana', 1987, 'United States'),
(5, 'Pink Floyd', 1965, 'United Kingdom'),
(6, 'The Rolling Stones', 1962, 'United Kingdom'),
(7, 'AC/DC', 1973, 'Australia'),
(8, 'Metallica', 1981, 'United States'),
(9, 'Red Hot Chili Peppers', 1983, 'United States'),
(10, 'U2', 1976, 'Ireland');

-- Заполнение таблицы Album данными
INSERT INTO Album (ID, Name, ReleaseYear) VALUES
(1, 'Abbey Road', 1969),
(2, 'A Night at the Opera', 1975),
(3, 'Led Zeppelin IV', 1971),
(4, 'Nevermind', 1991),
(5, 'The Dark Side of the Moon', 1973),
(6, 'Sticky Fingers', 1971),
(7, 'Back in Black', 1980),
(8, 'Metallica (The Black Album)', 1991),
(9, 'Blood Sugar Sex Magik', 1991),
(10, 'The Joshua Tree', 1987);

-- Заполнение таблицы Genre данными
INSERT INTO Genre (ID, Name) VALUES
(1, 'Rock'),
(2, 'Pop'),
(3, 'Alternative'),
(4, 'Metal'),
(5, 'Punk'),
(6, 'Blues'),
(7, 'Jazz'),
(8, 'Hip Hop'),
(9, 'Electronic'),
(10, 'Reggae');



INSERT INTO Collaborates ($from_id, $to_id)
VALUES ((SELECT $node_id FROM MusicGroup WHERE id = 1),
 (SELECT $node_id FROM MusicGroup WHERE id = 2)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 10),
 (SELECT $node_id FROM MusicGroup WHERE id = 5)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 2),
 (SELECT $node_id FROM MusicGroup WHERE id = 9)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 3),
 (SELECT $node_id FROM MusicGroup WHERE id = 1)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 3),
 (SELECT $node_id FROM MusicGroup WHERE id = 6)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 4),
 (SELECT $node_id FROM MusicGroup WHERE id = 2)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 5),
 (SELECT $node_id FROM MusicGroup WHERE id = 4)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 6),
 (SELECT $node_id FROM MusicGroup WHERE id = 7)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 6),
 (SELECT $node_id FROM MusicGroup WHERE id = 8)),
 ((SELECT $node_id FROM MusicGroup WHERE id = 8),
 (SELECT $node_id FROM MusicGroup WHERE id = 3));

INSERT INTO Writes ($from_id, $to_id)
VALUES ((SELECT $node_id FROM MusicGroup WHERE ID = 1),
 (SELECT $node_id FROM Album WHERE ID = 1)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 5),
 (SELECT $node_id FROM Album WHERE ID = 1)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 8),
 (SELECT $node_id FROM Album WHERE ID = 1)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 2),
 (SELECT $node_id FROM Album WHERE ID = 2)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 3),
 (SELECT $node_id FROM Album WHERE ID = 3)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 4),
 (SELECT $node_id FROM Album WHERE ID = 3)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 6),
 (SELECT $node_id FROM Album WHERE ID = 4)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 7),
 (SELECT $node_id FROM Album WHERE ID = 4)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 1),
 (SELECT $node_id FROM Album WHERE ID = 9)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 9),
 (SELECT $node_id FROM Album WHERE ID = 4)),
 ((SELECT $node_id FROM MusicGroup WHERE ID = 10),
 (SELECT $node_id FROM Album WHERE ID = 9));


INSERT INTO Relates ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Album WHERE ID = 1),
 (SELECT $node_id FROM Genre WHERE ID = 6)),
 ((SELECT $node_id FROM Album WHERE ID = 5),
 (SELECT $node_id FROM Genre WHERE ID = 1)),
 ((SELECT $node_id FROM Album WHERE ID = 8),
 (SELECT $node_id FROM Genre WHERE ID = 7)),
 ((SELECT $node_id FROM Album WHERE ID = 2),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Album WHERE ID = 3),
 (SELECT $node_id FROM Genre WHERE ID = 5)),
 ((SELECT $node_id FROM Album WHERE ID = 4),
 (SELECT $node_id FROM Genre WHERE ID = 3)),
 ((SELECT $node_id FROM Album WHERE ID = 6),
 (SELECT $node_id FROM Genre WHERE ID = 4)),
 ((SELECT $node_id FROM Album WHERE ID = 7),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Album WHERE ID = 1),
 (SELECT $node_id FROM Genre WHERE ID = 9)),
 ((SELECT $node_id FROM Album WHERE ID = 9),
 (SELECT $node_id FROM Genre WHERE ID = 8)),
 ((SELECT $node_id FROM Album WHERE ID = 10),
 (SELECT $node_id FROM Genre WHERE ID = 9));

 SELECT M1.name, M2.name
FROM MusicGroup AS M1
	, Collaborates AS c
	, MusicGroup AS M2
WHERE MATCH(M1-(c)->M2)
	AND M1.name = 'Led Zeppelin';

SELECT m.name, a.name
FROM MusicGroup AS m
	, Writes AS w
	, Album AS a
WHERE MATCH(m-(w)->a)
AND m.name = 'The Beatles';

SELECT g.name, a.name
FROM Genre AS g
	, Relates AS r
	, Album AS a
WHERE MATCH(a-(r)->g)
AND g.name = 'Pop';

SELECT m.name, a.name, m.YearFormed
FROM MusicGroup AS m
	, Writes AS w
	, Album AS a
WHERE MATCH(m-(w)->a)
AND m.YearFormed > 1970;

SELECT g.name, a.name
FROM Genre AS g
	, Relates AS r
	, Album AS a
WHERE MATCH(a-(r)->g)
AND a.ReleaseYear >  1970;

SELECT M1.name
	, STRING_AGG(M2.name, '->') WITHIN GROUP (GRAPH PATH)
FROM MusicGroup AS M1
	, Collaborates FOR PATH AS c
	, MusicGroup FOR PATH AS M2
WHERE MATCH(SHORTEST_PATH(M1(-(c)->M2)+))
	AND M1.name = 'Led Zeppelin';

	
SELECT M1.name
	, STRING_AGG(M2.name, '->') WITHIN GROUP (GRAPH PATH)
FROM MusicGroup AS M1
	, Collaborates FOR PATH AS c
	, MusicGroup FOR PATH AS M2
WHERE MATCH(SHORTEST_PATH(M1(-(c)->M2){1,3}))
	AND M1.name = 'The Rolling Stones';

SELECT M1.ID AS IdFirst
	, M1.name AS First
	, CONCAT(N'group (', M1.id, ')') AS [First image name]
	, M2.ID AS IdSecond
	, M2.name AS Second
	, CONCAT(N'group (', M2.id, ')') AS [Second image name]
FROM MusicGroup AS M1
	, Collaborates AS c
	, MusicGroup AS M2
WHERE MATCH(M1-(c)->M2);

SELECT M.ID AS IdFirst
	, M.name AS First
	, CONCAT(N'group (', M.id, ')') AS [First image name]
	, A.ID AS IdSecond
	, A.name AS Second
	, CONCAT(N'album (', A.id, ')') AS [Second image name]
FROM MusicGroup AS M
	, Writes AS w
	, Album AS A
WHERE MATCH(M-(w)->A);

SELECT G.ID AS IdFirst
	, G.name AS First
	, CONCAT(N'genre (', G.id, ')') AS [First image name]
	, A.ID AS IdSecond
	, A.name AS Second
	, CONCAT(N'album (', A.id, ')') AS [Second image name]
FROM Genre AS G
	, Relates AS r
	, Album AS A
WHERE MATCH(A-(r)->G);

select @@servername