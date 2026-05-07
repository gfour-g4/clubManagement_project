package servlet;

import dao.UtilisateurDAO;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class UserCreateServlet extends BaseServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }
        request.getRequestDispatcher("/jsp/createUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }

        String nomComplet = request.getParameter("nomComplet");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String role = request.getParameter("role");

        if (isBlank(nomComplet) || isBlank(email) || isBlank(motDePasse) || !allowedRoles().contains(role)) {
            forwardWithError(request, response, "Veuillez remplir correctement tous les champs.");
            return;
        }
        if (!email.contains("@")) {
            forwardWithError(request, response, "Adresse email invalide.");
            return;
        }
        if (motDePasse.length() < 4) {
            forwardWithError(request, response, "Le mot de passe doit contenir au moins 4 caracteres.");
            return;
        }

        Utilisateur u = new Utilisateur();
        u.setNomComplet(nomComplet.trim());
        u.setEmail(email.trim());
        u.setMotDePasse(motDePasse);
        u.setRole(role);
        try {
            utilisateurDAO.create(u);
            response.sendRedirect(request.getContextPath() + "/users?info=Utilisateur+cree.");
        } catch (RuntimeException e) {
            forwardWithError(request, response, "Creation impossible (email deja utilise ou donnees invalides).");
        }
    }

    private List<String> allowedRoles() {
        return Arrays.asList("MEMBRE", "ADMIN", "RESPONSABLE");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.setAttribute("oldNomComplet", request.getParameter("nomComplet"));
        request.setAttribute("oldEmail", request.getParameter("email"));
        request.setAttribute("oldRole", request.getParameter("role"));
        request.getRequestDispatcher("/jsp/createUser.jsp").forward(request, response);
    }
}
