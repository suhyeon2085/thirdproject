package org.zerock.controller;

import java.io.File;


import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.ReportDTO;
import org.zerock.service.ReportService;

@Controller
public class ReportController {

    @Autowired
    private ReportService reportService;
    
    @GetMapping("/receipt")
    public String redirectReceiptGet() {
        // 필요하면 "report/form" 같은 신고 작성 페이지로 변경
        return "/receipt";
    }

    @PostMapping("/receipt")
    public String submitReport(@ModelAttribute ReportDTO dto,
                               @RequestParam("files") MultipartFile[] files) throws Exception {

        String uploadDir = "\\\\Des67\\02-공유폴더\\20250223KDT반\\LiveAir\\image\\";
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        StringBuilder storedNames = new StringBuilder();  // UUID 저장명
        StringBuilder origNames   = new StringBuilder();  // 원본 이름
        StringBuilder filePaths   = new StringBuilder();  // 경로+UUID (옵션)

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;

            String originalFilename = file.getOriginalFilename();
            String ext = "";
            int dotIdx = originalFilename.lastIndexOf('.');
            if (dotIdx != -1) ext = originalFilename.substring(dotIdx);

            String storedFilename = java.util.UUID.randomUUID() + ext; // UUID.jpg
            File dest = new File(uploadDir, storedFilename);
            file.transferTo(dest);

            storedNames.append(storedFilename).append(';');          // UUID.jpg;
            origNames.append(originalFilename).append(';');          // 사진.jpg;
            filePaths.append(dest.getAbsolutePath()).append(';');    // \\Des67\...\UUID.jpg;

            System.out.println("업로드 완료 → " + originalFilename
                             + " ▶ 저장명 " + storedFilename);
        }

        // 마지막 ; 제거
        if (storedNames.length() > 0) storedNames.setLength(storedNames.length() - 1);
        if (origNames.length()   > 0) origNames.setLength(origNames.length()   - 1);
        if (filePaths.length()   > 0) filePaths.setLength(filePaths.length()   - 1);

        // DTO 세팅
        dto.setStoredName(storedNames.toString()); // UUID 목록
        dto.setOrigName(origNames.toString());     // 원본 이름 목록
        dto.setFilePath(filePaths.toString());     // 경로+UUID 목록  ← 추가!!

        reportService.submitReport(dto);
        return "redirect:/view";
    }
    
    @GetMapping("/view")
    public String redirectViewGet() {
        
        return "/view";
    }
    
    @GetMapping("/list")
    public String redirecListGet() {
        
        return "/list";
    }
    
    @GetMapping("/modify")
    public String redirecModifyGet() {
        
        return "/modify";
    }
    
    @GetMapping("/login")
    public String redirecLoginGet() {
        
        return "/login";
    }
}
