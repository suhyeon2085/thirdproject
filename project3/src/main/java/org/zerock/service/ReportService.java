package org.zerock.service;

import java.io.File;
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
    
    private static final String UPLOAD_DIR =
            "\\\\Des67\\02-공유폴더\\20250223KDT반\\LiveAir\\image\\";
    
    
    
    
    
    

    public List<ReportDTO> getMyReports(String name, String phone) {
        return reportMapper.findByNameAndPhone(name, phone);
    }

    public List<ReportDTO> getReportsForAdmin(String city, String district, String crimeType) {
        return reportMapper.findByFilter(city, district, crimeType);
    }

    public ReportDTO getReport(Integer id) {
        return reportMapper.findById(id);
    }



    /** 글 1건 삭제 : 삭제된 행 수(0 또는 1) 반환 */
    public int delete(Integer id) {

        // (1) 먼저 첨부파일 정보를 가져옴
        ReportDTO dto = reportMapper.findById(id);
        if (dto == null) return 0;           // 이미 없는 글

        // (2) DB DELETE 실행
        int cnt = reportMapper.delete(id);   // <delete id="delete"> 호출

        // (3) DB 삭제가 성공하면 실제 파일도 제거
        if (cnt > 0 && dto.getStoredName() != null && !dto.getStoredName().isEmpty()) {
            for (String uuid : dto.getStoredName().split(";")) {
                File file = new File(UPLOAD_DIR, uuid);
                if (file.exists()) file.delete();
            }
        }
        return cnt;          // 1 또는 0
    }
}
