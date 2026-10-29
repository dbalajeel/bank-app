package com.bankey.backend.config;

import com.bankey.backend.model.Account;
import com.bankey.backend.model.Customer;
import com.bankey.backend.repository.AccountRepository;
import com.bankey.backend.repository.CustomerRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements CommandLineRunner {

    private final CustomerRepository customerRepository;
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;

    public DataSeeder(CustomerRepository customerRepository,
                      AccountRepository accountRepository,
                      PasswordEncoder passwordEncoder) {
        this.customerRepository = customerRepository;
        this.accountRepository = accountRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        if (customerRepository.count() > 0) {
            return;
        }

        customerRepository.save(new Customer(123456789, passwordEncoder.encode("Password123")));
        customerRepository.save(new Customer(987654321, passwordEncoder.encode("Secret456")));

        accountRepository.save(new Account("100000001", 123456789, 1250.500f, "Salary"));
        accountRepository.save(new Account("100000002", 123456789, 300.750f, null));
        accountRepository.save(new Account("200000001", 987654321, 5000.000f, "Savings"));
    }
}
