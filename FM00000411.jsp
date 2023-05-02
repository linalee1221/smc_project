<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 외부강의·회의등 취소신청 -->
<!-- EZSP_CANCELLECTURE_INSERT - PR_PHC_CANCEL_PHC5000
	 VW_PPE_GW_INTERFACE40 -->


<style>

#FORM_FM00000411 {
	min-height: 404px !important;
	max-height: 500px !important;
	overflow-y: auto !important;
	margin-bottom: 10px;
}

</style>
	
<script>

var code = "";	
var if_docid = "";
var cnt1 = 0;
var cnt2 = 0;

var html = '';

var sabun = "";
var userNM = "";
var jikwi = "";
var buseo = "";
var gunmuji = "";
var lecturetype = "";
var acttype = "";
var datetext = "";
var sigan = "";
var amt = "";


$(function() {
	
	// 외부강의·회의신청 목록
	$.ajax({
		url: '/interwork/getLectureList.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {
			'user_emp_id': HGW_APPR_BANK.loginVO.user_emp_id
		}
	}).success(function(data) {
        console.log('getLectureList???? : ', data);
        if(data == null || data == undefined) {
	        } else {
	          var list = data.rows;
	          
	          cnt1 = list.length;
	          
	          sabun = data.rows[0].SABUN;
	          userNM = data.rows[0].SABUN_NAME_K;
	          jikwi = data.rows[0].JIKWI_CODE_NAME;
	          buseo = data.rows[0].BUSEO_CODE_NAME;
	          gunmuji = data.rows[0].GUNMUJI_CODE_NAME;
	          lecturetype = data.rows[0].TYPE;
	          acttype = data.rows[0].ACT_TYPE;
	          sigan = data.rows[0].SIGAN;
	          amt = data.rows[0].AMT;
	          
	          if(list.length == 0) {
	        	  html = '<tr><td colspan="4"><p style="text-align:center">취소 가능한 외부강의 회의등 신고서가 없습니다.</p></td></tr>';
	        	  $("#strhtml").append(html);
	          } else {
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              
	              
	              datetext = item.YMD+' '+ item.START_TIME.substring(0, 2) + ':'+item.START_TIME.substring(2, 4)+ ' ~ ' + item.END_TIME.substring(0, 2) +':' +item.END_TIME.substring(2, 4);
	              
	              
	              console.log('기간?? :: ', datetext);
	              
	              html = '<tr>';
	              html += '<td style="text-align:center;width:5">';
	              html += '<input type="radio" name="chk" id="chk'+ i + '" onclick="pknrs_checked(' + i + ')"/>';
	              html += '<input type="hidden" id="pknrs' + i + '" value="' + item.PKPHC5000 + '"/>';
	              html += '<input type="hidden" id="cancelpknum' + i + '" value="' + item.CANCEL_PKPHC5000 + '" />';
	              html += '<input type="hidden" id="sabun' + i + '" value="' + item.SABUN + '" />';
	              html += '<input type="hidden" id="sabunName' + i + '" value="' + item.SABUN_NAME_K + '" />';
	              html += '<input type="hidden" id="buseoCode' + i + '" value="' + item.BUSEO_CODE_NAME + '" />';
	              html += '<input type="hidden" id="jikwiCode' + i + '" value="' + item.JIKWI_CODE_NAME + '" />';
	              html += '<input type="hidden" id="gunmujiName' + i + '" value="' + item.GUNMUJI_CODE_NAME + '" />';
	              html += '<input type="hidden" id="payYn' + i + '" value="' + item.PAY_YN + '" />';
	              html += '<input type="hidden" id="type' + i + '" value="' + item.TYPE + '" />';
	              html += '<input type="hidden" id="actType' + i + '" value="' + item.ACT_TYPE + '" />';
	              html += '<input type="hidden" id="ymd' + i + '" value="' + item.YMD + '" />';
	              html += '<input type="hidden" id="startTime' + i + '" value="' + item.START_TIME + '" />';
	              html += '<input type="hidden" id="endTime' + i + '" value="' + item.END_TIME + '" />';
	              html += '<input type="hidden" id="sigan' + i + '" value="' + item.SIGAN + '" />';
	              html += '<input type="hidden" id="amt' + i + '" value="' + item.AMT + '" />';
	              html += '<input type="hidden" id="predocid' + i + '" value="' + item.IF_DOCID + '" />';
	              html += '</td>';
	              html += '<td colspan="4" id="actYmd'+i+'" style="text-align:center;">'+item.ACT_TYPE+'</td>';
	              html += '<td id="worktime'+i+'" style="text-align:center;width:20%">'+datetext+'</td>';
	              html += '</tr>';
	              $("#strhtml").append(html);
	            }
	          }
            }
  	 });
});

	
	$('#FM00000411_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var cnt = 0;
		var k = 1;
		var pkppe = 0;
		
		for(var i=0; i < cnt1; i++) {
            if (document.getElementById("chk" + i).checked == true)
            {
                pkppe = document.getElementById("pknrs" + i).value;
                k++;
            }
        }
		
		$(document).on("change","input[name='chk']", function(){
			var k='';
			for(var i=0; i < cnt1; i++) {
				if ($('input[id="chk'+i+'"]:checked').val() == 'on') {
	            	k = i;
	            } else {
	            	code = "";
	            } 	            	
			}
			pknrs_checked(k);
		});
		
		function pknrs_checked(k) {					        
	        for (var i = 0; i < cnt1; i++) {
	            if (i != k) {
	                document.getElementById("chk" + i).checked = false;
	            }
	            else {
	                if (document.getElementById("chk" + i).checked) {
	                    code = document.getElementById("pknrs" + i).value;
	                }
	            }
	        }
	    }
		
		for(var i=0; i < cnt1; i++) {
            if ($('input[id="chk1"]').is(':checked') == true) {
                code = document.getElementById("pknrs" + i).value;
                cancelpknum = document.getElementById("cancelpknum" + i).value;
                sabun = document.getElementById("sabun" + i).value;
                sabunName = document.getElementById("sabunName" + i).value;
                buseoCode = document.getElementById("buseoCode" + i).value;
                jikwiCode = document.getElementById("jikwiCode" + i).value;
                gunmujiName = document.getElementById("gunmujiName" + i).value;
                payYn = document.getElementById("payYn" + i).value;
                type = document.getElementById("type" + i).value;
                actType = document.getElementById("actType" + i).value;
                ymd = document.getElementById("ymd" + i).value;
                startTime = document.getElementById("startTime" + i).value;
                endTime = document.getElementById("endTime" + i).value;
                sigan = document.getElementById("sigan" + i).value;
                amt = document.getElementById("amt" + i).value;
                predocid = document.getElementById("predocid" + i).value;
                actYmd = document.getElementById("actYmd" + i).value;
                worktime = document.getElementById("worktime" + i).value;
                
                break;
            }
        }
		
		// 1. validation check
		if (document.getElementById("sayou").value == "") {
            alert("취소 사유를 입력해 주세요");
            document.getElementById("sayou").focus();
            return;
        }
		
        if (code == '')
        {
            alert("취소하실 외부강의 회의를 한개만 체크 후 확인 버튼을 클릭해 주세요");
            return;
        }
        if (k > 2) {
            alert("취소하실 외부강의 회의를 한개만 체크 후 확인 버튼을 클릭해 주세요");
            return;
        }
		
		
		
		var formData = $('#FORM_FM00000411').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var docid = "";
		
		
		// 3. validation check 후 기안기에 내용 입력
		// 인적사항 - 사번 : 기안자사번, 성명 : 기안자, 직위 : draftposition, 부서 : 기안부서, 근무지 : gunmuji
		// 외부강의 회의유형 : lecturetype
		// 활동유형 : acttype
		// 취소사유 : sayou
		// 일시 : datetext
		// 강의시간 : sigantext
		// 사례금 : amt
		// 기안일자 : 기안일자
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});

		_$hwpObj.insertSignData('if_docid', if_docid);
		_$hwpObj.insertSignData('pkppe', code);
		
 		_$hwpObj.insertSignData('기안자사번', sabun);
 		_$hwpObj.insertSignData('기안자', userNM);
		_$hwpObj.insertSignData('draftposition', jikwi);
		_$hwpObj.insertSignData('기안부서', buseo);
		_$hwpObj.insertSignData('gunmuji', gunmuji);
		
		_$hwpObj.insertSignData('lecturetype', lecturetype);
		_$hwpObj.insertSignData('acttype', acttype);
	
		_$hwpObj.insertSignData('sayou', $('#sayou').val()); 
		
		
		
		var dateTime = "";
		var rows = document.getElementById("strhtml").getElementsByTagName("tr");
		var msg =  '';
		
		for (var i=0; i<rows.length; i++) {
			var cells = rows[i].getElementsByTagName("td");
			var cell_1 = cells[2].firstChild.data;
			
			
			if($('input:radio[id=chk'+i+']').is(':checked') == true) {
				dateTime = cell_1;
				}
				
 			console.log("cells[2]의 값은??? : : :", cell_1);
 			console.log("dateTime의 값은???: : : : : ", dateTime);
 			
 			
 			msg = dateTime;
 				
			}
		
		_$hwpObj.insertSignData('datetext', msg);
		_$hwpObj.insertSignData('sigantext', sigan);
		_$hwpObj.insertSignData('amt', amt);
		
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));
		
		var legacydata = [];
		
		// 2. 데이터 저장
 		legacydata.push({
 			I_CANCEL_PKPHC5000 : code,
			I_IF_DOCID         : docid,
			O_FLAG             : ''
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000411_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
	$(document).on("change","input[name='chk']", function(){
		var k='';
		for(var i=0; i < cnt1; i++) {
			if ($('input[id="chk'+i+'"]:checked').val() == 'on') {
            	k = i;
            } else {
            	code = "";
            } 	            	
		}
		pknrs_checked(k);
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
		
	function pknrs_checked(k) {					        
        for (var i = 0; i < cnt1; i++) {
            if (i != k) {
                document.getElementById("chk" + i).checked = false;
            }
            else {
                if (document.getElementById("chk" + i).checked) {
                    code = document.getElementById("pknrs" + i).value;
                }
            }
        }
	}
    
</script>

<form id="FORM_FM00000411">
	<span>* 취소사유 입력 및 취소하실 외부강의 회의를 체크 후 확인 버튼을 클릭해 주세요.</span>
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr>
				<th style="border-bottom: none; width: 10%;">취소사유</th>
					<td colspan="6" style="border-bottom: none;">
						<input type="text" id="sayou" style="height:25px;" class="edu-cancel">
					</td>
			</tr>

			</table>
		</div>

		<div class="tablewrap-line" style="overflow: visible; margin-top: 10px;">
			<table class="table-datatype01">

				<tr>
					<th style="width: 10%;"></th>
					<th colspan="4">활동유형</th>
					<th style="width: 20%; border-right: none;">날짜</th>
				</tr>

			<tbody id="strhtml" style="width:99%">
			</tbody>

		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000411_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000411_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>