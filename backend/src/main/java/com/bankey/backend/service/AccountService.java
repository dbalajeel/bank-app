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

    public AccountService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    public List<AccountResponse> getAccounts(Integer customerNumber) {
        return accountRepository.findByCustomerNumber(customerNumber)
                .stream()
                .map(AccountResponse::from)
                .toList();
    }

    public AccountResponse getAccount(String accountNumber, Integer customerNumber) {
        Account account = findOwnedAccount(accountNumber, customerNumber);
        return AccountResponse.from(account);
    }

    public AccountResponse updateNickname(String accountNumber, Integer customerNumber, String nickname) {
        Account account = findOwnedAccount(accountNumber, customerNumber);

        String cleaned = (nickname == null) ? "" : nickname.trim();
        if (cleaned.length() > 255) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nickname must be 255 characters or less");
        }

        account.setNickname(cleaned.isEmpty() ? null : cleaned);
        Account saved = accountRepository.save(account);
        return AccountResponse.from(saved);
    }

    private Account findOwnedAccount(String accountNumber, Integer customerNumber) {
        return accountRepository.findByAccountNumberAndCustomerNumber(accountNumber, customerNumber)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Account not found"));
    }
}
