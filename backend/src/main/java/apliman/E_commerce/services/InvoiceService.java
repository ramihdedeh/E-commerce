package apliman.E_commerce.services;

import apliman.E_commerce.DTO.InvoiceDTO;
import apliman.E_commerce.DTO.InvoiceItemDTO;
import apliman.E_commerce.models.*;
import apliman.E_commerce.repositories.*;
import apliman.E_commerce.requests.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.ArrayList;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class InvoiceService {

    private final InvoiceRepository invoiceRepository;
    private final CustomerRepository customerRepository;
    private final ItemRepository itemRepository;
    private final InvoiceItemRepository invoiceItemRepository;

  
    public List<InvoiceDTO> getInvoicesByCustomerId(Long customerId) {
        List<Invoice> invoices = invoiceRepository.findByCustomerId(customerId);
        return invoices.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    
    public List<InvoiceDTO> getInvoicesByCustomerName(String name) {
        List<Invoice> invoices = invoiceRepository.findByCustomer_NameContainingIgnoreCase(name);
        return invoices.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    // Convert Invoice to DTO (for clean API responses)
    private InvoiceDTO convertToDTO(Invoice invoice) {
        InvoiceDTO dto = new InvoiceDTO();
        dto.setId(invoice.getId());
        dto.setCustomerName(invoice.getCustomer().getName());
        dto.setTotal(invoice.getTotal() != null ? invoice.getTotal() : 0.0);
        dto.setCreatedAt(invoice.getCreatedAt());
    
        // Convert InvoiceItems to DTOs
        List<InvoiceItemDTO> itemDTOs = invoice.getInvoiceItems().stream().map(item -> {
            InvoiceItemDTO itemDTO = new InvoiceItemDTO();
            itemDTO.setItemName(item.getItem().getName());
            itemDTO.setPrice(item.getPrice());
            itemDTO.setQuantity(item.getQuantity());
            return itemDTO;
        }).collect(Collectors.toList());
    
        dto.setInvoiceItems(itemDTOs);
        return dto;
    }
    

    // Create an invoice with multiple items
    @Transactional
    public InvoiceDTO createInvoice(InvoiceRequest request) {
        Customer customer = customerRepository.findById(request.getCustomerId())
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        Invoice invoice = new Invoice();
        invoice.setCustomer(customer);
        invoice.setTotal(0.0);

        List<InvoiceItem> invoiceItems = new ArrayList<>();

        // Loop through the items
        for (InvoiceItemRequest itemRequest : request.getItems()) {
            Item item = itemRepository.findById(itemRequest.getItemId())
                    .orElseThrow(() -> new RuntimeException("Item not found"));

            // Set every attribute for the invoice item
            InvoiceItem invoiceItem = new InvoiceItem();
            invoiceItem.setInvoice(invoice);
            invoiceItem.setItem(item);
            invoiceItem.setQuantity(itemRequest.getQuantity());
            invoiceItem.setPrice(item.getPrice()); // Stores historical price

            // Add this new invoice item to the invoice items table
            invoiceItems.add(invoiceItem);
            invoice.setTotal(invoice.getTotal() + (item.getPrice() * itemRequest.getQuantity()));
        }

        // Save the new invoice
        invoice.setInvoiceItems(invoiceItems);
        invoiceRepository.save(invoice);
        return convertToDTO(invoice);
    }

    // Purchase an item and add it to an invoice
    @Transactional
    public InvoiceDTO purchaseItem(Long customerId, Long itemId, int quantity) {
        // Find the customer
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        //  Find the item
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));

        //  Check if the item is in stock
        if (item.getStock() < quantity) {
            throw new RuntimeException("Not enough stock available for " + item.getName());
        }

        //  Find an existing invoice or create a new one
        Invoice invoice = invoiceRepository.findByCustomerId(customerId).stream().findFirst()
                .orElseGet(() -> {
                    Invoice newInvoice = new Invoice();
                    newInvoice.setCustomer(customer);
                    newInvoice.setTotal(0.0);
                    invoiceRepository.save(newInvoice);
                    return newInvoice;
                });

        //  Create a new InvoiceItem and link it to the invoice
        InvoiceItem invoiceItem = new InvoiceItem();
        invoiceItem.setInvoice(invoice);
        invoiceItem.setItem(item);
        invoiceItem.setQuantity(quantity);
        invoiceItem.setPrice(item.getPrice()); // Stores historical price

        //  Update invoice total price
        invoice.setTotal(invoice.getTotal() + (item.getPrice() * quantity));

        //  Reduce stock after purchase
        item.setStock(item.getStock() - quantity);
        itemRepository.save(item);

        //  Save the invoice item
        invoiceItemRepository.save(invoiceItem);

        //  Return the updated invoice with full purchase details
        return convertToDTO(invoice);
    }
    //get all items of the invoice 
    public List<InvoiceItemDTO> getInvoiceItems(Long invoiceId) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new RuntimeException("Invoice not found"));
    
        return invoice.getInvoiceItems().stream().map(item -> {
            InvoiceItemDTO itemDTO = new InvoiceItemDTO();
            itemDTO.setItemName(item.getItem().getName());
            itemDTO.setPrice(item.getPrice());
            itemDTO.setQuantity(item.getQuantity());
            return itemDTO;
        }).collect(Collectors.toList());
    }
    
}
