package com.bankey.backend.repository;

import com.bankey.backend.model.Customer;
// brings in springs data's ready made repository
import org.springframework.data.jpa.repository.JpaRepository;

// Ready-made database methods for Customer, whose ID is an Integer. Spring writes the code.
public interface CustomerRepository extends JpaRepository<Customer, Integer> {
}

//Ready-made methods you get for free