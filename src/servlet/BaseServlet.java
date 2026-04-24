package servlet;

import model.Utilisateur;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public abstract class BaseServlet extends HttpServlet {

    protected Utilisateur getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Utilisateur) session.getAttribute("user");
    }

    protected boolean requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (getCurrentUser(request) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    protected boolean requireRole(HttpServletRequest request, HttpServletResponse response, String... roles) throws IOException {
        Utilisateur user = getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        for (String role : roles) {
            if (role.equals(user.getRole())) {
                return true;
            }
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return false;
    }

    protected void utf8(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }
}
