package servlet;

import dao.UtilisateurDAO;
import model.Utilisateur;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UserDeleteServlet extends BaseServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        Utilisateur current = getCurrentUser(request);
        if (current != null && current.getId() == id) {
            response.sendRedirect(request.getContextPath() + "/users?info=Vous+ne+pouvez+pas+supprimer+votre+propre+compte.");
            return;
        }
        utilisateurDAO.deleteById(id);
        response.sendRedirect(request.getContextPath() + "/users?info=Utilisateur+supprime.");
    }
}
