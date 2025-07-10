package org.zerock.controller;

import java.io.File;
import java.io.IOException;
import java.time.ZoneId;
import java.util.Date;
import java.util.Map;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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
    @ResponseBody               // JSON 직렬화
    public Map<String, Object> submitReport(@ModelAttribute ReportDTO dto,
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

        Integer id = reportService.submitReport(dto); // ★ PK 받기
        return Map.of("id", id); // { "id": 123 }           // 상세 페이지로 이동
    }
    
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> updateReport(@ModelAttribute ReportDTO dto,
                                            @RequestParam(value = "files", required = false) MultipartFile[] files,
                                            @RequestParam(value = "removedFiles", required = false) String removedFiles) throws Exception {
    	
        System.out.println("수정 id: " + dto.getId());
        System.out.println("삭제할 파일들: " + removedFiles);
    	
    	
        String uploadDir = "\\\\Des67\\02-공유폴더\\20250223KDT반\\LiveAir\\image\\";
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        // 1) 삭제할 파일 처리
        if (removedFiles != null && !removedFiles.isBlank()) {
            for (String uuid : removedFiles.split(";")) {
                File file = new File(uploadDir, uuid);
                if (file.exists()) file.delete();
            }
        }

        // 2) 새 파일 처리
        StringBuilder storedNames = new StringBuilder();
        StringBuilder origNames = new StringBuilder();
        StringBuilder filePaths = new StringBuilder();

        if (files != null) {
            for (MultipartFile file : files) {
                if (file.isEmpty()) continue;

                String originalFilename = file.getOriginalFilename();
                String ext = "";
                int dotIdx = originalFilename.lastIndexOf('.');
                if (dotIdx != -1) ext = originalFilename.substring(dotIdx);

                String storedFilename = java.util.UUID.randomUUID() + ext;
                File dest = new File(uploadDir, storedFilename);
                file.transferTo(dest);

                storedNames.append(storedFilename).append(';');
                origNames.append(originalFilename).append(';');
                filePaths.append(dest.getAbsolutePath()).append(';');
            }
        }

        // 기존 파일과 합칠 수도 있음 (선택사항)

        // 마지막 ; 제거
        if (storedNames.length() > 0) storedNames.setLength(storedNames.length() - 1);
        if (origNames.length() > 0) origNames.setLength(origNames.length() - 1);
        if (filePaths.length() > 0) filePaths.setLength(filePaths.length() - 1);

        dto.setStoredName(storedNames.toString());
        dto.setOrigName(origNames.toString());
        dto.setFilePath(filePaths.toString());

        // 3) DB 업데이트
        reportService.updateReport(dto);

        // 4) 응답
        return Map.of("id", dto.getId());  // 수정 후 view로 이동하기 위한 ID 반환
    }
    
    
    
    @GetMapping("/view")
    public String view(@RequestParam("id") Integer id, Model model) {

        // 1) 상세 가져오기
        ReportDTO report = reportService.getReport(id);
        model.addAttribute("report", report);   // 기존 그대로

        // 2) LocalDateTime → Date 변환해서 별도 전달
        if (report.getCreatedAt() != null) {
            Date createdDate = Date.from(
                    report.getCreatedAt()
                       .atZone(ZoneId.systemDefault())
                       .toInstant());
            model.addAttribute("createdDate", createdDate);
        }

        return "view";
    }
    

    
    @GetMapping("/list")
    public String redirecListGet() {
        
        return "/list";
    }
    
    @PostMapping("/modify")
    public String modifyPost(@RequestParam("id") int id, Model model) {
        ReportDTO report = reportService.getReport(id); // DB 조회
        model.addAttribute("report", report);
        return "modify";
    }
    
    @GetMapping("/login")
    public String redirecLoginGet() {
        
        return "/login";
    }
    
    @GetMapping("/mainU")
    public String redirecMainUGet() {
        
        return "/mainU";
    }
    
    @GetMapping("/download")
    @ResponseBody
    public ResponseEntity<Resource> download(@RequestParam String uuid,
                                             @RequestParam String name) throws IOException {

        // 업로드된 실제 폴더 (수정 금지)
        String UPLOAD_DIR = "\\\\Des67\\02-공유폴더\\20250223KDT반\\LiveAir\\image\\";

        // 1) 파일 존재 확인
        Path filePath = Paths.get(UPLOAD_DIR, uuid);
        if (!Files.exists(filePath)) {
            return ResponseEntity.notFound().build();
        }

        // 2) 리소스 생성
        Resource resource = new UrlResource(filePath.toUri());

        // 3) 브라우저 파일명 인코딩 (한글 깨짐 방지)
        String encodedName = URLEncoder.encode(name, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        // 4) 응답
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)            // 강제 다운로드
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename*=UTF-8''" + encodedName)       // 저장될 이름
                .body(resource);
    }
    
    @PostMapping("/delete")
    public String delete(@RequestParam("id") Integer id,
                         RedirectAttributes rttr) throws IOException {

        // 1) 먼저 기존 글·파일 정보 가져오기
        ReportDTO dto = reportService.getReport(id);
        if (dto == null) {
            rttr.addFlashAttribute("msg", "존재하지 않는 글입니다.");
            return "redirect:/list";
        }

        // 2) DB 삭제
        int cnt = reportService.delete(id);   // ★ ReportService에 delete(id) 하나 만들거나 Mapper 직접 호출

        // 3) 실제 파일 삭제 (DB 삭제 성공했을 때만)
        if (cnt > 0 && dto.getStoredName() != null) {
            String uploadDir = "\\\\Des67\\02-공유폴더\\20250223KDT반\\LiveAir\\image\\";
            for (String uuid : dto.getStoredName().split(";")) {
                File f = new File(uploadDir, uuid);
                if (f.exists()) f.delete();
            }
            rttr.addFlashAttribute("msg", "삭제 완료!");
        } else {
            rttr.addFlashAttribute("msg", "삭제 실패!");
        }

        return "redirect:/list";
    }
}
