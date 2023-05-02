<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 외부강의등 승인 신청서(월 3회 또는 6시간 초과 시) -->
<!-- EZSP_GETSTARTDATE - TBENDAPRDOCINFO, TBAPRDOCINFO 
	 EZSP_GETLASTLINECN1 - TBENDAPRLINEINFO
	 EZSP_LECTURE2_INSERT - PR_PHC_INSERT_PHC5001 -->

<style>
	#FORM_FM00000412 {
		min-height: 404px !important;
		max-height: 500px !important;
		overflow-y: auto !important;
		margin-bottom: 10px;
	}
	
    img.ui-datepicker-trigger {
       margin-left: 5px;
    }
</style>

<script>
var gunmuji = "";
	$(function () {
		
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
		
		
		
	    $("#date1").datepicker({
	        dateFormat: 'yy-mm-dd',
	        showOn: 'button',
	        buttonImage: '/images/common/ico_date_drop.gif',
	        buttonImageOnly: true,
	    });
	    $("#date2").datepicker({
	        dateFormat: 'yy-mm-dd',
	        showOn: 'button',
	        buttonImage: '/images/common/ico_date_drop.gif',
	        buttonImageOnly: true,
	    });
	    $("#date3").datepicker({
	        dateFormat: 'yy-mm-dd',
	        showOn: 'button',
	        buttonImage: '/images/common/ico_date_drop.gif',
	        buttonImageOnly: true,
	    });
	    $("#date4").datepicker({
	        dateFormat: 'yy-mm-dd',
	        showOn: 'button',
	        buttonImage: '/images/common/ico_date_drop.gif',
	        buttonImageOnly: true,
	    });
	    $("#date5").datepicker({
	        dateFormat: 'yy-mm-dd',
	        showOn: 'button',
	        buttonImage: '/images/common/ico_date_drop.gif',
	        buttonImageOnly: true,
	    });
	});
	
	var cnt = 1;
	// 추가
	function btnAdd_onclick() {
	    if(cnt == 5){
	    	alert("더이상 추가되지 않습니다.");
	    } else {
	    	cnt = cnt + 1;
	    	//alert("1건추가:" + cnt);
	    	// id: p14_tbl_1~p14_tbl_5
	    	if(cnt==2){
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).hide();
	    		$(p14_tbl_3_label).hide();
	    		
	    		$(p14_tbl_4).hide();
	    		$(p14_tbl_4_label).hide();
	    		
	    		$(p14_tbl_5).hide();
	    		$(p14_tbl_5_label).hide();
	    	}    
	    	else if(cnt==3){
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).show();
	    		$(p14_tbl_3_label).show();
	    		
	    		$(p14_tbl_4).hide();
	    		$(p14_tbl_4_label).hide();
	    		
	    		$(p14_tbl_5).hide();
	    		$(p14_tbl_5_label).hide();            		            		            		
	    	}
	    	else if(cnt==4){    
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).show();
	    		$(p14_tbl_3_label).show();
	    		
	    		$(p14_tbl_4).show();
	    		$(p14_tbl_4_label).show();
	    		
	    		$(p14_tbl_5).hide();
	    		$(p14_tbl_5_label).hide();              		
	    	}
	    	else if(cnt==5){
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).show();
	    		$(p14_tbl_3_label).show();
	    		
	    		$(p14_tbl_4).show();
	    		$(p14_tbl_4_label).show();
	    		
	    		$(p14_tbl_5).show();
	    		$(p14_tbl_5_label).show();             		
	    	}
	    }
	}
	
	// 삭제
	function btnDel_onclick(){
		if(cnt == 1){
			alert("더이상 삭제할 수 없습니다.");
	    } else {
			cnt = cnt - 1;
			if(cnt==1){
	    		$(p14_tbl_2).hide();      
	    		$(p14_tbl_2_label).hide();
	    		
	    		$(p14_tbl_3).hide();
	    		$(p14_tbl_3_label).hide();
	    		
	    		$(p14_tbl_4).hide();
	    		$(p14_tbl_4_label).hide();
	    		
	    		$(p14_tbl_5).hide();
	    		$(p14_tbl_5_label).hide(); 
	    		
			}
			else if(cnt==2){
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).hide();
	    		$(p14_tbl_3_label).hide();
	    		
	    		$(p14_tbl_4).hide();
	    		$(p14_tbl_4_label).hide();
	    		
	    		$(p14_tbl_5).hide();
	    		$(p14_tbl_5_label).hide();
	    	}    
	    	else if(cnt==3){
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).show();
	    		$(p14_tbl_3_label).show();
	    		
	    		$(p14_tbl_4).hide();
	    		$(p14_tbl_4_label).hide();
	    		
	    		$(p14_tbl_5).hide();
	    		$(p14_tbl_5_label).hide();            		            		            		
	    	}
	    	else if(cnt==4){    
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).show();
	    		$(p14_tbl_3_label).show();
	    		
	    		$(p14_tbl_4).show();
	    		$(p14_tbl_4_label).show();
	    		
	    		$(p14_tbl_5).hide();
	    		$(p14_tbl_5_label).hide();              		
	    	}
	    	else if(cnt==5){
	    		$(p14_tbl_2).show();      
	    		$(p14_tbl_2_label).show();
	    		
	    		$(p14_tbl_3).show();
	    		$(p14_tbl_3_label).show();
	    		
	    		$(p14_tbl_4).show();
	    		$(p14_tbl_4_label).show();
	    		
	    		$(p14_tbl_5).show();
	    		$(p14_tbl_5_label).show();      
	    		
	    		
	    	}        		        		
		}
	}
