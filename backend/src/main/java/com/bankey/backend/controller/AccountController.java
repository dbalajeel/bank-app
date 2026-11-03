package com.bankey.backend.controller;

import com.bankey.backend.dto.AccountResponse;
import com.bankey.backend.dto.NicknameRequest;
import com.bankey.backend.service.AccountService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
// answers with json
@RestController
@RequestMapping("/accounts")
public class AccountController {

    private final AccountService accountService;

    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }
    // get accounts
    @GetMapping
    // GET /accounts: list the logged-in customer's accounts
    // @AuthenticationPrincipal = take the customer number from the badge (from the token), not from the app
    public List<AccountResponse> getAccounts(@AuthenticationPrincipal Integer customerNumber) {
         // Ask the service for this customer's accounts, sent back as a JSON list
        return accountService.getAccounts(customerNumber);
    }

    // GET /accounts/{accountNumber}: one account's details
    @GetMapping("/{accountNumber}")
    public AccountResponse getAccount(@PathVariable String accountNumber,// account number from the URL
                                      @AuthenticationPrincipal Integer customerNumber) { // customer number from the token
        // check it is mine
        return accountService.getAccount(accountNumber, customerNumber);
    }

    //change nickname 
    @PatchMapping("/{accountNumber}/nickname")
    public AccountResponse updateNickname(@PathVariable String accountNumber, // account number from the URL
                                          @Valid @RequestBody NicknameRequest request, // JSON body {"nickname": "..."}, checked (max 255)
                                          @AuthenticationPrincipal Integer customerNumber ) {  // customer number from the token
           // Save the new nickname (only if the account is theirs) and send back the updated account                                  
        return accountService.updateNickname(accountNumber, customerNumber, request.nickname());
    }
}
