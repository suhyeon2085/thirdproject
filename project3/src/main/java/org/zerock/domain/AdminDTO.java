package org.zerock.domain;

import lombok.Data;

@Data
public class AdminDTO {
    private String  username; // 관리자 ID
    private String  password; // 관리자 password   
    // BCrypt 해시 저장
    private String role;
}
