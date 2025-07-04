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
                               @RequestParam("file") MultipartFile file,
                               HttpServletRequest request) throws Exception {
    	System.out.println("== DTO 확인 ==" + dto);   // ⚡ 콘솔에 찍어 보기

        // 파일 저장 처리
        if (!file.isEmpty()) {
            String uploadDir = request.getServletContext().getRealPath("/uploads/");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String filePath = uploadDir + file.getOriginalFilename();
            file.transferTo(new File(filePath));
            dto.setFilePath("/uploads/" + file.getOriginalFilename());
        }

        reportService.submitReport(dto);
        return "redirect:/report/success";
    }
    
    @GetMapping("/view")
    public String redirectViewGet() {
        // 필요하면 "report/form" 같은 신고 작성 페이지로 변경
        return "/view";
    }
    
}
