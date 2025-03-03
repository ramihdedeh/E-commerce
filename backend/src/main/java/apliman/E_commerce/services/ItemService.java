package apliman.E_commerce.services;



import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import apliman.E_commerce.models.Item;
import apliman.E_commerce.repositories.ItemRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemService {

    private final ItemRepository itemRepository;

    // Create a new item
    public Item createItem(Item item) {
        return itemRepository.save(item);
    }

    // Get an item by ID
    public Item getItemById(Long id) {
        return itemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item not found"));
    }

    // Get all items with pagination
    public Page<Item> getAllItems(int page, int size) {
        return itemRepository.findByDeletedFalse(PageRequest.of(page, size));
    }
    // Search items by name with pagination
    public Page<Item> searchItemsByName(String name, int page, int size) {
        return itemRepository.findByNameContainingIgnoreCase(name, PageRequest.of(page, size));
    }

    // Update an item
    public Item updateItem(Long id, Item item) {
        Item existingItem = getItemById(id);
        existingItem.setName(item.getName());
        existingItem.setDescription(item.getDescription());
        existingItem.setPrice(item.getPrice());
        existingItem.setStock(item.getStock());
        return itemRepository.save(existingItem);
    }

    // Delete an item
    public void deleteItem(Long id) {
        Item item = itemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item not found"));
    
        item.setDeleted(true); // Mark as deleted instead of removing
        itemRepository.save(item);
    }
}