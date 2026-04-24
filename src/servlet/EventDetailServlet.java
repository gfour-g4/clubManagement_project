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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/events?info=Evenement+introuvable.");
            return;
        }
        int eventId;
        try {
            eventId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events?info=Identifiant+evenement+invalide.");
            return;
        }

        Evenement event = evenementDAO.findById(eventId);
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/events?info=Evenement+introuvable.");
            return;
        }

        Utilisateur current = getCurrentUser(request);
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "info";
        }
        if ("register".equals(tab) && !"ETUDIANT".equals(current.getRole())) {
            tab = "info";
        }

        Club club = clubDAO.findById(event.getClubId());
        List<Utilisateur> participants = inscriptionDAO.findActiveParticipantsByEvent(eventId);

        request.setAttribute("event", event);
        request.setAttribute("club", club);
        request.setAttribute("participants", participants);
        request.setAttribute("activeTab", tab);
        request.setAttribute("isRegistered", inscriptionDAO.isUserRegisteredActive(eventId, current.getId()));
        request.getRequestDispatcher("/jsp/eventDetails.jsp").forward(request, response);
    }
}
