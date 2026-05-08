package servlet;

import dao.AdhesionDAO;
import dao.ClubDAO;
import dao.ClubMembershipRequestDAO;
import dao.EvenementDAO;
import dao.EventRegistrationRequestDAO;
import dao.UtilisateurDAO;
import model.Club;
import model.ClubMembershipRequest;
import model.EventRegistrationRequest;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class ClubDetailServlet extends BaseServlet {
    private final ClubDAO clubDAO = new ClubDAO();
    private final EvenementDAO evenementDAO = new EvenementDAO();
    private final AdhesionDAO adhesionDAO = new AdhesionDAO();
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    private final ClubMembershipRequestDAO clubMembershipRequestDAO = new ClubMembershipRequestDAO();
    private final EventRegistrationRequestDAO eventRegistrationRequestDAO = new EventRegistrationRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/clubs?info=Club+introuvable.");
            return;
        }

        int clubId;
        try {
            clubId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/clubs?info=Identifiant+club+invalide.");
            return;
        }

        Club club = clubDAO.findById(clubId);
        if (club == null) {
            response.sendRedirect(request.getContextPath() + "/clubs?info=Club+introuvable.");
            return;
        }

        Utilisateur currentUser = getCurrentUser(request);
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "info";
        }
        if ("assign".equals(tab) && !"ADMIN".equals(currentUser.getRole())) {
            tab = "info";
        }

        if ("requests".equals(tab)) {
            if (!"RESPONSABLE".equals(currentUser.getRole()) || !clubDAO.isResponsableOfClub(currentUser.getId(), clubId)) {
                tab = "info";
            }
        }

        Map<Integer, String> responsablesByClub = clubDAO.findResponsableNamesByClub();
        List<Utilisateur> responsables = utilisateurDAO.findByRole("RESPONSABLE");

        request.setAttribute("club", club);
        request.setAttribute("activeTab", tab);
        request.setAttribute("members", clubDAO.findMembersByClub(clubId));
        request.setAttribute("events", evenementDAO.findByClub(clubId));
        request.setAttribute("responsableName", responsablesByClub.get(clubId));
        request.setAttribute("responsables", responsables);
        request.setAttribute("isStudentMember", adhesionDAO.isActiveMember(currentUser.getId(), clubId));
        request.setAttribute("hasPendingMembershipRequest",
                clubMembershipRequestDAO.hasPendingRequest(currentUser.getId(), clubId));

        boolean isResponsableOfClub = clubDAO.isResponsableOfClub(currentUser.getId(), clubId);
        request.setAttribute("isResponsableOfClub", isResponsableOfClub);
        if ("RESPONSABLE".equals(currentUser.getRole()) && isResponsableOfClub) {
            request.setAttribute("pendingMembershipRequests",
                    clubMembershipRequestDAO.findPendingByResponsableAndClub(currentUser.getId(), clubId));
            request.setAttribute("pendingEventRequests",
                    eventRegistrationRequestDAO.findPendingByResponsableAndClub(currentUser.getId(), clubId));
        }
        request.getRequestDispatcher("/jsp/clubDetails.jsp").forward(request, response);
    }
}
