package org.zerock.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.domain.ReportDTO;
import org.zerock.service.ReportService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller 
public class HomeController {
	
	@Autowired
    private ReportService reportService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		
		return "temp/usermain";
	}
	
	@RequestMapping(value = "/admin/administrator")
	public String admin()
	{
		return "/admin/administrator";
	}
	
	@GetMapping(value = "/temp/list")
	@ResponseBody
	public Map<String, Object> callList(
			@RequestParam(required = false) String si,
	        @RequestParam(required = false) String gu,
	        @RequestParam(required = false) String crimeType,
	        @RequestParam(defaultValue = "1") int page,
	        @RequestParam(defaultValue = "5") int size)
	{
	    int offset = (page - 1) * size;

	    List<ReportDTO> reportList = reportService.findByFilterWithPaging(si, gu, crimeType, offset, size);
	    int totalCount = reportService.getTotalCount(si, gu, crimeType);

	    Map<String, Object> result = new HashMap<>();
	    result.put("data", reportList);
	    result.put("totalCount", totalCount);
	    return result;
	}
}
