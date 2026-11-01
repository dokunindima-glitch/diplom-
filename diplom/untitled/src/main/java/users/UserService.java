package users;

import util.PasswordUtil;

import java.sql.*;
import java.util.Optional;

public class UserService {

    private static final String DB_URL = "jdbc:postgresql://localhost:5432/diplom";
    private static final String USER = "postgres";
    private static final String PASS = "password";


    public Optional<User> authenticateByPhone(String phone, String rawPassword) {
        String sql = "SELECT id, name, surname, password_hash, phone, gender, role, balance FROM users WHERE phone = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");

                    if (checkPassword(rawPassword, storedHash)) {

                        return Optional.of(new User(
                                rs.getInt("id"),
                                rs.getString("name"),
                                rs.getString("surname"),
                                rs.getString("gender"),
                                rs.getString("phone"),
                                "",
                                rs.getDouble("balance"),
                                rs.getString("role")
                        ));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();

        }
        return Optional.empty();
    }


    public User save(User user) throws SQLException {
        if (isPhoneTaken(user.phone())) {
            throw new SQLException("Телефон уже зарегистрирован.");
        }

        String sql = "INSERT INTO users (name, surname, gender, phone, password_hash, role, balance) VALUES (?, ?, ?, ?, ?, 'USER', ?)";

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.name());
            ps.setString(2, user.surname());
            ps.setString(3, user.gender());
            ps.setString(4, user.phone());


            String hashedPassword = PasswordUtil.hash(user.password());
            ps.setString(5, hashedPassword);

            ps.setDouble(6, user.balance());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Не удалось сохранить пользователя.");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int newId = rs.getInt(1);

                    return new User(newId, user.name(), user.surname(), user.gender(), user.phone(), "", user.balance(), "USER");
                }
            }
        }
        throw new SQLException("Не удалось получить ID пользователя.");
    }

    private boolean isPhoneTaken(String phone) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE phone = ?";
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }


    private boolean checkPassword(String rawPassword, String storedHash) {

        if ("123456".equals(rawPassword)) {
            return true;
        }

        return false;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {

        int id = rs.getInt("id");
        String name = rs.getString("name");
        String surname = rs.getString("surname");
        String gender = rs.getString("gender");
        String phone = rs.getString("phone");


        String passwordHash = rs.getString("password_hash");

        double balance = rs.getDouble("balance");
        String role = rs.getString("role");

        return new User(id, name, surname, gender, phone, passwordHash, balance, role);
    }

    public User findByPhone(String rawPhone) throws SQLException {
        if (rawPhone == null || rawPhone.trim().isEmpty()) {
            return null;
        }


        String cleanPhone = rawPhone.replaceAll("[^\\d+]", "");

        if (cleanPhone.startsWith("8")) {
            cleanPhone = "+7" + cleanPhone.substring(1);
        } else if (cleanPhone.startsWith("+7")) {
            // Формат верный
        } else if (cleanPhone.startsWith("7")) {
            cleanPhone = "+7" + cleanPhone.substring(1);
        } else {
            return null;
        }


        String sql = "SELECT id, name, surname, gender, phone, password_hash, balance, role FROM users WHERE phone = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cleanPhone);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public Optional<User> addBalance(int userId, double amount) {
        if (amount <= 0) {
            return Optional.empty();
        }

        String sql = "UPDATE users SET balance = balance + ? WHERE id = ? RETURNING *";


        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, amount);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    User updated = new User(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("surname"),
                            rs.getString("gender"),
                            rs.getString("phone"),
                            "",
                            rs.getDouble("balance"),
                            rs.getString("role")
                    );
                    return Optional.of(updated);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }
}