CREATE OR REPLACE FUNCTION test_pg(testNum int) RETURNS BOOL AS
$$
DECLARE
  CityID int;
  RegionIDs int;
  OperatorID int;
  HomeNetworkTariffID int;
  InsideCountryTariffID int;
  RoamingTariffID int;
  PlanIDs int;
  result bool;
  equal int;
  temp1 int;
  temp2 int;
BEGIN
    INSERT INTO Countries(Name) VALUES ('TestCity')
    RETURNING Id into CityID;
    INSERT INTO Regions(Name, CountryID) VALUES ('TestRegion', CityID) RETURNING id into RegionIDs;
    INSERT INTO Operators(Name) VALUES ('TestOperator') RETURNING id into OperatorID;
    INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  160, 1,  160, 1,  NULL, 0, 1) RETURNING id into HomeNetworkTariffID;
    INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  300, 1,  300, 1,  NULL, 0, 1) RETURNING id into InsideCountryTariffID;
    INSERT INTO Tariffs VALUES (DEFAULT, 5000, 0, 5000, 0,  590, 0,  20000, 40, 0) RETURNING id into RoamingTariffID;
    INSERT INTO Plans VALUES (DEFAULT, 'TestPlan', OperatorID, HomeNetworkTariffID, InsideCountryTariffID, RoamingTariffID,50000,600,300,0) RETURNING id into PlanIDs;
    INSERT INTO PlansInRegions VALUES (RegionIDs, PlanIDs);
    
    if (testNum = 0) Then
        DELETE FROM Countries WHERE id = CityID;
        equal = 0;
    end if;
    if (testNum = 1) Then
        DELETE FROM Regions WHERE id = RegionIDs;
        equal = 1; -- страна
    end if;
    if (testNum = 2) Then
        DELETE FROM Operators WHERE id = OperatorID;
        equal = 2; --страна и регион
    end if;
    if (testNum = 3) Then
        DELETE FROM Plans WHERE id = PlanIDs;
        equal = 2; --страна и регион
    end if;
    if (testNum = 4) Then
        INSERT INTO Tariffs VALUES (DEFAULT, NULL, 0,  300, 1,  300, 1,  NULL, 0, 1) RETURNING id into temp1;
        INSERT INTO Tariffs VALUES (DEFAULT, 5000, 0, 5000, 0,  590, 0,  20000, 40, 0) RETURNING id into temp2;
        INSERT INTO Plans VALUES (DEFAULT, 'TestPlan2', OperatorID, HomeNetworkTariffID, temp1, temp2,50000,600,300,0);
        DELETE FROM Plans WHERE id = PlanIDs;
        equal = 3; --страна и регион и 1 тариф
    end if;
    
    if (Select count(*) FROM (
    (SELECT id FROM Countries WHERE id = CityID)
    UNION
    (SELECT id FROM Regions WHERE id = RegionIDs)
    UNION
    (SELECT id FROM Plans WHERE id = PlanIDs)
    UNION
    (SELECT PlansInRegions.PlanID FROM PlansInRegions WHERE PlansInRegions.PlanId = PlanIDs OR PlansInRegions.RegionId = RegionIDs)
    UNION
    (SELECT id FROM Tariffs WHERE id = HomeNetworkTariffID OR id = InsideCountryTariffID OR id = RoamingTariffID)
    ) AS t) = equal THEN
        result := True;
    else
        result := False;
    end if;
    RETURN result;
END
$$
LANGUAGE plpgsql;

BEGIN;
SELECT test_pg(0),test_pg(1),test_pg(2),test_pg(3),test_pg(4);
ROLLBACK;