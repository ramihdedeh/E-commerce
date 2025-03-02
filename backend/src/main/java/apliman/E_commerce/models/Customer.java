package apliman.E_commerce.models;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data // Lombok for Getters/Setters
@Table(name = "customer") 
public class Customer {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;

    @JsonBackReference  // Prevents infinite recursion
    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL) 
    // One customer can have multiple invoices
    // "mappedBy = customer" means the "customer" field in Invoice owns this relation
    private List<Invoice> invoices;

    
    @CreationTimestamp  // Automatically sets timestamp when customer is created
    @Column(updatable = false)
    private LocalDateTime createdAt;
}

