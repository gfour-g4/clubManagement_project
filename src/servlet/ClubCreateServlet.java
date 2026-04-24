package servlet;

import dao.ClubDAO;
import model.Club;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ClubCreateServlet extends BaseServlet {
    private final ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }
        request.getRequestDispatcher("/jsp/createClub.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }
        Club club = new Club();
        club.setNom(request.getParameter("nom"));
        club.setDescription(request.getParameter("description"));
        clubDAO.create(club);
        response.sendRedirect(request.getContextPath() + "/clubs");
    }
}
