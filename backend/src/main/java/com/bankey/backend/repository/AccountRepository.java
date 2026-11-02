package com.bankey.backend.repository;

import com.bankey.backend.model.Account;
// brings in springs data's ready made repository
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
// a box that may or may not contain something
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, String> {

    List<Account> findByCustomerNumber(Integer customerNumber);

    Optional<Account> findByAccountNumberAndCustomerNumber(String accountNumber, Integer customerNumber);
}
