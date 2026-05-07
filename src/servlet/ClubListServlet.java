package servlet;

import dao.AdhesionDAO;
import dao.ClubDAO;
import model.Club;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClubListServlet extends BaseServlet {
    private final ClubDAO clubDAO = new ClubDAO();
    private final AdhesionDAO adhesionDAO = new AdhesionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        List<Club> clubs = clubDAO.findAll();
        request.setAttribute("clubs", clubs);
        request.setAttribute("clubResponsables", clubDAO.findResponsableNamesByClub());

        Utilisateur currentUser = getCurrentUser(request);
        Map<Integer, Boolean> membershipStatus = new HashMap<>();
        for (Club c : clubs) {
            membershipStatus.put(c.getId(), adhesionDAO.isActiveMember(currentUser.getId(), c.getId()));
        }
        request.setAttribute("membershipStatus", membershipStatus);

        request.getRequestDispatcher("/jsp/listClubs.jsp").forward(request, response);
    }
}
