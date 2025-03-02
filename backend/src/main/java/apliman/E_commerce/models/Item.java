package apliman.E_commerce.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "item") 
public class Item {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;
    private String description;
    private Double price;
    private Integer stock;

    
    @OneToMany(mappedBy = "item")
    // One item can appear in multiple invoices
    // "mappedBy = item" means the "item" field in InvoiceItem owns this relation
    private List<InvoiceItem> invoiceItems;

    @CreationTimestamp  // Tracks when the invoice was created
    @Column(updatable = false)
    private LocalDateTime createdAt;


    @Column(nullable = false)
    private boolean deleted = false; // Marks the item as "deleted" instead of removing it

}
