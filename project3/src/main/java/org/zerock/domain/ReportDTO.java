package org.zerock.domain;

import java.time.LocalDateTime;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

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
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")

    private Date createdAt; // 작성 일시
    
    
    
    private String storedName; // UUID로 변환된 실제 저장 파일명들
    private String origName;   // 사용자가 올린 원본 이름들   
    
    private double lat;
    private double lon;
    private String myLoc1;
    private String myLoc2;
    
    private String si;  // 시/도
    private String gu;	// 시/군/구
    
    private String locationYn;
    
    private String station;
    private String state;
}