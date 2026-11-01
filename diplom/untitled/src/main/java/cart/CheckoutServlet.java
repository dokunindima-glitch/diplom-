package cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import users.User;
import util.DBConnection;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Пользователь не авторизован");
            return;
        }

        User user = (User) session.getAttribute("user");

        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        JSONObject json = new JSONObject(sb.toString());
        double orderTotal = json.getDouble("totalAmount");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            double currentBalance = getUserBalance(conn, user.id());

            if (currentBalance < orderTotal) {
                throw new SQLException("Недостаточно средств на балансе. Требуется: " + orderTotal + ", Доступно: " + currentBalance);
            }

            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
            if (cartItems == null || cartItems.isEmpty()) {
                throw new SQLException("Корзина пуста");
            }

            for (CartItem item : cartItems) {
                int availableStock = getProductStock(conn, item.productId());
                if (availableStock < item.quantity()) {
                    throw new SQLException("Товара '" + item.productName() + "' недостаточно на складе. В наличии: " + availableStock);
                }


                updateProductStock(conn, item.productId(), item.quantity());
            }


            updateUserBalance(conn, user.id(), orderTotal);


            createOrder(conn, user.id(), orderTotal, cartItems);


            conn.commit();


            session.removeAttribute("cart");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"status\": \"success\", \"message\": \"Заказ оформлен\"}");

        } catch (SQLException e) {

            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Транзакция отменена: " + e.getMessage());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }


            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");

        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }



    private double getUserBalance(Connection conn, int userId) throws SQLException {
        String sql = "SELECT balance FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble("balance");
            return 0.0;
        }
    }

    private int getProductStock(Connection conn, int productId) throws SQLException {
        String sql = "SELECT quantity FROM products WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("quantity");
            return 0;
        }
    }

    private void updateProductStock(Connection conn, int productId, int quantity) throws SQLException {

        String sql = "UPDATE products SET quantity = quantity - ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    private void updateUserBalance(Connection conn, int userId, double amount) throws SQLException {
        String sql = "UPDATE users SET balance = balance - ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, amount);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private void createOrder(Connection conn, int userId, double total, List<CartItem> items) throws SQLException {
    }
}
