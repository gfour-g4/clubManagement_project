package servlet;

import dao.ClubDAO;
import dao.EvenementDAO;
import dao.InscriptionEvenementDAO;
import model.Club;
import model.Evenement;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class EventDetailServlet extends BaseServlet {
    private final EvenementDAO evenementDAO = new EvenementDAO();
    private final ClubDAO clubDAO = new ClubDAO();
    private final InscriptionEvenementDAO inscriptionDAO = new InscriptionEvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }
        int eventId = Integer.parseInt(idParam);
        Evenement event = evenementDAO.findById(eventId);
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }
        Club club = clubDAO.findById(event.getClubId());
        Utilisateur currentUser = getCurrentUser(request);
        boolean isRegistered = inscriptionDAO.isRegistered(eventId, currentUser.getId());
        
        boolean canViewMembers = false;
        List<Utilisateur> registeredUsers = null;
        if ("ADMIN".equals(currentUser.getRole())) {
            canViewMembers = true;
            registeredUsers = inscriptionDAO.findRegisteredUsersByEvenement(eventId);
        } else if ("RESPONSABLE".equals(currentUser.getRole())) {
            if (clubDAO.isResponsableOfClub(currentUser.getId(), event.getClubId())) {
                canViewMembers = true;
                registeredUsers = inscriptionDAO.findRegisteredUsersByEvenement(eventId);
            }
        }

        request.setAttribute("event", event);
        request.setAttribute("club", club);
        request.setAttribute("isRegistered", isRegistered);
        request.setAttribute("canViewMembers", canViewMembers);
        request.setAttribute("registeredUsers", registeredUsers);
        request.getRequestDispatcher("/jsp/eventDetail.jsp").forward(request, response);
    }
}
