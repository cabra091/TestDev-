/* kreiranje osnovnih tabela */

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists prodavnica;
SET FOREIGN_KEY_CHECKS = 1;
create table prodavnica (
id int unsigned auto_increment primary key,
ime varchar(50) not null,
tip_prodavnice varchar(30),
adresa int unsigned,
vlasnik int unsigned not null
);

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists covek;
SET FOREIGN_KEY_CHECKS = 1;
create table covek (
id int unsigned auto_increment primary key,
ime varchar(50) not null,
prezime varchar(50) not null,
nadimak varchar(50),
godine int unsigned,
stepen_strucne_spreme int unsigned not null,
mesto_stanovanja int unsigned
);

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists proizvod;
SET FOREIGN_KEY_CHECKS = 1;
create table proizvod (
id int unsigned auto_increment primary key,
ime varchar(50) not null,
tip_proizvoda varchar(50),
cena double not null,
proizvodjac int unsigned not null
);

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists fabrika;
SET FOREIGN_KEY_CHECKS = 1;
create table fabrika (
id int unsigned auto_increment primary key,
ime varchar(50) not null,
vlasnik int unsigned not null,
adresa int unsigned
);

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists grad;
SET FOREIGN_KEY_CHECKS = 1;
create table grad (
id int unsigned auto_increment primary key,
ime varchar(50) not null,
drzava varchar(50) not null
);

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists adresa;
SET FOREIGN_KEY_CHECKS = 1;
create table adresa (
id int unsigned auto_increment primary key,
ulica varchar(50) not null,
broj int unsigned not null,
grad int unsigned not null,
adresa_prodavnice int unsigned,
adresa_fabrike int unsigned
);

/* kreiranje ogranicenja */

alter table prodavnica
add constraint fk_adresa foreign key (adresa) references adresa(id) on delete set null on update cascade,
/* ako se obrise vlasnik brise se i njegova prodavnica - namerno je tako :) */
add constraint fk_vlasnik foreign key (vlasnik) references covek(id) on delete cascade on update cascade,
add constraint uq_adresa unique (adresa);

alter table covek
add constraint fk_mesto_stanovanja_coveka foreign key (mesto_stanovanja) references grad(id) on delete set null on update cascade;

alter table proizvod
add constraint fk_proizvodjac foreign key (proizvodjac) references fabrika(id) on delete cascade on update cascade;

alter table fabrika
add constraint fk_vlasnik_fabrike foreign key (vlasnik) references covek(id) on delete cascade on update cascade,
add constraint fk_adresa_fabrike foreign key (adresa) references adresa(id) on delete set null on update cascade,
add constraint uq_adresa_fabrike unique(adresa);

alter table adresa
add constraint fk_grad_adrese foreign key(grad) references grad(id) on delete cascade on update cascade,
add constraint fk_prodavnica_koja_je_tu foreign key(adresa_prodavnice) references prodavnica(id) on delete set null on update cascade,
add constraint fk_fabrika_koja_je_tu foreign key(adresa_fabrike) references fabrika(id) on delete set null on update cascade,
/* Samo jedan covek moze da zivi na jednoj adrese, bas je namerno tako */
add constraint uq_fk_prodavnica_koja_je_tu unique(adresa_prodavnice),
add constraint uq_adresa_fabrike_adresa unique(adresa_fabrike);

/* kreiranje join tabela */

SET FOREIGN_KEY_CHECKS = 0;
drop table if exists prodavnica_covek__zaposleni;
SET FOREIGN_KEY_CHECKS = 1;
create table prodavnica_covek__zaposleni (
id int unsigned auto_increment primary key,
prodavnica_id int unsigned not null,
covek_id int unsigned not null,
foreign key(prodavnica_id) references prodavnica(id) on delete cascade,
foreign key(covek_id) references covek(id) on delete cascade,
unique (covek_id)
);

/* punjenje baze */

/* ovo ce biti grad sa id = 1 */
INSERT INTO grad (ime, drzava) VALUES ('Novi Sad', 'Srbija');
/* ovo ce biti grad sa id = 2 */
INSERT INTO grad (ime, drzava) VALUES ('Barcelona', 'Spain');
INSERT INTO covek (ime, prezime, nadimak, godine, stepen_strucne_spreme, mesto_stanovanja)
VALUES ('Pera', 'Peric', 'Pera', 33, 4, 1);
INSERT INTO covek (ime, prezime, nadimak, godine, stepen_strucne_spreme, mesto_stanovanja)
VALUES ('Pedro', 'Diaz', 'Pedo', 26, 4, 2);
INSERT INTO covek (ime, prezime, nadimak, godine, stepen_strucne_spreme, mesto_stanovanja)
VALUES ('Ana-Hope', 'Ibanez', 'Pedo', 24, 4, 2);

/* upiti */

/* Odakle su ljudi koji u imenu sadrže "pe"? */
SELECT g.ime FROM grad AS g
JOIN covek AS c
ON c.mesto_stanovanja = g.id
WHERE c.ime LIKE '%Pe%';

/* Probajte obe verzije, u cemu je razlika? */
SELECT DISTINCT g.ime FROM grad AS g
JOIN covek AS c
ON c.mesto_stanovanja = g.id
WHERE c.ime LIKE '%Pe%'
