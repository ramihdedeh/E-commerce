package apliman.E_commerce.requests;

import lombok.Data;

@Data
public class InvoiceItemRequest {
    private Long itemId;  // The ID of the item being purchased
    private Integer quantity; // Quantity of the item in the invoice
}
