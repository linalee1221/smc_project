<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 배차신청서 -->

<!-- 배차 예약시 중복예약 검사 필요함(DB필요), OCS 연동 안됨 -->

<!-- 사용 데이터베이스 : 
	 이거 세개는 Resource
	 ezSp_GetAdmSubClsTree
     ezSp_GetSubClsTree - TBLBRD
     EZSP_CheckTimeDup - TB_Schedule : 중복 체크
     
     이거 두개는 conn
     EZSP_BAECHAHESONG - TBBaeCha
     EZSP_BaeChaApproval - TBBaeCha -->
     
<!-- 라디오버튼값 중복저장 해결 22/12/29 이은송 -->

<!-- 중복체크 DB 어디서 하는지 물어봐야함. -->

<script>
	
	//현재 연월일
	var mm = new Date().getMonth()+1;
	if(mm < 10) {
		mm ="0"+mm;
	}
	var dd = new Date().getDate();
	if(dd < 10){
		dd ="0"+dd;
	}
	
	var d = new Date();
	var crtYear = d.getFullYear(); //현재 연도
	var today = crtYear+'-'+ mm +'-'+ dd;
	
	var start_reserve = "";
	var end_reserve = "";
	
	var checkTimeDupYN = "";
	
	var resId = "";
	var resName = "";

	/* datepicker */
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
			buttonImageOnly : true,
// 			onClose : function( selectedDate ) {
//                 if( selectedDate != "" ) {
//                     $("#sDate").datepicker("option", "maxDate", selectedDate);
//                 }
//             }
		});
		
		
		// 차종		
		$.ajax({
			url: '/interwork/getBaechaList.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {}
		}).success(function(data) {
	        console.log('getBaechaList', data);
	        if(data == null || data == undefined) {
		        } else {
		          var list = data.rows;
		          if(list.length == 0) {
		          } else {
		            for(var i=0; i<list.length; i++) {
		              var item = list[i];
		              $("#carid").append('<option value='+ item.PK_RES_ID +'>'+ item.RES_NAME +'</option>');
		            }
		          }
	            }
  	 	});
		
		
	});
	
	
	
	$('#FM00000070_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000070').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var date1 = $('#sDate').val().split("-");
		var date2 = $('#eDate').val().split("-");
		
		var yymmdd1 = $('#sDate').val();
		var yymmdd2 = $('#eDate').val();
		start_reserve = yymmdd1.replace(/-/gi, "")+$('#starthour').val()+$('#startmin').val()+"00";
		end_reserve = yymmdd2.replace(/-/gi, "")+$('#endhour').val()+$('#endmin').val()+"00";
		
		if ($('input[name="sayou"]:checked').val() == "") {
            alert("배차요구를 선택해 주세요.");
            return;
        }
        if (document.getElementById("sloc").value == "" || document.getElementById("eloc").value == "") {
            alert("운행구간을 입력해 주세요.");
            document.getElementById("sloc").focus();
            return;
        }
        if (document.getElementById("purpose").value == "") {
            alert("사용목적을 구체적으로 입력해 주세요.");
            document.getElementById("purpose").focus();
            return;
        }
        if (document.getElementById("carid").value == "") {
            alert("차종을 선택해 주세요.");
            return;
        }
        if (document.getElementById("leader").value == "") {
            alert("운전자를 입력해 주세요.");
            document.getElementById("leader").focus();
            return;
        }
        if (document.getElementById("cnt").value == "") {
            alert("승차인원을 입력해 주세요.");
            document.getElementById("cnt").focus();
            return;
        }

        if (!chkDate()) {
            alert("날짜 또는 시간 선택을 잘못 하였습니다. 다시 확인해 주세요.");
            return;
        }
		
		checkTimeDup();
		if(checkTimeDupYN == "Y"){
			alert("선택하신 날짜 및 시간에 중복된 예약이 있습니다.");
			return;
		}
		
		resId = $('#carid option:selected').val();
		resName = $('#carid option:selected').text();
		
		// 1. 본문에 내용 삽입
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});

        _$hwpObj.insertSignData('제목', '배차신청서 (' + HGW_APPR_BANK.loginVO.user_emp_id + ', ' + HGW_APPR_BANK.loginVO.user_nm + ', ' + HGW_APPR_BANK.loginVO.dept_nm + ')');

		_$hwpObj.insertSignData('v_draftername', HGW_APPR_BANK.loginVO.user_nm);
