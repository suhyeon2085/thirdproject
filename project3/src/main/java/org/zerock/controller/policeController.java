package org.zerock.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.domain.ReportDTO;
import org.zerock.service.ReportService;

@Controller
@RequestMapping("/police/*")
public class policeController {
	@Autowired
    private ReportService reportService;
	
	@GetMapping("/listP")
    public String redirectAdminListGet() {
        
        return "/police/listP";
    }
	
	@GetMapping("/viewP")
    public String view(@RequestParam("id") Integer id, Model model) {

        // 1) 상세 가져오기
        ReportDTO report = reportService.getReport(id);
        model.addAttribute("report", report);   // 기존 그대로

        return "police/viewP";
    }
	
	@GetMapping("/reportList")
    @ResponseBody
    public List<ReportDTO> findByFilter(
            @RequestParam(required = false) String si,
            @RequestParam(required = false) String gu,
            @RequestParam(required = false) String crimeType) {
        
        return reportService.findByFilter(si, gu, crimeType);
    }
}
