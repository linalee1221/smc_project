<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 교육취소신청서 -->

<!-- EZSP_EDU_CANCEL - PR_PPE_DELETE_NRS2002
	 EZSP_EDUCANCEL - TBLSCHEDULE, TBHugaSchedule -->

<style>

#FORM_FM00000098 {
		min-height: 404px !important;
		max-height: 500px !important;
		overflow-y: auto !important;
		margin-bottom: 10px;
	}

</style>

<script>

var cnt1 = 0;
var cnt2 = 0;
var cnt = 0;

var edutitle = "";
var organ = "";
var loc = "";
var gigan = "";
var attend = "";
var sayou = "";
var sabun = "";
var eduList = "";

$(function() {
	
	// 교육신청목록
	$.ajax({
		url: '/interwork/getEduList.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {
			'user_emp_id': HGW_APPR_BANK.loginVO.user_emp_id
		}
	}).success(function(data) {
        console.log('getEduList???? ::: ', data);
        
        if(data == null || data == undefined) {
	        } else {
	          var list = data.rows;
	          
	          cnt1 = list.length;
	          
		    	
	          
	          if(list.length == 0) {
	        	  html = '<tr><td colspan="8"><div class="text-center"><span>취소 가능한 교육신청서가 없습니다.</span></div></td></tr>';
	        	  $("#strhtml").append(html);
	          } else {
	            for(var i=0; i<list.length; i++) {
	              var item = list[i];
	              
	              edutitle = item.EDU_NAME;
			      organ = item.EDU_GIKWAN;
			      loc = item.JANGSO;
			      
			      sabun = item.SABUN;
	              
	              html = '<tr>';
	              html += '<td style="text-align:center;width:5">';
	              html += '<input type="radio" id="chk'+i+'" name="eduList" onclick="addEduUsers(\''+item.IF_DOCID+'\')" >';
	              html += '<input type="hidden" id="pknrs'+i+'" value="'+item.PKNRS2001+'" />'; 
	              html += '</td>';
	              html += '<td colspan="3" id="edutitle'+i+'" style="text-align:center;" value="' + item.EDU_NAME + '">'+item.EDU_NAME+'</td>';
	              html += '<td colspan="2" id="loc'+i+'" style="text-align:center;" value="' + item.JANGSO + '">'+item.JANGSO+'</td>';
	              html += '<td colspan="2" id="organ'+i+'" style="text-align:center; display:none;" value="' + item.EDU_GIKWAN + '">'+item.EDU_GIKWAN+'</td>';
	              html += '<td id="startdate'+i+'" style="text-align:center;">'+item.EDU_START_DATE+'</td>';
	              html += '<td id="enddate'+i+'" style="text-align:center;">'+item.EDU_END_DATE+'</td>';
	              html += '</tr>';
	              $("#strhtml").append(html);
	            }
	          }
	        }
  	 });
	
});



//교육신청 참석자 목록
var addEduUsers = function(IF_DOCID){	
	
	$.ajax({
		url: '/interwork/getEduNameList.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {
			'docId': IF_DOCID
		}
	}).success(function(response) {
        console.log('getEduNameList???? ::: ', response);
        
	     $('#spanattend').show();
	     $('#attendList').show();		
	     
 	     $('#attendhtml').html('');
	     
	     var list2 = response.rows;
	          
	          cnt2 = list2.length;
	     
	     if(list2.length == 0) {
       	  html2 = '<tr><td colspan="7"><div class="text-center"><span>취소 가능한 참석자가 없습니다.</span></div></td></tr>';
       	  $("#attendhtml").append(html2);
         } else {
           for(var j=0; j<cnt2; j++) {
             var item = list2[j];
             gigan = item.EDU_START_DATE + "~" + item.EDU_END_DATE;
             
             html2 = '<tr id="edu-person'+j+'">';																	
             html2 += '<td style="text-align:center;width:5">';
             html2 += '<input type="checkbox" id="eduPersonList'+j+'" name="eduPersonList" onclick="personList_data()" value="'+ item.CN +'" />';
             html2 += '<input type="hidden" id="hiddenValue" />';
             html2 += '<input type="hidden" id="startDate'+j+'" value="'+ item.EDU_START_DATE +'" />';
             html2 += '<input type="hidden" id="endDate'+j+'" value="'+ item.EDU_END_DATE +'"/>';
             html2 += '</td>';
             html2 += '<td colspan="3" id="sabun'+j+'" style="text-align:center; border-left:solid 1px #dbdbdb;">'+item.CN+'</td>';
             html2 += '<td colspan="3" id="name'+j+'" style="text-align:center; border-left:solid 1px #dbdbdb;">'+item.DISPLAYNAME+'</td>';
             html2 += '</tr>';
             $("#attendhtml").append(html2);
           }
         }
       })
	}

