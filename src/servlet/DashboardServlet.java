package servlet;

import dao.ClubDAO;
import dao.EvenementDAO;
import model.Club;
import model.Evenement;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class DashboardServlet extends BaseServlet {
    private final ClubDAO clubDAO = new ClubDAO();
    private final EvenementDAO evenementDAO = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        Utilisateur user = (Utilisateur) request.getSession().getAttribute("user");
        String role = user.getRole();

        if ("ADMIN".equals(role)) {
            request.setAttribute("statsMembres", clubDAO.countMembersPerClub());
            request.setAttribute("upcomingEvents", evenementDAO.findUpcoming());
            request.setAttribute("allClubs", clubDAO.findAll());
        } else if ("RESPONSABLE".equals(role)) {
            List<Club> myClubs = clubDAO.findByResponsableUserId(user.getId());
            List<Integer> clubIds = myClubs.stream().map(Club::getId).collect(Collectors.toList());
            request.setAttribute("myClubs", myClubs);
            request.setAttribute("myUpcomingEvents", evenementDAO.findUpcomingByClubIds(clubIds));
        } else {
            List<Club> myClubs = clubDAO.findByMemberUserId(user.getId());
            request.setAttribute("myClubs", myClubs);
            request.setAttribute("myUpcomingEvents", evenementDAO.findUpcomingByUserClubs(user.getId()));
        }

        request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
    }
}
