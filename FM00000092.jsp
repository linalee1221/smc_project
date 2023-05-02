<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 휴직원 -->
<!-- EZSP_CHONGMU_INSERT, PR_PPE_INSERT_PPE0351 -->
<!-- OCS연동완료 -->
	
<style>
	/* datepicker 아이콘 input box에서 살짝 떨어뜨림 */
    img.ui-datepicker-trigger {
        margin-left: 5px;
    }
    
    /* input box옆에 '일' 글자 input box에서 살짝 떨어뜨림 */
    #calDay {
        margin-left: 4px;
    }
</style>
	
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
    });
	
    /* 휴직일수 계산 */
    function calDate() {

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
    
    /* 휴직사유 기타 선택 시 직접 입력 */
    function setDisplay() {
        if ($('input:radio[id=sayou6]').is(':checked')) {
            $('#sayouetc').show();
            $('#sayouetc').focus();
        } else {
            $('#sayouetc').hide();
        }
        if ($('input:radio[id=sayou3]').is(':checked')) {
        	alert("휴직기간 동안 보수가 지급되지 않으며, 육아휴직 급여는 직접 신청해주시기 바랍니다.\n\n(※육아휴직급여 : 휴직일로부터 30일 후 고용보험 홈페이지에서 직접 신청하며, 필요 서류는 급여 담당자가 등록)");
        	$('#sayoutxt1-title').show();
        	$('#sayoutxt1').show();
        	$('#sayoutxt1').focus();
        } else {
        	$('#sayoutxt1-title').hide();
            $('#sayoutxt1').hide();
        }
        if ($('input:radio[id=sayou4]').is(':checked')) {
        	$('#sayoutxt2-title').show();
        	$('#sayoutxt2').show();
        	$('#sayoutxt2').focus();
        } else {
        	$('#sayoutxt2-title').hide();
            $('#sayoutxt2').hide();
        }
        
        if ($('input:radio[id=sayou5]').is(':checked')) {
        	alert("해당 휴직은 법정휴직이 아니기에 휴직기간에 따라 발생되는 총 연차수가 감소되며, 휴직기간 동안 보수는 지급되지 않습니다.");
        }
    };
    
    
	
	$('#FM00000092_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000092').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var sDate = $('#sDate').val().split("-");
		var eDate = $('#eDate').val().split("-");
		var legacydata = [];
		
		var sayou = "";
		if($('input[name="sayou"]:checked').val() == "1"){
			sayou = "일반질병휴직";
		} else if ($('input[name="sayou"]:checked').val() == "2") {
			sayou = "업무상질병휴직";
		} else if ($('input[name="sayou"]:checked').val() == "3") {
			sayou = "육아휴직";
		} else if ($('input[name="sayou"]:checked').val() == "4") {
			sayou = "가족돌봄휴직";
		} else if ($('input[name="sayou"]:checked').val() == "5") {
			sayou = "산전(모성보호)휴직";
		} else if ($('input[name="sayou"]:checked').val() == "6") {
			sayou = "기타";
		}
		
		// 1. 데이터 저장
		legacydata.push({
			I_USER_ID      	 : HGW_APPR_BANK.loginVO.user_emp_id,
			I_SABUN        	 : HGW_APPR_BANK.loginVO.user_emp_id,
			I_BALRYENG_YMD 	 : $('#sDate').val(), //시작일
			I_BALRYENG_TO  	 : $('#eDate').val(), //종료일
			I_BALRYENG_CODE  : '1',
			I_BIGO         	 : sayou, //비고
			I_IF_DOCID     	 : '', //문서번호
			O_FLAG 			 : ''  //0이면 성공 아니면 에러
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if($("#calDays").val() == "") {
			alert('날짜계산을 눌러 휴직 기간을 입력해 주세요.');
			$("#sDate").focus();
			return false;
		} 
		if($("#location").val() == "") {
			alert('장소를 입력해 주세요.');
			$("#location").focus();
			return false;
		} 
		if ($('input[name="sayou"]:checked').val() == null) {
			alert('휴직 사유를 선택해 주세요.');
			$('#sayou1').focus();
			return false;
		}
		if($('input:radio[name="sayou"]:checked').val() == '6' && $("#sayouetc").val() == "") {
			alert('사유가 기타인 경우 직접 입력해 주세요.');
			$('#sayouetc').focus();
			return false;
		}
		
		// 3. validation check 후 기안기에 내용 입력
		// 인적사항 : 성명 : v_draftername, 직명 : v_position, 사번 : v_userid, 소속 : v_department 
		// 휴직기간 : gigan
		// 장소 : location
		// 휴직사유 : sayou1 ~ sayou6
		// 기타 : sayouetc
		// 기안일자 : daftdate
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		// 인적사항
		_$hwpObj.insertSignData('v_draftername', HGW_APPR_BANK.loginVO.user_nm); // 성명
		_$hwpObj.insertSignData('v_position', $('#userTitle').text()); // 직명
		_$hwpObj.insertSignData('v_userid', HGW_APPR_BANK.loginVO.user_emp_id); // 사번
		_$hwpObj.insertSignData('v_department', HGW_APPR_BANK.loginVO.dept_nm); // 소속
		
		// 휴직기간
		_$hwpObj.insertSignData('gigan', sDate[0] + '년 ' + sDate[1] + '월 ' + sDate[2] + '일 ~ '
								+ eDate[0] + '년 ' + eDate[1] + '월 ' + eDate[2] + '일 ' + ' ( ' + $('#calDays').val() + ' ) 일간');
		
		// 장소
		_$hwpObj.insertSignData('location', $('#location').val());
		
		// 휴직사유
		if($('input[name="sayou"]:checked').val() == '1'){
			_$hwpObj.insertSignData('sayou1', '( O )');
			_$hwpObj.deleteSignData('sayou2');
			_$hwpObj.deleteSignData('sayou3');
			_$hwpObj.deleteSignData('sayou4');
			_$hwpObj.deleteSignData('sayou5');
			_$hwpObj.deleteSignData('sayou6');
			_$hwpObj.deleteSignData('sayouetc');
			_$hwpObj.deleteSignData('sayoutxt1');
			_$hwpObj.deleteSignData('sayoutxt2');
			$('#sayouetc').val('');
			$('#sayoutxt1').val('');
			$('#sayoutxt2').val('');
		} else if($('input[name="sayou"]:checked').val() == '2'){
			_$hwpObj.insertSignData('sayou2', '( O )');
			_$hwpObj.deleteSignData('sayou1');
			_$hwpObj.deleteSignData('sayou3');
			_$hwpObj.deleteSignData('sayou4');
			_$hwpObj.deleteSignData('sayou5');
			_$hwpObj.deleteSignData('sayou6');
			_$hwpObj.deleteSignData('sayouetc');
			_$hwpObj.deleteSignData('sayoutxt1');
			_$hwpObj.deleteSignData('sayoutxt2');
			$('#sayouetc').val('');
			$('#sayoutxt1').val('');
			$('#sayoutxt2').val('');
		} else if($('input[name="sayou"]:checked').val() == '3'){
			_$hwpObj.insertSignData('sayou3', '( O )');
			_$hwpObj.insertSignData('sayoutxt1', '대상 : ' + $('#sayoutxt1').val());
			_$hwpObj.deleteSignData('sayou1');
			_$hwpObj.deleteSignData('sayou2');
			_$hwpObj.deleteSignData('sayou4');
			_$hwpObj.deleteSignData('sayou5');
			_$hwpObj.deleteSignData('sayou6');
			_$hwpObj.deleteSignData('sayouetc');
			_$hwpObj.deleteSignData('sayoutxt2');
			$('#sayouetc').val('');
			$('#sayoutxt2').val('');
		} else if($('input[name="sayou"]:checked').val() == '4'){
			_$hwpObj.insertSignData('sayou4', '( O )');
			_$hwpObj.insertSignData('sayoutxt2', '대상 : ' + $('#sayoutxt2').val());
			_$hwpObj.deleteSignData('sayou1');
			_$hwpObj.deleteSignData('sayou2');
			_$hwpObj.deleteSignData('sayou3');
			_$hwpObj.deleteSignData('sayou5');
			_$hwpObj.deleteSignData('sayou6');
			_$hwpObj.deleteSignData('sayouetc');
			_$hwpObj.deleteSignData('sayoutxt1');
			$('#sayouetc').val('');
			$('#sayoutxt1').val('');
		} else if($('input[name="sayou"]:checked').val() == '5'){
			_$hwpObj.insertSignData('sayou5', '( O )');
			_$hwpObj.deleteSignData('sayou1');
			_$hwpObj.deleteSignData('sayou2');
			_$hwpObj.deleteSignData('sayou3');
			_$hwpObj.deleteSignData('sayou4');
			_$hwpObj.deleteSignData('sayou6');
			_$hwpObj.deleteSignData('sayouetc');
			_$hwpObj.deleteSignData('sayoutxt1');
			_$hwpObj.deleteSignData('sayoutxt2');
			$('#sayouetc').val('');
			$('#sayoutxt1').val('');
			$('#sayoutxt2').val('');
		} else if($('input[name="sayou"]:checked').val() == '6'){
			_$hwpObj.insertSignData('sayou6', '( O )');
			_$hwpObj.deleteSignData('sayou1');
			_$hwpObj.deleteSignData('sayou2');
			_$hwpObj.deleteSignData('sayou3');
			_$hwpObj.deleteSignData('sayou4');
			_$hwpObj.deleteSignData('sayou5');
			_$hwpObj.deleteSignData('sayoutxt1');
			_$hwpObj.deleteSignData('sayoutxt2');
			$('#sayoutxt1').val('');
			$('#sayoutxt2').val('');
		}
		_$hwpObj.insertSignData('sayouetc', '기타 (' + $('#sayouetc').val() + ')');
		
		// 작성일
		_$hwpObj.insertSignData('daftdate', new Date().hgwDateFormat('yyyy년 MM월 dd일'));
		
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000092_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<form id="FORM_FM00000092">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr>
               <th>소속</th>
               <td colspan="2">${loginVO.dept_nm}<input type="text" style="width: 0px; height: 0px; border: 0px;"/></td>
               <th>직명</th>
               <td colspan="2" id="userTitle"></td>
           </tr>
           
           <tr>
               <th>성명</th>
               <td colspan="2">${loginVO.user_nm}</td>
               <th>사번</th>
               <td colspan="2">${loginVO.user_emp_id}</td>
           </tr>

           <tr>
               <th>휴직 기간</th>
               <td colspan="5">
                   <input type="text" name="sDate" id="sDate" title="시작일" style="width: 90px; height:25px;" readonly/>
                   	<span> ~ </span>
                   <input type="text" name="eDate" id="eDate" title="종료일" style="width: 90px; height:25px;" readonly/>
                   	<span><button type="button" class="btn btn-outline-dark" id="calDay" onclick="calDate()">날짜계산</button></span>
               </td>
           </tr>
           
           <tr>
               <th>휴직일수</th>	
               <td colspan="5"><input type="text" style="width: 90px; height:25px; margin-right: 10px;" id="calDays" readonly/><span>일</span></td>					
           </tr>
           
           <tr>
               <th>장소</th>
               <td colspan="5"><input id="location" type="text" style="width: 100%; height:25px;"></td>
           </tr>

           <tr>
               <th>사유</th>
               <td colspan="5">
				<label><input type="radio" id="sayou1" name="sayou" value="1" onchange="setDisplay()" /> 일반질병휴직</label><br>
				<label><input type="radio" id="sayou2" name="sayou" value="2" onchange="setDisplay()" /> 업무상질병휴직</label><br>
				<label><input type="radio" id="sayou3" name="sayou" value="3" onchange="setDisplay()" /> 육아휴직<span id="sayoutxt1-title" style="margin-left:5px; display:none;">(대상 : <input type="text" id="sayoutxt1" style="margin-left:5px; width: 250px; height:25px; display:none;"> )</span></label><br>
				<label><input type="radio" id="sayou4" name="sayou" value="4" onchange="setDisplay()" /> 가족돌봄휴직<span id="sayoutxt2-title" style="margin-left:5px; display:none;">(대상 : <input type="text" id="sayoutxt2" style="margin-left:5px; width: 250px; height:25px; display:none;"> )</span></label><br>
				<label><input type="radio" id="sayou5" name="sayou" value="5" onchange="setDisplay()" /> 산전(모성보호)휴직</label><br>
				<label><input type="radio" id="sayou6" name="sayou" value="6" onchange="setDisplay()" /> 기타</label>
				<input type="text" id="sayouetc" style="width: 250px; height:25px; display:none;">
               </td>
           </tr>

		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000092_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000092_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>