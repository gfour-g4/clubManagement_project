package servlet;

import dao.AdhesionDAO;
import dao.ClubDAO;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class MembershipServlet extends BaseServlet {
    private final AdhesionDAO adhesionDAO = new AdhesionDAO();
    private final ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        int clubId = Integer.parseInt(request.getParameter("clubId"));
        request.setAttribute("members", clubDAO.findMembersByClub(clubId));
        request.setAttribute("clubId", clubId);
        request.getRequestDispatcher("/jsp/clubMembers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        utf8(request, response);
        if (!requireRole(request, response, "MEMBRE", "ETUDIANT")) {
            return;
        }
        Utilisateur user = getCurrentUser(request);
        int clubId = Integer.parseInt(request.getParameter("clubId"));
        String action = request.getParameter("action");
        String redirectClubId = request.getParameter("redirectClubId");
        String redirectTo = redirectClubId != null && !redirectClubId.trim().isEmpty()
                ? request.getContextPath() + "/clubs/view?id=" + redirectClubId + "&tab=info&info="
                : request.getContextPath() + "/clubs?info=";
        if ("join".equals(action)) {
            adhesionDAO.joinClub(user.getId(), clubId);
            response.sendRedirect(redirectTo + "Adhesion+enregistree.");
        } else if ("leave".equals(action)) {
            adhesionDAO.leaveClub(user.getId(), clubId);
            response.sendRedirect(redirectTo + "Vous+avez+quitte+le+club.");
        } else {
            response.sendRedirect(redirectTo + "Action+invalide.");
        }
    }
}
