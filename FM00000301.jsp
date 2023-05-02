<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 사직원 -->
<!-- EZSP_CHONGMU_INSERT, PR_PPE_INSERT_PPE0351 -->
	
<style>
	img.ui-datepicker-trigger {
		margin-left: 4px;
	}
	
	.secondLine {
		margin-left: 9px;
	}
</style>

<script>
var JIKGEUB_NAME = "";
	/* datepicker */
	$(function() {
		$("#date").datepicker({
	           dateFormat : 'yy-mm-dd',
	           showOn : 'both',
	           buttonImage : '/images/common/ico_date_drop.gif',
	           buttonImageOnly : true,
	    }).datepicker("setDate", new Date())
	    
		$.ajax({
			url: '/interwork/selectUserDetailInfo.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'user_emp_id': HGW_APPR_BANK.loginVO.user_emp_id
			}
		}).success(function(response) {
			console.log('response', response);
		
			JIKGEUB_NAME = response.rows[0].JIKGEUB_CODE_NAME;
			$('#jobdept').val(response.rows[0].GUNMUJI_NAME);
			$('#UserTitle').text(response.rows[0].JIKJONG_CODE_NAME + response.rows[0].JIKGEUB_CODE_NAME);
			
		});
	});
	
	/* 사직사유 기타 선택 시 입력창 */
	$(document).ready(function() {
        $('#sayou').change(function() {
            var result = $('#sayou option:selected').val();
            if (result == 'reason6') {
                $('#sayoutxt').show();
            } else {
                $('#sayoutxt').hide();
            }
        });
    });
	

		
	$('#FM00000301_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000301').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var date = $('#date').val().split("-");
		var legacydata = [];
		
		var sayou = "";
		
		if($('#sayou option:selected').val() == "reason1"){
			sayou = "과다한업무량";
		} else if ($('#sayou option:selected').val() == "reason2") {
			sayou = "담당업무의 부적합(경력사항과부적합 등)";
		} else if ($('#sayou option:selected').val() == "reason3") {
			sayou = "비전 제시가 미흡";
		} else if ($('#sayou option:selected').val() == "reason4") {
			sayou = "상사의 부당한 업무 지시, 상사와의 갈등";
		} else if ($('#sayou option:selected').val() == "reason5") {
			sayou = "적은연봉";
		} else if ($('#sayou option:selected').val() == "reason6") {
			sayou = "기타";
		}
		
		// 1. 데이터 저장
		legacydata.push({
			I_USER_ID      	 : HGW_APPR_BANK.loginVO.user_emp_id,
			I_SABUN        	 : HGW_APPR_BANK.loginVO.user_emp_id,
			I_BALRYENG_YMD 	 : $('#date').val(),
			I_BALRYENG_TO  	 : $('#date').val(),
			I_BALRYENG_CODE  : '9',
			I_BIGO         	 : sayou, //비고
			I_IF_DOCID     	 : '', //문서번호
			O_FLAG 			 : ''  //0이면 성공 아니면 에러
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if ($('#jobdept').val() == '') {
			alert('근무지를 입력해 주세요.');
			$('#jobdept').focus();
			return false;
		}
		if ($('#sayou option:selected').val() == 'reason0') {
			alert('사직사유를 선택해 주세요.');
			$('#sayou').focus();
			return false;
		}
		if ($('#sayou option:selected').val() == 'reason6' && $("#sayoutxt").val() == "") {
			alert('사직사유가 기타인 경우 사유를 입력해 주세요.');
			$("#sayoutxt").focus();
			return false;
		};
		
		// 3. validation check 후 기안기에 내용 입력
		// 소속, 부서 : v_department
		// 근무지 : jobdept
		// 직명 : v_position
		// 성명 : v_draftername
		// 사번 : v_userid
		// 사직사유 : sayoutxt
		// 연 : year2, 월 : month2, 일 : day2
		// 작성일자, 작성일 : draftdate
		// 직급 : jikgub, 성명 : draftername
	
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
				
		// 인적사항
		_$hwpObj.insertSignData('v_department', HGW_APPR_BANK.loginVO.dept_nm); // 소속
		_$hwpObj.insertSignData('v_position', $('#UserTitle').text()); // 직명
		_$hwpObj.insertSignData('jikgub', JIKGEUB_NAME); // 직급
		_$hwpObj.insertSignData('v_draftername', HGW_APPR_BANK.loginVO.user_nm); // 성명
		_$hwpObj.insertSignData('draftername', HGW_APPR_BANK.loginVO.user_nm); // 성명
		_$hwpObj.insertSignData('v_userid', HGW_APPR_BANK.loginVO.user_emp_id); // 사번
	
		// 근무지
		_$hwpObj.insertSignData('jobdept', $('#jobdept').val());
		
		// 사직사유
		_$hwpObj.insertSignData('sayoutxt', $('#sayou option:selected').text()); // 사직사유 윗장, 아랫장
				
		if($('#sayou option:selected').val() == 'reason6') {
			_$hwpObj.insertSignData('sayoutxt', $('#sayoutxt').val());} // 사직사유 기타
		
		// 사직일
		_$hwpObj.insertSignData('year2', date[0]); // 연
		_$hwpObj.insertSignData('month2', date[1]); // 월
		_$hwpObj.insertSignData('day2', date[2]); // 일
		
		// 작성일
		_$hwpObj.insertSignData('draftdate', new Date().hgwDateFormat('yyyy년 MM월 dd일')); // 윗장
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일')); // 아랫장
	
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000301_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<form id="FORM_FM00000301">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr>
	            <th>소속<input type="hidden" id="DepartCD" /></th>
	            <td colspan="2" id="DepartNM">${loginVO.dept_nm}</td>
	            <th>근무지</th>
	            <td colspan="2"><input id="jobdept" class="work-loc" type="text" style="width: 200px; height:25px;"></td>
	        </tr>
	       
	        <tr>
	            <th>직명</th>
	            <td colspan="5" id="UserTitle"></td>
	        </tr>
	
	        <tr>
	            <th>성명</th>
	            <td colspan="2" id="UserNM">${loginVO.user_nm}</td>
	            <th>사번</th>
	            <td colspan="2" id="UserID">${loginVO.user_emp_id}</td>
	        </tr>
		          
	        <tr>
	            <th>사직사유</th>
	            <td colspan="5">
	                <select id="sayou" name="selectBox" style="height:25px;">
	                    <option value="reason0" selected="selected">선택하세요</option>								
	                    <option value="reason1">과다한 업무량</option>								
	                    <option value="reason2">담당업무의 부적합(경력사항과 부적합 등)</option>								
	                    <option value="reason3">비전 제시가 미흡</option>								
	                    <option value="reason4">상사의 부당한 업무 지시, 상사와의 갈등</option>								
	                    <option value="reason5">적은 연봉</option>								
	                    <option value="reason6">기타</option>							
	                </select>
	                    <input class="etc-reason" id="sayoutxt" type="text" style="width: 250px; height:25px; display:none;">
	            </td>
	        </tr>
	       
	        <tr>
	            <td colspan="6" id="Td2">
	                <span>* 사직일은 최종근무일(휴가일포함)로 작성<br></span>
	                <span class="secondLine">사직예정일 이전 휴가(연차 등)를 사용하는 경우에는 본인의 잔여휴가일수 확인(내선 : 7136)후 진행하기 바랍니다.</span>
	            </td>
	        </tr>
	       
	        <tr>
	            <th>사직일</th>
	            <td colspan="5">
	                <input type="text" name="date" id="date" title="선택일" style="width: 90px; height:25px;" readonly/>
	            </td>
	        </tr>
	          
	       	<tr>
	           <td colspan="6" style="border-bottom:none;" id="Td1">
	                <span>* 퇴직금 지급 안내 (대상 : 1년 이상 근무자)<br></span>
	                <span class="secondLine">「근로자퇴직급여 보장법」 제9조 제2항에 따라 <b><u>퇴직금 지급을 위한 “개인형 퇴직연금(IRP)” 계좌 사본을 총무팀에 제출</u></b>하여 주시기 바랍니다. (내선 : 7086)</span>
	            </td>
	     	</tr>
	
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000301_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000301_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>