</script>

<script>

	$('#FM00000412_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000412').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
 		var legacydata = [];
 		var sayoutxt = "";
 		
/*  		sayoutxt = function() {
 			for (var i = 1 ; i <= cnt ; i++){
 				if($('#acttype'+i+' option:selected').val() == "1"){
 					sayoutxt = "강의·강연";
 				} else if($('#acttype'+i+' option:selected').val() == "2"){
 					sayoutxt = "발표·토론";
 				} else if($('#acttype'+i+' option:selected').val() == "3"){
 					sayoutxt = "심사·평가·자문·의결";
 				} else if($('#acttype'+i+' option:selected').val() == "4"){
 					sayoutxt = "기타";
 				}
 			}
 		} */
		
 		
 		var sayoutxt1 = "";
		if($('#acttype1 option:selected').val() == "1"){
			sayoutxt1 = "강의·강연";
		} else if($('#acttype1 option:selected').val() == "2"){
			sayoutxt1 = "발표·토론";
		} else if($('#acttype1 option:selected').val() == "3"){
			sayoutxt1 = "심사·평가·자문·의결";
		} else if($('#acttype1 option:selected').val() == "4"){
			sayoutxt1 = "기타";
		}
		
 		var sayoutxt2 = "";
		if($('#acttype2 option:selected').val() == "1"){
			sayoutxt2 = "강의·강연";
		} else if($('#acttype2 option:selected').val() == "2"){
			sayoutxt2 = "발표·토론";
		} else if($('#acttype2 option:selected').val() == "3"){
			sayoutxt2 = "심사·평가·자문·의결";
		} else if($('#acttype2 option:selected').val() == "4"){
			sayoutxt2 = "기타";
		}
		
 		var sayoutxt3 = "";
		if($('#acttype3 option:selected').val() == "1"){
			sayoutxt3 = "강의·강연";
		} else if($('#acttype3 option:selected').val() == "2"){
			sayoutxt3 = "발표·토론";
		} else if($('#acttype3 option:selected').val() == "3"){
			sayoutxt3 = "심사·평가·자문·의결";
		} else if($('#acttype3 option:selected').val() == "4"){
			sayoutxt3 = "기타";
		}
		
 		var sayoutxt4 = "";
		if($('#acttype4 option:selected').val() == "1"){
			sayoutxt4 = "강의·강연";
		} else if($('#acttype4 option:selected').val() == "2"){
			sayoutxt4 = "발표·토론";
		} else if($('#acttype4 option:selected').val() == "3"){
			sayoutxt4 = "심사·평가·자문·의결";
		} else if($('#acttype4 option:selected').val() == "4"){
			sayoutxt4 = "기타";
		}
		
 		var sayoutxt5 = "";
		if($('#acttype5 option:selected').val() == "1"){
			sayoutxt5 = "강의·강연";
		} else if($('#acttype5 option:selected').val() == "2"){
			sayoutxt5 = "발표·토론";
		} else if($('#acttype5 option:selected').val() == "3"){
			sayoutxt5 = "심사·평가·자문·의결";
		} else if($('#acttype5 option:selected').val() == "4"){
			sayoutxt5 = "기타";
		}
		
		
		// 1. 데이터 저장
		legacydata.push({
			I_SABUN          : HGW_APPR_BANK.loginVO.user_emp_id,
			


 			I_ASK_GIGWAN_1   : $('#organ1').val(),
			I_ASK_DAMDANG_1  : $('#ceo1').val(),
			I_ASK_TEL_1      : $('#damtel1').val(),
			I_LECTURE_NAME_1 : $('#acttitle1').val(),
			I_AMT_1          : $('#amt_tot1').val(),
			I_LECTURE_DATE_1 : $("#date1").val(),
			I_LECTURE_TIME_1 : $('#sigan1').val(),
			I_ACT_TYPE_1     : sayoutxt1,

		 	I_ASK_GIGWAN_2   : $('#organ2').val(),
			I_ASK_DAMDANG_2  : $('#ceo2').val(),
			I_ASK_TEL_2      : $('#damtel2').val(),
			I_LECTURE_NAME_2 : $('#acttitle2').val(),
			I_AMT_2          : $('#amt_tot2').val(),
			I_LECTURE_DATE_2 : $("#date2").val(),
			I_LECTURE_TIME_2 : $('#sigan2').val(),
			I_ACT_TYPE_2     : sayoutxt2,

			I_ASK_GIGWAN_3   : $('#organ3').val(),
			I_ASK_DAMDANG_3  : $('#ceo3').val(),
			I_ASK_TEL_3      : $('#damtel3').val(),
			I_LECTURE_NAME_3 : $('#acttitle3').val(),
			I_AMT_3          : $('#amt_tot3').val(),
			I_LECTURE_DATE_3 : $("#date3").val(),
			I_LECTURE_TIME_3 : $('#sigan3').val(),
			I_ACT_TYPE_3     : sayoutxt3,

			I_ASK_GIGWAN_4   : $('#organ4').val(),
			I_ASK_DAMDANG_4  : $('#ceo4').val(),
			I_ASK_TEL_4      : $('#damtel4').val(),
			I_LECTURE_NAME_4 : $('#acttitle4').val(),
			I_AMT_4          : $('#amt_tot4').val(),
			I_LECTURE_DATE_4 : $("#date4").val(),
			I_LECTURE_TIME_4 : $('#sigan4').val(),
			I_ACT_TYPE_4     : sayoutxt4,

			I_ASK_GIGWAN_5   : $('#organ5').val(),
			I_ASK_DAMDANG_5  : $('#ceo5').val(),
			I_ASK_TEL_5      : $('#damtel5').val(),
			I_LECTURE_NAME_5 : $('#acttitle5').val(),
			I_AMT_5          : $('#amt_tot5').val(),
			I_LECTURE_DATE_5 : $("#date5").val(),
			I_LECTURE_TIME_5 : $('#sigan5').val(),
			I_ACT_TYPE_5     : sayoutxt5,
				
			I_TOTAL_CNT      : $('#count').val(),
			I_TOTAL_TIME     : $('#sigan_tot').val(),
			I_SAYU           : $('#sayou').val(),
			I_SINCHUNG_YMD   : new Date().hgwDateFormat('yyyy-MM-dd'),
			I_IF_DOCID       : '',
			I_GIAN_YMD       : '',
			I_KYULJE_YMD     : ''
		});
 		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		//alert($("#gunmuji").val() + '/' + "test");        	
		if ($("#gunmuji").val() == '') {
			alert("근무지를 입력해 주세요");        		
			$("#gunmuji").focus();
			return;        		
		}
		
		for (var i = 1; i <= cnt; i++) {
			if($("#organ"+cnt).val() == ""){
				alert(cnt + "번째 요청기관명을 입력해 주세요");
				$("#organ"+cnt).focus();	
				return;
			}      
			if($("#ceo"+cnt).val() == ""){
				alert(cnt + "번째 담당자명을 입력해 주세요");
				$("#ceo"+cnt).focus();	
				return;
			}    
			if($("#damtel"+cnt).val() == ""){
				alert(cnt + "번째 연락처를 입력해 주세요");
				$("#damtel"+cnt).focus();	
				return;
			}       
			if($("#acttitle"+cnt).val() == ""){
				alert(cnt + "번째 외부강의명칭을 입력해 주세요");
				$("#acttitle"+cnt).focus();	
				return;
			}    
			if($("#amt_tot"+cnt).val() == ""){
				alert(cnt + "번째 대가 정보를 입력해 주세요");
				$("#amt_tot"+cnt).focus();	
				return;
			}         
			if($("#sigan"+cnt).val() == ""){
				alert(cnt + "번째 시간 정보를 입력해 주세요");
				$("#sigan"+cnt).focus();	
				return;
			}
		}
		
		
		// 3. validation check 후 기안기에 내용 입력
		
		// 인적사항 : 사번 : v_userid, 성명 : 기안자, 직위 : draftposition, 부서 : 기안부서, 근무지 : gunmuji
		// 요청기관명 : organ1~5
		// 담당자(연락처) : ceo1~5, 연락처 : damtel1~5
		// 외부강의등의 명칭 : acttitle1~5
		// 대가 : amt_tot1~5
		// 외부강의등의 날짜 및 시간 : datetext1~5, sigan1~5
		// 활동유형 : sayoutxt1~5
		// 외부강의등의 월 총 횟수 : count
		// 외부강의등의 월 총 시간 : sigan_tot
		// 월3회 또는 6시간초과사유 : sayou
		// 기안일자 : 기안일자
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		// 인적사항
		_$hwpObj.insertSignData('v_userid', HGW_APPR_BANK.loginVO.user_emp_id); // 사번
		_$hwpObj.insertSignData('기안자', HGW_APPR_BANK.loginVO.user_nm); // 성명
		_$hwpObj.insertSignData('draftposition', HGW_APPR_BANK.loginVO.memb_postion); // 직위
		_$hwpObj.insertSignData('기안부서', HGW_APPR_BANK.loginVO.dept_nm); // 부서
		_$hwpObj.insertSignData('gunmuji', $('#gunmuji').val()); // 근무지
		
		// 승인신청서 1~5
		for (var i = 1 ; i <= cnt ; i++){
			_$hwpObj.insertSignData('organ'+i, $('#organ'+i).val());
			_$hwpObj.insertSignData('ceo'+i, $('#ceo'+i).val());
			_$hwpObj.insertSignData('damtel'+i, $('#damtel'+i).val());
			_$hwpObj.insertSignData('acttitle'+i, $('#acttitle'+i).val());
			_$hwpObj.insertSignData('amt_tot'+i, $('#amt_tot'+i).val());
			_$hwpObj.insertSignData('datetext'+i, $('#date'+i).val());
			_$hwpObj.insertSignData('sigan'+i, $('#sigan'+i).val());
			_$hwpObj.insertSignData('sayoutxt'+i, $('#acttype'+i+' option:selected').text());
		}
		
		for (var i = cnt+1 ; i <= 5 ; i++){
			_$hwpObj.insertSignData('organ'+i, ' ');
			_$hwpObj.insertSignData('ceo'+i, ' ');
			_$hwpObj.insertSignData('damtel'+i, ' ');
			_$hwpObj.insertSignData('acttitle'+i, ' ');
			_$hwpObj.insertSignData('amt_tot'+i, ' ');
			_$hwpObj.insertSignData('datetext'+i, ' ');
			_$hwpObj.insertSignData('sigan'+i, ' ');
			_$hwpObj.insertSignData('sayoutxt'+i, ' ');
		}
		
		// 외부강의등의 월 총 횟수 : count
		_$hwpObj.insertSignData('count', $('#count').val());
		
		// 외부강의등의 월 총 시간 : sigan_tot
		_$hwpObj.insertSignData('sigan_tot', $('#sigan_tot').val());
		
		// 월3회 또는 6시간초과사유 : sayou
		_$hwpObj.insertSignData('sayou', $('#sayou').val());
		
		// 작성일
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));
		
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000412_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<form id="FORM_FM00000412">
	<span>* 취소사유 입력 및 취소하실 외부강의 회의를 체크 후 확인 버튼을 클릭해 주세요.</span>
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>

			<tr>
				<%-- 사번 --%>
				<th class="lln" scope="row"><label for="htmlEditorLyr_1">사번</label></th>
				<td class="lln">
					<c:out value="${loginVO.user_emp_id}" escapeXml="false"/>
				</td>
				<!-- 성명 -->
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">성명</label></th>
				<td data-hgwtype="public">
					<c:out value="${loginVO.user_nm}" escapeXml="false"/>
				</td>
			</tr>
			
			<tr>
				<!-- 직위 -->
				<th scope="row" class="lln"><label for="htmlEditorLyr_7">직위</label></th>
				<td>
					<c:out value="${loginVO.memb_postion}" escapeXml="false"/>
				</td>
				<!-- 소속 -->
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">소속</label></th>
				<td data-hgwtype="public">
					<c:out value="${loginVO.dept_nm}" escapeXml="false"/>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;">근무지</th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<input type="text" id="gunmuji" style="height: 25px;">
				</td>
			</tr>
		</table>
	</div>
	<br>
			
	<span style="margin-bottom: 5px;">승인신청서 1</span>
	<div class="tablewrap-line" id="p14_tbl_1">
		<table class="table-datatype01">
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2" style="width:17%">
				<col class="col3">
				<col class="col4">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln">요청기관명</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="organ1" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">담당자</th>
				<td data-hgwtype="public">
					<input type="text" id="ceo1" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln">연락처</th>
				<td data-hgwtype="public">
					<input type="text" id="damtel1" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">외부강의등의명칭</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="acttitle1" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">대가(천원)</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="amt_tot1" style="width:24%; height: 25px;"><span style="margin-left: 3px;">천원 (숫자로 입력)</span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;"><label for="htmlEditorLyr_1">외부강의등의<br>날짜 및 시간</label></th>
				<td data-hgwtype="public" style="padding: 10px 0px 10px 10px;">
					<input type="text" name="date1" id="date1" title="선택일" style="width: 85%; height:25px;" readonly />
				</td>
				<th data-hgwtype="public" scope="row" class="lln">시간</th>
				<td data-hgwtype="public" >
					<input type="text" id="sigan1" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">활동유형</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<select class="frm_select" id="acttype1" name="receiveable_yn" style="height: 25px; width:150px">
						<option value="0">선택하세요.</option>
						<option value="1">강의·강연</option>
						<option value="2">발표·토론</option>
						<option value="3">심사·평가·자문·의결</option>
						<option value="4">기타</option>
					</select>					
				</td>
			</tr>
			
		</table>
	</div>
	<span id="p14_tbl_2_label" style="display:none; margin-bottom: 5px; margin-top: 5px;">승인신청서 2</span>
	<div class="tablewrap-line" id="p14_tbl_2" style="display:none;">
		<table class="table-datatype01">
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2" style="width:17%">
				<col class="col3">
				<col class="col4">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln">요청기관명</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="organ2" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">담당자</th>
				<td data-hgwtype="public">
					<input type="text" id="ceo2" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln">연락처</th>
				<td data-hgwtype="public">
					<input type="text" id="damtel2" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">외부강의등의명칭</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="acttitle2" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">대가(천원)</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="amt_tot2" style="width:24%; height: 25px;"><span style="margin-left: 3px;">천원 (숫자로 입력)</span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;"><label for="htmlEditorLyr_1">외부강의등의<br>날짜 및 시간</label></th>
				<td data-hgwtype="public" style="padding: 10px 0px 10px 10px;">
					<input type="text" name="date2" id="date2" title="선택일" style="width: 85%; height:25px;" readonly />
				</td>
				<th data-hgwtype="public" scope="row" class="lln">시간</th>
				<td data-hgwtype="public" >
					<input type="text" id="sigan2" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">활동유형</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<select class="frm_select" id="acttype2" name="receiveable_yn" style="height: 25px; width:150px">
						<option value="0">선택하세요.</option>
						<option value="1">강의·강연</option>
						<option value="2">발표·토론</option>
						<option value="3">심사·평가·자문·의결</option>
						<option value="4">기타</option>
					</select>					
				</td>
			</tr>
			
		</table>
	</div>
	
	<span id="p14_tbl_3_label" style="display:none; margin-bottom: 5px; margin-top: 5px;">승인신청서 3</span>
	<div class="tablewrap-line" id="p14_tbl_3" style="display:none;">
		<table class="table-datatype01">
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2" style="width:17%">
				<col class="col3">
				<col class="col4">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln">요청기관명</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="organ3" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">담당자</th>
				<td data-hgwtype="public">
					<input type="text" id="ceo3" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln">연락처</th>
				<td data-hgwtype="public">
					<input type="text" id="damtel3" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">외부강의등의명칭</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="acttitle3" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">대가(천원)</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="amt_tot3" style="width:24%; height: 25px;"><span style="margin-left: 3px;">천원 (숫자로 입력)</span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;"><label for="htmlEditorLyr_1">외부강의등의<br>날짜 및 시간</label></th>
				<td data-hgwtype="public" style="padding: 10px 0px 10px 10px;">
					<input type="text" name="date3" id="date3" title="선택일" style="width: 85%; height:25px;" readonly />
				</td>
				<th data-hgwtype="public" scope="row" class="lln">시간</th>
				<td data-hgwtype="public" >
					<input type="text" id="sigan3" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">활동유형</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<select class="frm_select" id="acttype3" name="receiveable_yn" style="height: 25px; width:150px">
						<option value="0">선택하세요.</option>
						<option value="1">강의·강연</option>
						<option value="2">발표·토론</option>
						<option value="3">심사·평가·자문·의결</option>
						<option value="4">기타</option>
					</select>					
				</td>
			</tr>
			
		</table>
	</div>	
	
	<span id="p14_tbl_4_label" style="display:none; margin-bottom: 5px; margin-top: 5px;">승인신청서 4</span>
	<div class="tablewrap-line" id="p14_tbl_4" style="display:none;">
		<table class="table-datatype01">
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2" style="width:17%">
				<col class="col3">
				<col class="col4">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln">요청기관명</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="organ4" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">담당자</th>
				<td data-hgwtype="public">
					<input type="text" id="ceo4" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln">연락처</th>
				<td data-hgwtype="public">
					<input type="text" id="damtel4" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">외부강의등의명칭</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="acttitle4" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">대가(천원)</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="amt_tot4" style="width:24%; height: 25px;"><span style="margin-left: 3px;">천원 (숫자로 입력)</span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;"><label for="htmlEditorLyr_1">외부강의등의<br>날짜 및 시간</label></th>
				<td data-hgwtype="public" style="padding: 10px 0px 10px 10px;">
					<input type="text" name="date4" id="date4" title="선택일" style="width: 85%; height:25px;" readonly />
				</td>
				<th data-hgwtype="public" scope="row" class="lln">시간</th>
				<td data-hgwtype="public" >
					<input type="text" id="sigan4" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">활동유형</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<select class="frm_select" id="acttype4" name="receiveable_yn" style="height: 25px; width:150px">
						<option value="0">선택하세요.</option>
						<option value="1">강의·강연</option>
						<option value="2">발표·토론</option>
						<option value="3">심사·평가·자문·의결</option>
						<option value="4">기타</option>
					</select>					
				</td>
			</tr>
			
		</table>
	</div>
	
	<span id="p14_tbl_5_label" style="display:none; margin-bottom: 5px; margin-top: 5px;">승인신청서 5</span>
	<div class="tablewrap-line" id="p14_tbl_5" style="display:none;">
		<table class="table-datatype01">
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2" style="width:17%">
				<col class="col3">
				<col class="col4">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln">요청기관명</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="organ5" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">담당자</th>
				<td data-hgwtype="public">
					<input type="text" id="ceo5" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln">연락처</th>
				<td data-hgwtype="public">
					<input type="text" id="damtel5" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">외부강의등의명칭</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="acttitle5" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln">대가(천원)</th>
				<td data-hgwtype="public" colspan="3">
					<input type="text" id="amt_tot5" style="width:24%; height: 25px;"><span style="margin-left: 3px;">천원 (숫자로 입력)</span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;"><label for="htmlEditorLyr_1">외부강의등의<br>날짜 및 시간</label></th>
				<td data-hgwtype="public" style="padding: 10px 0px 10px 10px;">
					<input type="text" name="date5" id="date5" title="선택일" style="width: 85%; height:25px;" readonly />
				</td>
				<th data-hgwtype="public" scope="row" class="lln">시간</th>
				<td data-hgwtype="public" >
					<input type="text" id="sigan5" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">활동유형</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<select class="frm_select" id="acttype5" name="receiveable_yn" style="height: 25px; width:150px">
						<option value="0">선택하세요.</option>
						<option value="1">강의·강연</option>
						<option value="2">발표·토론</option>
						<option value="3">심사·평가·자문·의결</option>
						<option value="4">기타</option>
					</select>					
				</td>
			</tr>
			
		</table>
	</div>												
	<br>
	<div class="tablewrap-line" id="p14_tbl">
		<table class="table-datatype01">
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2" style="width:33%">
				<col class="col3" style="width:17%">
				<col class="col4" style="width:33%">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;">외부강의등의<br>월 총 횟수</th>
				<td data-hgwtype="public" >
					<input type="text" id="count" style="width:120px; height:25px;"><span style="margin-left: 3px;">(숫자로 입력)</span>
				</td>
				<th data-hgwtype="public" scope="row" class="lln" style="padding: 0px 0px 0px 0px;">월 총 시간</th>
				<td data-hgwtype="public">
					<input type="text" id="sigan_tot" class="" value="" style="width:120px; height:25px;"><span style="margin-left: 3px;">(숫자로 입력)</span>
				</td>
			</tr>
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none; padding: 0px 0px 0px 0px;">월3회 또는<br>6시간 초과사유</th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<input type="text" id="sayou" style="height:25px;">
				</td>
			</tr>
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button id="A1" onclick ="btnAdd_onclick();" class="btn_basic_setting btn_normal_box" style="height: 35px; margin-right: 5px; display:inline-block;" type="button">1건추가</button>
		<button id="A2" onclick ="btnDel_onclick();" class="btn_basic_setting btn_normal_box" style="height: 35px; margin-right: 5px; display:inline-block;" type="button">1건삭제</button>
		<button type="button" id="FM00000412_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000412_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>