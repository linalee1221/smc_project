<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 노동이사 활동 취소 신청서 -->
<!-- 기안자가 신청한 활동 검색 후 출력해야 함 -->

<!-- EZSP_HUGACODE2 - VW_PPE_GW_INTERFACE42
	 EZSP_GETLASTLINECN - TBENDAPRLINEINFO
	 EZSP_HUGA_INSERT3 - PR_PPE_INSERT_PPE0319
	 EZSP_DELETESCHEDULEHUGA - TBLSCHEDULE
	 EZSP_HUGAUSE6 - VW_PPE_GW_INTERFACE45 -->
	 
<script>

var code = "";	
var if_docid = "";
var cnt1 = 0;
var cnt2 = 0;

var html = '';

var v_department = "";
var jikjong = "";
var v_draftername = "";
var v_userid = "";
var hugatxt = "";
var gigan = "";
var huga_ilsu = "";
var holiday = "";
var AMPMTXT = "";
var ymd = "";
	 
var d = new Date();
var crtYear = d.getFullYear(); //현재 연도
console.log("현재연도는? :: ", crtYear);

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
		
		v_department = response.rows[0].DESCRIPTION;
		jikjong = response.rows[0].JIKJONG_CODE_NAME+response.rows[0].JIKGEUB_CODE_NAME;
		v_draftername = response.rows[0].DISPLAYNAME;
		
		
		
	});
	
	$(function() {
		
		// 노동이사 활동 신청 목록
		$.ajax({
			url: '/interwork/getLaborActList.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'user_emp_id': HGW_APPR_BANK.loginVO.user_emp_id,
				'year': crtYear  
			}
		}).success(function(data) {
	        console.log('getLaborActList???? : ', data);
	        if(data == null || data == undefined) {
		        } else {
		          var list = data.rows;
		          
		          cnt1 = list.length;
		          
		          if(list.length == 0) {
		        	  html = '<tr><td colspan="5" style="border-bottom:none;"><p style="text-align:center">선택하신 휴가구분에 취소 가능한 휴가가 없습니다.</p></td></tr>';
		        	  $("#strhtml").append(html);
		          } else {
		            for(var i=0; i<list.length; i++) {
		              var item = list[i];
		              
		              AMPMTXT = item.AMPM_GUBUN;
		              
		              if (AMPMTXT == "A")
		                  AMPMTXT = "오전";
		              else if (AMPMTXT == "P")
		                  AMPMTXT = "오후";          
		              else if (AMPMTXT = "*") {
		                  AMPMTXT = " ";               
		              }
		              
			          v_userid = item.CN;
			          hugatxt = item.GUNTAE_GUBUN_NAME;
			          huga_ilsu = item.HYUGA_ILSU;
			          holiday = item.HOLIDAY_YN;
			          ymd = item.YMD;
			          
			          console.log("휴가일수가 몇개라고?::: ", huga_ilsu);
		              
		              html = '<tr>';
		              html += '<td style="text-align:center;width:5">';
		              html += '<input type="checkbox" name="chk" onclick="clickOnlyOne(this)" id="chk'+ i + '"/>';
		              html += '<input type="hidden" id="code' + i + '" value="' + item.GUNTAE_GUBUN + '"/>';
		              html += '<input type="hidden" id="holidayyn' + i + '" value="' + item.HOLIDAY_YN + '"/>';
		              html += '<input type="hidden" id="ampm' + i + '" value="' + item.AMPM_GUBUN + '"/>';
		              html += '<input type="hidden" id="payyn' + i + '" value="' + item.PAY_YN + '"/>';
		              html += '<input type="hidden" id="gunmu_ymd' + i + '" value="' + item.GUNMU_YMD + '"/>';
		              html += '<input type="hidden" id="if_docid' + i + '" value="' + item.IF_DOCID + '"/>';
		              html += '</td>';
		              html += '<td id="ymd'+i+'" style="text-align:center; width:30%;">'+item.YMD+'</td>';
		              html += '<td id="codenm'+i+'" style="text-align:center; width:16%;">'+item.GUNTAE_GUBUN_NAME+'</td>';
		              html += '<td id="ilsu'+i+'" style="text-align:center; width:16%;">'+item.HYUGA_ILSU+'</td>';
		              html += '<td id="ampmtxt'+i+'" style="text-align:center;width:16%;">'+AMPMTXT+'</td>';
		              html += '</tr>';
		              $("#strhtml").append(html);
		            }
		          }
	            }
	  	 });
	});
	
	
	
	function clickOnlyOne(itself){
		const checkboxes = document.getElementsByName('chk');
		checkboxes.forEach((checkbox) => {
			checkbox.checked =false;
		})
		itself.checked = true;
	}
		
	$('#FM00000561_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
		
		// 1. validation check
		
		var ymd = "";
        var guntae = "";
        var codenm = "";
        var ilsu = "";
        var holidayyn = "";
        var ampm = "";
        var payyn = "";
        var gunmu_ymd = "";
        var ampmtxt = "";

        if (document.getElementById("sayou").value == "")
        {
            alert("휴가 취소 사유를 입력해 주세요");
            document.getElementById("sayou").focus();
            return;
        }
       
        for(var i=0; i < cnt1; i++)
        {
            if (document.getElementById("chk" + i).checked == true)
            {
                ymd += document.getElementById("ymd" + i).innerHTML;
                code += document.getElementById("code" + i).value;
                codenm += document.getElementById("codenm" + i).innerHTML;
                ilsu += document.getElementById("ilsu" + i).value;
                holidayyn += document.getElementById("holidayyn" + i).value;
                ampm += document.getElementById("ampm" + i).value;
                payyn += document.getElementById("payyn" + i).value;
                gunmu_ymd += document.getElementById("gunmu_ymd" + i).value;
                ampmtxt += document.getElementById("ampmtxt" + i).innerHTML;
            }
        }
        if (code == '')
        {
            alert("취소하실 휴가를 체크 후 확인 버튼을 클릭해 주세요");
            return;
        }
        
        
		var rows = document.getElementById("strhtml").getElementsByTagName("tr");
		var msg =  '';
		
		for (var i=0; i<rows.length; i++) {
			var cells = rows[i].getElementsByTagName("td");
			var cell_1 = cells[3].firstChild.data;
			
			if($('input:checkbox[id=chk'+i+']').is(':checked') == true) {
				huga_ilsu = cell_1;
				
				
 			console.log("cells[4]의 값은??? : : :", cell_1);
 			console.log("휴가 며칠이야? :: ", huga_ilsu);
 			
 				
			}
			
		} 
   
	
		var formData = $('#FORM_FM00000561').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var legacydata = [];
		
		var guntae = "15";
	
		if (holiday == 'Y') {
			holiday = "Y"
		} else {
			holiday = "N"
		}
		
		if(AMPMTXT == "1"){
			AMPMTXT = "A"
		} else {
			AMPMTXT = "P"
		}
		
		
		
		// 2. 데이터 저장
		legacydata.push({
			I_USER_ID      : v_userid,
			I_YMD          : ymd,
			I_SABUN        : HGW_APPR_BANK.loginVO.user_emp_id,
			I_GUNTAE_GUBUN : guntae,
			I_HYUGA_ILSU   : huga_ilsu,
			I_HOLIDAY_YN   : holiday,
			I_REMARK       : '',
			I_IF_DOCID     : '',
			I_KYULJE_YMD   : '',
			I_AMPM_GUBUN   : AMPMTXT,
			I_PAY_YN       : '',
			I_GUNMU_YMD    : ''
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		
		// 3. validation check 후 기안기에 내용 입력
		// 소속 : v_department, 직명 : jikjong, 성명 : v_draftername, 사번 : v_userid
		// 구분 : hugatxt, 취소기간 : gigan, 취소사유 : huga_sayou, 비고 : huga_detail
		// 기안일자 : 기안일자
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		_$hwpObj.insertSignData('v_department', v_department);
		_$hwpObj.insertSignData('jikjong', jikjong);
		_$hwpObj.insertSignData('v_draftername', v_draftername);
		_$hwpObj.insertSignData('v_userid', v_userid);
		_$hwpObj.insertSignData('hugatxt', hugatxt);
		_$hwpObj.insertSignData('gigan', ymd);
		_$hwpObj.insertSignData('huga_sayou', $('#sayou').val());
		
		_$hwpObj.insertSignData('daftdate', new Date().hgwDateFormat('yyyy 년 MM 월 dd 일')); // 기안일자
		


		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
		
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000561_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
			
	function formatDate(date) {
	    
	    var d = new Date(date),
	    
	    month = '' + (d.getMonth() + 1) , 
	    day = '' + d.getDate(), 
	    year = d.getFullYear();
	    
	    if (month.length < 2) month = '0' + month; 
	    if (day.length < 2) day = '0' + day; 
	    
	    return [year, month, day].join('-');
	    
	 }
		  
	
</script>

<form id="FORM_FM00000561">
<span>* 취소사유 입력 및 취소하실 휴가를 체크 후 확인 버튼을 클릭해 주세요</span>
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr>
				<th>취소사유</th>
					<td colspan="6">
						<input type="text" style="height:25px;" id="sayou">
					</td>
			</tr>
			
			<tr>
				<th style="border-bottom:none;">휴가구분</th>
					<td colspan="6" style="border-bottom:none;">
				 		<select style="height:25px;" id="hugakind">
				 			<option value="15">활동시간</option>
				 		</select>
					</td>
			</tr>
		</table>
	</div>
			
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
		
			<tr>
				<th style="width:10%;"></th>
				<th style="width:30%;">휴가일</th>
				<th style="width:16%;">휴가구분</th>
				<th style="width:16%;">기간</th>
				<th style="width:16%; border-right:none;">반차구분</th>
			</tr>
			
			<tbody id="strhtml" style="width:99%">
			</tbody>

		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000561_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000561_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>