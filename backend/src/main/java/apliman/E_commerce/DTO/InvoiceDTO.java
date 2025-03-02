package apliman.E_commerce.DTO;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class InvoiceDTO {
    private Long id;
    private String customerName;
    private Double total;
    private LocalDateTime createdAt;
    private List<InvoiceItemDTO> invoiceItems;
}
