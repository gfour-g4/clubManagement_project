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
        if (!requireRole(request, response, "MEMBRE", "ETUDIANT")) {
            return;
        }
        Utilisateur user = getCurrentUser(request);
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");
        String redirectUrl = request.getParameter("redirectUrl");
        String eventIdParam = request.getParameter("eventIdParam");
        if (redirectUrl == null || redirectUrl.isEmpty()) {
            redirectUrl = "/events";
        }
        String info = "";
        if ("register".equals(action)) {
            inscriptionDAO.register(eventId, user.getId());
            info = "Inscription+effectuee.";
        } else if ("cancel".equals(action)) {
            inscriptionDAO.cancel(eventId, user.getId());
            info = "Inscription+annulee.";
        } else {
            info = "Action+invalide.";
        }
        StringBuilder finalUrl = new StringBuilder(request.getContextPath()).append(redirectUrl).append("?info=").append(info);
        if (eventIdParam != null && !eventIdParam.isEmpty()) {
            finalUrl.append("&").append(eventIdParam).append("=").append(eventId);
        }
        response.sendRedirect(finalUrl.toString());
    }
}
