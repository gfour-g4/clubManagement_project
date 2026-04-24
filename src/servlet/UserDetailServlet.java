package servlet;

import dao.AdhesionDAO;
import dao.InscriptionEvenementDAO;
import dao.UtilisateurDAO;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class UserDetailServlet extends BaseServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    private final AdhesionDAO adhesionDAO = new AdhesionDAO();
    private final InscriptionEvenementDAO inscriptionDAO = new InscriptionEvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/users?info=Utilisateur+introuvable.");
            return;
        }
        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/users?info=Identifiant+utilisateur+invalide.");
            return;
        }

        Utilisateur target = utilisateurDAO.findById(userId);
        if (target == null) {
            response.sendRedirect(request.getContextPath() + "/users?info=Utilisateur+introuvable.");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "info";
        }
        if (!"info".equals(tab) && !"clubs".equals(tab) && !"events".equals(tab) && !"actions".equals(tab)) {
            tab = "info";
        }

        List<String> clubs = adhesionDAO.findActiveClubNamesByUser(userId);
        List<String> events = inscriptionDAO.findActiveEventTitlesByUser(userId);

        request.setAttribute("targetUser", target);
        request.setAttribute("activeTab", tab);
        request.setAttribute("clubs", clubs);
        request.setAttribute("events", events);
        request.getRequestDispatcher("/jsp/userDetails.jsp").forward(request, response);
    }
}
