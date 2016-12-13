CREATE TABLE Operators (
	id	SERIAL,
	Name	TEXT NOT NULL
);

CREATE TABLE Tariffs (
	id	SERIAL,
	PricePerMinutesInsideNetwork	INTEGER,
	IsIncludeMinInsideNetwork	INTEGER NOT NULL,
	PricePerMinutes	INTEGER,
	IsIncludeMinOtherOperators	INTEGER NOT NULL,
	PricePerSMS	INTEGER,
	IsIncludeSMS	INTEGER NOT NULL,
	PricePerInternetPacket	INTEGER,
	PacketSize	INTEGER NOT NULL,
	IsIncludeInternet	INTEGER NOT NULL
);

CREATE TABLE Plans (
	id	SERIAL,
	title	TEXT NOT NULL,
	OperatorID	INTEGER NOT NULL,
	HomeNetworkTariff	INTEGER NOT NULL,
	InsideCountryTariff	INTEGER NOT NULL,
	RoamingTariff	INTEGER NOT NULL,
	SubscriptionFee	INTEGER NOT NULL,
	Minutes	INTEGER NOT NULL,
	SMS	INTEGER NOT NULL,
	MBytes	INTEGER NOT NULL
);

CREATE TABLE Countries (
	id	SERIAL,
	Name	TEXT NOT NULL
);

CREATE TABLE Regions (
	id	SERIAL,
	Name	TEXT NOT NULL,
	CountryID	INTEGER NOT NULL
);

CREATE TABLE PlansInRegions (
	RegionID	INTEGER NOT NULL,
	PlanID	INTEGER NOT NULL
);

CREATE USER webUser WITH PASSWORD '123456';
GRANT SELECT ON Operators TO webUser;
GRANT SELECT ON Tariffs TO webUser;
GRANT SELECT ON Plans TO webUser;
GRANT SELECT ON Countries TO webUser;
GRANT SELECT ON Regions TO webUser;
GRANT SELECT ON  PlansInRegions TO webUser;

REVOKE ALL PRIVILEGES ON operators,plansinregions,regions,tariffs FROM webuser;


--Страны
INSERT INTO Countries(Name) VALUES ('Россия');

--Регионы
WITH RussiaID AS (
	SELECT id FROM Countries WHERE Name = 'Россия'
)
INSERT INTO Regions(Name, CountryID) VALUES ('Санкт-Петербург и область', (SELECT * from RussiaID));

--Операторы
INSERT INTO Operators(Name) VALUES ('Мегафон'), ('МТС'), ('Билайн');

-- Мегафон -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  185, 1,  185, 1,  4000, 300, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0, 1250, 0,  300, 0,   990,   1, 0) RETURNING id
),
RoamingTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, 4900, 0, 4900, 0, 1999, 0, 26000,  65, 0) RETURNING id
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено XS', (SELECT * FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),25000,150,150,2048) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено XS'
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  350, 1,  300, 1,   990,   1, 1) RETURNING id
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено XS'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено S', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),35000,300,300,5120) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено S'
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё включено S'
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено S'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено M', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),65000,650,650,7168) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено S'
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё включено S'
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено S'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено L', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),100000,1300,1300,10240) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено S'
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё включено S'
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено S'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено VIP', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),200000,3000,3000,15360) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));

