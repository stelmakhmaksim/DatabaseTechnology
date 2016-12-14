--GetCountries
SELECT * from Countries;

--GetCountries
SELECT * from Regions WHERE id = 1;

--GetTable
WITH Reg AS (
	SELECT 1
),
MinuteHomeInside AS ( --���� �� ���������
	SELECT 5000
),
MinuteHomeInsideCountry AS ( --������ �� ���������
	SELECT 5000
),
MinuteHomeInsideRoaming AS ( --����� �� ���������
	SELECT 1
),
MinuteHome AS ( --���� �� ������
	SELECT 151
),
MinuteInside AS (
	SELECT 1
),
MinuteRoaming AS (
	SELECT 1
),
SMSHome AS (
	SELECT 151
),
SMSInside AS (
	SELECT 1
),
SMSRoaming AS (
	SELECT 1
),
InternetHome AS (
	SELECT 0
),
InternetInside AS (
	SELECT 0
),
InternetRoaming AS (
	SELECT 0
),
ResultTable AS (
SELECT Operators.Name AS r1,
	Plans.title AS r2,
	Plans.SubscriptionFee AS r3,
	(CASE
		WHEN Home.PricePerMinutesInsideNetwork IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Home.IsIncludeMinInsideNetwork = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside) < 0 THEN --��������� �����
							((SELECT * FROM MinuteHomeInside) - Plans.Minutes)*Home.PricePerMinutesInsideNetwork
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM MinuteHomeInside)*Home.PricePerMinutesInsideNetwork
			END)
		ELSE
			0
    END) AS r4,
	(CASE
		WHEN Inside.PricePerMinutesInsideNetwork IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Inside.IsIncludeMinInsideNetwork = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry) < 0 THEN --��������� �����
							((SELECT * FROM MinuteHomeInsideCountry) -
								(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork END)) *
								Inside.PricePerMinutesInsideNetwork
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM MinuteHomeInsideCountry)*Inside.PricePerMinutesInsideNetwork
			END)
		ELSE
			0
    END) AS r5,
	(CASE
		WHEN Roaming.PricePerMinutesInsideNetwork IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Roaming.IsIncludeMinInsideNetwork = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming) < 0 THEN --��������� �����
							((SELECT * FROM MinuteHomeInsideRoaming) -
								(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork END)) *
								Roaming.PricePerMinutesInsideNetwork
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM MinuteHomeInsideRoaming)*Roaming.PricePerMinutesInsideNetwork
			END)
		ELSE
			0
    END) AS r6,
	(CASE
		WHEN Home.PricePerMinutes IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Home.IsIncludeMinOtherOperators = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome) < 0 THEN --��������� �����
							((SELECT * FROM MinuteHome) -
								(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork END)) *
								Home.PricePerMinutes
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM MinuteHome)*Home.PricePerMinutes
			END)
		ELSE
			0
    END) AS r7,
	(CASE
		WHEN Inside.PricePerMinutes IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Inside.IsIncludeMinOtherOperators = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside) < 0 THEN --��������� �����
							((SELECT * FROM MinuteInside) -
								(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators END)) *
								Inside.PricePerMinutes
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM MinuteInside)*Inside.PricePerMinutes
			END)
		ELSE
			0
    END) AS r8,
	(CASE
		WHEN Roaming.PricePerMinutes IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Roaming.IsIncludeMinOtherOperators = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside)*Inside.IsIncludeMinOtherOperators - (SELECT * FROM MinuteRoaming) < 0 THEN --��������� �����
							((SELECT * FROM MinuteRoaming) -
								(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside)*Inside.IsIncludeMinOtherOperators < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside)*Inside.IsIncludeMinOtherOperators END)) *
								Roaming.PricePerMinutes
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM MinuteRoaming)*Roaming.PricePerMinutes
			END)
		ELSE
			0
    END) AS r9,
	(CASE
		WHEN Home.PricePerSMS IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Home.IsIncludeSMS = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.SMS - (SELECT * FROM SMSHome) < 0 THEN --��������� �����
							((SELECT * FROM SMSHome) - Plans.SMS) * Home.PricePerSMS
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM SMSHome)*Home.PricePerSMS
			END)
		ELSE
			0
    END) AS r10,
	(CASE
		WHEN Inside.PricePerSMS IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Inside.IsIncludeSMS = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.SMS - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside) < 0 THEN --��������� �����
							((SELECT * FROM SMSInside) -
								(CASE WHEN Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS END)) *
								Inside.PricePerSMS
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM SMSInside)*Inside.PricePerSMS
			END)
		ELSE
			0
    END) AS r11,
	(CASE
		WHEN Roaming.PricePerSMS IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Roaming.IsIncludeSMS = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.SMS - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside)*Inside.IsIncludeSMS - (SELECT * FROM SMSRoaming) < 0 THEN --��������� �����
							((SELECT * FROM SMSRoaming) -
								(CASE WHEN Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside)*Inside.IsIncludeSMS < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside)*Inside.IsIncludeSMS END)) *
								Roaming.PricePerSMS
						ELSE
							0
					END)
				ELSE
					(SELECT * FROM SMSRoaming)*Roaming.PricePerSMS
			END)
		ELSE
			0
    END) AS r12,
	(CASE
		WHEN Home.PricePerInternetPacket IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Home.IsIncludeInternet = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.MBytes - (SELECT * FROM InternetHome) < 0 AND (SELECT * FROM InternetHome) > 0 THEN --��������� �����
							(((SELECT * FROM InternetHome) - Plans.MBytes)/Home.PacketSize + 1) * Home.PricePerInternetPacket
						ELSE
							0
					END)
				ELSE
           (CASE
               WHEN (SELECT * FROM InternetHome) > 0 THEN
					          ((SELECT * FROM InternetHome)/Home.PacketSize + 1) * Home.PricePerInternetPacket
               ELSE
                0
            END)
			END)
		ELSE
			0
    END) AS r13,
	(CASE
		WHEN Inside.PricePerInternetPacket IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Inside.IsIncludeInternet = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside) < 0 AND (SELECT * FROM InternetInside) > 0 THEN --��������� �����
							(((SELECT * FROM InternetInside) -
								(CASE WHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet < 0 THEN 0 ELSE Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet END)) /
								Inside.PacketSize + 1) * Inside.PricePerInternetPacket
						ELSE
							0
					END)
				ELSE
            (CASE
               WHEN (SELECT * FROM InternetInside) > 0 THEN
					          ((SELECT * FROM InternetInside)/Inside.PacketSize + 1) * Inside.PricePerInternetPacket
                ELSE
                0
            END)
			END)
		ELSE
			0
    END) AS r14,
	(CASE
		WHEN Roaming.PricePerInternetPacket IS NOT NULL THEN --�� ��������
			(CASE
				WHEN Roaming.IsIncludeInternet = 1 THEN --�������� � ����������
					(CASE
						WHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside)*Inside.IsIncludeInternet - (SELECT * FROM InternetRoaming) < 0 AND (SELECT * FROM InternetRoaming) > 0 THEN --��������� �����
							(((SELECT * FROM InternetRoaming) -
								(CASE WHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside)*Inside.IsIncludeInternet < 0 THEN 0 ELSE Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside)*Inside.IsIncludeInternet END)) /
								Roaming.PacketSize + 1) * Roaming.PricePerInternetPacket
						ELSE
							0
					END)
				ELSE
            (CASE
               WHEN (SELECT * FROM InternetRoaming) > 0 THEN
					      ((SELECT * FROM InternetRoaming)/Roaming.PacketSize + 1) * Roaming.PricePerInternetPacket
            ELSE
                0
            END)
			END)
		ELSE
			0
    END) AS r15
