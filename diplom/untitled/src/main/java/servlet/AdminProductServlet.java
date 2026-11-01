package servlet;

import products.Product;
import products.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {

        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String view = request.getParameter("view");
        String mode;
        Product productObj = null;


        if ("edit".equals(action)) {
            mode = "edit";
            String idStr = request.getParameter("id");

            if (idStr == null || idStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Отсутствует ID товара");
                return;
            }

            try {
                int id = Integer.parseInt(idStr);
                Optional<Product> optProduct = productService.getById(id);

                if (optProduct.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Товар не найден");
                    return;
                }
                productObj = optProduct.get();
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
                return;
            }
        } else {

            mode = "new";
            productObj = null;
        }


        List<Product> products = productService.getAll();
        request.setAttribute("products", products);
        request.setAttribute("mode", mode);
        request.setAttribute("product", productObj);


        if ("list".equals(view)) {
            request.getRequestDispatcher("/WEB-INF/views/admin/products-list.jsp").forward(request, response);
        } else {

            request.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rawMode = request.getParameter("mode");
        String mode = (rawMode != null) ? rawMode.trim().toLowerCase() : "";

        if (!"edit".equals(mode) && !"new".equals(mode)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Неизвестный режим: " + rawMode);
            return;
        }

        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String image_url = request.getParameter("image_url");
        String description = request.getParameter("description");
        String quantityStr = request.getParameter("quantity");

        double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0.0;
        int quantity = (quantityStr != null && !quantityStr.isEmpty()) ? Integer.parseInt(quantityStr) : 0;

        if ("edit".equals(mode)) {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Для редактирования требуется ID");
                return;
            }
            int id = Integer.parseInt(idStr);

            Product product = new Product(id, name, price, category, image_url, description, quantity);


            try {
                productService.update(product);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            System.out.println("Товар обновлён: " + product);

        } else {

            Product product = new Product(0, name, price, category, image_url, description, quantity);


            try {
                productService.add(product);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            System.out.println("Товар создан: " + product);
        }


        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}