-- МТС -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH MtsID AS (
	SELECT id FROM Operators WHERE Name = 'МТС'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  150, 0,  150, 1,  7500, 500, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT,  150, 1, 1200, 0,  250, 0,  9500, 500, 0) RETURNING id
),
RoamingTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, 4900, 0, 4900, 0,  590, 0,  9500, 500, 0) RETURNING id
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Smart mini', (SELECT id FROM MtsID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),20000,1000,200,1024) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MtsID AS (
	SELECT id FROM Operators WHERE Name = 'МТС'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  150, 1,  150, 1,  7500, 500, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  500, 0,  250, 0,  9500, 500, 1) RETURNING id
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Smart mini'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Smart', (SELECT id FROM MtsID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),35000,500,500,3072) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MtsID AS (
	SELECT id FROM Operators WHERE Name = 'МТС'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  150, 1,  150, 1,  NULL, 0, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  500, 0,  250, 0,  NULL, 0, 1) RETURNING id
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Smart mini'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Smart Безлимитище', (SELECT id FROM MtsID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),45000,200,200,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MtsID AS (
	SELECT id FROM Operators WHERE Name = 'МТС'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  150, 1,  100, 1,  15000, 1024, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  500, 0,  250, 0,  15000, 1024, 1) RETURNING id
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Smart mini'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Smart+', (SELECT id FROM MtsID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),60000,900,900,5120) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH MtsID AS (
	SELECT id FROM Operators WHERE Name = 'МТС'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Smart+'
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Smart+'
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Smart mini'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Smart Top', (SELECT id FROM MtsID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),100000,1600,1600,7168) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));

-- Билайн --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH BeelineID AS (
	SELECT id FROM Operators WHERE Name = 'Билайн'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  150, 1,  150, 1,  NULL, 0, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  150, 1,  150, 1,  NULL, 0, 1) RETURNING id
),
RoamingTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, 5000, 0, 5000, 0,  590, 0,  20000, 40, 0) RETURNING id
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё за 500', (SELECT id FROM BeelineID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),50000,600,600,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH BeelineID AS (
	SELECT id FROM Operators WHERE Name = 'Билайн'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё за 500'
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500'
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё за 500'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё за 800', (SELECT id FROM BeelineID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),80000,1500,1500,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH BeelineID AS (
	SELECT id FROM Operators WHERE Name = 'Билайн'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё за 500'
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500'
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё за 500'
),
SpbID AS (
	SELECT id FROM Regions WHERE Name = 'Санкт-Петербург и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё за 1200', (SELECT id FROM BeelineID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),120000,3500,3500,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM SpbID), (SELECT * FROM LastID));














--МОСКВА
WITH RussiaID AS (
	SELECT id FROM Countries WHERE Name = 'Россия'
)
INSERT INTO Regions(Name, CountryID) VALUES ('Москва и область', (SELECT * from RussiaID));

WITH BeelineID AS (
	SELECT id FROM Operators WHERE Name = 'Билайн'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  160, 1,  160, 1,  NULL, 0, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  300, 1,  300, 1,  NULL, 0, 1) RETURNING id
),
RoamingTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, 5000, 0, 5000, 0,  590, 0,  20000, 40, 0) RETURNING id
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё за 500', (SELECT id FROM BeelineID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),50000,600,300,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH BeelineID AS (
	SELECT id FROM Operators WHERE Name = 'Билайн'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
RoamingTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё за 800', (SELECT id FROM BeelineID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),80000,1100,500,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH BeelineID AS (
	SELECT id FROM Operators WHERE Name = 'Билайн'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
RoamingTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё за 1200', (SELECT id FROM BeelineID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),120000,2200,1000,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));
------------------------------------------------------------------------------------------------------------------------------------------------
WITH BeelineID AS (
	SELECT id FROM Operators WHERE Name = 'Билайн'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
RoamingTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё за 500' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё за 1800', (SELECT id FROM BeelineID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),180000,3300,3000,0) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));

