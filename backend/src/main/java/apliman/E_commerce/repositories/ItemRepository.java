package apliman.E_commerce.repositories;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import apliman.E_commerce.models.Item;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

@Repository
public interface ItemRepository extends JpaRepository<Item, Long> {
    
    // Search for items by name (case insensitive)
    Page<Item> findByNameContainingIgnoreCase(String name, PageRequest pageRequest);
    Page<Item> findByDeletedFalse(PageRequest pageRequest); // Exclude deleted items
}
