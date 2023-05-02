<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 외부강의·회의등 신고서_감사실 -->
<!-- EZSP_GETLASTLINECN1 - TBENDAPRLINEINFO, 
	 EZSP_GETLASTLINECN1_APR - TBAPRLINEINFO, 
	 EZSP_LECTURE_INSERT - PR_PHC_INSERT_PHC5000 -->
<!-- OCS 연동 안됨 -->

<style>
	/* datepicker 아이콘 input박스에서 조금 떨어뜨림 */
	img.ui-datepicker-trigger {
		margin-left: 5px;
	}
	
	#FORM_FM00000410 {
		min-height: 404px !important;
		max-height: 700px !important;
		overflow-y: auto !important;
		margin-bottom: 10px;
	}
</style>	 

<script>
var gunmuji = "";
	/* datepicker */
	$(function() {
		
		$.ajax({
			url: '/interwork/selectUserDetailInfo.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'user_emp_id': HGW_APPR_BANK.loginVO.user_emp_id
			}
		}).success(function(res) {
			console.log('사용자정보??:: ', res);
			
			gunmuji = res.rows[0].GUNMUJI_NAME;
			
			$('#gunmuji').val(gunmuji);
			
		});
		
		$("#date").datepicker({
			dateFormat : 'yy-mm-dd',
			showOn : 'both',
			buttonImage : '/images/common/ico_date_drop.gif',
			buttonImageOnly : true
		});
	});

	$('#FM00000410_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000410').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var checkNum1 = $('#sigan').val();
		var checkNum2 = $('#amt_hour').val();
		var checkNum3 = $('#amt_tot').val();
		var checkNum4 = $('#amt_silbi').val();
		var date = $('#date').val().split("-");
		var legacydata = [];
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		var Huga = $('input[name="way"]:checked').val();
        if (Huga == "1") {
        	Huga = "개인휴가사용";
        } else if (Huga == "2") {
        	Huga = "공가처리";
        } else if (Huga == "3") {
        	Huga = "출장신청";
        } else if (Huga == "4") {
        	Huga = "근무시간외(휴무일 포함)";
        } else {
        	Huga = "";
        }
        
		// 1. 데이터 저장
		legacydata.push({
			I_SABUN        : HGW_APPR_BANK.loginVO.user_emp_id,
			I_PAY_YN       : '',
			I_TYPE         : $('#lecturetype').val(),
			I_ACT_TYPE     : $('#acttype').val(),
			I_YMD          : $('#date').val().replace(/-/g, ""),
			I_START_TIME   : $('#hour1').val() + $('#min1').val(),
			I_END_TIME     : $('#hour2').val() + $('#min2').val(),
			I_SIGAN        : $('#sigan').val(),
			I_AMT          : $('#amt_tot').val(),
			I_IF_DOCID     : '',
			I_ASK_GIGWAN   : $('#organ').val(),
			I_ASK_DAEPYO   : $('#ceo').val(),
			I_ASK_BUSEO    : $('#damdept').val(),
			I_ASK_TEL      : $('#damtel').val(),
			I_ASK_SAYU     : $('#sayou_2').val(),
			I_JANGSO       : $('#location_2').val(),
			I_HYUGA_CHURI  : Huga,
			I_GIAN_YMD     : '',
			I_KYULJE_YMD   : '',
			I_SINCHUNG_YMD : new Date().hgwDateFormat('yyyyMMdd'),
			I_SILBI        : $('#amt_silbi').val()
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if ($('#gunmuji').val() == '') {
			alert("근무지를 입력해 주세요");
			$('#gunmuji').focus();
			return false;
		}
		if ($('#lecturetype').val() == '') {
			alert("외부강의 회의유형을 입력해 주세요");
			$('#lecturetype').focus();
			return false;
		}
		if ($('#acttype').val() == '') {
			alert("활동유형을 입력해 주세요");
			$('#acttype').focus();
			return false;
		}
		if ($('#organ').val() == '') {
			alert("기관명을 입력해 주세요");
			$('#organ').focus();
			return false;
		}
		if ($('#ceo').val() == '') {
			alert("대표자를 입력해 주세요");
			$('#ceo').focus();
			return false;
		}
		if ($('#damdept').val() == '') {
			alert("담당부서를 입력해 주세요");
			$('#damdept').focus();
			return false;
		}
		if ($('#damtel').val() == '') {
			alert("연락처를 입력해 주세요");
			$('#damtel').focus();
			return false;
		}
		if ($('#sayou_2').val() == '') {
			alert("요청사유를 입력해 주세요");
			$('#sayou_2').focus();
			return false;
		}
		if ($('#location_2').val() == '') {
			alert("장소를 입력해 주세요");
			$('#location_2').focus();
			return false;
		}
		if ($('#date').val() == '') {
			alert('강의날짜를 선택해 주세요.');
			$('#date').focus();
			return false;
		}
		if ($('input[name="way"]:checked').val() == null) {
			alert("복무처리여부를 선택하세요.");
			return false;
		}
		
		if ($('#sigan').val() == '' ) {
			alert("강의시간을 입력해 주세요");
			$('#sigan').focus();
			return false;
		}
		
	 	if ($.isNumeric(checkNum1) == true) {
			_$hwpObj.insertSignData('sigan', $('#sigan').val());
		} else {
			alert("강의시간은 숫자만 입력해 주세요.");
			$('#sigan').focus();
			return;
		}
		
		if ($('#amt_hour').val() == '' ) {
			alert("1시간 대가를 입력해 주세요.");
			$('#amt_hour').focus();
			return false;
		}
		
	 	if ($.isNumeric(checkNum2) == true) {
			_$hwpObj.insertSignData('amt_hour', $('#amt_hour').val());
		} else {
			alert("1시간 대가는 숫자만 입력해 주세요.");
			$('#amt_hour').focus();
			return;
		}
	 	
		if ($('#amt_tot').val() == '' ) {
			alert("사례금을 입력해 주세요.");
			$('#amt_tot').focus();
			return false;
		}
		
		if ($('#amt_tot').val == null || $('#amt_tot').val == '' || $.isNumeric(checkNum3) == true) {
			_$hwpObj.insertSignData('amt_hour', $('#amt_hour').val());
		} else {
	 		alert("사례금은 숫자만 입력해 주세요.");
            document.getElementById("amt_tot").focus();
            return;
	 	} 
	 	if (parseInt(document.getElementById("amt_tot").value) < parseInt(document.getElementById("amt_hour").value) || parseInt(document.getElementById("amt_tot").value) < 10000) {
            alert("사례금을 계산하여 입력해 주세요.\n\n(사례금계산법 = 강의시간×1시간대가)");
            document.getElementById("amt_tot").focus();
            return;
	 	}
	 	
		if ($('#amt_silbi').val() == '' ) {
			alert("[교통비, 숙박비, 식비]를 입력해 주세요.");
			$('#amt_silbi').focus();
			return false;
		}
		
	 	if ($.isNumeric(checkNum4) == true) {
			_$hwpObj.insertSignData('amt_silbi', $('#amt_silbi').val());
		} else {
			alert("[교통비, 숙박비, 식비]는 숫자만 입력해 주세요.");
			$('#amt_silbi').focus();
			return;
		}

	 	// 3. validation check 후 기안기에 내용 입력
		// 신고자 : 사번 : 기안자사번, 성명 : 기안자, 직위 : draftposition, 부서 : 기안부서, 근무지 : gunmuji
		// 외부강의·회의유형 : lecturetype
		// 활동유형 : acttype
		// 요청자 : 기관명 : organ, 대표자 : ceo, 담당부서 : damdept, 연락처 : damtel
		// 요청사유 : sayou
		// 장소 : location
		// 일시 : ymd, stime, etime
		// 복무처리 여부 : hyugatext
		// 강의시간 : sigan, 1시간 대가 : amt_hour
		// 사례금 : amt_tot
		// 교통비,숙박비,식비 : amt_silbi
		// 기안일자 : 기안일자
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		// 신고자 인적사항
		_$hwpObj.insertSignData('기안자사번', HGW_APPR_BANK.loginVO.user_emp_id); // 사번
		_$hwpObj.insertSignData('기안자', HGW_APPR_BANK.loginVO.user_nm); // 성명
		_$hwpObj.insertSignData('draftposition', HGW_APPR_BANK.loginVO.memb_postion); // 직위
		_$hwpObj.insertSignData('기안부서', HGW_APPR_BANK.loginVO.dept_nm); // 부서
		_$hwpObj.insertSignData('gunmuji', $('#gunmuji').val()); // 근무지
		
		// 신고내용
		_$hwpObj.insertSignData('lecturetype', $('#lecturetype').val()); // 외부강의·회의유형
		_$hwpObj.insertSignData('acttype', $('#acttype').val()); // 활동유형
		
		// 요청자
		_$hwpObj.insertSignData('organ', $('#organ').val()); // 기관명
		_$hwpObj.insertSignData('ceo', $('#ceo').val()); // 대표자
		_$hwpObj.insertSignData('damdept', $('#damdept').val()); // 담당부서
		_$hwpObj.insertSignData('damtel', $('#damtel').val()); // 연락처
		
		// 요청내용
		_$hwpObj.insertSignData('sayou', $('#sayou_2').val()); // 요청사유
		_$hwpObj.insertSignData('location', $('#location_2').val()); // 장소
		_$hwpObj.insertSignData('ymd', $('#date').val()); // 일시
		_$hwpObj.insertSignData('stime', $('#hour1').val() + ':' + $('#min1').val()); // 시작시간
		_$hwpObj.insertSignData('etime', $('#hour2').val() + ':' + $('#min2').val()); // 마치는시간
		_$hwpObj.insertSignData('hyugatext', $('input[name="way"]:checked').closest('label').text()); // 복무처리 여부
		
		// 금액내용
		_$hwpObj.insertSignData('sigan', $('#sigan').val()); // 강의시간
		_$hwpObj.insertSignData('amt_hour', $('#amt_hour').val()); // 1시간대가
		_$hwpObj.insertSignData('amt_tot', $('#amt_tot').val()); // 사례금 = 강의시간×1시간대가 금액
		_$hwpObj.insertSignData('amt_silbi', $('#amt_silbi').val()); // 교통비, 숙박비, 식비
		
		// 작성일
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));

		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000410_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
	