-- Мегафон -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  160, 1,  290, 1,  3000, 200, 1) RETURNING id
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  300, 0,  390, 0,   990,   1, 1) RETURNING id
),
RoamingTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, 4900, 0, 4900, 0, 1999, 0, 26000,  65, 0) RETURNING id
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено S', (SELECT * FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),30000,300,200,2048) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));
----------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено M', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),50000,550,400,5120) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));
----------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
InsideCountryTariffID AS (
	INSERT INTO Tariffs VALUES (DEFAULT, NULL, 1,  300, 1,  390, 1,   990,   1, 1) RETURNING id
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено L', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),80000,1000,1000,7168) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));
----------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё включено L' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено XL', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),120000,2000,2000,10240) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));
----------------------------------------------------------------------------------------
WITH MegafonID AS (
	SELECT id FROM Operators WHERE Name = 'Мегафон'
),
MskID AS (
	SELECT id FROM Regions WHERE Name = 'Москва и область'
),
HomeNetworkTariffID AS (
	SELECT HomeNetworkTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
InsideCountryTariffID AS (
	SELECT InsideCountryTariff FROM Plans WHERE title = 'Всё включено L' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
RoamingTariffID AS (
	SELECT RoamingTariff FROM Plans WHERE title = 'Всё включено S' AND id IN (SELECT PlanID FROM PlansInRegions WHERE RegionID=(SELECT * FROM MskID))
),
LastID AS (
	INSERT INTO Plans VALUES (DEFAULT, 'Всё включено VIP', (SELECT id FROM MegafonID), (SELECT * FROM HomeNetworkTariffID), (SELECT * FROM InsideCountryTariffID), (SELECT * FROM RoamingTariffID),270000,5000,5000,20480) RETURNING id
)
INSERT INTO PlansInRegions VALUES ((SELECT * FROM MskID), (SELECT * FROM LastID));













--Триггер удаления тарифа (удалить нессылаемые тарификации и ссылки на регион)
CREATE FUNCTION delete_plan_trigger_func() RETURNS TRIGGER AS
$$
BEGIN
    if (SELECT count(*) FROM Plans WHERE homenetworktariff = OLD.homenetworktariff OR insidecountrytariff = OLD.homenetworktariff OR roamingtariff = OLD.homenetworktariff) = 0 then
        DELETE FROM Tariffs WHERE Id = OLD.homenetworktariff;
    end if;
    if (SELECT count(*) FROM Plans WHERE homenetworktariff = OLD.insidecountrytariff OR insidecountrytariff = OLD.insidecountrytariff OR roamingtariff = OLD.insidecountrytariff) = 0 then
        DELETE FROM Tariffs WHERE Id = OLD.insidecountrytariff;
    end if;
    if (SELECT count(*) FROM Plans WHERE homenetworktariff = OLD.roamingtariff OR insidecountrytariff = OLD.roamingtariff OR roamingtariff = OLD.roamingtariff) = 0 then
        DELETE FROM Tariffs WHERE Id = OLD.roamingtariff;
    end if;
    DELETE FROM PlansInRegions WHERE PlanId = OLD.id;
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_plan_trigger
AFTER DELETE ON Plans FOR EACH ROW
EXECUTE PROCEDURE delete_plan_trigger_func();

--Триггер удаления региона (удалить все нессылаемые тарифы и ссылки на тарифы)
CREATE FUNCTION delete_region_trigger_func() RETURNS TRIGGER AS
$$
BEGIN
    DELETE FROM Plans WHERE Id NOT IN
    (SELECT Plans.id FROM PlansInRegions
    JOIN Plans ON PlansInRegions.PlanId = Plans.Id
    WHERE PlansInRegions.RegionId <> OLD.id);
    DELETE FROM PlansInRegions WHERE RegionId = OLD.Id;
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_region_trigger
AFTER DELETE ON Regions FOR EACH ROW
EXECUTE PROCEDURE delete_region_trigger_func();


--Триггер удаления страны (удалить регионы, тарифы в них и всё связанное)
CREATE FUNCTION delete_country_trigger_func() RETURNS TRIGGER AS
$$
BEGIN
    DELETE FROM Regions WHERE CountryId = OLD.Id;
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_country_trigger
AFTER DELETE ON Countries FOR EACH ROW
EXECUTE PROCEDURE delete_country_trigger_func();

--Триггер удаления оператора (удалить планы и ссылки на них)
CREATE FUNCTION delete_operator_trigger_func() RETURNS TRIGGER AS
$$
BEGIN
    DELETE FROM Plans WHERE OperatorId = OLD.Id;
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_operator_trigger
AFTER DELETE ON Operators FOR EACH ROW
EXECUTE PROCEDURE delete_operator_trigger_func();