package apliman.E_commerce.DTO;


import lombok.Data;

@Data
public class InvoiceItemDTO {
    private String itemName;
    private Double price;
    private Integer quantity;
}
