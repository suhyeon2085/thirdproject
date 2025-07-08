package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.ReportDTO;
import org.zerock.mapper.ReportMapper;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
public class ReportService {

	@Autowired
    private ReportMapper reportMapper;

    public Integer submitReport(ReportDTO dto) {
    	int row = reportMapper.insertReport(dto); // ② 성공 행수 체크
        if (row == 0) throw new RuntimeException("Insert 실패");
        return dto.getId();
    }
    
    

    public List<ReportDTO> getMyReports(String name, String phone) {
        return reportMapper.findByNameAndPhone(name, phone);
    }

    public List<ReportDTO> getReportsForAdmin(String city, String district, String crimeType) {
        return reportMapper.findByFilter(city, district, crimeType);
    }

    public ReportDTO getReport(Integer id) {
        return reportMapper.findById(id);
    }
}
