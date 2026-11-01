package users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String surname = req.getParameter("surname");
        String gender = req.getParameter("gender");
        String phoneRaw = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");


        String normalizedPhone = null;
        if (phoneRaw != null && !phoneRaw.trim().isEmpty()) {
            String digitsOnly = phoneRaw.replaceAll("\\D", "");
            if (digitsOnly.startsWith("8")) {
                digitsOnly = "7" + digitsOnly.substring(1);
            }
            if (digitsOnly.length() == 11) {
                normalizedPhone = "+7" + digitsOnly.substring(1);
            } else {
                req.setAttribute("error", "Телефон должен содержать ровно 11 цифр.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
        } else {
            req.setAttribute("error", "Телефон обязателен.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }


        if (name == null || name.trim().isEmpty() ||
                surname == null || surname.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty() ||
                password == null || password.length() < 4 || password.length() > 8 ||
                confirmPassword == null || !password.equals(confirmPassword)) {

            String msg = "Проверьте поля: все обязательны, пароль 4–8 символов, пароли должны совпадать.";
            req.setAttribute("error", msg);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }


        User newUser = new User(name, surname, gender, normalizedPhone, password);

        try {
            User savedUser = userService.save(newUser);
            System.out.println("✅ Пользователь зарегистрирован! ID: " + savedUser.id());
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } catch (SQLException e) {

            String msg = e.getMessage();
            if (msg != null && msg.contains("Телефон уже зарегистрирован")) {
                req.setAttribute("error", "Этот телефон уже используется.");
            } else {

                e.printStackTrace();
                req.setAttribute("error", "Ошибка регистрации. Проверьте консоль сервера.");
            }
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Произошла непредвиденная ошибка.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