//			_$hwpObj.insertSignData('v_position', HGW_APPR_BANK.loginVO.memb_postion);
		_$hwpObj.insertSignData('v_userid', HGW_APPR_BANK.loginVO.user_emp_id);
		_$hwpObj.insertSignData('v_department', HGW_APPR_BANK.loginVO.dept_nm);
		_$hwpObj.insertSignData('v_departmentcd', HGW_APPR_BANK.loginVO.dept_id);
		
		_$hwpObj.insertSignData('startdate', $('#sDate').val());
		_$hwpObj.insertSignData('enddate', $('#eDate').val());
		_$hwpObj.insertSignData('starthour', $('#starthour').val());
		_$hwpObj.insertSignData('endhour', $('#endhour').val());
		_$hwpObj.insertSignData('startmin', $('#startmin').val());
		_$hwpObj.insertSignData('endmin', $('#endmin').val());
		
		_$hwpObj.insertSignData('sloc', $('#sloc').val());
		_$hwpObj.insertSignData('eloc', $('#eloc').val());
        
		_$hwpObj.insertSignData('기안부서', HGW_APPR_BANK.loginVO.dept_nm); // 소속
		_$hwpObj.insertSignData('v_position', HGW_APPR_BANK.loginVO.memb_postion); // 직급
		_$hwpObj.insertSignData('v_draftername', HGW_APPR_BANK.loginVO.user_nm); // 기안자
		
		// 배차요구
		if($('input[name="sayou"]:checked').val() == '1'){
			_$hwpObj.insertSignData('sayou1', 'O');	
			_$hwpObj.deleteSignData('sayou2');	
		} else if($('input[name="sayou"]:checked').val() == '2'){
			_$hwpObj.insertSignData('sayou2', 'O');	
			_$hwpObj.deleteSignData('sayou1');	
		}
		
		// 사용기간
		_$hwpObj.insertSignData('gigan', date1[0] + '년 ' + date1[1] + '월 ' + date1[2] + '일 ' + $('#starthour').val() + '시 ' + $('#startmin').val() + '분 ~ '
								+ date2[0] + '년 ' + date2[1] + '월 ' + date2[2] + '일 ' + $('#endhour').val() + '시 ' + $('#endmin').val() + '분');
		
		
		_$hwpObj.insertSignData('purpose', $('#purpose').val()); // 사용목적
		_$hwpObj.insertSignData('carname', $('#carid option:selected').text()); // 차종
		_$hwpObj.insertSignData('leader', $('#leader').val()); // 운전자
		_$hwpObj.insertSignData('cnt', $('#cnt').val()); // 승차인원
		
        var legacydata = [];
		// 2. 데이터 저장
		legacydata.push({
		    PK_RESERVE_ID		: '',
        	FK_RES_ID			: resId,
        	RESERVATION_PURPOSE : $('#purpose').val(),
        	RESERVATION_START	: start_reserve,
        	RESERVATION_END		: end_reserve,        
        	CONTENTS			: $('#purpose').val(),
        	USER_ID				: HGW_APPR_BANK.loginVO.user_id,
        	DEPT_NM				: HGW_APPR_BANK.loginVO.dept_nm,        
        	APPROVED_STATUS		: 'Y',
        	RESERVE_DATE		: today,
        	ATTEND_INFO			: '',
        	REPEAT_ID			: '',
        	ALL_DAY				: 'N',
        	DEPT_ID				: HGW_APPR_BANK.loginVO.dept_id
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		$('#gw_sp_dialog').dialog('close');
	});
	
	function chkDate() {
        var pSTime = document.getElementById("sDate").value + " " + document.getElementById("starthour").value + ":" + document.getElementById("startmin").value + ":00";
        var pETime = document.getElementById("eDate").value + " " + document.getElementById("endhour").value + ":" + document.getElementById("endmin").value + ":00";

        if (pSTime >= pETime)
            return false;
        else
            return true;
    }
	
	function checkTimeDup(){
		checkTimeDupYN = "";
		var yymmdd1 = $('#sDate').val();
		var yymmdd2 = $('#eDate').val();
		start_reserve = yymmdd1.replace(/-/gi, "")+$('#starthour').val()+$('#startmin').val()+"00";
		end_reserve = yymmdd2.replace(/-/gi, "")+$('#endhour').val()+$('#endmin').val()+"00";
		
		$.ajax({
			url: '/interwork/checkTimeDup.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'user_emp_id': HGW_APPR_BANK.loginVO.user_emp_id,
				'start_date': start_reserve,
				'end_date': end_reserve
			}
		}).success(function(data) {
	        console.log('checkTimeDup', data);
	        if(data == null || data == undefined) {
		        } else {
		          var list = data.rows;
		          
		          if(list.length == 0) {
		          } else {
		        	  checkTimeDupYN = "Y";
		          }
	            }
	  	 });
	}
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000070_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<style>
	/* datepicker 아이콘 input박스에서 조금 떨어뜨림 */
	img.ui-datepicker-trigger {
		margin-left: 8px;
	}
