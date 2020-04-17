CREATE SCHEMA spatial;
CREATE EXTENSION postgis;

CREATE TABLE budynki (
	id SERIAL,
	polygon geometry NOT NULL,
	name varchar(30) NOT NULL,
	wysokosc INT NOT NULL,
	CONSTRAINT budynki_pk PRIMARY KEY (id));

CREATE TABLE drogi(
	id SERIAL,
	linestring geometry NOT NULL,
	name varchar(30) NOT NULL
	CONSTRAINT drogi_pk PRIMARY KEY (id)
	);

CREATE TABLE pktinfo(
	id SERIAL,
	point geometry NOT NULL,
	name varchar(30) NOT NULL
	liczprac INT NOT NULL
	CONSTRAINT pktinfo_pk PRIMARY KEY (id)
	);
	

INSERT INTO budynki VALUES (1, ('POLYGON((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4)), -1)', 'BuildingA', 10);
INSERT INTO budynki VALUES (2, ('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7)), -1)', 'BuildingB', 8);
INSERT INTO budynki VALUES (3, ('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8)),-1)', 'BuildingC', 12);
INSERT INTO budynki VALUES (4, ('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9)),-1)', 'BuildingD', 6);
INSERT INTO budynki VALUES (5, ('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2)),-1)', 'BuildingF', 10);

	
INSERT INTO drogi VALUES (1, ('LINESTRING (0 4.5, 12 4.5), -1)', 'RoadX');
INSERT INTO drogi VALUES (2, ('LINESTRING (7.5 10.5, 7.5 0), -1)', 'RoadY');

INSERT INTO pktinfo VALUES (1, ('POINT(1 3.5), -1)', 'G', 8);
INSERT INTO pktinfo VALUES (2, ('POINT(5.5 1.5), -1)', 'H', 9);
INSERT INTO pktinfo VALUES (3, ('POINT(9.5 6), -1)', 'I',10);
INSERT INTO pktinfo VALUES (4, ('POINT(6.5 6), -1)', 'J', 5);
INSERT INTO pktinfo VALUES (5, ('POINT(6 9.5), -1)', 'K', 13);

1. SELECT SUM(ST_Length(linestring)) FROM drogi;

2. SELECT ST_GeomFromText('POLYGON((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4))',-1);
   SELECT ST_Area(polygon) FROM budynki WHERE name = 'BuildingA';

   SELECT ST_Perimeter(polygon) FROM budynki WHERE name = 'BuildingA';
3. SELECT ST_Area(polygon) AS area,
		name AS name
		FROM budynki ORDER BY name;

4. SELECT name as Nazwa, ST_Perimeter(polygon)as Obwód
		FROM budynki ORDER BY ST_Area(polygon) DESC LIMIT 2;

5. SELECT ST_Distance(ST_GeomFromText('POLYGON ((3 8, 5 8, 5 6, 3 6, 3 8))'),
				  ST_GeomFromText('POINT (1 3.5)'));

6. SELECT ST_Area(ST_Difference(polygon, (SELECT ST_Buffer(polygon, 0.5, 'join=mitre') 
	FROM budynki WHERE name='BuildingB'))) AS Polepow FROM budynki WHERE budynki.name='BuildingC';

7. SELECT budynki.name FROM budynki, drogi WHERE ST_Y(ST_Centroid(budynki.polygon))>ST_Y(ST_Centroid(drogi.linestring)) AND drogi.name = 'RoadX';

8. SELECT ST_Area(ST_SymDifference(budynki.polygon, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) AS Pole FROM budynki WHERE budynki.name='BuildingC';