function personList_data(){
    var obj = $("[name=eduPersonList]");
    var chkArray = new Array(); // 배열 선언

    $('input:checkbox[name=eduPersonList]:checked').each(function() { // 체크된 체크박스의 value 값을 가지고 온다.
        chkArray.push(this.value);
    });
    
    $('#hiddenValue').val(chkArray);
    
    console.log($('#hiddenValue').val()); // 체크박스가 모두 체크되어 있다면 전부 출력 된다.
    
}

		
	$('#FM00000098_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
		
		var code = "";
	
		for (var i=0; i < cnt1; i++) {
			if ($('input[id="chk'+i+'"]').is(':checked') == true) {
				
				
		    	code = document.getElementById("pknrs" + i).value;
		    	edutitle = document.getElementById("edutitle" + i).innerText;
		        loc = document.getElementById("loc" + i).innerText;
		        organ = document.getElementById("organ" + i).innerText;
		        break;
		    }
		}
		
		// 1. validation check
        if (document.getElementById("sayou").value == "")
        {
            alert("취소 사유를 입력해 주세요");
            document.getElementById("sayou").focus();
            return;
        }
        
        if ($('input:radio[name="eduList"]').is(':checked') == false) {
        	alert("취소하실 교육을 선택해 주세요.");
        	return;
        }
        
      
        if ($('input:checkbox[name=eduPersonList]').is(':checked') == false) {
        	alert("취소하실 참석자를 선택해 주세요.");
        	return;
        }
        
		
		var formData = $('#FORM_FM00000098').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var legacydata = [];
		
		// 2. 데이터 저장
 		legacydata.push({
			I_USER_ID   : sabun,
			I_PKNRS2001 : code,
			I_SABUN     : $('#hiddenValue').val()
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 3. validation check 후 기안기에 내용 입력
		// 교육명 : edutitle, 교육기관 : organ, 장소 : loc, 일시 : gigan, 취소자 : attend, 취소사유 : sayou
		// 기안일자 : 기안일자
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});

		
		var userName = "";
		var rows = document.getElementById("attendhtml").getElementsByTagName("tr");
		var msg =  '';
		
		for (var i=0; i<rows.length; i++) {
			var cells = rows[i].getElementsByTagName("td");
			var cell_1 = cells[2].firstChild.data + '(' + cells[1].firstChild.data + ')';
			
			
			if($('input:checkbox[id=eduPersonList'+i+']').is(':checked') == true) {
				userName = userName+cell_1;
				if (rows.length != i+1){ userName += ',' };
				
 			console.log("cells[0]의 값은??? : : :", cell_1);
 			console.log("userids의 값은???: : : : : ", userName);
 			
 			
 			msg = userName;
 				
			}
			
		} 
		
		
 		_$hwpObj.insertSignData('edutitle', edutitle);
 		_$hwpObj.insertSignData('organ', organ);
		_$hwpObj.insertSignData('loc', loc);
		_$hwpObj.insertSignData('gigan', gigan);
		_$hwpObj.insertSignData('attend', msg);
		_$hwpObj.insertSignData('sayou', $('#sayou').val());
		
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));
		
		
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
		
		// 5. 취소버튼 누르면 다이얼로그 창 닫기
	$('#FM00000098_reset').unbind().on('click', function() {
		$('#gw_sp_dialog').dialog('close');
	});

	
</script>

<form id="FORM_FM00000098">
<span>* 취소사유 입력 및 취소하실 교육을 체크해 주세요</span>
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr>
				<th style="border-bottom: none;">취소사유</th>
					<td colspan="6" style="border-bottom: none;"><input id="sayou"
						type="text" style="height:25px;" class="edu-cancel">
					</td>
			</tr>

		</table>
	</div>

	<div class="tablewrap-line" style="overflow: visible; margin-top: 10px;">
		<table class="table-datatype01">

			<tr>
			
				<th></th>
				<th colspan="3">교육명</th>
				<th colspan="2">장소</th>
				<th>시작일시</th>
				<th style="border-right: none;">종료일시</th>
			</tr>

			<tbody id="strhtml" style="width:99%">
			</tbody>
			
		</table>
	</div>
	
	<span id="spanattend" style="margin-top:5px; display:none;">* 아래 참석자 중 취소를 원하시는 참석자를 체크해 주세요</span>
	<div  id="attendList" class="tablewrap-line" style="overflow: visible; margin-top: 10px; display:none;">
		<table class="table-datatype01">
		
			<tr>
				<th></th>
				<th colspan="3">사번</th>
				<th colspan="3">이름</th>
			</tr>
			
		<tbody id="attendhtml" style="width:99%"></tbody>
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000098_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000098_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>