</style>

<form id="FORM_FM00000070">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr style="display:none">
				<th style="width:15%">소속</th>
				<td style="width:35%">${loginVO.dept_nm}</td>
				<th style="width:15%">직명</th>
				<td style="width:35%">${loginVO.memb_postion}</td>
			</tr>
	
			<tr style="display:none">
				<th style="width:15%">성명</th>
				<td style="width:35%" id="UserNM">${loginVO.user_nm}</td>
				<th style="width:15%">사번</th>
				<td style="width:35%" id="UserID">${loginVO.user_emp_id}</td>
			</tr>
			
			<tr>
				<th style="width:10%;" class="radius-th">배차요구</th>
					<td style="width:90%;" colspan="4">
						<label><input type="radio" id="Radio1" name="sayou" value="1" style="margin-right: 5px;" />업무용</label> 
						<label style="margin-left: 10px;"><input type="radio" id="Radio2" name="sayou" value="2" style="margin-right: 5px;" />기타용</label>
					</td>
			</tr>
			
			<tr>
				<th>사용기간</th>
				<td colspan="2">
					<input type="text" name="sDate" id="sDate" title="시작일" style="width: 90px; height: 25px;" readonly> 
						<select style="height: 25px;" id="starthour">
							<option value="01">01</option>
							<option value="02">02</option>
							<option value="03">03</option>
							<option value="04">04</option>
							<option value="05">05</option>
							<option value="06">06</option>
							<option value="07">07</option>
							<option value="08">08</option>
							<option value="09">09</option>
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
						<select style="height: 25px;" id="startmin">
							<option value="00">00</option>
							<option value="30">30</option>
						</select> 
					<span>분 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;~</span>
				</td>
	
				<td colspan="2">
					<input type="text" name="eDate" id="eDate" title="종료일" style="width: 90px; height: 25px;" readonly> 
						<select style="height: 25px;" id="endhour">
							<option value="01">01</option>
							<option value="02">02</option>
							<option value="03">03</option>
							<option value="04">04</option>
							<option value="05">05</option>
							<option value="06">06</option>
							<option value="07">07</option>
							<option value="08">08</option>
							<option value="09">09</option>
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
					<span> 시</span> 
						<select style="height: 25px;" id="endmin">
							<option value="00">00</option>
							<option value="30">30</option>
						</select> 
					<span> 분</span>
				</td>
			</tr>
			
			<tr>
				<th rowspan="3">운행구간</th>
				<th colspan="2">출발</th>
				<th colspan="2" style="border-right: none;">도착(지역명 / 기관명)</th>
			</tr>
			
			<tr>
				<td colspan="2" style="border: 1px solid #dbdbdb;">
					<input id="sloc" value="서울의료원" type="text" style="height: 25px;">
				</td>
				<td colspan="2">
					<input id="eloc" type="text" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<td style="width: 100%;" colspan="4">
					<span style="color: gray;"><i>예제) 출발 : 서울의료원 ~ 도착 : 중랑구 서울의료원</i></span>
				</td>
			</tr>
			
			<tr>
				<th scope="row" rowspan="3">사용목적<br>(구체적으로)</th>
				<td style="width: 100%;" colspan="4">
					<textarea id="purpose" style="height: 8em; resize: none;"></textarea>
				</td>
			</tr>
			
			<tr></tr>
			<tr></tr>
			<tr></tr>
			
			<tr>
				<th>차종</th>
				<td colspan="4">
					<select style="height: 25px;" id="carid" name="carid">
						<option value="" selected>선택하세요</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th>운전자</th>
					<td colspan="2" style="width: 100%;"><input type="text" style="height: 25px;" id="leader"></td>
				<th style="width:15%;">승차인원</th>
					<td style="width: 100%;"><input type="text" style="height: 25px;" id="cnt"></td>
			<tr>
			
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000070_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000070_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>