//login brain
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
//create one and give it to whoever nees it 
@Service
public class AuthService {
// the 3 tools it needs:
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
        //i gave you the customer number. find the customer ID
        Optional<Customer> found = customerRepository.findById(request.customerNumber());
        // if no customer was found, OR the password does NOT match the hash -> 401
        if (found.isEmpty() || !passwordEncoder.matches(request.password(), found.get().getPasswordHash())) {
            //throw -> stop and report an errror (401)
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid customer number or password");
        }

        // Make a JWT token with this customer's number
        String token = jwtService.createToken(found.get().getCustomerNumber());
        // Send the token back to the app 
        return new LoginResponse(token);
    }
}