</script>

<form id="FORM_FM00000410">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
		
			<tr>
				<%-- 사번 --%>
				<th class="lln" scope="row"><label for="htmlEditorLyr_1">사번</label></th>
				<td class="lln">
					<c:out value="${loginVO.user_emp_id }" escapeXml="false"/>
				</td>
				<!-- 성명 -->
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">성명</label></th>
				<td data-hgwtype="public">
					<c:out value="${loginVO.user_nm }" escapeXml="false"/>
				</td>
			</tr>
			<tr>
				<!-- 직위 -->
				<th scope="row" class="lln"><label for="htmlEditorLyr_7">직위</label></th>
				<td>
					<c:out value="${loginVO.memb_postion }" escapeXml="false"/>
				</td>
				<!-- 소속 -->
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">소속</label></th>
				<td data-hgwtype="public">
					<c:out value="${loginVO.dept_nm }" escapeXml="false"/>
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">근무지</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="gunmuji" class="" value="" style="height: 25px;">
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">외부강의<br>회의유형</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="lecturetype" class="" value="" style="height: 25px;">
				</td>
			</tr>
			<tr>
				<th style="border-bottom: none;" data-hgwtype="public" scope="row" class="lln">활동유형</th>
				<td style="border-bottom: none;" data-hgwtype="public" colspan="3">
					<input type="text" id="acttype" class="" value="" style="height: 25px;">
				</td>
			</tr>
		</table>
	</div><br>
	
	<div class="tablewrap-line" id="p15_tbl">
		<table class="table-datatype01">
			<colgroup class="colgroup_1">
				<col class="col1" style="width:16%">
				<col class="col2" style="width:12%">
				<col class="col3" style="width:30%">
				<col class="col4" style="width:12%">
				<col class="col5" style="width:30%">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln" rowspan="2">요청자</th>
				<th data-hgwtype="public" scope="row" class="lln">기관명</th>
				<td data-hgwtype="public">
					<input type="text" id="organ" class="" value="" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln">대표자</th>
				<td data-hgwtype="public">
					<input type="text" id="ceo" class="" value="" style="height: 25px;">
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">담당부서</th>
				<td data-hgwtype="public">
					<input type="text" id="damdept" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln">연락처</th>
				<td data-hgwtype="public">
					<input type="text" id="damtel" style="height: 25px;">
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">요청사유</th>
				<td data-hgwtype="public" colspan="4">
					<input type="text" id="sayou_2" style="height: 25px;" placeholder="※ 요청사유에는 교육과정명, 회의명, 행사명 등을 기재">
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">장소</th>
				<td data-hgwtype="public" colspan="4">
					<input type="text" id="location_2" style="height: 25px;" placeholder="※ 실제 강의, 회의, 행사 등을 실행하는 주소 입력">
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">일시</label></th>
				<td colspan="2">
					<input type="text" name="date" id="date" style="width: 90px; height: 25px;" readonly /> 
						<select style="height: 25px;" id="hour1">
							<option value="01">1</option>
							<option value="02">2</option>
							<option value="03">3</option>
							<option value="04">4</option>
							<option value="05">5</option>
							<option value="06">6</option>
							<option value="07">7</option>
							<option value="08">8</option>
							<option value="09">9</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
							<option value="13">13</option>
							<option value="14">14</option>
							<option value="15">15</option>
							<option value="16">16</option>
							<option value="17">17</option>
							<option value="18">18</option>
							<option value="19">19</option>
							<option value="20">20</option>
							<option value="21">21</option>
							<option value="22">22</option>
							<option value="23">23</option>
							<option value="24">24</option>
						</select> 
					<span>시</span> 
						<select style="height: 25px;" id="min1">
							<option value="00">00</option>
							<option value="30">30</option>
						</select> 
					<span>분 &nbsp;&nbsp;&nbsp;~</span>
				</td>
	
				<td colspan="2">
					<select style="height: 25px;" id="hour2">
						<option value="01">1</option>
						<option value="02">2</option>
						<option value="03">3</option>
						<option value="04">4</option>
						<option value="05">5</option>
						<option value="06">6</option>
						<option value="07">7</option>
						<option value="08">8</option>
						<option value="09">9</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
					</select> 
					<span id="hour2"> 시</span> 
						<select style="height: 25px;" id="min2">
							<option value="00">00</option>
							<option value="30">30</option>
						</select> 
					<span id="min2"> 분</span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">복무처리여부</th>
				<td data-hgwtype="public" colspan="4">
					<label><input type="radio" name="way" value="1" /> 개인휴가사용</label> 
					<label><input style="margin-left: 10px;" type="radio" name="way" value="2" /> 공가처리</label>
					<label><input style="margin-left: 10px;" type="radio" name="way" value="3" /> 출장신청</label>
					<label><input style="margin-left: 10px;" type="radio" name="way" value="4" /> 근무시간외(휴무일 포함)</label>
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">강의시간</th>
				<td data-hgwtype="public" colspan="4">
					<input type="text" id="sigan" style="width: 50px; height: 25px;"> <span> 시간(숫자로 입력)</span>
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">1시간 대가</th>
				<td data-hgwtype="public" colspan="4">
					<input type="text" id="amt_hour" style="width:70px; height: 25px;" /><span style="margin-left: 4px;">(원, 숫자로 입력)</span>
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">사 례 금</th>
				<td data-hgwtype="public" colspan="4">
					<input type="text" id="amt_tot" style="width:70px; height: 25px;"><span style="margin-left: 4px;">(원, 숫자로 입력) : 강의시간 X 1시간대가 금액</span>
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;">교통비,<br>숙박비, 식비</th>
				<td data-hgwtype="public" colspan="4">
					<input type="text" id="amt_silbi" style="width:70px; height: 25px;"><span style="margin-left: 4px;">(원, 숫자로 입력) : 사례금 외 별도 금액</span>
				</td>
			</tr>
			<tr>
				<td colspan="4" style="border-bottom: none;">
					1. 금액은 세전금액으로 원단위 입력<br>
					2. 사례금은 60만원을 초과할 수 없음.<br>
					3. [교통비, 숙박비, 식비]는 실비로 입력.
				</td>
			</tr>
		
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000410_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000410_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>