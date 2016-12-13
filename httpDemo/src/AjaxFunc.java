import com.mysoft.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Created by Maks on 12/11/2016.
 */
@WebServlet(name = "AjaxFunc", urlPatterns = "/ajaxFunc")
public class AjaxFunc extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=Windows-1251");
        String txt = request.getParameter("func");
        String JSONString = "ERROR";
        try {
            if (txt.equals("GetCountries")) {
                JSONString = DAO.GetCountries();
            } else if (txt.equals("GetRegions")) {
                JSONString = DAO.GetRegions(Integer.parseInt(request.getParameter("country")));
            } else if (txt.equals("GetTable")) {
                String argNames[] = {"Reg", "MinuteHomeInside", "MinuteHomeInsideCountry", "MinuteHomeInsideRoaming"
                        , "MinuteHome", "MinuteInside", "MinuteRoaming", "SMSHome", "SMSInside", "SMSRoaming", "InternetHome", "InternetInside", "InternetRoaming"};
                int args[] = new int[argNames.length];
                for (int i = 0; i < argNames.length; i++) {
                    args[i] = Integer.parseInt(request.getParameter(argNames[i]));
                }
                JSONString = DAO.GetTable(args);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        PrintWriter buf = response.getWriter();
        buf.print(JSONString);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=Windows-1251");
        String txt = request.getParameter("func");
        String JSONString = "ERROR";
        try {
            if (txt.equals("GetCountries")) {
                JSONString = DAO.GetCountries();
            } else if (txt.equals("GetRegions")) {
                JSONString = DAO.GetRegions(Integer.parseInt(request.getParameter("country")));
            } else if (txt.equals("GetTable")) {
                String argNames[] = {"Reg", "MinuteHomeInside", "MinuteHomeInsideCountry", "MinuteHomeInsideRoaming"
                        , "MinuteHome", "MinuteInside", "MinuteRoaming", "SMSHome", "SMSInside", "SMSRoaming", "InternetHome", "InternetInside", "InternetRoaming"};
                int args[] = new int[argNames.length];
                for (int i = 0; i < argNames.length; i++) {
                    args[i] = Integer.parseInt(request.getParameter(argNames[i]));
                }
                JSONString = DAO.GetTable(args);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        PrintWriter buf = response.getWriter();
        buf.print(JSONString);
    }
}
