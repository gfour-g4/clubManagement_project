package servlet;

import dao.ClubDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ClubListServlet extends BaseServlet {
    private final ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        request.setAttribute("clubs", clubDAO.findAll());
        request.setAttribute("clubResponsables", clubDAO.findResponsableNamesByClub());
        request.getRequestDispatcher("/jsp/listClubs.jsp").forward(request, response);
    }
}
