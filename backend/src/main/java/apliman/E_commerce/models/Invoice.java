package apliman.E_commerce.models;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "invoice")
public class Invoice {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonManagedReference  // Prevents infinite recursion
    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false) 
    // Many invoices belong to one customer
    // "customer_id" is the foreign key referencing Customer's ID
    private Customer customer;

    private Double total;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL)
    // One invoice can have multiple invoice items
    // "mappedBy = invoice" means the "invoice" field in InvoiceItem owns this relation
    private List<InvoiceItem> invoiceItems;

    @CreationTimestamp  // Automatically sets timestamp when item is added
    @Column(updatable = false)
    private LocalDateTime createdAt;

}
