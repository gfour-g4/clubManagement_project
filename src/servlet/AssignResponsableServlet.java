package servlet;

import dao.ClubDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AssignResponsableServlet extends BaseServlet {
    private final ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN")) {
            return;
        }
        int clubId = Integer.parseInt(request.getParameter("clubId"));
        int utilisateurId = Integer.parseInt(request.getParameter("utilisateurId"));
        clubDAO.assignResponsable(utilisateurId, clubId);
        String redirectClubId = request.getParameter("redirectClubId");
        if (redirectClubId != null && !redirectClubId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/clubs/view?id=" + redirectClubId + "&tab=assign&info=Responsable+mis+a+jour.");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/clubs?info=Responsable+mis+a+jour.");
    }
}
