package apliman.E_commerce.requests;

import lombok.Data;
import java.util.List;

@Data
public class InvoiceRequest {
    private Long customerId; // The ID of the customer making the purchase
    private List<InvoiceItemRequest> items; // List of items and their quantities
}
