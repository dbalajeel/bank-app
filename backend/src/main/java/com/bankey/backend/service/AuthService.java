package com.bankey.backend.service;

import com.bankey.backend.dto.LoginRequest;
import com.bankey.backend.dto.LoginResponse;
import com.bankey.backend.model.Customer;
import com.bankey.backend.repository.CustomerRepository;
import com.bankey.backend.security.JwtService;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

@Service
public class AuthService {

    private final CustomerRepository customerRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(CustomerRepository customerRepository,
                       PasswordEncoder passwordEncoder,
                       JwtService jwtService) {
        this.customerRepository = customerRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public LoginResponse login(LoginRequest request) {
        Optional<Customer> found = customerRepository.findById(request.customerNumber());

        if (found.isEmpty() || !passwordEncoder.matches(request.password(), found.get().getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid customer number or password");
        }

        String token = jwtService.createToken(found.get().getCustomerNumber());
        return new LoginResponse(token);
    }
}
