package servlet;

import dao.ClubMembershipRequestDAO;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class MembershipRequestDecisionServlet extends BaseServlet {
    private final ClubMembershipRequestDAO membershipRequestDAO = new ClubMembershipRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "RESPONSABLE")) {
            return;
        }

        Utilisateur current = getCurrentUser(request);
        int responsableId = current.getId();

        String requestIdParam = request.getParameter("requestId");
        String decision = request.getParameter("decision");
        String redirectClubIdParam = request.getParameter("redirectClubId");

        int requestId = Integer.parseInt(requestIdParam);
        boolean accept = "accept".equals(decision);

        int redirectClubId = Integer.parseInt(redirectClubIdParam);
        String info = accept ? "Demande+acceptee." : "Demande+refusee.";

        membershipRequestDAO.decide(requestId, responsableId, accept);
        response.sendRedirect(request.getContextPath() + "/clubs/view?id=" + redirectClubId + "&tab=requests&info=" + info);
    }
}

