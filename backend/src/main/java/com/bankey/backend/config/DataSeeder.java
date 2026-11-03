package com.bankey.backend.config;

import com.bankey.backend.model.Account;
import com.bankey.backend.model.Customer;
import com.bankey.backend.repository.AccountRepository;
import com.bankey.backend.repository.CustomerRepository;

// run this command right after the server starts
import org.springframework.boot.CommandLineRunner;

// the password hasher 
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

//Spring creates this class automatically when the server starts.
@Component
// CommandLineRunner = Spring calls run() once, right after the server starts.
public class DataSeeder implements CommandLineRunner {
// The tools we need: save customers, save accounts, scramble passwords
    private final CustomerRepository customerRepository;
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;

    // Constructor: Spring gives us the 3 tools automatically (dependency injection)
    public DataSeeder(CustomerRepository customerRepository,
                      AccountRepository accountRepository,
                      PasswordEncoder passwordEncoder) {
        this.customerRepository = customerRepository;
        this.accountRepository = accountRepository;
        this.passwordEncoder = passwordEncoder;
    }

// Runs once when the server starts
    @Override
     // Database already has customers? Do nothing (no duplicates on restart)
    public void run(String... args) { //any number of text values, from zero to many.
        if (customerRepository.count() > 0) {
            return;
        }

        // 2 test customers. Passwords are scrambled with BCrypt before saving
        customerRepository.save(new Customer(123456789, passwordEncoder.encode("Password123")));
        customerRepository.save(new Customer(987654321, passwordEncoder.encode("Secret456")));

        // 3 test accounts: (account number, owner's customer number, balance as Float, nickname)
        accountRepository.save(new Account("100000001", 123456789, 1250.500f, "Salary"));
        accountRepository.save(new Account("100000002", 123456789, 300.750f, null));
        accountRepository.save(new Account("200000001", 987654321, 5000.000f, "Savings"));
    }
}
