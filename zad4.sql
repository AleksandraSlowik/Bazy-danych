4. SELECT Buffer(Geometry, 100000) FROM majrivers;
CREATE TABLE tableB AS SELECT count(*) FROM popp p, majrivers m WHERE Contains (Buffer(m.Geometry, 100000), p.Geometry) -> liczba_budynkow

5. CREATE TABLE airportsNew as SELECT NAME, Geometry, ELEV FROM airports;

5a. SELECT NAME, Geometry FROM airportsNew ORDER BY MbrMinY(Geometry) asc limit 1;
 SELECT NAME, Geometry FROM airportsNew ORDER BY MbrMaxY(Geometry) asc limit 1;

5b. INSERT INTO airportsNEW(NAME, Geometry, ELEV) VALUES('airportB', (0.5*Distance((SELECT Geometry FROM airportsNew WHERE NAME='NOATAK'),
(SELECT Geometry FROM airportsNew WHERE NAME='NIKOLSKI AS'))), (SELECT avg(ELEV) FROM airportsNew WHERE NAME="NIKOLSKI AS" OR NAME="NOATAK"));

6. SELECT Area(Buffer((Distance(lakes.Geometry, airports.Geometry)),1000)) FROM lakes, airports WHERE lakes.NAMES='Iliamma Lake' AND airports.NAME='AMBLER';

7. SELECT SUM(trees.AREA_KM2) AS pole FROM tundra, trees, swamp WHERE Intersects(tundra.Geometry, trees.Geometry)
   OR Intersects(swamp.Geometry, trees.Geometry);





