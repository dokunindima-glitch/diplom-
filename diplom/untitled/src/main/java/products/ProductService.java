package products;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


public class ProductService {

    private static final String DB_URL = "jdbc:postgresql://localhost:5432/diplom";
    private static final String USER = "postgres";
    private static final String PASS = "password";


    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("PostgreSQL driver not found. Add postgresql-jdbc to classpath.");
        }
    }

    public Optional<Product> getById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public List<Product> getAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id";
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }


    public Product add(Product product) throws SQLException {
        String sql = """
        INSERT INTO products (name, price, category, image_url, description, quantity)
        VALUES (?, ?, ?, ?, ?, ?)
        RETURNING *
    """;
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.name());
            ps.setDouble(2, product.price());
            ps.setString(3, product.category());
            ps.setString(4, product.image_url());
            ps.setString(5, product.description());
            ps.setInt(6, product.quantity());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                } else {
                    throw new SQLException("Не удалось добавить товар");
                }
            }
        }
    }


    public boolean update(Product product) throws SQLException {
        String sql = """
        UPDATE products
        SET name = ?, price = ?, category = ?, image_url = ?, description = ?, quantity = ?
        WHERE id = ?
    """;
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.name());
            ps.setDouble(2, product.price());
            ps.setString(3, product.category());
            ps.setString(4, product.image_url());
            ps.setString(5, product.description());
            ps.setInt(6, product.quantity());
            ps.setInt(7, product.id());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getDouble("price"),
                rs.getString("category"),
                rs.getString("image_url"),
                rs.getString("description"),
                rs.getInt("quantity")
        );
    }
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
}
