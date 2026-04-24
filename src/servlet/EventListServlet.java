package servlet;

import dao.ClubDAO;
import dao.EvenementDAO;
import model.Club;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EventListServlet extends BaseServlet {
    private final EvenementDAO evenementDAO = new EvenementDAO();
    private final ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        String clubIdParam = request.getParameter("clubId");
        Integer selectedClubId = null;
        if (clubIdParam != null && !clubIdParam.isEmpty()) {
            int clubId = Integer.parseInt(clubIdParam);
            selectedClubId = clubId;
            request.setAttribute("events", evenementDAO.findByClub(clubId));
        } else {
            request.setAttribute("events", evenementDAO.findAll());
        }
        List<Club> clubs = clubDAO.findAll();
        request.setAttribute("selectedClubId", selectedClubId);
        request.setAttribute("clubs", clubs);
        request.setAttribute("clubNamesById", buildClubNamesMap(clubs));
        request.getRequestDispatcher("/jsp/listEvents.jsp").forward(request, response);
    }

    private Map<Integer, String> buildClubNamesMap(List<Club> clubs) {
        Map<Integer, String> namesById = new HashMap<>();
        clubs.forEach(club -> namesById.put(club.getId(), club.getNom()));
        return namesById;
    }
}
