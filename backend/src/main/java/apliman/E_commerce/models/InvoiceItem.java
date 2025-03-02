package apliman.E_commerce.models;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "invoice_item")
public class InvoiceItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonIgnore  // Prevents infinite recursion
    @ManyToOne
    @JoinColumn(name = "invoice_id", nullable = false)
    // Many invoice items belong to one invoice
    // "invoice_id" is the foreign key referencing Invoice's ID
    private Invoice invoice;

    @ManyToOne
    @JoinColumn(name = "item_id", nullable = false)
    @JsonIgnoreProperties("invoiceItems")
    // Many invoice items belong to one item
    // "item_id" is the foreign key referencing Item's ID
    private Item item;

    private Integer quantity;

    private Double price; // Store item price at the time of invoice (in case prices change)

    @CreationTimestamp  // Tracks when the invoice was created
    @Column(updatable = false)
    private LocalDateTime createdAt;
}
