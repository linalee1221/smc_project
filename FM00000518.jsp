<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 관심환자등록신청서 -->
<!-- EZSP_PATIENT_INSERT - PR_INF_INSERT_INF8010 -->
<!-- OCS 연동 완료 -->

<style>
	img.ui-datepicker-trigger {
		margin-left: 5px;
	}
</style>

<script>

	$("#occr_date").datepicker({
	    dateFormat: 'yy-mm-dd',
	    showOn: 'button',
	    buttonImage: '/images/common/ico_date_drop.gif',
	    buttonImageOnly: true,
	}).datepicker("setDate", new Date());
	
	$('#FM00000518_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000518').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var legacydata = [];
		
		// 1. 데이터 저장
		legacydata.push({
			I_USER_ID    : HGW_APPR_BANK.loginVO.user_emp_id,
			I_BUNHO      : $('#p_bunho').val(),
			I_MEMO       : '',
			I_START_DATE : $('#occr_date').val().replace(/-/g, "") //발생일
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if (document.getElementById("p_name").value == "") {
            alert("이름을 입력해 주세요.");
            document.getElementById("p_name").focus();
            return;
        }

        if ($('input[name="psex"]:checked').val() == null) {
            alert("남/여를 선택하세요.");
            return;
        }

        if (document.getElementById("p_bunho").value == "") {
            alert("등록번호를 입력해 주세요.");
            document.getElementById("p_bunho").focus();
            return;
        }

        if (document.getElementById("p_birth").value == "") {
            alert("생년월일을 입력해 주세요.");
            document.getElementById("p_birth").focus();
            return;
        }
        
        if (document.getElementById("occr_date").value == "") {
            alert("발생일을 입력해 주세요.");
            document.getElementById("occr_date").focus();
            return;
        }
		
     	// 3. validation check 후 기안기에 내용 입력
		// 환자인적사항 - 이름 : p_name_sex, 등록번호 : p_bunho, 생년월일 : p_birth
		// 발생일 : pstartdate, 신청일 : pregidate
		// 문제발생내용 : p_memo
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
        
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		_$hwpObj.insertSignData('p_name_sex', $('#p_name').val()); // 이름
		_$hwpObj.insertSignData('p_bunho', $('#p_bunho').val()); // 등록번호
		_$hwpObj.insertSignData('p_birth', $('#p_birth').val()); // 생년월일
		_$hwpObj.insertSignData('pstartdate', $('#occr_date').val()); // 발생일
		_$hwpObj.insertSignData('pregidate', new Date().hgwDateFormat('yyyy-MM-dd')); // 신청일

		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000518_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<form id="FORM_FM00000518">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>
	
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">이름</label></th>
				<td data-hgwtype="public">
					<input type="text" id="p_name" style="width:40%; height:25px;">&nbsp;
					<input type="radio" name="psex" class="input_radio" value="Y">&nbsp;남&nbsp;
					<input type="radio" name="psex" class="input_radio" value="N">&nbsp;여
				</td>
				<th scope="row" class="lln"><label for="htmlEditorLyr_7">등록번호</label></th>
				<td>
					<input type="text" id="p_bunho" style="height:25px;">
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">생년월일</label></th>
				<td data-hgwtype="public">
					<input type="text" id="p_birth" style="height:25px;">
				</td>
				<th class="lln" scope="row"><label for="htmlEditorLyr_1">발생일</label></th>
				<td data-hgwtype="public">
					<div>
						<input id="occr_date" name="occr_date" style="width:40%; height:25px;" type="text" class="form-control" readonly />
					</div>							
				</td>
			</tr>
						
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000518_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000518_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>