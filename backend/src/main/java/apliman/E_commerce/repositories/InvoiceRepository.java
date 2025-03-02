package apliman.E_commerce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apliman.E_commerce.models.Invoice;

import java.util.List;


@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {

    // Get all invoices by customer ID
    List<Invoice> findByCustomerId(Long customerId);

    // Get all invoices by customer name (using the relation with Customer entity)
    List<Invoice> findByCustomer_NameContainingIgnoreCase(String name);
}
