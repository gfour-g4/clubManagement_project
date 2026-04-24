package servlet;

import dao.UtilisateurDAO;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends BaseServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        utf8(request, response);
        request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        Utilisateur user = utilisateurDAO.login(email, motDePasse);
        if (user == null) {
            request.setAttribute("error", "Email ou mot de passe incorrect.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
