package users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/topup")
public class TopupServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {

        this.userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect("index.jsp");
            return;
        }

        String amountParam = req.getParameter("amount");
        if (amountParam == null || amountParam.trim().isEmpty()) {
            resp.sendRedirect("topup.jsp?error=empty");
            return;
        }

        double amount;
        try {
            amount = Double.parseDouble(amountParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect("topup.jsp?error=invalid");
            return;
        }

        if (amount <= 0) {
            resp.sendRedirect("topup.jsp?error=negative");
            return;
        }

        Optional<User> updatedOpt = userService.addBalance(currentUser.id(), amount);

        if (updatedOpt.isPresent()) {
            User updatedUser = updatedOpt.get();
            req.getSession().setAttribute("user", updatedUser);
            resp.sendRedirect("profile.jsp?success=true");
        } else {
            resp.sendRedirect("topup.jsp?error=db");
        }
    }
}