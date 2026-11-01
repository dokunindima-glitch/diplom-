package cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) return;

        int productId = Integer.parseInt(idParam);
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<Integer> cart = (List<Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }


        if (!cart.contains(productId)) {
            cart.add(productId);
            System.out.println("Сервер: Товар " + productId + " добавлен.");
        } else {
            System.out.println("Сервер: Товар " + productId + " уже в корзине, игнорируем.");
        }

        session.setAttribute("cartCount", cart.size());
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
