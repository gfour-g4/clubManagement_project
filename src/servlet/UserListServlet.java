package servlet;

import dao.UtilisateurDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UserListServlet extends BaseServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }
        request.setAttribute("users", utilisateurDAO.findAll());
        request.getRequestDispatcher("/jsp/listUsers.jsp").forward(request, response);
    }
}
