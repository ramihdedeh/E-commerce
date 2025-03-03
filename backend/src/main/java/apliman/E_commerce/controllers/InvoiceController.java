package apliman.E_commerce.controllers;

import apliman.E_commerce.DTO.InvoiceDTO;
import apliman.E_commerce.DTO.InvoiceItemDTO;
import apliman.E_commerce.requests.InvoiceRequest;
import apliman.E_commerce.services.InvoiceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*") 
@RestController
@RequestMapping("/api/invoices")
@RequiredArgsConstructor
public class InvoiceController {

    private final InvoiceService invoiceService;

    // Get all invoices by customer ID
    @GetMapping("/customer/{customerId}")
    public ResponseEntity<List<InvoiceDTO>> getInvoicesByCustomerId(@PathVariable Long customerId) {
        return ResponseEntity.ok(invoiceService.getInvoicesByCustomerId(customerId));
    }

    //Get Items of an Invoice
    @GetMapping("/{invoiceId}/items")
    public ResponseEntity<List<InvoiceItemDTO>> getInvoiceItems(@PathVariable Long invoiceId) {
    return ResponseEntity.ok(invoiceService.getInvoiceItems(invoiceId));
}


    // Get all invoices by customer name
    @GetMapping("/customer")
    public ResponseEntity<List<InvoiceDTO>> getInvoicesByCustomerName(@RequestParam String name) {
        return ResponseEntity.ok(invoiceService.getInvoicesByCustomerName(name));
    }

    // Create an invoice including all items
    @PostMapping
    public ResponseEntity<InvoiceDTO> createInvoice(@RequestBody InvoiceRequest request) {
        return ResponseEntity.ok(invoiceService.createInvoice(request));
    }
 

}
