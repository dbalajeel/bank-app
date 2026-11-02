//account brain 
package com.bankey.backend.service;

import com.bankey.backend.dto.AccountResponse;
import com.bankey.backend.model.Account;
import com.bankey.backend.repository.AccountRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class AccountService {

    private final AccountRepository accountRepository;
// tool needed:
    public AccountService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    //gives back a list of the customerNumber cards 
    public List<AccountResponse> getAccounts(Integer customerNumber) {
        // gets all accounts of a customer 
        return accountRepository.findByCustomerNumber(customerNumber)
                // break down the list 
                .stream()
                //turn each account into an accountresponse card
                .map(AccountResponse::from)
                .toList();
    }

    public AccountResponse getAccount(String accountNumber, Integer customerNumber) {
        Account account = findOwnedAccount(accountNumber, customerNumber);
        return AccountResponse.from(account);
    }

    public AccountResponse updateNickname(String accountNumber, Integer customerNumber, String nickname) {
        Account account = findOwnedAccount(accountNumber, customerNumber);
        //trim remove spaces from the start and the end 
        String cleaned = (nickname == null) ? "" : nickname.trim();
        if (cleaned.length() > 255) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nickname must be 255 characters or less");
        }

        account.setNickname(cleaned.isEmpty() ? null : cleaned);
        //write it to the database 
        Account saved = accountRepository.save(account);
        return AccountResponse.from(saved);
    }

    private Account findOwnedAccount(String accountNumber, Integer customerNumber) {
        return accountRepository.findByAccountNumberAndCustomerNumber(accountNumber, customerNumber)
        //give me the answer or throw an error 
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Account not found"));
    }
}
