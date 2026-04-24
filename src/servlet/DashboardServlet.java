package servlet;

import dao.ClubDAO;
import dao.EvenementDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DashboardServlet extends BaseServlet {
    private final ClubDAO clubDAO = new ClubDAO();
    private final EvenementDAO evenementDAO = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        request.setAttribute("statsMembres", clubDAO.countMembersPerClub());
        request.setAttribute("upcomingEvents", evenementDAO.findUpcoming());
        request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
    }
}
