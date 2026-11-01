package users;

public record User(
        int id,
        String name,
        String surname,
        String gender,
        String phone,
        String password,
        double balance,
        String role
) {
    public User(String name, String surname, String gender, String phone, String password) {
        this(0, name, surname, gender, phone, password, 0.0, "USER");
    }
}