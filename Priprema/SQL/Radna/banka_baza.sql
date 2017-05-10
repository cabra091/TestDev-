drop database banka_baza;
CREATE database banka_baza CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use  banka_baza;

create table brojRacuna(
brojRacuna_id INT auto_increment,
oznakaRacuna varchar(50),
primary key(brojRacuna_id)

);
create table korisnik(
korisnik_id INT auto_increment,
ime varchar(50),
prezime varchar(50),
primary key(korisnik_id)

);

create table centralnaBanka(
centralnaBanka_id int auto_increment,
ime varchar(50),
primary key(centralnaBanka_id)



);
create table banka(
banka_id int auto_increment,
ime varchar(50),
osnivac varchar(50),
centralnaBanka int,
primary key(banka_id),
foreign key(centralnaBanka)references centralnaBanka(centralnaBanka_id)

);
create table filijala(
filijala_id INT auto_increment,
adresa varchar(100),
brojZaposlenih int not null,
banka INT,
primary key(filijala_id),
foreign key(banka) references banka(banka_id)


);
/*Veza vise prema vise*/
create table korisniciUBankama(
korisnici int,
banke int,
foreign key(korisnici) references korisnik(korisnik_id),
foreign key(banke) references banka(banka_id),
primary key(korisnici,banke)
);

insert into centralnaBanka(ime) value("Centralna Banka Srbije");
insert into centralnaBanka(ime) value("Centralna Banka Rusije");

insert into banka (ime,osnivac,centralnaBanka) values("Intesa bank","IntesaGroup",1);
insert into banka (ime,osnivac,centralnaBanka) values("Erste bank","Erste Group",1);
insert into banka (ime,osnivac,centralnaBanka) values("Credit Agricole","CAGroup",2);

insert into filijala(adresa,brojZaposlenih,banka)values("Brace Ribnikar, Novi Sad",10,3);
insert into filijala(adresa,brojZaposlenih,banka)values("Bulevar Oslobodjenja2, Novi Sad",8,1);
insert into filijala(adresa,brojZaposlenih,banka)values("Bulevat M.Pupina 1 ,Novi Sad",20,1);
insert into filijala(adresa,brojZaposlenih,banka)values("Novosadskog Sajma 1, Novi Sad",15,3);

insert into  korisnik(ime,prezime) values("Lav","Popov");
insert into  korisnik(ime,prezime) values("Jovan","Simonović");
insert into  korisnik(ime,prezime) values("Tanja","Vujin");
insert into  korisnik(ime,prezime) values("Relja","Simin");
insert into  korisnik(ime,prezime) values("Dragana","Hrenović");

insert into korisniciUBankama(korisnici,banke)values(1,1);
insert into korisniciUBankama(korisnici,banke)values(2,3);
insert into korisniciUBankama(korisnici,banke)values(3,2);
insert into korisniciUBankama(korisnici,banke)values(4,1);
insert into korisniciUBankama(korisnici,banke)values(5,2);
insert into korisniciUBankama(korisnici,banke)values(5,3);




select ime from banka;

select banka.osnivac from banka join centralnaBanka on banka.centralnaBanka = centralnaBanka.centralnaBanka_id where centralnaBanka_id = 1;

select distinct banka.ime from banka join korisniciUBankama on banka.banka_id = korisniciUBankama.banke join korisnik on korisniciUBankama.korisnici = korisnik.korisnik_id where korisnik.prezime like "%ić";

select banka.osnivac from banka join filijala on banka.banka_id = filijala.banka where filijala.brojZaposlenih > 10;




/* Odakle su ljudi koji u imenu sadrže "pe"? */
/* 
SELECT g.ime FROM grad AS g
JOIN covek AS c
ON c.mesto_stanovanja = g.id
WHERE c.ime LIKE '%Pe%';
*/
