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
    //returns a list of cards (all accounts)
    public List<AccountResponse> getAccounts(@AuthenticationPrincipal Integer customerNumber) {
        return accountService.getAccounts(customerNumber);
    }
    //take this value from the URL address (one account) account from URL number from token
    @GetMapping("/{accountNumber}")
    public AccountResponse getAccount(@PathVariable String accountNumber,
                                      @AuthenticationPrincipal Integer customerNumber) {
                                        //check it is mine
        return accountService.getAccount(accountNumber, customerNumber);
    }

    //change nickname 
    @PatchMapping("/{accountNumber}/nickname")
    public AccountResponse updateNickname(@PathVariable String accountNumber,
                                          @Valid @RequestBody NicknameRequest request,
                                          @AuthenticationPrincipal Integer customerNumber) {
        return accountService.updateNickname(accountNumber, customerNumber, request.nickname());
    }
}
