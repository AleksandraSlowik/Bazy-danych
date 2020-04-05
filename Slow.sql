ĆWICZENIA 1

Zad.1 CREATE DATABASE s299635;

Zad.2 CREATE SCHEMA firma;

Zad.3 CREATE ROLE ksiegowosc;
      GRANT USAGE ON SCHEMA firma TO ksiegowosc;
      GRANT SELECT on all tables in SCHEMA "firma" TO ksiegowosc;

Zad.4 
CREATE TABLE firma.pracownicy (
    id_pracownika SERIAL,
    imie varchar(20)  NOT NULL,
    nazwisko varchar(40)  NOT NULL,
    adres varchar(60)  NOT NULL,
    telefon varchar(20)  NOT NULL,
    CONSTRAINT pracownicy_pk PRIMARY KEY (id_pracownika)
);


CREATE INDEX id_index ON firma.pracownicy (nazwisko);

CREATE TABLE firma.godziny (
    id_godziny SERIAL,
    data date  NOT NULL,
    liczba_godzin int  NOT NULL,
    id_pracownika int  NOT NULL,
    CONSTRAINT godziny_pk PRIMARY KEY (id_godziny)
);

CREATE TABLE firma.pensja_stanowisko (
    id_pensji serial  NOT NULL,
    stanowisko varchar(30)  NOT NULL,
    kwota decimal(6,2)  NOT NULL,
    CONSTRAINT pensja_stanowisko_pk PRIMARY KEY (id_pensji)
);

CREATE TABLE firma.premia (
    id_premii serial  NOT NULL,
    rodzaj varchar(30)  NOT NULL,
    kwota decimal(6,2)  NOT NULL,
    CONSTRAINT premia_pk PRIMARY KEY (id_premii)
);

CREATE TABLE firma.wynagrodzenie (
    id_wynagrodzenia serial  NOT NULL,
    data date  NOT NULL,
    id_pracownika int  NOT NULL,
    id_godziny int  NOT NULL,
    id_pensji int  NOT NULL,
    id_premii int  NOT NULL,
    CONSTRAINT wynagrodzenie_pk PRIMARY KEY (id_wynagrodzenia)
);

ALTER TABLE firma.godziny ADD CONSTRAINT godziny_pracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_godziny
    FOREIGN KEY (id_godziny)
    REFERENCES firma.godziny (id_godziny)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pensja_stanowisko
    FOREIGN KEY (id_pensji)
    REFERENCES firma.pensja_stanowisko (id_pensji)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_premia
    FOREIGN KEY (id_premii)
    REFERENCES firma.premia (id_premii)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

Zad.5 
COMMENT ON TABLE firma.pracownicy
   IS 'Opis pracowników'
;
COMMENT ON TABLE firma.godziny
   IS 'Informacje o przepracowanych godzinach'
;
COMMENT ON TABLE firma.pensja_stanowisko 
   IS 'Informacje o pensji na danych stanowiskach'
;
COMMENT ON TABLE firma.premia
   IS 'Informacje o premii'
;
COMMENT ON TABLE firma.wynagrodzenie 
   IS 'Informacje o końcowym wynagrodzeniu'
;

ALTER TABLE  firma.wynagrodzenie ALTER COLUMN "data" TYPE varchar(20);

Zad.6
a) SELECT id_pracownika, nazwisko FROM firma.pracownicy;
b) SELECT firma.wynagrodzenie.id_pracownika FROM firma.wynagrodzenie JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji = firma.wynagrodzenie.id_pensji JOIN firma.premia ON firma.premia.id_premii = firma.wynagrodzenie.id_premii WHERE firma.premia.kwota+firma.pensja_stanowisko.kwota >1000;
c) SELECT firma.wynagrodzenie.id_pracownika FROM firma.wynagrodzenie JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji = firma.wynagrodzenie.id_pensji JOIN firma.premia ON firma.premia.id_premii = firma.wynagrodzenie.id_premii WHERE firma.premia.kwota = 0 AND firma.pensja_stanowisko.kwota > 2000;
d) SELECT imie FROM firma.pracownicy WHERE imie LIKE 'J%';
e) SELECT pracownicy FROM firma.pracownicy WHERE nazwisko LIKE '%n%' OR nazwisko LIKE '%N%' AND imie LIKE '%a';
f) SELECT pracownicy.imie, pracownicy.nazwisko , CASE WHEN godziny.liczba_godzin<160 THEN 0 ELSE godziny.liczba_godzin-160 END AS "nadgodziny" FROM firma.pracownicy pracownicy JOIN firma.godziny godziny ON pracownicy.id_pracownika = godziny.id_pracownika;
g) SELECT pracownicy.imie, pracownicy.nazwisko FROM firma.pracownicy pracownicy JOIN firma.wynagrodzenie wynagrodzenie ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika JOIN firma.pensja_stanowisko pensja ON wynagrodzenie.id_pensji = pensja.id_pensji WHERE pensja.kwota >= 1500 and pensja.kwota <= 3000;
h) SELECT pracownicy.imie, pracownicy.nazwisko FROM firma.pracownicy pracownicy JOIN firma.godziny godziny ON pracownicy.id_pracownika = godziny.id_pracownika JOIN firma.wynagrodzenie wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika JOIN firma.premia premia ON wynagrodzenie.id_premii = premia.id_premii WHERE premia.kwota = 0 AND godziny.liczba_godzin > 160;

