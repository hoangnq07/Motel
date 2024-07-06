package dao;
import context.DBcontext;
import model.CategoryRoom;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CategoryRoomDAO {
    public static List<CategoryRoom> getCategoryList() {
        List<CategoryRoom> categories = new ArrayList<>();
        try (Connection con = DBcontext.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM dbo.category_room")) {
            // Lặp qua các kết quả
            while (rs.next()) {
                CategoryRoom cr = new CategoryRoom();
                cr.setCategoryRoomId(rs.getInt("category_room_id"));
                cr.setDescriptions(rs.getString("descriptions"));
                cr.setQuantity(rs.getInt("quantity"));
                cr.setStatus(rs.getBoolean("status"));
                categories.add(cr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }
}
