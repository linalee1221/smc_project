<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 항공마일리지 신고서 -->
<!-- EZSP_GETAIR - VW_PPE_GW_INTERFACE21
	 EZSP_GETBANGBUB - VW_PPE_GW_INTERFACE22
	 EZSP_Mileage_INSERT - PR_PPE_INSERT_PPE0900
	 EZSP_GETMileage - VW_PPE_GW_INTERFACE23  -->

<script>

var jikjong = "";
var jikgeub = "";

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
			
			jikjong = res.rows[0].JIKJONG_CODE_NAME;
			jikgeub = res.rows[0].JIKGEUB_CODE_NAME;
			
			$('#userTitle').text(jikjong+jikgeub);
			
		});
		
		
		$("#sDate").datepicker({
			dateFormat : 'yy-mm-dd',
			showOn : 'both',
			buttonImage : '/images/common/ico_date_drop.gif',
			buttonImageOnly : true,
			onClose : function( selectedDate ) {
                if( selectedDate != "" ) {
                    $("#eDate").datepicker("option", "minDate", selectedDate);
                }
            }
		});
		$("#eDate").datepicker({
			dateFormat : 'yy-mm-dd',
			showOn : 'both',
			buttonImage : '/images/common/ico_date_drop.gif',
			buttonImageOnly : true
		});
		
	/*
	- VIEW_TABLE 조회
	VW_PPE_GW_INTERFACE21 (이용항공사)
	VW_PPE_GW_INTERFACE22 (활용방법)
	*/
	
	// 이용항공사
	var airName = "";
	$.ajax({
		url: '/interwork/getAirCompany.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {}
	}).success(function(data) {
        console.log('getAirCompany  :::  ', data);
        if(data == null || data == undefined) {
	        } else {
	          var list = data.rows;
	          if(list.length == 0) {
	          } else {
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              
	              airName = item.CODE_NAME;
	              
	              $("#mileage2").append('<option value='+ item.CODE +'>'+ item.CODE_NAME +'</option>');
	              
	              console.log("이용항공사 이름 :: ", airName);
	            }
	          }
            }
  	 });
	
	// 활용방법
	var wayText = "";
	$.ajax({
		url: '/interwork/getWayText.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {}
	}).success(function(response) {
        console.log('getWayText  :::  ', response);
        if(response == null || response == undefined) {
	        } else {
	          var list = response.rows;
	          if(list.length == 0) {
	          } else {
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              
	              wayText = item.CODE;
	              
	              var labelTag = $('<label/>').css('margin-right', '5px');
				  var radioTag =  $('<input/>', {
						'type': 'radio',
						'name': 'way',
						'value': item.CODE
					}).css('margin-right', '5px');
				  
				  labelTag.append(radioTag).appendTo('#VW_PPE_GW_INTERFACE22_DATA');
				  radioTag.after(item.CODE_NAME);
	              
	              console.log("활용방법 옵션 :: ", wayText);
	            }
	          }
            }
  	 });
	
	// 마일리지 가져오기
	var mileage = "";
	getMileage = function() {
		$.ajax({
		url: '/interwork/getMileage.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {
			'user_emp_id': HGW_APPR_BANK.loginVO.user_emp_id
		}
	}).success(function(date2) {
        console.log('getMileage  :::  ', date2);
        var list = date2.rows;
        
        if (list.length == 0) {
        	$('#mileage1').val('0');
        }
        
        
        selectVal = $("#mileage2 option:selected").val();
        
        if(date2 == null || date2 == undefined) {
	        } else {
	          
	          if(list.length == 0) {
	          } else {
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              
	              mileage = item.REAMIN_MILEAGE;
	              
	              if (item.COMPANY_CODE == selectVal) {

						$('#mileage1').val(date2.rows[0].REAMIN_MILEAGE);

					}
	              
	              console.log("마일리지 :: ", mileage);
	            }
	          }
            }
  	 });
	}
	
	/* $.ajax({
		url: '/interwork/selectOcsViewTable.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {
			'ifkey_sys': 'GW',
			'ifkey_type': FORM_LINE_BANK[0].form_link_sub_type
		}
	}).success(function(response) {
		console.log('response :: ', response);
		$('#mileage2').html('');
		$('#VW_PPE_GW_INTERFACE21_DATA').html('');
		if (isNull(response) == false) {
			if (isNull(response.VW_PPE_GW_INTERFACE21) == false) {
				response.VW_PPE_GW_INTERFACE21.forEach(function(v) {
					if (isNull($.trim(v.code)) == false && isNull($.trim(v.code_name)) == false) {
						$('<option/>', {'text': v.code_name, 'value': v.code}).appendTo('#mileage2');
					}
				});
			}
			
			if (isNull(response.VW_PPE_GW_INTERFACE22) == false) {
				response.VW_PPE_GW_INTERFACE22.forEach(function(v) {
					if (isNull($.trim(v.code)) == false && isNull($.trim(v.code_name)) == false) {
						var labelTag = $('<label/>').css('margin-right', '5px');
						var radioTag =  $('<input/>', {
							'type': 'radio',
							'name': 'way',
							'value': v.code
						}).css('margin-right', '5px');
						
						labelTag.append(radioTag).appendTo('#VW_PPE_GW_INTERFACE22_DATA');
						radioTag.after(v.code_name);
					}
				});
			}
		}
	}).error(function(error) {
		console.error(error);
		alert(error);
	}); */
		
	$('#FM00000095_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000095').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var checkNum1 = $('#fee').val();
		var checkNum2 = $('#requestfee').val();
		var checkNum3 = $('#mileage3').val();
		var checkNum4 = $('#mileage4').val();
		var sDate = $('#sDate').val().split("-");
		var eDate = $('#eDate').val().split("-");
		var legacydata = [];
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 1. 데이터 저장
		legacydata.push({
			I_USER_ID      : HGW_APPR_BANK.loginVO.user_id,
			I_SABUN        : HGW_APPR_BANK.loginVO.user_emp_id,
			I_FROM_YMD     : $('#sDate').val().replace(/-/g, ""), //시작일
			I_TO_YMD       : $('#eDate').val().replace(/-/g, ""), //종료일
			I_DAY_CNT      : $('#calDays').val(),
			I_LOCATION     : $("#location").val(),
			I_COMPANY_CODE : $("#mileage2").val(),
			I_MILEAGE      : $("#mileage3").val(),
			I_USE_MILEAGE  : $("#mileage4").val(),
			I_METHOD_CODE  : $('input[name="way"]:checked').val(),
			I_IF_DOCID     : ''
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if ($('#calNight').val() == '' && $('#calDays').val() == '') {
			alert('날짜를 선택 후 날짜계산을 클릭해 주세요.');
			$('#calDay').focus();
			return false;			
		}
		if ($("#location").val() == "") {
			alert('여행지를 입력해 주세요.');
			$("#location").focus();
			return false;	
		}
		if ($('input[name="grade"]:checked').val() == null) {
			alert('적용등급을 선택해 주세요.');
			return false;
		}
		if ($("#fee").val() == "") {
			alert('정액운임을 입력해 주세요.');
			$("#fee").focus();
			return false;
		}
		
		// 숫자인지 판별 후 숫자면 데이터저장(기안기입력), 아니면 경고창
	 	if ($.isNumeric(checkNum1) == true) {
			_$hwpObj.insertSignData('fee', $('#fee').val());
		} else {
			alert('정액운임은 숫자만 입력해 주세요.');
			$('#fee').focus();
			return;
		}
		
		if ($("#requestfee").val() == "") {
			alert('청구금액을 입력해 주세요.');
			$("#requestfee").focus();
			return false;
		}
		
		// 숫자인지 판별 후 숫자면 데이터저장(기안기입력), 아니면 경고창
	 	if ($.isNumeric(checkNum2) == true) {
			_$hwpObj.insertSignData('requestfee', $('#requestfee').val());
		} else {
			alert('청구금액은 숫자만 입력해 주세요.');
			$('#requestfee').focus();
			return;
		}
		
		/* 이용항공사 선택하면 자동입력되는 칸이라서 경고창 삭제 */
	 	/* if ($("#mileage1").val() == "") {
			generateNoty('','warning','','기존마일리지를 입력해 주세요.','center',true);
			return false;
		} */
		
		/* 기본적으로 첫번째 옵션이 선택되어 있으므로 경고창 삭제 */
		/* if ($("#mileage2").val() == "") {
			alert('이용항공사를 선택해 주세요.');
			$('#mileage2').focus();
			return false;
		} */
		if ($("#mileage3").val() == "") {
			alert('누적마일리지를 입력해 주세요.');
			$("#mileage3").focus();
			return false;
		}
		
		// 숫자인지 판별 후 숫자면 데이터저장(기안기입력), 아니면 경고창
	 	if ($.isNumeric(checkNum3) == true) {
			_$hwpObj.insertSignData('mileage3', $('#mileage3').val());
		} else {
			alert('누적마일리지는 숫자만 입력해 주세요.');
			$('#mileage3').focus();
			return;
		}
		
		if ($('input[name="way"]:checked').val() == null) {
			alert('활용방법을 선택해 주세요.');
			return false;
		}
		if ($("#mileage4").val() == "") {
			alert('사용마일리지를 입력해 주세요.');
			$("#mileage4").focus();
			return false;
		}
		
		// 숫자인지 판별 후 숫자면 데이터저장(기안기입력), 아니면 경고창
	 	if ($.isNumeric(checkNum4) == true) {
			_$hwpObj.insertSignData('mileage4', $('#mileage4').val());
		} else {
			alert('사용마일리지는 숫자만 입력해 주세요.');
			$('#mileage4').focus();
			return;
		}
		
	 	// 3. validation check 후 기안기에 내용 입력
		// 소속 : v_department, 직급(직위) : v_position, 성명 : v_draftername
		// 일시 : gigan, 여행지 : location, 적용등급 : gradetxt, 정액운임 : fee, 청구금액 : requestfee
		// 기존마일리지 : mileage1, 이용항공사 : mileage2, air, 누적마일리지 : mileage3
		// 활용방법 : bangbubtxt, 사용마일리지 : mileage4
		// 총마일리지 : mileage5
		// 기안일자 : daftdate
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		_$hwpObj.insertSignData('v_department', HGW_APPR_BANK.loginVO.dept_nm);
		_$hwpObj.insertSignData('v_position', HGW_APPR_BANK.loginVO.memb_postion);
		_$hwpObj.insertSignData('v_draftername', HGW_APPR_BANK.loginVO.user_nm);
		_$hwpObj.insertSignData('daftdate', new Date().hgwDateFormat('yyyy.MM.dd'));
		_$hwpObj.insertSignData('gigan', $('#sDate').val() + '~' + $('#eDate').val() + (isNull($('#calNight').val()) == false ? ' (' + $('#calNight').val() + '박 ' + $('#calDays').val() + '일)' : ''));
		_$hwpObj.insertSignData('gradetxt', $('input[name="grade"]:checked').closest('label').text());
		_$hwpObj.insertSignData('mileage2', $('#mileage2 option:selected').text());
		_$hwpObj.insertSignData('air', $('#mileage2 option:selected').val());
		_$hwpObj.insertSignData('bangbubtxt', $('input[name="way"]:checked').closest('label').text());
		
		var mileage1 = $('#mileage1').val();
		var mileage3 = $('#mileage3').val();
		var mileage4 = $('#mileage4').val();
		var sum = (Number(mileage1) + Number(mileage3)) - Number(mileage4);
	
		if (sum == 0) {
			_$hwpObj.insertSignData('mileage5', '0'); 
		} else {
			_$hwpObj.insertSignData('mileage5', sum); 
		}

		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
		
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
		$('#FM00000095_reset').unbind().on('click', function() {
			alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
			$('form').each(function() {
			    this.reset();
			  });
			$('#gw_sp_dialog').dialog('close');
		});
	});
	
	/* 박 수, 일 수 계산 */
	function calDate() {
		
		if($("#sDate").val() == '' || $("#sDate").val() == null){
			return;
		}
		
		var date1 = $("#sDate").val();
		var date2 = $("#eDate").val();

		date1 = date1.split("-");
		date2 = date2.split("-");

		date1 = new Date(date1[0], date1[1], date1[2]);
		date2 = new Date(date2[0], date2[1], date2[2]);

		var btMs = date2.getTime() - date1.getTime();

		var btDay = btMs / (1000 * 60 * 60 * 24) + 1;
		
		$("#calDays").val(btDay);

		var btDayNight = btMs / (1000 * 60 * 60 * 24);
		
		$("#calNight").val(btDayNight)
	}