Zad.7
a) SELECT pracownicy.*, pensja.kwota FROM firma.pracownicy pracownicy JOIN firma.wynagrodzenie wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika JOIN firma.pensja_stanowisko pensja ON pensja.id_pensji = wynagrodzenie.id_pensji ORDER BY pensja.kwota;
b) SELECT pracownicy.*, pensja.kwota+premia.kwota AS "wypłata" FROM firma.pracownicy pracownicy JOIN firma.wynagrodzenie wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika JOIN firma.pensja_stanowisko pensja ON pensja.id_pensji = wynagrodzenie.id_pensji join firma.premia premia on premia.id_premii = wynagrodzenie.id_premii ORDER BY pensja.kwota+premia.kwota DESC;
c) SELECT pensja.stanowisko, COUNT(pensja.stanowisko) FROM firma.pensja_stanowisko pensja JOIN firma.wynagrodzenie wynagrodzenie ON pensja.id_pensji = wynagrodzenie.id_pensji JOIN firma.pracownicy pracownicy ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika GROUP BY pensja.stanowisko;
d) SELECT pensja.stanowisko, AVG(pensja.kwota+premia.kwota), MIN(pensja.kwota+premia.kwota), MAX(pensja.kwota+premia.kwota) FROM firma.pensja_stanowisko pensja JOIN firma.wynagrodzenie wynagrodzenie ON pensja.id_pensji = wynagrodzenie.id_pensji JOIN firma.premia premia ON premia.id_premii = wynagrodzenie.id_premii WHERE pensja.stanowisko = 'Kierownik' GROUP BY pensja.stanowisko;
e) SELECT SUM(pensja.kwota+premia.kwota) AS "Wynagrodzenie-suma" FROM firma.wynagrodzenie wynagrodzenie JOIN firma.pensja_stanowisko pensja ON wynagrodzenie.id_pensji = pensja.id_pensji JOIN firma.premia premia ON wynagrodzenie.id_premii = premia.id_premii;
f) SELECT pensja.stanowisko, SUM(pensja.kwota+premia.kwota) AS "Wynagrodzenie-suma" FROM firma.wynagrodzenie wynagrodzenie JOIN firma.pensja_stanowisko pensja ON wynagrodzenie.id_pensji = pensja.id_pensji JOIN firma.premia premia ON wynagrodzenie.id_premii = premia.id_premii GROUP BY pensja.stanowisko;
g) SELECT pensja.stanowisko, COUNT(premia.kwota>0) AS "Ilość premii" FROM firma.pensja_stanowisko pensja JOIN firma.wynagrodzenie wynagrodzenie ON pensja.id_pensji = wynagrodzenie.id_pensji JOIN firma.premia premia ON premia.id_premii = wynagrodzenie.id_premii WHERE premia.kwota > 0 GROUP BY pensja.stanowisko;
h) DELETE FROM firma.pracownicy pracownicy USING firma.wynagrodzenie wynagrodzenie, firma.pensja_stanowisko pensja WHERE pracownicy.id_pracownika = wynagrodzenie.id_pracownika AND pensja.id_pensji = wynagrodzenie.id_pensji AND pensja.kwota < 1200;

Zad.8
a) UPDATE firma.pracownicy SET telefon=CONCAT('(+48) ', telefon);
b) UPDATE firma.pracownicy SET telefon=CONCAT(SUBSTRING(telefon, 1, 5), '-', substring(telefon, 5, 2), '-', substring(telefon, 10, 5));
c) SELECT imie, UPPER(nazwisko) AS "nazwisko", adres, telefon FROM firma.pracownicy WHERE LENGTH(nazwisko) = (SELECT MAX(LENGTH(nazwisko)) FROM firma.pracownicy);
d) SELECT md5(pracownicy.imie) AS "imie", md5(pracownicy.nazwisko) AS "nazwisko", md5(pracownicy.adres) AS "adres", md5(pracownicy.telefon) AS "telefon", 
   md5(CAST(pensja.kwota AS varchar(20))) AS "pensja" FROM firma.pracownicy pracownicy JOIN firma.wynagrodzenie wynagrodzenie ON 
   wynagrodzenie.id_pracownika = pracownicy.id_pracownika JOIN firma.pensja_stanowisko pensja ON pensja.id_pensji = wynagrodzenie.id_pensji;

Zad.9
a) SELECT concat('Pracownik ', pracownicy.imie, ' ', pracownicy.nazwisko, ', w dniu ', wynagrodzenie."data", ' otrzymał pensję całkowitą na kwotę ', 
			  pensja.kwota+premia.kwota,'zł, gdzie wynagrodzenie zasadnicze wynosiło: ', pensja.kwota, 'zł, premia: ', premia.kwota, 'zł. Liczba nadgodzin: ') 
			  AS "raport" FROM firma.pracownicy pracownicy JOIN firma.wynagrodzenie wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
			  JOIN firma.pensja_stanowisko pensja ON pensja.id_pensji = wynagrodzenie.id_pensji JOIN firma.premia premia ON premia.id_premii = wynagrodzenie.id_premii;





























