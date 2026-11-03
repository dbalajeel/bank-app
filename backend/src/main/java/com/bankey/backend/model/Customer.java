package com.bankey.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.Check;

//This class is a database table.
@Entity
//The table’s name in SQLite is customers
@Table(name = "customers")
@Check(constraints = "customer_number BETWEEN 100000000 AND 999999999")
public class Customer {

    //The primary key: the unique ID of each customer (no two the same)
    @Id
    //Column name in the table
    @Column(name = "customer_number")
    private Integer customerNumber;

    @Column(name = "password_hash", nullable = false, length = 100)
    private String passwordHash; //The scrambled password, never the real one

    protected Customer() { //Hidden from the rest of our code, so nobody creates an empty customer by mistake
    }
    //testing customers 
    public Customer(Integer customerNumber, String passwordHash) {
        this.customerNumber = customerNumber;
        this.passwordHash = passwordHash;
    }

    //getters : let other classes read the values (AuthService uses getPasswordHash() to check the password).
    public Integer getCustomerNumber() {
        return customerNumber;
    }

    public String getPasswordHash() {
        return passwordHash;
    }
}
    