</script>

<form id="FORM_FM00000095">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			<tr>
				<th>소속</th>
				<td colspan="2">${loginVO.dept_nm}</td>
				<th>직명</th>
				<td colspan="2" id="userTitle"></td>
			</tr>
	
			<tr>
				<th style="border-bottom: none;">성명</th>
				<td colspan="2" style="border-bottom: none;">${loginVO.user_nm}</td>
				<th style="border-bottom: none;">사번</th>
				<td colspan="2" style="border-bottom: none;">${loginVO.user_emp_id}</td>
			</tr>
		</table>
	</div>
	
	<div class="tablewrap-line" style="margin-top:10px;">
		<table class="table-datatype01">
		
			<tr>
				<th style="width: 15%" rowspan="2">공무 여행지</th>
				<th style="width: 15%">일 시</th>
				<td style="width: 70%;" colspan="2">
					<input type="text" name="sDate" id="sDate" title="시작일" style="width: 90px; height: 25px; margin-right: 5px;" readonly/> 
						<span> ~ </span>
					<input type="text" name="eDate" id="eDate" title="종료일" style="width: 90px; height: 25px; margin-right: 5px;" readonly/> 
						<span>
							<button type="button" class="btn btn-outline-dark" id="calDay" onclick="calDate()">날짜계산</button>
						</span> 
					<input type="text" name="calNight" id="calNight" style="margin-left: 5px; width: 50px; height: 25px" readonly />&nbsp;박 
					<input type="text" name="calDays" id="calDays" style="width: 50px; height: 25px" readonly />&nbsp;일
				</td>
			</tr>
			
			<tr>
				<th style="width: 15%">여행지</th>
				<td style="width: 70%;" colspan="2">
					<input type="text" id="location" name="location" style="width: 95%; height:25px" />
				</td>
			</tr>
			
			<tr>
				<th style="width: 15%" rowspan="3">항공운임</th>
				<th style="width: 15%">적용등급</th>
				<td style="width: 70%;" colspan="2">
					<label style="margin-right: 5px;"><input type="radio" name="grade" value="A" style="margin-right: 5px;" />1등석</label> 
					<label style="margin-right: 5px;"><input type="radio" name="grade" value="B" style="margin-right: 5px;" />비즈니스석 </label>
					<label style="margin-right: 5px;"><input type="radio" name="grade" value="C" style="margin-right: 5px;" />2등석</label>
				</td>
			</tr>
			
			<tr>
				<th style="width: 15%">정액운임</th>
				<td style="width: 70%;" colspan="2">
					<input type="text" id="fee" name="fee" style="width: 40%; height:25px" /> * 숫자만 입력해 주세요
				</td>
			</tr>
			
			<tr>
				<th style="width: 15%">청구금액</th>
				<td style="width: 70%;" colspan="2">
					<input type="text" id="requestfee" name="requestfee" style="width: 40%; height:25px" /> * 숫자만 입력해 주세요
				</td>
			</tr>
			
			<tr>
				<th style="width: 15%" rowspan="5">마일리지<BR />이용정보</th>
				<th style="width: 15%;">기존마일리지</th>
				<td style="width: 70%;" colspan="2">
					<input type="text" id="mileage1" name="mileage1" style="width: 40%; height:25px" readonly />
					 * 아래 이용항공사 선택시 자동입력 됩니다.</td>
			</tr>
			
			<tr>
				<th style="width: 15%" rowspan="2">신규 누적<br />마일리지</th>
				<th style="width: 15%">이용항공사</th>
				<td style="width: 55%;">
					<select id="mileage2" name="mileage2" style="height:25px;" class="frm_select" onchange="getMileage()">
						<option value="0">선택하세요.</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th style="width: 15%">누적마일리지</th>
				<td style="width: 55%;">
					<input type="text" id="mileage3" name="mileage3" style="width: 40%; height:25px" /> * 숫자만 입력해 주세요
				</td>
			</tr>
			
			<tr>
				<th style="width: 15%" rowspan="2">금번 사용<br />마일리지</th>
				<th style="width: 15%">활용방법</th>
				<td style="width: 55%;" class="bangbubtxt" id="VW_PPE_GW_INTERFACE22_DATA"></td>
			</tr>
			
			<tr>
				<th style="width: 15%">사용마일리지</th>
				<td style="width: 55%;">
					<input type="text" id="mileage4" name="mileage4" style="width: 40%; height:25px" /> * 숫자만 입력해 주세요
				</td>
			</tr>
			
			<tr style="display: none">
				<th style="width: 15%">총 마일리지</th>
				<td style="width: 55%;" colspan="2">
					<input type="text" id="mileage5" name="mileage5" style="width: 95%; height:25px" />
				</td>
			</tr>
			
			<tr>
				<td colspan="4" style="padding: 10px 0px 10px 10px; border-bottom:none;">
					<p style="line-height: 20px">
						※ 적용등급은 여비규정상 여비등급구분에 따라 “√” 로 표시<br /> ※ 정액운임은 당해직원의 여비등급에
						해당하는 항공운임 정액의 총액을 말함<br /> ※ 청구금액은 공적마일리지를 활용한 이후에 필요한 항공운금의
						총액을 말함<br /> ※ 금번 출장 등에 사용한 마일리지 활용방법은 출장구간 전부 또는 일부의 항공편 좌석을
						마일리지로 구매 또는 업그레이드한 경우에 “√” 로 표시하고, 금번 사용 마일리지는 당해 출장 등으로 사용한
						마일리지의 총 합계를 말함<br /> ※ 총 마일리지는 기존 마일리지와 금번 출장 등으로 누적된 마일리지에서
						사용한 마일리지를 공제한 것임
					</p>
				</td>
			</tr>
			
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000095_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000095_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>