package servlet;

import dao.InscriptionEvenementDAO;
import model.Utilisateur;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class EventRegistrationServlet extends BaseServlet {
    private final InscriptionEvenementDAO inscriptionDAO = new InscriptionEvenementDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        utf8(request, response);
        if (!requireRole(request, response, "ETUDIANT")) {
            return;
        }
        Utilisateur user = getCurrentUser(request);
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");
        String redirectEventId = request.getParameter("redirectEventId");
        String redirectBase = redirectEventId != null && !redirectEventId.trim().isEmpty()
                ? request.getContextPath() + "/events/view?id=" + redirectEventId + "&tab=register&info="
                : request.getContextPath() + "/events?info=";
        if ("register".equals(action)) {
            inscriptionDAO.register(eventId, user.getId());
            response.sendRedirect(redirectBase + "Inscription+effectuee.");
        } else if ("cancel".equals(action)) {
            inscriptionDAO.cancel(eventId, user.getId());
            response.sendRedirect(redirectBase + "Inscription+annulee.");
        } else {
            response.sendRedirect(redirectBase + "Action+invalide.");
        }
    }
}
