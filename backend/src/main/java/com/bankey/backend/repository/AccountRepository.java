package com.bankey.backend.repository;

import com.bankey.backend.model.Account;
// brings in springs data's ready made repository
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
// a box that may or may not contain something
import java.util.Optional;


//Ready-made database methods for Account (ID = account number, a String). Spring writes the code.
public interface AccountRepository extends JpaRepository<Account, String> {
// All accounts of one customer. Spring makes: SELECT ... WHERE customer_number = ?
    List<Account> findByCustomerNumber(Integer customerNumber);
// One account ONLY if it belongs to this customer (otherwise empty -> 404).
    Optional<Account> findByAccountNumberAndCustomerNumber(String accountNumber, Integer customerNumber);
}
