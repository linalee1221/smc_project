<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 근로시간 단축 신청서 -->
<!-- EZSP_CHONGMU_INSERT - PR_PPE_INSERT_PPE0351 -->
<!-- OCS 연동 완료 -->

	
<style>
	img.ui-datepicker-trigger {
		margin-left: 5px;
	}
	
	#calDay {
		margin-left: 4px;
	}
		
	.time {
		margin-left: 4px;
	}
</style>

<script>

var jikjong = "";
var jikgeub = "";
$(function() {
	// 사용자정보
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
		
		$('#UserTitle').text(jikjong+jikgeub);
		
	});
	
	/* datepicker */
	
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
});
		
	/* 날짜계산 */
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
	
	    var btDay = btMs / (1000*60*60*24) +1;
	    $("#calDays").val(btDay);
	    
    };
    
    $(function() {
     	var html = [];
    	var value = "";
    	
    /*     	for (let now = new Date(), start = new Date(now.setHours(0, 0, 0, 0)), end = new Date(now.setDate(now.getDate()+1)); start < end; start.setMinutes(start.getMinutes() + 30)) {
    	    console.log(start.toTimeString().slice(0, 5))
    	} */
    	
    	/* for (var i=0; i<24; i++) {
    		if(i<10) {
    			value = '0'+i;
    		} else {
    			value = i;
    		}
    		
    		html[i] = "<option value="+value+">"+value+"</option>";
    	}
    	
    	$('#hour1').append(html.join('')); */
    	
    	for (var i=0; i<49; i++) {
    		var hour = '';
    		var min = ':00';
    		
    		if((Math.ceil(i/2)) < 13) {
    			hour = (Math.floor(i/2));
    		} else {
    			hour = (Math.floor(i/2));
    		}
    		hour = (Math.floor(i/2));
    		
    		if(hour<10) {
    			hour = '0' + hour;
    		}
    		
    		if(i%2 != 0) {
    			min = ':30';
    		}
    		
    		html[i] = "<option value="+hour+min+">"+hour+min+"</option>";
    	}
    	$('#hour1').append(html.join(''));
    	$('#hour2').append(html.join(''));
    	
    })
	
    
    /* 시간계산 */
    function calSigan() {
    	
    	if ($('#calDays').val() == '') {
    		alert("날짜계산을 눌러 단축근로일수를 먼저 계산하세요.");
    		return;
    	}
    	
    	// 시작 시간과 종료 시간 가져오기
    	var startTime = $('#hour1').val();
    	var endTime = $('#hour2').val();

    	// 시작 시간과 종료 시간을 Date 객체로 변환하기
    	var startDate = new Date("2000-01-01T" + startTime + ":00");
    	var endDate = new Date("2000-01-01T" + endTime + ":00");

    	// 시간 차이 계산하기
    	var timeDifference = endDate.getTime() - startDate.getTime();
    	var hoursDifference = Math.floor(timeDifference / (1000 * 60 * 60));
    	var minutesDifference = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));

    	// 분 단위를 0.5로 계산하기
    	var minutesDifferenceHalf = Math.round(minutesDifference / 30) * 30;
    	if (minutesDifferenceHalf == 60) {
    	hoursDifference += 1;
    	minutesDifferenceHalf = 0;
    	}

    	// 시간 차이를 소수점으로 계산하기
    	var timeDifferenceDecimal = hoursDifference + (minutesDifferenceHalf / 60);
    	if (timeDifferenceDecimal > 4) {
    		timeDifferenceDecimal = hoursDifference + (minutesDifferenceHalf / 60) - 1;
    	} else {
    		timeDifferenceDecimal = hoursDifference + (minutesDifferenceHalf / 60);
    	}

    	// 총 시간 차이 구하기
    	var totalMinutesDifference = Math.round(timeDifferenceDecimal * 60);

    	// 1주일(5일)동안의 근무 시간 계산하기
    	var weeklyHours = totalMinutesDifference * 5 / 60;

    	// 선택한 기간 가져오기
    	var duration = $('#calDays').val();

    	// 선택한 기간과 시간 차이를 곱하여 총 시간 계산하기
    	var totalMinutes = totalMinutesDifference * duration;
    	var totalHours = Math.floor(totalMinutes / 60);
    	var remainingMinutes = totalMinutes % 60;

    	// 결과 출력하기
    	console.log("근무 시작 시간: " + startTime + "\n근무 종료 시간: " + endTime + "\n\n하루 근무 시간: " + timeDifferenceDecimal.toFixed(1) + "시간" + "\n\n단축근로할 기간: " + duration + "일" + "\n1주 총 근무 시간: " + (weeklyHours + (remainingMinutes / 60)).toFixed(1) + "시간");
    	
    	var totalTime = (weeklyHours + (remainingMinutes / 60)).toFixed(1);
    	
    	$('#hours').val(totalTime);
    	
    }
	    
    /* 육아기를 선택하면 영유아 이름 및 생년월일 입력창이 뜸 */
 		function setDisplay() {
        if ($('input:radio[id=sayou1]').is(':checked')) {
            $('#display').show();
            $('.youahname').focus();
        } else {
            $('#display').hide();
        }
   	};
   	
	$('#FM00000094_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000094').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var sDate = $('#sDate').val().split("-");
		var eDate = $('#eDate').val().split("-");
		var sTime = $('#hour1').val().split(":");
		var eTime = $('#hour2').val().split(":");
		var legacydata = [];
		
		var sayou = "";
		if($('input[name="sayou"]:checked').val() == "1"){
			sayou = "육아기"
		} else {
			sayou = "임신기간"
		}
		
		var startDate = $('#sDate').val();
		var endDate = $('#eDate').val();
		
		// 1. 데이터 저장
		legacydata.push({
			I_USER_ID      	 : HGW_APPR_BANK.loginVO.user_emp_id,
			I_SABUN        	 : HGW_APPR_BANK.loginVO.user_emp_id,
			I_BALRYENG_YMD 	 : startDate, //시작일
			I_BALRYENG_TO  	 : endDate, //종료일
			I_BALRYENG_CODE  : '04',
			I_BIGO         	 : sayou, //비고
			I_IF_DOCID     	 : '', //문서번호
			O_FLAG 			 : ''  //0이면 성공 아니면 에러
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if ($('input[name="sayou"]:checked').val() == null) {
			alert('단축 근무 사유를 선택해 주세요.');
			$('#sayou1').focus();
			return false;
		}
		if ($('input[name="sayou"]:checked').val() == '1') {
			if ($('.youahname').val() == '' || $('.youahbirth').val() == '') {
				alert('영유아 이름과 생년월일을 입력해 주세요.');
				$('.youahname').focus();
				return false;
			}
		}
		if ($('#calDays').val() == '') {
			alert('날짜계산을 눌러 단축근로 일수를 입력해 주세요.');
			$('#calDays').focus();
			return false;
		};
		if ($('#hours').val() == '') {
			alert('단축근로 시간을 입력해 주세요.');
			$('#hours').focus();
			return false;
		};
		
		// 3. validation check 후 기안기에 내용 입력
		// 성명 : v_draftername
		// 직종 : v_position
		// 사번 : v_userid
		// 소속 : v_department
		// 단축근무사유 - 육아기 : sayou1, 임신기간 : sayou2
		// 영유아이름 : youahname, 영유아 생년월일 : youahbirth
		// 단축근로기간 : gigan
		// 단축근로시간 : sigan
		// 기안일자 : 기안일자
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		// 인적사항
		_$hwpObj.insertSignData('v_draftername', HGW_APPR_BANK.loginVO.user_nm); // 성명
		_$hwpObj.insertSignData('v_position', jikjong); // 직종
		_$hwpObj.insertSignData('v_userid', HGW_APPR_BANK.loginVO.user_emp_id); // 사번
		_$hwpObj.insertSignData('v_department', HGW_APPR_BANK.loginVO.dept_nm); // 소속
		
		// 단축근무사유
		if($('input[name="sayou"]:checked').val() == '1'){
			_$hwpObj.insertSignData('sayou1', 'O');
			_$hwpObj.deleteSignData('sayou2');
		} else if($('input[name="sayou"]:checked').val() == '2'){
			_$hwpObj.insertSignData('sayou2', 'O');
			_$hwpObj.deleteSignData('sayou1');
			_$hwpObj.deleteSignData('youahname');
			_$hwpObj.deleteSignData('youahbirth');
		}
		
		// 단축근무사유가 육아기일 경우 영유아 이름, 생년월일 입력
		if($('input[name="sayou"]:checked').val() == '1'){
			_$hwpObj.insertSignData('youahname', $('.youahname').val());
			_$hwpObj.insertSignData('youahbirth', $('.youahbirth').val());
		}
		
		// 단축근로기간
		_$hwpObj.insertSignData('gigan', sDate[0] + '년 ' + sDate[1] + '월 ' + sDate[2] + '일 ~ '
								+ eDate[0] + '년 ' + eDate[1] + '월 ' + eDate[2] + '일 ' + ' ( ' + $('#calDays').val() + '일간 )');
		
		// 단축근로시간
		_$hwpObj.insertSignData('sigan', sTime[0] + '시 ' + sTime[1] + '분 ~ '
								+ eTime[0] + '시 ' + eTime[1] + '분' + ' ( 1주 근로시간 : ' + $('#hours').val() + '시간 )');
		
		// 작성일
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));

		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기		
	$('#FM00000094_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
	
</script>

<form id="FORM_FM00000094">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
		
			<tr>
				<th>소속<input type="hidden" id="DepartCD" /></th>
				<td colspan="2" id="DepartNM">${loginVO.dept_nm}</td>
				<th>직명</th>
				<td colspan="2" id="UserTitle"></td>
			</tr>

			<tr>
				<th>성명</th>
				<td colspan="2" id="UserNM">${loginVO.user_nm}</td>
				<th>사번</th>
				<td colspan="2" id="UserID">${loginVO.user_emp_id}</td>
			</tr>

			<tr>
				<th>단축근무사유</th>
				<td colspan="5">
					<label><input type="radio" id="sayou1" name="sayou" value="1" onchange="setDisplay()" /> 육아기</label><br>
					<label><input type="radio" id="sayou2" name="sayou" value="2" onchange="setDisplay()" /> 임신기간</label><br>
				</td>
			</tr>

			<tr id="display" style="display: none;">
				<th>영유아 이름</th>
				<td colspan="2">
					<input class="youahname" type="text" style="height: 25px;">
				</td>
				<th>영유아 생년월일</th>
				<td colspan="2">
					<input class="youahbirth" type="text" style="height: 25px;">
				</td>
			</tr>

			<tr>
				<th>단축근로기간</th>
				<td colspan="5">
					<input type="text" name="sDate" id="sDate" title="시작일" style="width: 90px; height: 25px;" readonly/> 
						<span> ~ </span> 
					<input type="text" name="eDate" id="eDate" title="종료일" style="width: 90px; height: 25px;" readonly/> 
						<span>
							<button type="button" class="btn btn-outline-dark" id="calDay" onclick="calDate()">날짜계산</button>
						</span>
				</td>
			</tr>

			<tr>
				<th>단축근로일수</th>
				<td colspan="5"><input type="text" style="width: 90px; height: 25px;" id="calDays" readonly>
					<span>일 </span>
				</td>
			</tr>

			<tr>
				<th>단축근로시간</th>
				<td colspan="5">
					<select id="hour1" style="height: 25px;"></select> 
					<span>&nbsp;~&nbsp;</span>
					<select id="hour2" style="height: 25px;"></select> 
					<span>
						<button type="button" class="btn btn-outline-dark" id="calTime" onclick="calSigan()">시간계산</button>
					</span>
					<span style="margin-left:5px;">1주 근로시간 : </span><input id="hours" type="text" style="margin-left: 10px; width: 70px; height: 25px;">
					<span class="time">시간</span>
				</td>
			</tr>

			<tr>
				<th colspan="6" style="border-right:none;">유의사항</th>
			</tr>

			<tr>
				<td colspan="6">
					<span>※ 근로시간 단축을 신청하는 자는 개시
							예정일 30일 전까지 신청서를 작성하여 제출하여야 한다.<br></span> 
					<span>단, 임신기간 근로시간 단축을 신청하는 자는 개시 예정일 3일 전까지 신청서를 작성하여
							제출하여야 한다.<br></span> 
					<span>※ 육아기 근로시간 단축 신청시 해당 자녀의 출생 등을 증명할 수 있는 서류를 첨부하여야 한다.<br></span>
					<span>※ 임신기간 근로시간 단축 신청시 임신에 대한 증명은 의사가 발급한 진단서를 첨부하여야 한다.<br></span>
					<p>※ 단축근로시간에는 단축하여 근로할 시간을 기재한다.<br></p>
				</td>
			</tr>
		
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000094_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000094_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>