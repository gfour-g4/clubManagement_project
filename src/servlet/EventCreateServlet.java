package servlet;

import dao.ClubDAO;
import dao.EvenementDAO;
import model.Club;
import model.Evenement;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

public class EventCreateServlet extends BaseServlet {
    private final EvenementDAO evenementDAO = new EvenementDAO();
    private final ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN", "RESPONSABLE")) {
            return;
        }
        request.setAttribute("clubs", getAllowedClubs(request));
        request.getRequestDispatcher("/jsp/createEvent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireRole(request, response, "ADMIN", "RESPONSABLE")) {
            return;
        }
        Utilisateur currentUser = getCurrentUser(request);
        int clubId = Integer.parseInt(request.getParameter("clubId"));
        if ("RESPONSABLE".equals(currentUser.getRole()) && !clubDAO.isResponsableOfClub(currentUser.getId(), clubId)) {
            request.setAttribute("error", "Vous ne pouvez creer un evenement que pour votre club.");
            request.setAttribute("clubs", getAllowedClubs(request));
            request.getRequestDispatcher("/jsp/createEvent.jsp").forward(request, response);
            return;
        }

        String dateEvenementParam = request.getParameter("dateEvenement");
        Timestamp dateEvenement;
        try {
            dateEvenement = Timestamp.valueOf(dateEvenementParam.replace("T", " ") + ":00");
        } catch (Exception ex) {
            forwardWithError(request, response, "Format de date invalide.");
            return;
        }

        if (dateEvenement.toLocalDateTime().isBefore(LocalDateTime.of(1970, 1, 1, 0, 0))) {
            forwardWithError(request, response, "La date de l'evenement doit etre superieure a 1970-01-01.");
            return;
        }

        Evenement e = new Evenement();
        e.setClubId(clubId);
        e.setTitre(request.getParameter("titre"));
        e.setDescription(request.getParameter("description"));
        e.setDateEvenement(dateEvenement);
        e.setLieu(request.getParameter("lieu"));
        try {
            evenementDAO.create(e);
        } catch (RuntimeException ex) {
            forwardWithError(request, response, "Impossible de creer l'evenement: verifiez les champs saisis.");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/events?info=Evenement+cree+avec+succes.");
    }

    private List<Club> getAllowedClubs(HttpServletRequest request) {
        Utilisateur currentUser = getCurrentUser(request);
        if ("ADMIN".equals(currentUser.getRole())) {
            return clubDAO.findAll();
        }
        return clubDAO.findByResponsableUserId(currentUser.getId());
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.setAttribute("clubs", getAllowedClubs(request));
        request.setAttribute("oldTitre", request.getParameter("titre"));
        request.setAttribute("oldDescription", request.getParameter("description"));
        request.setAttribute("oldDateEvenement", request.getParameter("dateEvenement"));
        request.setAttribute("oldLieu", request.getParameter("lieu"));
        request.setAttribute("oldClubId", request.getParameter("clubId"));
        request.getRequestDispatcher("/jsp/createEvent.jsp").forward(request, response);
    }
}
