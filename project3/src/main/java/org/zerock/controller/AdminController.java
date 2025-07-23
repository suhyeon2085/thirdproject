package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.domain.ReportDTO;
import org.zerock.mapper.ReportMapper;
import org.zerock.service.ReportService;

@Controller
@RequestMapping("/admin/*")
public class AdminController {
	@Autowired
    private ReportService reportService;
	@Autowired
	private ReportMapper reportMapper;
	
	@GetMapping("/mainA")
    public String redirectAdminMainGet() {
        
        return "/admin/mainA";
    }
	
	@GetMapping("/listA")
    public String redirectAdminListGet() {
        
        return "/admin/listA";
    }
	
	@GetMapping("/admin/reportList")
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
	
//	@GetMapping("/viewA")
//    public String redirectAdminViewGet() {
//        
//        return "/admin/viewA";
//    }
//	
    @GetMapping("/viewA")
    public String view(@RequestParam("id") Integer id, Model model) {

        // 1) 상세 가져오기
        ReportDTO report = reportService.getReport(id);
        model.addAttribute("report", report);   // 기존 그대로

//        // 2) LocalDateTime → Date 변환해서 별도 전달
//        if (report.getCreatedAt() != null) {
//            Date createdDate = Date.from(
//                    report.getCreatedAt()
//                       .atZone(ZoneId.systemDefault())
//                       .toInstant());
//            model.addAttribute("createdDate", createdDate);
//        }

        return "admin/viewA";
    }
    
  @PostMapping("/admin/updateState")
	@ResponseBody
	public String updateState(
			@RequestParam("id") int id, 
			@RequestParam("state") String state,
			@RequestParam(value = "station", required = false) String station
			) {
	    try {
	    	reportService.updateState(id, state, station);
	        return "success";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "fail";
	    }
	}
    
//    @PostMapping("/admin/updateState")
//    @ResponseBody
//    public String updateState(
//    		@RequestParam("id") int id,
//            @RequestParam("state") String state,
//            @RequestParam(value = "station", required = false) String station) {
//        try {
//            reportService.updateStateAndStation(id, state, station); // 서비스 호출
//            return "success";
//        } catch (Exception e) {
//            e.printStackTrace();
//            return "fail";
//        }
//    }
    

	
	/*@PostMapping("/updateState")
	@ResponseBody
	public String updateState(@RequestParam String id, @RequestParam String state) {
		reportService.updateState(id, state);
	    return "success";
	}*/
}
