<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 신규(대체) 진료재료 도입 전 검토 조서 --> 
<!-- 연동아님 -->

<style>
	#FORM_FM00000425 {
		min-height: 404px !important;
		max-height: 600px !important;
		overflow-y: auto !important;
		margin-bottom: 10px;
	}
</style>


<script>
	
	function selectRadio() {
		if ($('input[name="gubun"]:checked').val() == "1") {
			$('input[id="etctext"]').val('');
		} else if ($('input[name="gubun"]:checked').val() == "2") {
	   		$('input[id="etctext"]').val('');
		} else if($('input[name="gubun"]:checked').val() == "3") {
			$('input[id="etctext"]').val('');
		}
	}
	
	$('#FM00000425_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000425').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var checkNum = $('#useqty').val();
		var legacydata = [];
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 1. 데이터 저장
			legacydata.push({
				NOT_LINK : '연동아님'
			});
			
			HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if (document.getElementById("kname").value == "" && document.getElementById("ename").value == "") {
            alert("재료명(한글 또는 영어)을 작성해주세요.");
            document.getElementById("kname").focus();
            return;
        }
        if (document.getElementById("kkyuk").value == "") {
            alert("규격을 작성해주세요.");
            document.getElementById("kkyuk").focus();
            return;
        }
        
        // 입력한 값이 숫자인지 판별 후 숫자면 데이터저장(기안기입력), 아니면 alert창
	 	if ($.isNumeric(checkNum) == true) {
			_$hwpObj.insertSignData('useqty', $('#useqty').val());
		} else {
			alert("연간사용예정량을 숫자로 작성해주세요.");
			$('#useqty').focus();
			return;
		}
        if (document.getElementById("unitcd").value == "") {
            alert("단위를 작성해주세요.");
            document.getElementById("unitcd").focus();
            return;
        }
        if (document.getElementById("k_foreign").value == "") {
            alert("국,외산 여부를 작성해주세요.");
            document.getElementById("k_foreign").focus();
            return;
        }
        if (document.getElementById("makenm").value == "") {
            alert("제조사를 작성해주세요.");
            document.getElementById("makenm").focus();
            return;
        }
        if (document.getElementById("damdang").value == "") {
            alert("담당자명을 작성해주세요.");
            document.getElementById("damdang").focus();
            return;
        }
        if (document.getElementById("tel").value == "") {
            alert("연락처를 작성해주세요.");
            document.getElementById("tel").focus();
            return;
        }  
        if ($('input[name="gubun"]:checked').val() == null) {
            alert("취득구분을 선택하세요.");
            $('input[name="gubun"]').focus();
            return;
        }
        if ($('input[id="gubun4"]:checked').val() == "4" && document.getElementById("etctext").value == "") {
            alert("취득구분이 기타입니다. 내용을 입력해 주세요.");
            document.getElementById("etctext").focus();
            return;
        }        

        if ($('input[name="yousa"]:checked').val() == null) {
            alert("유사재료 유무를 선택하세요.");
            $('input[name="yousa"]').focus();
            return;
        }
        if ($('input[name="sample"]:checked').val() == null) {
            alert("샘플링 유무를 선택하세요.");
            $('input[name="sample"]').focus();
            return;
        }
        if (document.getElementById("yongdo").value == "") {
            alert("도입필요성(용도)를 작성해주세요.");
            document.getElementById("yongdo").focus();
            return;
        }
		
		
     	// 3. validation check 후 기안기에 내용 입력
		
		// 요청부서명 : 기안부서, 작성일 : 기안일자
		// 재료명(품목명) 한글 : kname, 영문 : ename, 규격 : kkyuk, 단위 : unitcd, 제조(수입)회사명 : makenm
		// 연간사용예정량 : useqty, 담당자 : damdang
		// 국외산 : k_foreign, 담당자연락처 : tel
		// 처방코드 : order_code, 처방명칭 : order_nm
		// 진료행위수가 : suga, 해당재료의료장비명 : jangbi
		// 취득구분 - 신규도입 : gubun1, 기존유사재료대체구입 : gubun2, 기존유사재료병용사용구입 : gubun3, 기타 : gubun4, 기타입력칸 : etctext
		// 유사재료 - 유 : yousa1, 무 : yousa2
		// 샘플링 - 유 : sample1, 무 : sample2
		// 월간평균사용량 : evr
		// 원내사용재료현황 - 품목코드 : pummok1~5, 구입단가 : danga1~5, 창고재고수량 : suryang1~5
		// 도입필요성 : yongdo
		
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		_$hwpObj.insertSignData('기안부서', HGW_APPR_BANK.loginVO.dept_nm); // 요청부서명
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일')); // 작성일
		
		// 재료명(품목명) 한글 : kname, 영문 : ename, 규격 : kkyuk, 단위 : unitcd, 제조(수입)회사명 : makenm
		_$hwpObj.insertSignData('kname', $('#kname').val());
		_$hwpObj.insertSignData('ename', $('#ename').val());
		_$hwpObj.insertSignData('kkyuk', $('#kkyuk').val());
		_$hwpObj.insertSignData('unitcd', $('#unitcd').val());
		_$hwpObj.insertSignData('makenm', $('#makenm').val());
		
		// 연간사용예정량 : useqty, 담당자 : damdang
		
		_$hwpObj.insertSignData('damdang', $('#damdang').val());
		
		// 국외산 : k_foreign, 담당자연락처 : tel
		_$hwpObj.insertSignData('k_foreign', $('#k_foreign').val());
		_$hwpObj.insertSignData('tel', $('#tel').val());
		
		// 처방코드 : order_code, 처방명칭 : order_nm
		_$hwpObj.insertSignData('order_code', $('#order_code').val());
		_$hwpObj.insertSignData('order_nm', $('#order_nm').val());
		
		// 진료행위수가 : suga, 해당재료의료장비명 : jangbi
		_$hwpObj.insertSignData('suga', $('#suga').val());
		_$hwpObj.insertSignData('jangbi', $('#jangbi').val());
		
		// 취득구분 - 신규도입 : gubun1, 기존유사재료대체구입 : gubun2, 기존유사재료병용사용구입 : gubun3, 기타 : gubun4, 기타입력칸 : etctext
		if ($('input[name="gubun"]:checked').val() == '1') {
			$('#etctext').val() == '';
			_$hwpObj.insertSignData('gubun1', '■');
			_$hwpObj.insertSignData('gubun2', '□');
			_$hwpObj.insertSignData('gubun3', '□');
			_$hwpObj.insertSignData('gubun4', '□');
			_$hwpObj.deleteSignData('etctext');
		} else if ($('input[name="gubun"]:checked').val() == '2') {
			$('#etctext').val() == '';
			_$hwpObj.insertSignData('gubun1', '□');
			_$hwpObj.insertSignData('gubun2', '■');
			_$hwpObj.insertSignData('gubun3', '□');
			_$hwpObj.insertSignData('gubun4', '□');
			_$hwpObj.deleteSignData('etctext');
		} else if ($('input[name="gubun"]:checked').val() == '3') {
			
			_$hwpObj.insertSignData('gubun1', '□');
			_$hwpObj.insertSignData('gubun2', '□');
			_$hwpObj.insertSignData('gubun3', '■');
			_$hwpObj.insertSignData('gubun4', '□');
			_$hwpObj.deleteSignData('etctext');
		} else {
			_$hwpObj.insertSignData('gubun1', '□');
			_$hwpObj.insertSignData('gubun2', '□');
			_$hwpObj.insertSignData('gubun3', '□');
			_$hwpObj.insertSignData('gubun4', '■');
			_$hwpObj.insertSignData('etctext', $('#etctext').val());
		}
		
		// 유사재료 - 유 : yousa1, 무 : yousa2
		if ($('input[name="yousa"]:checked').val() == '1') {
			_$hwpObj.insertSignData('yousa1', '■');
			_$hwpObj.insertSignData('yousa2', '□');
		} else {
			_$hwpObj.insertSignData('yousa1', '□');
			_$hwpObj.insertSignData('yousa2', '■');
		}
		
		// 샘플링 - 유 : sample1, 무 : sample2
		if ($('input[name="sample"]:checked').val() == '1') {
			_$hwpObj.insertSignData('sample1', '■');
			_$hwpObj.insertSignData('sample2', '□');
		} else {
			_$hwpObj.insertSignData('sample1', '□');
			_$hwpObj.insertSignData('sample2', '■');
		}
		
		// 월간평균사용량 : evr
		if ($('#evr').val() == '') {
			_$hwpObj.deleteSignData('evr');
		} else {
		_$hwpObj.insertSignData('evr', $('#evr').val());
		}
		
		// 원내사용재료현황 - 품목코드 : pummok1~5
		// 입력 후 확인 눌렀는데 필요 없어서 지우게 되면 기안기에서도 삭제
		if ($('#pummok1').val().trim() == '') {
			_$hwpObj.deleteSignData('pummok1');
		} else {
			_$hwpObj.insertSignData('pummok1', $('#pummok1').val());
		}
		
		if ($('#pummok2').val().trim() == '') {
			_$hwpObj.deleteSignData('pummok2');
		} else {
			_$hwpObj.insertSignData('pummok2', $('#pummok2').val());
		}
		
		if ($('#pummok3').val().trim() == '') {
			_$hwpObj.deleteSignData('pummok3');
		} else {
			_$hwpObj.insertSignData('pummok3', $('#pummok3').val());
		}
		
		if ($('#pummok4').val().trim() == '') {
			_$hwpObj.deleteSignData('pummok4');
		} else {
			_$hwpObj.insertSignData('pummok4', $('#pummok4').val());
		}
		
		if ($('#pummok5').val().trim() == '') {
			_$hwpObj.deleteSignData('pummok5');
		} else {
			_$hwpObj.insertSignData('pummok5', $('#pummok5').val());
		}
		
		
		// 원내사용재료현황 - 구입단가 : danga1~5
		if ($('#danga1').val().trim() == '') {
			_$hwpObj.deleteSignData('danga1');
		} else {
			_$hwpObj.insertSignData('danga1', $('#danga1').val());
		}
		
		if ($('#danga2').val().trim() == '') {
			_$hwpObj.deleteSignData('danga2');
		} else {
			_$hwpObj.insertSignData('danga2', $('#danga2').val());
		}
		
		if ($('#danga3').val().trim() == '') {
			_$hwpObj.deleteSignData('danga3');
		} else {
			_$hwpObj.insertSignData('danga3', $('#danga3').val());
		}
		
		if ($('#danga4').val().trim() == '') {
			_$hwpObj.deleteSignData('danga4');
		} else {
			_$hwpObj.insertSignData('danga4', $('#danga4').val());
		}
		
		if ($('#danga5').val().trim() == '') {
			_$hwpObj.deleteSignData('danga5');
		} else {
			_$hwpObj.insertSignData('danga5', $('#danga5').val());
		}
		
		// 원내사용재료현황 - 창고재고수량 : suryang1~5
		if ($('#suryang1').val().trim() == '') {
			_$hwpObj.deleteSignData('suryang1');
		} else {
			_$hwpObj.insertSignData('suryang1', $('#suryang1').val());
		}
		
		if ($('#suryang2').val().trim() == '') {
			_$hwpObj.deleteSignData('suryang2');
		} else {
			_$hwpObj.insertSignData('suryang2', $('#suryang2').val());
		}
		
		if ($('#suryang3').val().trim() == '') {
			_$hwpObj.deleteSignData('suryang3');
		} else {
			_$hwpObj.insertSignData('suryang3', $('#suryang3').val());
		}
		
		if ($('#suryang4').val().trim() == '') {
			_$hwpObj.deleteSignData('suryang4');
		} else {
			_$hwpObj.insertSignData('suryang4', $('#suryang4').val());
		}
		
		if ($('#suryang5').val().trim() == '') {
			_$hwpObj.deleteSignData('suryang5');
		} else {
			_$hwpObj.insertSignData('suryang5', $('#suryang5').val());
		}
		
		// 도입필요성 : yongdo
		_$hwpObj.insertSignData('yongdo', $('#yongdo').val());
		

		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000425_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<form id="FORM_FM00000425">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>

			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">요청부서</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<input type="text" id="department" style="height:25px;" value="${loginVO.dept_nm}" />
				</td>
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" id="p18_tbl">
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>
			
			<tr>
				<td data-hgwtype="public" colspan="4">
					<span style="color:red"><b>* 아래칸을 모두 작성하신 후 확인버튼을 클릭해주세요. (필수)</b></span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">재료명 한글</label></th>
				<td data-hgwtype="public">
					<input type="text" id="kname" style="height: 25px;">
				</td>
				<td colspan="2" style="border-left: 1px solid #dbdbdb;"></td>		
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">재료명 영문</label></th>
				<td data-hgwtype="public">
					<input type="text" id="ename" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">규격</label></th>
				<td data-hgwtype="public">
					<input type="text" id="kkyuk" style="height: 25px;">
				</td>		
			</tr>		
				
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">연간사용예정량</label></th>
				<td data-hgwtype="public">
					<input type="text" id="useqty" style="width:90%; height:25px;"><span style="margin-left:5px;">개</span>
				</td>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">단위</label></th>
				<td data-hgwtype="public">
					<input type="text" id="unitcd" style="height: 25px;">
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">국,외산</label></th>
				<td data-hgwtype="public" style="border-bottom: none;">
					<input type="text" id="k_foreign" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">제조(수입)사</label></th>
				<td data-hgwtype="public" style="border-bottom: none;">
					<input type="text" id="makenm" style="height: 25px;">
				</td>		
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" >
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>					
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">담당자명</label></th>
				<td data-hgwtype="public" style="border-bottom: none;">
					<input type="text" id="damdang" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">연락처</label></th>
				<td data-hgwtype="public" style="border-bottom: none;">
					<input type="text" id="tel" style="height: 25px;">
				</td>		
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" >
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>		
						
			<tr>
				<td data-hgwtype="public" colspan="4">
					<span style="color:blue"><b>* 해당 재료로 행하는 진료행위 (필요시 작성)</b></span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">처방코드</label></th>
				<td data-hgwtype="public">
					<input type="text" id="order_code" style="height: 25px;">
				</td>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">처방명칭</label></th>
				<td data-hgwtype="public">
					<input type="text" id="order_nm" style="height: 25px;">
				</td>		
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">진료행위수가</label></th>
				<td data-hgwtype="public" style="border-bottom: none;">
					<input type="text" id="suga" style="width:90%; height: 25px;"><span style="margin-left: 5px;">원</span>
				</td>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none; padding: 0px 0px 0px 0px;"><label for="htmlEditorLyr_1">해당 재료가<br>필요한 의료장비명</label></th>
				<td data-hgwtype="public" style="border-bottom: none;">
					<input type="text" id="jangbi" style="height:25px;">
				</td>		
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" >
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>					
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" rowspan="2" style="border-bottom: none;"><label for="htmlEditorLyr_1">취득구분</label></th>
				<td data-hgwtype="public" colspan="3">
					<label><input type="radio" id="gubun1" name="gubun" value="1" onchange="selectRadio()" /> 신규도입&nbsp;&nbsp;</label> 
					<label><input type="radio" id="gubun2" name="gubun" value="2" onchange="selectRadio()" /> 기존 유사재료 대체구입&nbsp;&nbsp;</label>
					<label><input type="radio" id="gubun3" name="gubun" value="3" onchange="selectRadio()" /> 기존 유사재료 병용사용구입&nbsp;&nbsp;</label>
				</td>
			</tr>
			
			<tr>
				<td data-hgwtype="public" colspan="3" style="padding-right: 5px; border-bottom: none;">
					<label><input type="radio" id="gubun4" name="gubun" value="4" class="input_radio" onchange="selectRadio()" > 기타&nbsp;</label>
					<input type="text" id="etctext" style="width:92%; height: 25px; padding: ">
				</td>
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" >
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>					
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">유사재료</label></th>
				<td data-hgwtype="public">
					<input type="radio" name="yousa" id="yousa1" class="input_radio" value="1" > 유&nbsp;
					<input type="radio" name="yousa" id="yousa2" class="input_radio" value="2" > 무
				</td>
				<th data-hgwtype="public" scope="row" class="lln"><label for="htmlEditorLyr_1">샘플링</label></th>
				<td data-hgwtype="public">
					<input type="radio" id="sample1" name="sample" class="input_radio" value="1" > 유&nbsp;
					<input type="radio" id="sample2" name="sample" class="input_radio" value="2" > 무
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom:none;"><label for="htmlEditorLyr_1">월간평균사용량</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom:none;">
					<input type="text" id="evr" style="height:25px;">
				</td>
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" >
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:33%">
				<col class="col2" style="width:33%">
				<col class="col3" style="width:33%">
			</colgroup>		
						
			<tr>
				<td colspan="3">
					<p style="font-weight:600; text-align:center">기존 (유사) 원내 사용재료 현황</p>
				</td>
			</tr>
			
			<tr>
				<th style="text-align:center; width:33%;">품목코드</th>
				<th style="text-align:center; width:33%;">구입단가(원)</th>
				<th style="text-align:center; width:33%; border-right:none;">창고재료수량(개)</th>
			</tr>
			
			<tr>
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="pummok1" style="width:99%; height: 25px;">
				</td>	
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="danga1" style="width:90%; height: 25px;"><span style="margin-left: 5px;">원</span>
				</td>	
				<td data-hgwtype="public">
					<input type="text" id="suryang1" style="width:90%; height: 25px;"><span style="margin-left: 5px;">개</span>
				</td>	
			</tr>
			
			<tr>
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="pummok2" style="width:99%; height: 25px;">
				</td>	
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="danga2" style="width:90%; height: 25px;"><span style="margin-left: 5px;">원</span>
				</td>	
				<td data-hgwtype="public">
					<input type="text" id="suryang2" style="width:90%; height: 25px;"><span style="margin-left: 5px;">개</span>
				</td>	
			</tr>
			
			<tr>
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="pummok3" style="width:99%; height: 25px;">
				</td>	
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="danga3" style="width:90%; height: 25px;"><span style="margin-left: 5px;">원</span>
				</td>	
				<td data-hgwtype="public">
					<input type="text" id="suryang3" style="width:90%; height: 25px;"><span style="margin-left: 5px;">개</span>
				</td>	
			</tr>
			
			<tr>
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="pummok4" style="width:99%; height: 25px;">
				</td>	
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb;">
					<input type="text" id="danga4" style="width:90%; height: 25px;"><span style="margin-left: 5px;">원</span>
				</td>	
				<td data-hgwtype="public">
					<input type="text" id="suryang4" style="width:90%; height: 25px;"><span style="margin-left: 5px;">개</span>
				</td>	
			</tr>
			
			<tr>
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb; border-bottom: none;">
					<input type="text" id="pummok5" style="width:99%; height: 25px;">
				</td>	
				<td data-hgwtype="public" style="border-right: 1px solid #dbdbdb; border-bottom: none;">
					<input type="text" id="danga5" style="width:90%; height: 25px;"><span style="margin-left: 5px;">원</span>
				</td>	
				<td data-hgwtype="public" style="border-bottom: none;">
					<input type="text" id="suryang5" style="width:90%; height: 25px;"><span style="margin-left: 5px;">개</span>
				</td>	
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" >
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>		
						
			<tr>
				<td colspan="4">
					<span style="color:red"><b>* 용도 및 효과를 구체적으로 알기 쉽게 기술(필수)</b></span>
				</td>
			</tr>
			
			<tr>
				<th data-hgwtype="public" scope="row" class="lln" style="border-bottom: none;"><label for="htmlEditorLyr_1">도입 필요성</label></th>
				<td data-hgwtype="public" colspan="3" style="border-bottom: none;">
					<input type="text" id="yongdo" style="height: 25px;">
				</td>
			</tr>
			
		</table>
	</div>
	<br>
	<div class="tablewrap-line" >
		<table class="table-datatype01">
		
			<colgroup class="colgroup_1">
				<col class="col1" style="width:17%">
				<col class="col2">
				<col class="col3" style="width:16%">
				<col class="col4" style="width:32%">
			</colgroup>
								
			<tr>
				<td colspan="4" style="border-bottom: none;">
					* 결재순서 : [기안자 -> 부서장 or 주임과장] 후 구매물류팀 담당자에게 발송해 주세요
				</td>
			</tr>
			
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000425_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000425_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>