FROM PlansInRegions
JOIN Plans ON PlansInRegions.PlanID = Plans.id
JOIN Operators ON Plans.OperatorID = Operators.id
JOIN Tariffs AS Home ON Plans.HomeNetworkTariff = Home.id
JOIN Tariffs AS Inside ON Plans.InsideCountryTariff = Inside.id
JOIN Tariffs AS Roaming ON Plans.RoamingTariff = Roaming.id
WHERE PlansInRegions.RegionID = (SELECT * FROM Reg)
),
MinSum AS (
	SELECT MIN(r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15) FROM ResultTable
)

-- ��� ���������
SELECT r1 AS "��������",
	r2 AS "�����",
	r3 AS "���������� �����",
	r4 AS "��������� � ������� �� ���������",
	r5 AS "��������� � ������ �� ���������",
	r6 AS "��������� � �������� �� ���������",
	r7 AS "��������� � ������� �� ������",
	r8 AS "��������� � ������ �� ������",
	r9 AS "��������� � �������� �� ������",
	r10 AS "��� � �������",
	r11 AS "��� � ������",
	r12 AS "��� � ��������",
	r13 AS "�������� � �������",
	r14 AS "�������� � ������",
	r15 AS "�������� � ��������",
	r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15 AS "�������� �����"
FROM ResultTable;
--ORDER BY 16;

SELECT r1 AS "��������",
	r2 AS "�����",
	r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15 AS "�����"
FROM ResultTable WHERE r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15 = MinSum;