package servlet;

import dao.AdhesionDAO;
import dao.ClubDAO;
import dao.EvenementDAO;
import dao.InscriptionEvenementDAO;
import model.Adhesion;
import model.Club;
import model.Evenement;
import model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class EventListServlet extends BaseServlet {
    private final EvenementDAO evenementDAO = new EvenementDAO();
    private final ClubDAO clubDAO = new ClubDAO();
    private final InscriptionEvenementDAO inscriptionDAO = new InscriptionEvenementDAO();
    private final AdhesionDAO adhesionDAO = new AdhesionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        utf8(request, response);
        if (!requireLogin(request, response)) {
            return;
        }
        Utilisateur currentUser = getCurrentUser(request);
        String clubIdParam = request.getParameter("clubId");
        Integer selectedClubId = null;
        List<Evenement> events;
        List<Club> allClubs = clubDAO.findAll();

        if ("MEMBRE".equals(currentUser.getRole()) || "ETUDIANT".equals(currentUser.getRole())) {
            List<Evenement> registeredEvents = inscriptionDAO.findRegisteredEventsByUser(currentUser.getId());
            request.setAttribute("registeredEvents", registeredEvents);
            
            java.util.Set<Integer> registeredEventIds = registeredEvents.stream()
                    .map(Evenement::getId)
                    .collect(Collectors.toSet());
            
            List<Evenement> upcomingClubEvents = evenementDAO.findUpcomingByUserClubs(currentUser.getId());
            upcomingClubEvents = upcomingClubEvents.stream()
                    .filter(e -> !registeredEventIds.contains(e.getId()))
                    .collect(Collectors.toList());
            request.setAttribute("upcomingClubEvents", upcomingClubEvents);
            
            List<Adhesion> myAdhesions = adhesionDAO.findByUtilisateur(currentUser.getId());
            List<Integer> myClubIds = myAdhesions.stream()
                    .filter(a -> "ACTIF".equals(a.getStatut()))
                    .map(Adhesion::getClubId)
                    .collect(Collectors.toList());
            if (clubIdParam != null && !clubIdParam.isEmpty()) {
                int clubId = Integer.parseInt(clubIdParam);
                if (myClubIds.contains(clubId)) {
                    selectedClubId = clubId;
                    events = evenementDAO.findByClub(clubId);
                } else {
                    events = new ArrayList<>();
                }
            } else {
                events = new ArrayList<>();
                for (int clubId : myClubIds) {
                    events.addAll(evenementDAO.findByClub(clubId));
                }
            }
            allClubs = allClubs.stream().filter(c -> myClubIds.contains(c.getId())).collect(Collectors.toList());
        } else {
            if (clubIdParam != null && !clubIdParam.isEmpty()) {
                int clubId = Integer.parseInt(clubIdParam);
                selectedClubId = clubId;
                events = evenementDAO.findByClub(clubId);
            } else {
                events = evenementDAO.findAll();
            }
        }

        request.setAttribute("events", events);
        request.setAttribute("selectedClubId", selectedClubId);
        request.setAttribute("clubs", allClubs);
        request.setAttribute("clubNamesById", buildClubNamesMap(allClubs));

        Map<Integer, Boolean> registrationStatus = new HashMap<>();
        
        for (Evenement e : events) {
            registrationStatus.put(e.getId(), inscriptionDAO.isRegistered(e.getId(), currentUser.getId()));
        }
        
        if ("MEMBRE".equals(currentUser.getRole()) || "ETUDIANT".equals(currentUser.getRole())) {
            List<Evenement> upcoming = (List<Evenement>) request.getAttribute("upcomingClubEvents");
            if (upcoming != null) {
                for (Evenement e : upcoming) {
                    if (!registrationStatus.containsKey(e.getId())) {
                        registrationStatus.put(e.getId(), inscriptionDAO.isRegistered(e.getId(), currentUser.getId()));
                    }
                }
            }
            List<Evenement> registered = (List<Evenement>) request.getAttribute("registeredEvents");
            if (registered != null) {
                for (Evenement e : registered) {
                    if (!registrationStatus.containsKey(e.getId())) {
                        registrationStatus.put(e.getId(), inscriptionDAO.isRegistered(e.getId(), currentUser.getId()));
                    }
                }
            }
        }
        
        request.setAttribute("registrationStatus", registrationStatus);

        request.getRequestDispatcher("/jsp/listEvents.jsp").forward(request, response);
    }

    private Map<Integer, String> buildClubNamesMap(List<Club> clubs) {
        Map<Integer, String> namesById = new HashMap<>();
        clubs.forEach(club -> namesById.put(club.getId(), club.getNom()));
        return namesById;
    }
}
