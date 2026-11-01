package products;

public record Product(int id, String name, double price, String category,
                      String image_url, String description, int quantity) {}