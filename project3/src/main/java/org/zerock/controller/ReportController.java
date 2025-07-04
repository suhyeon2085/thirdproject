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
                               @RequestParam("files") MultipartFile[] files,
                               HttpServletRequest request) throws Exception {
        System.out.println("== DTO 확인 ==" + dto);
        
        String uploadDir = request.getServletContext().getRealPath("/uploads/");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        StringBuilder filePaths = new StringBuilder();

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                String originalFilename = file.getOriginalFilename();
                String filePath = uploadDir + originalFilename;
                file.transferTo(new File(filePath));
                filePaths.append("/uploads/").append(originalFilename).append(";");
                System.out.println("업로드 파일: " + originalFilename);
            }
        }

        if (filePaths.length() > 0) {
            // 마지막 세미콜론 제거
            filePaths.setLength(filePaths.length() - 1);
            dto.setFilePath(filePaths.toString());
        } else {
            dto.setFilePath(null);
        }

        reportService.submitReport(dto);
        return "redirect:/view";
    }
    
    @GetMapping("/view")
    public String redirectViewGet() {
        // 필요하면 "report/form" 같은 신고 작성 페이지로 변경
        return "/view";
    }
    
}
