package users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.PasswordUtil;

import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String inputPhone = req.getParameter("phone");
        String inputPassword = req.getParameter("password");

        User user;
        try {

            user = userService.findByPhone(inputPhone);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Ошибка соединения с базой данных");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if (user == null) {
            req.setAttribute("error", "Неверный телефон или пароль");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }


        String storedHash = user.password();


        if (storedHash == null || storedHash.length() < 20) {
            if (!inputPassword.equals(storedHash)) {
                req.setAttribute("error", "Неверный телефон или пароль");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }
        } else {

            try {
                boolean matches = PasswordUtil.check(inputPassword, storedHash);
                if (!matches) {
                    req.setAttribute("error", "Неверный телефон или пароль");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("error", "Ошибка проверки пароля");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }
        }


        HttpSession session = req.getSession();

        session.setAttribute("user", user);

        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}