drop table if exists Consumables_tickets;
drop table if exists Consumables ;
drop table if exists Film_Categories;
drop table if exists Categories;
drop table if exists Tickets ;
drop table if exists Sessions ;
drop table if exists Film_Languages;
drop table if exists Languages ;
drop table if exists Film_Actors ;
drop table if exists Actors ;
drop table if exists ScreeningRoom ;
drop table if exists Films ;
drop table if exists Directors;
drop table if exists Producers;
drop table if exists Cinema ;
drop table if exists Consumables_tickets;
drop table if exists Consumables ;

CREATE TABLE `Directors` (
  `DirectorID` int PRIMARY KEY,
  `DirectorName` varchar(255)
);

CREATE TABLE `Producers` (
  `ProducerID` int PRIMARY KEY,
  `ProducerName` varchar(255)
);

CREATE TABLE `Films` (
  `FilmID` int PRIMARY KEY,
  `Title` varchar(255),
  `ReleaseDate` datetime,
  `DirectorID` int,
  `ProducerID` int
);

CREATE TABLE `Cinema` (
  `CinemaID` int PRIMARY KEY,
  `CinemaName` varchar(255),
  `CinemaLocation` varchar(255),
  `CinemaCapacity` int,
  `ContactInformation` varchar(255)
);

CREATE TABLE `ScreeningRoom` (
  `ScreeningRoomID` int PRIMARY KEY,
  `CinemaID` int,
  `Seats` int
);

CREATE TABLE `Languages` (
  `LanguageID` int PRIMARY KEY,
  `Language` varchar(255)
);

CREATE TABLE `Sessions` (
  `SessionsID` int PRIMARY KEY,
  `Time` datetime,
  `ScreeningRoomID` int,
  `CinemaID` int,
  `FilmID` int,
  `LanguageID` int
);

CREATE TABLE `Tickets` (
  `TicketID` int PRIMARY KEY,
  `SessionID` int,
  `TicketPrice` decimal,
  `PurchaseDate` datetime
);

CREATE TABLE `Actors` (
  `ActorID` int PRIMARY KEY,
  `ActorName` varchar(255),
  `Nationality` varchar(255)
);

CREATE TABLE `Consumables` (
	`ConsumableID` int PRIMARY KEY,
	`ConsumableName` varchar(255),
    `ConsumablePrice` decimal,
    `IsAlcoholic` boolean
);

CREATE TABLE `Consumables_tickets` (
  `ConsumableID` int,
  `TicketID` int,
  `ConsumablesQuantity` int,
   Primary Key (`ConsumableID` , `TicketID`)
);

CREATE TABLE `Categories` (
  `CategoryID` int PRIMARY KEY,
  `Genre` varchar(255)
);

CREATE TABLE `Film_Categories` (
  `FilmID` int,
  `CategoryID` int,
   Primary Key (`FilmID` , `CategoryID`)

);

CREATE TABLE `Film_Languages` (
  `FilmID` int,
  `LanguageID` int,
   Primary Key (`FilmID` , `LanguageID`)
);

CREATE TABLE `Film_Actors` (
  `FilmID` int,
  `ActorID` int,
   Primary Key (`FilmID` , `ActorID`)

);


ALTER TABLE `Films` ADD FOREIGN KEY (`DirectorID`) REFERENCES `Directors` (`DirectorID`);

ALTER TABLE `Films` ADD FOREIGN KEY (`ProducerID`) REFERENCES `Producers` (`ProducerID`);

ALTER TABLE `ScreeningRoom` ADD FOREIGN KEY (`CinemaID`) REFERENCES `Cinema` (`CinemaID`);

ALTER TABLE `Sessions` ADD FOREIGN KEY (`ScreeningRoomID`) REFERENCES `ScreeningRoom` (`ScreeningRoomID`);

ALTER TABLE `Sessions` ADD FOREIGN KEY (`CinemaID`) REFERENCES `Cinema` (`CinemaID`);

ALTER TABLE `Sessions` ADD FOREIGN KEY (`FilmID`) REFERENCES `Films` (`FilmID`);

ALTER TABLE `Sessions` ADD FOREIGN KEY (`LanguageID`) REFERENCES `Languages` (`LanguageID`);

ALTER TABLE `Tickets` ADD FOREIGN KEY (`SessionID`) REFERENCES `Sessions` (`SessionsID`);

ALTER TABLE `Consumables_tickets` ADD FOREIGN KEY (`TicketID`) REFERENCES `Tickets` (`TicketID`);

ALTER TABLE `Consumables_tickets` ADD FOREIGN KEY (`ConsumableID`) REFERENCES `Consumables` (`ConsumableID`);

ALTER TABLE `Film_Categories` ADD FOREIGN KEY (`FilmID`) REFERENCES `Films` (`FilmID`);

ALTER TABLE `Film_Categories` ADD FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`);

ALTER TABLE `Film_Languages` ADD FOREIGN KEY (`FilmID`) REFERENCES `Films` (`FilmID`);

ALTER TABLE `Film_Languages` ADD FOREIGN KEY (`LanguageID`) REFERENCES `Languages` (`LanguageID`);

ALTER TABLE `Film_Actors` ADD FOREIGN KEY (`FilmID`) REFERENCES `Films` (`FilmID`);

ALTER TABLE `Film_Actors` ADD FOREIGN KEY (`ActorID`) REFERENCES `Actors` (`ActorID`);

