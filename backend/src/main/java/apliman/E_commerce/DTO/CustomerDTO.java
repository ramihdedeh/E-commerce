package apliman.E_commerce.DTO;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data  // Generates Getters, Setters, toString(), equals(), and hashCode()
@NoArgsConstructor  // Generates a no-args constructor
@AllArgsConstructor // Generates a constructor with all fields
public class CustomerDTO {
    private Long id;
    private String name;
}
