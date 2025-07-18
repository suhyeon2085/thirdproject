package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	
	@GetMapping("/police/reportList")
	@ResponseBody
	public Map<String, Object> getReportList(
	        @RequestParam(required = false) String si,
	        @RequestParam(required = false) String gu,
	        @RequestParam(required = false) String crimeType,
	        @RequestParam(defaultValue = "1") int page,
	        @RequestParam(defaultValue = "10") int size) {

	    int offset = (page - 1) * size;

	    List<ReportDTO> reportList = reportService.findByFilterWithPaging(si, gu, crimeType, offset, size);
	    int totalCount = reportService.getTotalCount(si, gu, crimeType);

	    Map<String, Object> result = new HashMap<>();
	    result.put("data", reportList);
	    result.put("totalCount", totalCount);
	    return result;
	}
}
