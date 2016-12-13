package com.mysoft;

import java.sql.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 * Created by Maks on 12/11/2016.
 */
public class DAO {
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection("jdbc:postgresql://localhost:5432/TPYD", "postgres", "0309");
    }

    public static String GetCountries() throws SQLException, ClassNotFoundException {
        Connection c = getConnection();
        PreparedStatement ps = c.prepareStatement("SELECT * from Countries;");
        ResultSet resultSet = ps.executeQuery();
        JSONObject ojson = new JSONObject();
        int count = 0;
        JSONArray mainArray = new JSONArray();
        while (resultSet.next()) {
            JSONArray a = new JSONArray();
            a.add(resultSet.getInt(1));
            a.add(resultSet.getString(2));
            mainArray.add(a);
            count++;
        }
        ojson.put("count", count);
        ojson.put("mainarray", mainArray);
        return ojson.toString();
    }

    public static String GetRegions(int CountryId) throws SQLException, ClassNotFoundException {
        Connection c = getConnection();
        PreparedStatement ps = c.prepareStatement("SELECT Id, Name from Regions WHERE id = " + CountryId + ";");
        ResultSet resultSet = ps.executeQuery();
        JSONObject ojson = new JSONObject();
        int count = 0;
        JSONArray mainArray = new JSONArray();
        while (resultSet.next()) {
            JSONArray a = new JSONArray();
            a.add(resultSet.getInt(1));
            a.add(resultSet.getString(2));
            mainArray.add(a);
            count++;
        }
        ojson.put("count", count);
        ojson.put("mainarray", mainArray);
        return ojson.toString();
    }

    public static String GetTable(int[] argValue) throws SQLException, ClassNotFoundException {
        String argNames[] = {"Reg", "MinuteHomeInside", "MinuteHomeInsideCountry", "MinuteHomeInsideRoaming"
                , "MinuteHome", "MinuteInside", "MinuteRoaming", "SMSHome", "SMSInside", "SMSRoaming", "InternetHome", "InternetInside", "InternetRoaming"};
        String query = "WITH ";
        for (int i = 0; i < argNames.length; i++) {
            query += argNames[i] + " AS (SELECT " + argValue[i] + "),";
        }
        query += "ResultTable AS (\n" +
                "SELECT Operators.Name AS r1,\n" +
                "\tPlans.title AS r2,\n" +
                "\tPlans.SubscriptionFee AS r3,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Home.PricePerMinutesInsideNetwork IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Home.IsIncludeMinInsideNetwork = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM MinuteHomeInside) - Plans.Minutes)*Home.PricePerMinutesInsideNetwork\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM MinuteHomeInside)*Home.PricePerMinutesInsideNetwork\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r4,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Inside.PricePerMinutesInsideNetwork IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Inside.IsIncludeMinInsideNetwork = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM MinuteHomeInsideCountry) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork END)) *\n" +
                "\t\t\t\t\t\t\t\tInside.PricePerMinutesInsideNetwork\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM MinuteHomeInsideCountry)*Inside.PricePerMinutesInsideNetwork\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r5,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Roaming.PricePerMinutesInsideNetwork IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Roaming.IsIncludeMinInsideNetwork = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM MinuteHomeInsideRoaming) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork END)) *\n" +
                "\t\t\t\t\t\t\t\tRoaming.PricePerMinutesInsideNetwork\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM MinuteHomeInsideRoaming)*Roaming.PricePerMinutesInsideNetwork\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r6,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Home.PricePerMinutes IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Home.IsIncludeMinOtherOperators = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM MinuteHome) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork END)) *\n" +
                "\t\t\t\t\t\t\t\tHome.PricePerMinutes\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM MinuteHome)*Home.PricePerMinutes\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r7,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Inside.PricePerMinutes IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Inside.IsIncludeMinOtherOperators = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM MinuteInside) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators END)) *\n" +
                "\t\t\t\t\t\t\t\tInside.PricePerMinutes\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM MinuteInside)*Inside.PricePerMinutes\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r8,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Roaming.PricePerMinutes IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Roaming.IsIncludeMinOtherOperators = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside)*Inside.IsIncludeMinOtherOperators - (SELECT * FROM MinuteRoaming) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM MinuteRoaming) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside)*Inside.IsIncludeMinOtherOperators < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM MinuteHomeInside)*Home.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideCountry)*Inside.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHomeInsideRoaming)*Roaming.IsIncludeMinInsideNetwork - (SELECT * FROM MinuteHome)*Home.IsIncludeMinOtherOperators - (SELECT * FROM MinuteInside)*Inside.IsIncludeMinOtherOperators END)) *\n" +
                "\t\t\t\t\t\t\t\tRoaming.PricePerMinutes\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM MinuteRoaming)*Roaming.PricePerMinutes\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r9,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Home.PricePerSMS IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Home.IsIncludeSMS = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.SMS - (SELECT * FROM SMSHome) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM SMSHome) - Plans.SMS) * Home.PricePerSMS\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM SMSHome)*Home.PricePerSMS\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r10,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Inside.PricePerSMS IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Inside.IsIncludeSMS = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.SMS - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM SMSInside) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS END)) *\n" +
                "\t\t\t\t\t\t\t\tInside.PricePerSMS\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM SMSInside)*Inside.PricePerSMS\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r11,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Roaming.PricePerSMS IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Roaming.IsIncludeSMS = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.SMS - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside)*Inside.IsIncludeSMS - (SELECT * FROM SMSRoaming) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t((SELECT * FROM SMSRoaming) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside)*Inside.IsIncludeSMS < 0 THEN 0 ELSE Plans.Minutes - (SELECT * FROM SMSHome)*Home.IsIncludeSMS - (SELECT * FROM SMSInside)*Inside.IsIncludeSMS END)) *\n" +
                "\t\t\t\t\t\t\t\tRoaming.PricePerSMS\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t(SELECT * FROM SMSRoaming)*Roaming.PricePerSMS\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r12,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Home.PricePerInternetPacket IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Home.IsIncludeInternet = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.MBytes - (SELECT * FROM InternetHome) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t(((SELECT * FROM InternetHome) - Plans.MBytes)/Home.PacketSize + 1) * Home.PricePerInternetPacket\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t((SELECT * FROM InternetHome)/Home.PacketSize + 1) * Home.PricePerInternetPacket\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r13,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Inside.PricePerInternetPacket IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Inside.IsIncludeInternet = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t(((SELECT * FROM InternetInside) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet < 0 THEN 0 ELSE Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet END)) /\n" +
                "\t\t\t\t\t\t\t\tInside.PacketSize + 1) * Inside.PricePerInternetPacket\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t((SELECT * FROM InternetInside)/Inside.PacketSize + 1) * Inside.PricePerInternetPacket\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r14,\n" +
                "\t(CASE\n" +
                "\t\tWHEN Roaming.PricePerInternetPacket IS NOT NULL THEN --не безлимит\n" +
                "\t\t\t(CASE\n" +
                "\t\t\t\tWHEN Roaming.IsIncludeInternet = 1 THEN --включено в абоненскую\n" +
                "\t\t\t\t\t(CASE\n" +
                "\t\t\t\t\t\tWHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside)*Inside.IsIncludeInternet - (SELECT * FROM InternetRoaming) < 0 THEN --превысили лимит\n" +
                "\t\t\t\t\t\t\t(((SELECT * FROM InternetRoaming) -\n" +
                "\t\t\t\t\t\t\t\t(CASE WHEN Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside)*Inside.IsIncludeInternet < 0 THEN 0 ELSE Plans.MBytes - (SELECT * FROM InternetHome)*Home.IsIncludeInternet - (SELECT * FROM InternetInside)*Inside.IsIncludeInternet END)) /\n" +
                "\t\t\t\t\t\t\t\tRoaming.PacketSize + 1) * Roaming.PricePerInternetPacket\n" +
                "\t\t\t\t\t\tELSE\n" +
                "\t\t\t\t\t\t\t0\n" +
                "\t\t\t\t\tEND)\n" +
                "\t\t\t\tELSE\n" +
                "\t\t\t\t\t((SELECT * FROM InternetRoaming)/Roaming.PacketSize + 1) * Roaming.PricePerInternetPacket\n" +
                "\t\t\tEND)\n" +
                "\t\tELSE\n" +
                "\t\t\t0\n" +
                "    END) AS r15\n" +
                "FROM PlansInRegions\n" +
                "JOIN Plans ON PlansInRegions.PlanID = Plans.id\n" +
                "JOIN Operators ON Plans.OperatorID = Operators.id\n" +
                "JOIN Tariffs AS Home ON Plans.HomeNetworkTariff = Home.id\n" +
                "JOIN Tariffs AS Inside ON Plans.InsideCountryTariff = Inside.id\n" +
                "JOIN Tariffs AS Roaming ON Plans.RoamingTariff = Roaming.id\n" +
                "WHERE PlansInRegions.RegionID = (SELECT * FROM Reg)\n" +
                "),\n" +
                "MinSum AS (\n" +
                "\tSELECT MIN(r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15) FROM ResultTable\n" +
                ")\n";
        Connection c = getConnection();
        PreparedStatement ps = c.prepareStatement(query + "SELECT r1,r2,r3,r4,r5,r6,r7,r8,r9,r10" +
                ",r11,r12,r13,r14,r15,r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15 FROM ResultTable\n" +
                "ORDER BY 16;");
        ResultSet resultSet = ps.executeQuery();
        JSONObject ojson = new JSONObject();
        int count = 1;
        JSONArray mainArray = new JSONArray();
        JSONArray b = new JSONArray();
        b.add("Оператор");
        b.add("Тариф");
        b.add("Абоненская плата");
        b.add("Разговоры в регионе на оператора");
        b.add("Разговоры в стране на оператора");
        b.add("Разговоры в роуминге на оператора");
        b.add("Разговоры в регионе на другие");
        b.add("Разговоры в стране на другие");
        b.add("Разговоры в роуминге на другие");
        b.add("СМС в регионе");
        b.add("Интернет в стране");
        b.add("Интернет в роуминге");
        b.add("Итоговая сумма");
        mainArray.add(b);
        while (resultSet.next()) {
            JSONArray a = new JSONArray();
            a.add(resultSet.getString(1));
            a.add(resultSet.getString(2));
            a.add(resultSet.getInt(3));
            a.add(resultSet.getInt(4));
            a.add(resultSet.getInt(5));
            a.add(resultSet.getInt(6));
            a.add(resultSet.getInt(7));
            a.add(resultSet.getInt(8));
            a.add(resultSet.getInt(9));
            a.add(resultSet.getInt(10));
            a.add(resultSet.getInt(11));
            a.add(resultSet.getInt(12));
            a.add(resultSet.getInt(13));
            a.add(resultSet.getInt(14));
            a.add(resultSet.getInt(15));
            a.add(resultSet.getInt(16));
            mainArray.add(a);
            count++;
        }
        ojson.put("count", count);
        ojson.put("mainarray", mainArray);

        ps = c.prepareStatement(query + "SELECT r1,r2,r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15 " +
                "FROM ResultTable WHERE r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15 = (SELECT * FROM MinSum);");
        resultSet = ps.executeQuery();
        mainArray = new JSONArray();
        b = new JSONArray();
        b.add("Оператор");
        b.add("Тариф");
        b.add("Сумма");
        mainArray.add(b);
        count = 1;
        while (resultSet.next()) {
            JSONArray a = new JSONArray();
            a.add(resultSet.getString(1));
            a.add(resultSet.getString(2));
            a.add(resultSet.getInt(3));
            mainArray.add(a);
            count++;
        }
        ojson.put("optimal_count", count);
        ojson.put("optimal", mainArray);
        return ojson.toString();
    }
    /*public static void main(String[] args) throws SQLException, ClassNotFoundException {
        System.out.println(GetCountries());
    }*/
}
