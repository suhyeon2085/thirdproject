package org.zerock.domain;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class ReportDTO {
    private Integer id;           // AUTO_INCREMENT PK
    private String  name;         // 신고자 이름
    private String  phone;        // 전화번호
    private String  location;     // 위치 예) "서울특별시 강남구"
    private String  crimeType;    // 범죄 유형
    private String  content;      // 상세 신고내용
    private String  filePath;     // 첨부파일 실제 경로
    private LocalDateTime createdAt; // 작성 일시
}