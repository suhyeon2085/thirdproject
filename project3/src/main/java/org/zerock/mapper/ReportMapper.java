package org.zerock.mapper;



import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.zerock.domain.ReportDTO;

@Mapper      // 또는 @Repository + @MapperScan 사용
public interface ReportMapper {

    // INSERT
    int insertReport(ReportDTO dto);
    
    int updateReport(ReportDTO dto);
    
    int delete(int id);  // ReportMapper 인터페이스

    // 이름+전화번호로 개인 조회
    List<ReportDTO> findByNameAndPhone(@Param("name") String name, @Param("phone") String phone);


//    // 관리자: 전체 목록 + 동적 필터
//    List<ReportDTO> findByFilter(String city, String district, String crimeType);

    // id로 단건 조회
    ReportDTO findById(Integer id);

//    boolean existsByNamePhonePassword(@Param("name") String name, 
//            @Param("phone") String phone,
//            @Param("password") String password);
    
    List<ReportDTO> findByFilter(Map<String, String> paramMap);

    List<ReportDTO> findByFilterWithPaging(Map<String, Object> params);
    
    int getTotalCount(Map<String, Object> params);
    
    List<ReportDTO> findByFilterWithStates(Map<String, Object> params);
    int getTotalCountWithStates(Map<String, Object> params);
    
//    void updateState(@Param("id") int id, @Param("state") String state);
    
    void updateState(@Param("id") int id, @Param("state") String state, @Param("station") String station);
    
    void updateStateAndStation(@Param("id") int id,
            @Param("state") String state,
            @Param("station") String station);
    
    int updateSupportStation(@Param("id") int id,
            @Param("supportStation") String supportStation,
            @Param("state") String state);
    
    
    
    
}
