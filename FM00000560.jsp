<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 노동이사 활동 신청서 -->
<!-- EZSP_HUGACODE2 - VW_PPE_GW_INTERFACE42(DB에 없음... ??) - PR_PPE_INSERT_PPE0319
	 EZSP_HUGABANSONG - TBLSCHEDULE, TBHugaSchedule
	 EZSP_GETLASTLINECN - TBENDAPRLINEINFO
	 EZSP_HUGA_INSERT3  -->
<!-- OCS 연동안됨 -->
	 
<style>
	img.ui-datepicker-trigger {
	        margin-left: 4px;
	    }
</style>

<script>

var Holidays = "";
var holi_cnt = 0;
var halfDays = Number(0.5);
var jikjong = "";

var d = new Date();
var crtYear = d.getFullYear(); // 현재연도


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
		
		jikjong = response.rows[0].JIKJONG_CODE_NAME;
		
		
	});

	$(function() {
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
	
	function next() {
		$('#trused').show();
		$('#trloc').show();
		$('#trsayou').show();
		$('#FM00000560_confirm').show();
		$('#FM00000560_reset').show();
		$('#A1').show();
		
		var HugaCNT = 0;
		var totaldays = 0;
		var total_days = 0;

		getHoliday();

			var sdate = $("#sDate").val();
	    	var edate = $("#eDate").val();
	    	
//	     	var date_arr1 = sdate.split("-");
//	     	var date_arr2 = edate.split("-");
//	     	var stDate = new Date(date_arr1[0], date_arr1[1], date_arr1[2]);
//	     	var endDate = new Date(date_arr2[0], date_arr2[1], date_arr2[2]);
//	     	var btMs = endDate.getTime() - stDate.getTime() ;
//	     	var culday = btMs / (1000*60*60*24) + 1;
	    	
	    	var beforeday = document.getElementById("sDate").value.substring(0, 10);
	        var afterday = document.getElementById("eDate").value.substring(0, 10)
	        var DataSDT = new Date(beforeday.substring(0, 4), parseInt(beforeday.substring(5, 7), 10) - 1, parseInt(beforeday.substring(8, 10), 10));
	        var DataEDT = new Date(afterday.substring(0, 4), parseInt(afterday.substring(5, 7), 10) - 1, parseInt(afterday.substring(8, 10), 10));
	        var culday = Math.ceil((DataEDT - DataSDT)/24/60/60/1000);
	    	
	    	totaldays = culday + 1;
	    	
	    	
	    	var pHolidayYN = $('input[name="optHoliday"]:checked').val();
	        if (pHolidayYN == null) {
	            alert("휴일포함여부를 선택해 주세요");
	    		$('#trused').hide();
	    		$('#trloc').hide();
	    		$('#trsayou').hide();
	    		$('#FM00000560_confirm').hide();
	    		$('#FM00000560_reset').hide();
	    		$('#A1').hide();
	            return false;
	        }
	        
	        if (sdate == "") {
	            alert("기간을 다시 설정해주세요.");
	    		$('#trused').hide();
	    		$('#trloc').hide();
	    		$('#trsayou').hide();
	    		$('#FM00000560_confirm').hide();
	    		$('#FM00000560_reset').hide();
	    		$('#A1').hide();
	            return false;
	        }
	                                
	        var holiday = 0;
	        HugaCNT = 0;
	        var tmp, tmpyear = "", tmpmonth = "", tmpday = "", tmpdate = "", tmpweek = "";

	        for (var i = 0; i <= culday; i++) {
	            tmp = new Date(DataSDT);
	            tmp.setDate(tmp.getDate() + i);

	            tmpyear = String(tmp.getFullYear());
	            tmpmonth = String(tmp.getMonth() + 1);
	            tmpday = String(tmp.getDate());
	            tmpweek = String(tmp.getDay());
	            if (tmpmonth.length == 1)
	                tmpmonth = "0" + tmpmonth;
	            if (tmpday.length == 1)
	                tmpday = "0" + tmpday

	            tmpdate = tmpyear + tmpmonth + tmpday;
	            var isHoliday = false;
	            if (pHolidayYN == "N") {
	                if (Holidays.indexOf(tmpdate) > -1) {
	                    holiday++;
	                    isHoliday = true;
	                }
	                else if (tmp.getDay() == 0 || tmp.getDay() == 6) {
	                    holiday++;
	                    isHoliday = true;
	                }
	            }

	            HugaCNT++;
	      
	        }
	        
	        
	        if ($('#actHours option:selected').val() == "Y115" && $('#sDate').val() === $('#eDate').val() == true) {
	        	$("#days").val(halfDays);
	        } else if ($('#actHours option:selected').val() == "Y115" && $('#sDate').val() != $('#eDate').val() == true ) {
	        	alert("반일은 하루만 지정할 수 있습니다. 기간을 다시 설정해 주세요.");
	        	$('#trused').hide();
	    		$('#trloc').hide();
	    		$('#trsayou').hide();
	    		$('#FM00000560_confirm').hide();
	    		$('#FM00000560_reset').hide();
	    		$('#A1').hide();
	        	return false;
	        } else {
	            culday = culday + 1 - holiday;
	            $("#days").val(culday);
	        }
	} 
	
	function hide() {
		$('#trused').hide();
		$('#trloc').hide();
		$('#trsayou').hide();
		$('#FM00000560_confirm').hide();
		$('#FM00000560_reset').hide();
		$('#A1').hide();
	}
	
	function calDate() {
		var HugaCNT = 0;
		var totaldays = 0;
		var total_days = 0;

		var sdate = $("#sDate").val();
    	var edate = $("#eDate").val();
    	
    	var beforeday = document.getElementById("sDate").value.substring(0, 10);
        var afterday = document.getElementById("eDate").value.substring(0, 10)
        var DataSDT = new Date(beforeday.substring(0, 4), parseInt(beforeday.substring(5, 7), 10) - 1, parseInt(beforeday.substring(8, 10), 10));
        var DataEDT = new Date(afterday.substring(0, 4), parseInt(afterday.substring(5, 7), 10) - 1, parseInt(afterday.substring(8, 10), 10));
        var culday = Math.ceil((DataEDT - DataSDT)/24/60/60/1000);
	    	
	    	totaldays = culday + 1;
	    	
	    	var pHolidayYN = $('input[name="optHoliday"]:checked').val();
	        if (pHolidayYN == "") {
	            alert("휴일포함여부를 선택해 주세요.");
	            return false;
	        }
	                                
	        var holiday = 0;
	        HugaCNT = 0;
	        var tmp, tmpyear = "", tmpmonth = "", tmpday = "", tmpdate = "", tmpweek = "";

	        for (var i = 0; i <= culday; i++) {
	            tmp = new Date(DataSDT);
	            tmp.setDate(tmp.getDate() + i);

	            tmpyear = String(tmp.getFullYear());
	            tmpmonth = String(tmp.getMonth() + 1);
	            tmpday = String(tmp.getDate());
	            tmpweek = String(tmp.getDay());
	            if (tmpmonth.length == 1)
	                tmpmonth = "0" + tmpmonth;
	            if (tmpday.length == 1)
	                tmpday = "0" + tmpday

	            tmpdate = tmpyear + tmpmonth + tmpday;
	            var isHoliday = false;
	            if (pHolidayYN == "N") {
	                if (Holidays.indexOf(tmpdate) > -1) {
	                    holiday++;
	                    isHoliday = true;
	                }
	                else if (tmp.getDay() == 0 || tmp.getDay() == 6) {
	                    holiday++;
	                    isHoliday = true;
	                }
	            }

	            HugaCNT++;
	      
	        }
	        
	        culday = culday + 1 - holiday;
            $("#days").val(culday);
	        
	}
	
	// 활동시간 종일, 반일
	$.ajax({
		url: '/interwork/getActHours.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {}
	}).success(function(data) {
        console.log('getActHours', data);
        if(data == null || data == undefined) {
	        } else {
	          var list = data.rows;
	          if(list.length == 0) {
	          } else {
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              $("#actHours").append('<option value='+ item.SUB_CODE +'>'+ item.SUB_CODE_NAME +'</option>');
	            }
	          }
            }
  	 });
	
	// 총 개수 가져오기
	var totIlsu = 0; 
	getIlsuCnt = function(){
		totIlsu = Number(0);
		$.ajax({
			url: '/interwork/getIlsuCnt.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'user_emp_id' : HGW_APPR_BANK.loginVO.user_emp_id
			}
		}).success(function(response) {
			console.log('활동 총 개수 : ',response);
			if(response == null || response == undefined) {
          	alert("데이터가 없습니다.")
	        } else {
	          var list = response.rows;
	          
	          if(list.length == 0) {
	        	  //alert("휴가 정보가 없습니다.")
	          } else {
	        	
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	             totIlsu = Number(item.ILSU);
	             
	             console.log("개수? : ", totIlsu);
	             
	             $('#totIlsu').text(totIlsu);
	             }
	            }
	          }
		});
	}

	// 사용일 가져오기
	var usedIlsu = 0; 
	getUsedIlsuCnt = function(){
		usedIlsu = Number(0);
		$.ajax({
			url: '/interwork/getUsedIlsuCnt.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'user_emp_id' : HGW_APPR_BANK.loginVO.user_emp_id,
				'year': crtYear //crtYear
			}
		}).success(function(response) {
			console.log('활동 사용일 : ',response);
			if(response == null || response == undefined) {
          	alert("데이터가 없습니다.")
	        } else {
	          var list = response.rows;
	          
	          if(list.length == 0) {
	        	  //alert("휴가 정보가 없습니다.")
	          } else {
	        	
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              usedIlsu = Number(item.ILSU);
	             
	             console.log("개수? : ", usedIlsu);
	             
	             $('#usedIlsu').text(usedIlsu);
	             }
	            }
	          
	          $('#remainhugatxt').text(totIlsu-usedIlsu);
	          console.log("잔여일 : ", totIlsu-usedIlsu)
	          }
		});
	}
	
	//휴일포함여부
	getHoliday = function(){
		console.log($("#sDate").val());
		console.log($("#eDate").val());
		$.ajax({
			url: '/interwork/getHoliday.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'start_date': $("#sDate").val(),
				'end_date': $("#eDate").val()
			}
		}).success(function(data) {
	        console.log('getHoliday', data);
	        if(data == null || data == undefined) {
	        } else {
	          var list = data.rows;
	          holi_cnt = list.legnth;
	          if(list.length == 0) {
	          } else {
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              Holidays += item.YYYYMMDD+";";
	            }
	          }
            }
	  	 });
	}
	


	$("#actGubun").change(function(){
			
		var optionVal = $("#actGubun option:selected").val();
		
		// 구분>활동시간 선택 시
		if(optionVal == '1'){
			$('#actHours').show();
		}
		else {
			$('#actHours').hide();
			$('.act').hide();
		}
	});
	
	$("#actHours").change(function(){
		
		var optionVal = $("#actHours option:selected").val();
		 
		// 구분>활동시간 선택 시
		if(optionVal == 'Y115'){
			$('#actGubun2').show();
			$('.act').show();
		}
		else if(optionVal == 'Y110'){
			$('#actGubun2').hide();
			$('.act').show();
		} else{
			$('#actGubun2').hide();
			$('.act').hide();
		}
		getIlsuCnt();
		getUsedIlsuCnt();
	});
	
	$('#FM00000560_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000560').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var date1 = $('#sDate').val().split("-");
		var date2 = $('#eDate').val().split("-");
		var legacydata = [];
		
		var ampm = "";
		if($('#actHours option:selected').val() == 'Y115' && $('#actGubun2 option:selected').val() == "am") {
			ampm = "A";
		} else if($('#actHours option:selected').val() == 'Y115' && $('#actGubun2 option:selected').val() == "pm") {
			ampm = "P";
		} else {
			ampm = "*";
		}
		
		var holiday ="";
		if($('input[name="optHoliday"]:checked').val() == 'Y') {
			holiday = "Y";
		} else {
			holiday = "N";
		}
		
		var guntae = "15";
		
		
		
		// 1. 데이터 저장
		legacydata.push({
			I_USER_ID      : HGW_APPR_BANK.loginVO.user_emp_id,
			I_YMD          : $('#sDate').val(),
			I_SABUN        : HGW_APPR_BANK.loginVO.user_emp_id,
			I_GUNTAE_GUBUN : guntae,
			I_HYUGA_ILSU   : $('#days').val(),
			I_HOLIDAY_YN   : holiday,
			I_REMARK       : '',
			I_IF_DOCID     : '',
			I_KYULJE_YMD   : '',
			I_AMPM_GUBUN   : ampm,
			I_PAY_YN       : '*',
			I_GUNMU_YMD    : ''
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		
        if (document.getElementById("actHours").value == "Y115" && $('#sDate').val() != $('#eDate').val() == true) {
            if ($('#days').val() > 1 == true) {
                alert("반일는 하루만 지정할 수 있습니다. 기간을 다시 설정해 주세요.");
                return;
            }
        }
		
		
		
		if ($('input[name="optHoliday"]:checked').val() == null) {
			alert("휴일포함여부를 선택해 주세요.");
            return;
		} 
		
		if (document.getElementById("sayou").value == "") {
            alert("장소를 입력해 주세요.");
            document.getElementById("sayou").focus();
            return;
        }
		
        if (document.getElementById("location").value == "") {
            alert("사유를 입력해 주세요.");
            document.getElementById("location").focus();
            return;
        }
		
		// 3. validation check 후 기안기에 내용 입력
		// 소속 : v_department, 직종 : jikjong, 성명 : v_draftername, 사번 : v_userid
		// 구분 : hugatxt, 기간 - 년 : startyear, 월 : startmonth, 일 : startday
		//						  년 : endyear, 월 : endmonth, 일 : endday, 일간 : hugaday
		// 장소 : huga_location
		// 사유 : huga_sayou
		// 기안일자 : daftdate

		var _$hwpObj = HGW_hdlr.rtnObj(1);
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		_$hwpObj.insertSignData('v_department', HGW_APPR_BANK.loginVO.dept_nm); // 소속
		_$hwpObj.insertSignData('jikjong', jikjong); // 직종
		_$hwpObj.insertSignData('v_draftername', HGW_APPR_BANK.loginVO.user_nm); // 성명
		_$hwpObj.insertSignData('v_userid', HGW_APPR_BANK.loginVO.user_emp_id); // 사번
		
		// 구분		
		if ($('#actGubun option:selected').val() == '1' && $('#actHours option:selected').val() == 'Y110') {
			_$hwpObj.insertSignData('hugatxt', $('#actHours option:selected').text());
		}
		if ($('#actGubun option:selected').val() == '1' && $('#actHours option:selected').val() == 'Y115') {
			if ($('#actGubun2 option:selected').val() == 'am') {
				_$hwpObj.insertSignData('hugatxt', $('#actGubun2 option:selected').text());
			} else if ($('#actGubun2 option:selected').val() == 'pm') {
				_$hwpObj.insertSignData('hugatxt', $('#actGubun2 option:selected').text());
			}
		}
		
		// 기간 - 년 : startyear, 월 : startmonth, 일 : startday
		//		  년 : endyear, 월 : endmonth, 일 : endday, 일간 : hugaday, 
		_$hwpObj.insertSignData('startyear', date1[0]);
		_$hwpObj.insertSignData('startmonth', date1[1]);
		_$hwpObj.insertSignData('startday', date1[2]);
		_$hwpObj.insertSignData('endyear', date2[0]);
		_$hwpObj.insertSignData('endmonth', date2[1]);
		_$hwpObj.insertSignData('endday', date2[2]);
		_$hwpObj.insertSignData('hugaday', $("#days").val());
		
		// 장소 : huga_location
		_$hwpObj.insertSignData('huga_location', $("#location").val());
		
		// 사유 : huga_sayou
		_$hwpObj.insertSignData('huga_sayou', $("#sayou").val());
		
		_$hwpObj.insertSignData('daftdate', new Date().hgwDateFormat('yyyy 년 MM 월 dd 일')); // 기안일자
		
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000560_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<form id="FORM_FM00000560">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>

			<tr>
				<!-- 소속 -->
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">소속</label></th>
				<td data-hgwtype="public">
					<c:out value="${loginVO.dept_nm}" escapeXml="false"/>
				</td>
				<!-- 직위 -->
				<th scope="row" class="lln"><label for="htmlEditorLyr_7">직명</label></th>
				<td>
					<c:out value="${loginVO.memb_postion}" escapeXml="false"/>
				</td>
			</tr>
			<tr>
				<!-- 성명 -->
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">성명</label></th>
				<td data-hgwtype="public">
					<c:out value="${loginVO.user_nm}" escapeXml="false"/>
				</td>
				<%-- 사번 --%>
				<th class="lln" scope="row"><label for="htmlEditorLyr_1">사번</label></th>
				<td class="lln">
					<c:out value="${loginVO.user_emp_id}" escapeXml="false"/>
				</td>
			</tr>
			<tr>
				<td data-hgwtype="public" colspan="4">
					* 구분을 선택해 주세요.
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">구분</label></th>
				<td data-hgwtype="public" colspan="3">
					<select id="actGubun" name="actGubun" style="float:left; width: 32%; height:25px; margin-right: 5px;">
						<option value="0" selected>선택하세요</option>
						<option value="1" >활동시간</option>
					</select>
					<select id="actHours" name="actHours" class="frm_select" style="width:32%; float:left; height:25px; margin-right: 5px; display:none;">
						<option value="" selected>선택하세요</option>
					</select>
					<select id="actGubun2" name="actGubun2" style="width:32%; height:25px; float:left; display:none">
						<option value="am" >[반일] 오전</option>
						<option value="pm" >[반일] 오후</option>
					</select>
				</td>		
			</tr>
			<tr class="act" style="display:none;">
				<th data-hgwtype="public" scope="row"><label for="htmlEditorLyr_1">휴일포함여부</label></th>
				<td colspan="3">
					<input type="radio" id="optHoliday1" name="optHoliday" class="input_radio" value="Y" onclick="calDate()">&nbsp;휴일포함&nbsp;
					<input type="radio" id="optHoliday2" name="optHoliday" class="input_radio" value="N" onclick="calDate()">&nbsp;휴일제외
				</td>
			</tr>
			<tr class="act" style="display:none;">
				<th scope="row" class="lln">개수</th>
				<td id="totIlsu" colspan="3">
				</td>
			</tr>
			<tr class="act" style="display:none;">
				<th scope="row" class="lln">사용일</th>
				<td id="usedIlsu" colspan="3">
					
				</td>
			</tr>
			<tr class="act" style="display:none;">
				<th scope="row" class="lln">잔여일</th>
				<td id="remainhugatxt" colspan="3">
					
				</td>
			</tr>
			<tr class="act" style="display:none;">
				<td data-hgwtype="public" colspan="4">
					* 노동이사 활동 개수는 매년 12월 31일까지 근무시 개수입니다.
				</td>
			</tr>
			<tr class="act" style="display:none;">
				<td data-hgwtype="public" colspan="4">
					* 기간을 선택 후 다음 버튼을 클릭해 주세요.
				</td>
			</tr>
			<tr class="act" style="display:none;">
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">기간</label></th>
				<td data-hgwtype="public" colspan="3" class="bdRNo">
					<div>
						<input id="sDate" name="sDate" style="width:15%; height:25px;" type="text" class="form-control" readonly/>
						<span> ~&nbsp;</span>
						<input id="eDate" name="eDate" style="width:15%; height:25px;" type="text" class="form-control" readonly/>
						<button id="btn_Next" onClick ="return next()" class="btn btn-outline-dark" style="margin-left: 5px;" type="button">다음</button>
					</div>							
				</td>
			</tr>
			
			<tr id="trused" style="display:none">
		        <th style="width:15%;">일수</th>
		        <td style="width:85%;" colspan="3"><input type="text" id="days" style="width:50px; height:25px;" readonly /> 일</td>
		    </tr>
		    <tr id="trloc" style="display:none">
		        <th style="width:15%;">장소</th>
		        <td style="width:85%;" colspan="3"><input type="text" id="location" style="width:100%; height:25px;" /></td>
		    </tr>
		    <tr id="trsayou" style="display:none">
		        <th style="width:15%; border-bottom: none;">사유</th>
		        <td style="width:85%; border-bottom: none;" colspan="3"><input type="text" id="sayou" style="width:100%; height:25px;" /></td>
		    </tr>
		    
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" style="display:none;" id="FM00000560_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" style="display:none; margin-right: 4px;" onClick="return hide()" id="A1" class="btn_large_basic_setting btn_large_normal_box">다시입력</button>
		<button type="button" style="display:none;" id="FM00000560_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>