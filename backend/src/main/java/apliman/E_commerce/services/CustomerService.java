package apliman.E_commerce.services;


import apliman.E_commerce.DTO.CustomerDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import apliman.E_commerce.models.Customer;
import apliman.E_commerce.repositories.CustomerRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomerService {

    private final CustomerRepository customerRepository;

    public CustomerDTO createCustomer(CustomerDTO customerDTO) {
        Customer customer = new Customer();
        customer.setName(customerDTO.getName()); // Copy name from DTO
        customer = customerRepository.save(customer);
        return new CustomerDTO(customer.getId(), customer.getName());
    }
    

    public Customer getCustomerById(Long id) {
        return customerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
    }

    public Page<Customer> getAllCustomers(int page, int size) {
        return customerRepository.findAll(PageRequest.of(page, size));
    }

    public Page<Customer> searchCustomersByName(String name, int page, int size) {
        return customerRepository.findByNameContainingIgnoreCase(name, PageRequest.of(page, size));
    }

    public CustomerDTO updateCustomer(Long id, CustomerDTO customerDTO) {
        Optional<Customer> customerOptional = customerRepository.findById(id);
        if (customerOptional.isPresent()) {
            Customer customer = customerOptional.get();
            customer.setName(customerDTO.getName());
            customerRepository.save(customer);
            return new CustomerDTO(customer.getId(), customer.getName());
        } else {
            throw new RuntimeException("Customer not found");
        }
    }
    
    public void deleteCustomer(Long id) {
        customerRepository.deleteById(id);
    }
}
