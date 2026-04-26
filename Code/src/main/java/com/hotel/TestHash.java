package com.hotel;

import com.hotel.util.PasswordUtil;

public class TestHash {
    public static void main(String[] args) {
        String existingHash = "$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgNoT8E9.8C/79J6kIe9zVv8sXkO";
        System.out.println("Does 123456 match existing hash? " + PasswordUtil.verify("123456", existingHash));
        
        String newHash = PasswordUtil.hash("123456");
        System.out.println("New hash for 123456: " + newHash);
    }
}
