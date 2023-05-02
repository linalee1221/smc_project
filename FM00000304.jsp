<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 인력 충원 요청서 -->
<!-- 연동아님!!!! -->

<style>	
	#FORM_FM00000304 {
		min-height: 404px !important;
		max-height: 600px !important;
		overflow-y: auto !important;
		margin-bottom: 10px;
	}
</style>

<script>
	alert("인력 충원 요청서 작성 전 인사운영팀과 사전 협의 후 작성하시기 바랍니다.\n- 정규직(간호직,보건직,관리직) : 김선겸(내선 8189)\n- 정규직(의료직), 계약직 전체 : 김민정(내선 8099)\n- 정규직(약무직,기능직,운영지원직) : 송현우(내선 8093)");
	/* 직군 select box 선택 값에 따라 직종 select 값 바꾸기 */
	function categoryChange(e) {
		var jobClass_1 = ["전문의", "일반의", "전공의"];
		var jobClass_2 = ["약사"];
		var jobClass_3 = ["간호사"];
		var jobClass_4 = ["방사선사", "임상병리사", "물리치료사", "작업치료사", "치위생사", "보건의료정보관리사", "안경사", "임상심리사", "언어치료사", "특수교사", "응급구조사", "영양사"];
		var jobClass_5 = ["사무관리사", "정보처리사", "사회복지사", "사서", "기계기사", "전기기사", "건축기사", "의공기사", "환경기사"];
		var jobClass_6 = ["수석연구원", "책임연구원", "선임연구원", "주임연구원", "연구원"];
		var jobClass_7 = ["운전원", "간호조무사", "방호원", "보조원", "상례사"];
		var jobClass_8 = ["조리원", "환경미화원", "원무행정원", "콜센터상담원", "시설유지관리원", "보안경비원"];
		var target = document.getElementById("jobClass");
	
		if(e.value == "1") var d = jobClass_1;
		else if(e.value == "2") var d = jobClass_2;
		else if(e.value == "3") var d = jobClass_3;
		else if(e.value == "4") var d = jobClass_4;
		else if(e.value == "5") var d = jobClass_5;
		else if(e.value == "6") var d = jobClass_6;
		else if(e.value == "7") var d = jobClass_7;
		else if(e.value == "8") var d = jobClass_8;
	
		target.options.length = 0;
	
		for (x in d) {
			var opt = document.createElement("option");
			opt.value = d[x];
			opt.innerHTML = d[x];
			target.appendChild(opt);
		}	
	}
	
	/* 경력기간 : 경력필요 선택 시 필요 경력기간 input box 활성화 / 그 외 비활성화 */
	function selectChange() {
		if ($('#needCareer option:selected').val() == '00' || $('#needCareer option:selected').val() == '01') {
			$('input[id="needCareerYear"]').prop("disabled", true);
			$('input[id="needCareerYear"]').val('');
		} else if ($('#needCareer option:selected').val() == '02') {
			$('#needCareerYear').prop("disabled", false);
			$('#needCareerYear').focus();
		}
	}
	
	/* 기타세부자격사항 필수사항 및 우대사항 체크박스 체크 시 input 활성화 */
	function toggleTextbox(checkbox) {
		const textbox_elem = document.getElementById("essential_txt");
		textbox_elem.disabled = checkbox.checked ? false : true;
		if (textbox_elem.disabled) {
	    	textbox_elem.value = null;
	  	} else {
	    	textbox_elem.focus();
	  	}
	}
	
	function toggleTextbox2(checkbox) {
		const textbox_elem = document.getElementById("prefer_txt");
		textbox_elem.disabled = checkbox.checked ? false : true;
		if (textbox_elem.disabled) {
	    	textbox_elem.value = null;
	  	} else {
	    	textbox_elem.focus();
	  	}
	}	
	
	/* 구분(정원내,정원증원필요) 선택 시 각 radio 활성화 */
	function selectOption() {
	if ($('select[name="memberTypeSelect"]').val() == "0") {
		$('.memberTypeA').prop("disabled", true);
		$('.memberTypeB').prop("disabled", true);
		$('.memberTypeA').prop("checked", false);
		$('.memberTypeB').prop("checked", false);
		$('#memberType7').hide();
		$('input[id="memberType3_txt"]').val('');
		$('input[id="memberType6_txt"]').val('');
		
	}
   	if ($('select[name="memberTypeSelect"]').val() == "1") {
   		$('.memberTypeA').prop("disabled", false);
   		$('.memberTypeB').prop("disabled", true);
   		$('.memberTypeB').prop("checked", false);
   		$('#memberType7').hide();
   		$('input[id="memberType6_txt"]').val('');
		$('input[id="memberType3_txt"]').prop("disabled", true);
			if ($('input[id="memberType3"]:checked').val() == "3") {
				$('input[id="memberType3_txt"]').prop("disabled", false);
				$('#memberType3_txt').focus();
			}
   		}
  	if($('select[name="memberTypeSelect"]').val() == "2") {
  		$('.memberTypeA').prop("disabled", true);
  		$('.memberTypeB').prop("disabled", false);
  		$('.memberTypeA').prop("checked", false);
  		$('#memberType7').show();
  		$('input[id="memberType3_txt"]').val('');
		$('input[id="memberType6_txt"]').prop("disabled", true);
			if ($('input[id="memberType6"]:checked').val() == "6") {
				$('input[id="memberType6_txt"]').prop("disabled", false);
				$('#memberType6_txt').focus();
			}
   		}
	}
	
	$('#FM00000304_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000304').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var legacydata = [];
		
		// 1. 데이터 저장
		legacydata.push({
			NOT_LINK      	 : '연동아님'
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		//1. 요청인력 기초사항 start
        if (document.getElementById("peopleNum").value == "") {
            alert("요청인원 수를 입력해주세요.");
            document.getElementById("peopleNum").focus();
            return false;
        }
        if (document.getElementById("jobGroup").value == "0") {
            alert("직군을 선택해해주세요.");
            document.getElementById("jobGroup").focus();
            return false;
        }
        if (document.getElementById("needCareer").value == "00") {
            alert("경력기간을 선택해주세요.");
            document.getElementById("needCareer").focus();
            return false;
        } else {
            if (document.getElementById("needCareer").value == "02" && document.getElementById("needCareerYear").value == "") {
                alert("필요 경력기간을 입력해주세요.");
                document.getElementById("needCareerYear").focus();
                return false;
            }
        }
        if (document.getElementById("essential").checked == true) {
            if (document.getElementById("essential_txt").value == '') {
                alert("필수사항을 입력해주세요");
                document.getElementById("essential_txt").focus();
                return false;
            }
        }
        if (document.getElementById("prefer").checked == true) {
            if (document.getElementById("prefer_txt").value == '') {
                alert("우대사항을 입력해주세요");
                document.getElementById("prefer_txt").focus();
                return false;
            }
        }
        //1. 요청인력 기초사항 end
        
        //2. 충원 요청사유 start
        if (document.getElementById("memberTypeSelect").value == "0") {
            alert("충원 구분을 선택해주세요");
            document.getElementById("memberTypeSelect").focus();
            return false;
        }
        if (document.getElementById("memberTypeSelect").value == "1") {
            if (document.getElementById("memberType1").checked == false && document.getElementById("memberType2").checked == false && document.getElementById("memberType3").checked == false) {
                alert("충원 상세구분을 선택해주세요.");
                document.getElementById("memberType1").focus();
                return false;
            } else if (document.getElementById("memberType1").checked == false && document.getElementById("memberType2").checked == false && (document.getElementById("memberType3").checked == true && document.getElementById("memberType3_txt").value == "")) {
                //기타 사항을 입력 안했을 경우
                alert("기타 사유를 입력해주세요.");
                document.getElementById("memberType3_txt").focus();
                return false;
            }
        } else if (document.getElementById("memberTypeSelect").value == "2") {
            if (document.getElementById("memberType4").checked == false && document.getElementById("memberType5").checked == false && document.getElementById("memberType6").checked == false) {
                alert("충원 상세구분을 선택해주세요.");
                document.getElementById("memberType4").focus();
                return false;
            } else if (document.getElementById("memberType4").checked == false && document.getElementById("memberType5").checked == false && (document.getElementById("memberType6").checked == true && document.getElementById("memberType6_txt").value == "")) {
                //기타 사항을 입력 안했을 경우
                alert("기타 사유를 입력해주세요.");
                document.getElementById("memberType6_txt").focus();
                return false;
            }
        }
        if (document.getElementById("chungwonsayou").value == "") {
            alert("세부 요청 사유를 기재해주세요.");
            document.getElementById("chungwonsayou").focus();
            return false;
        }
        //2. 충원 요청사유 end
        
        // 직무설명서 start
        if (document.getElementById("gaeyo").value == "") {
            alert("개요를 작성해주세요");
            document.getElementById("gaeyo").focus();
            return false;
        }
        if (document.getElementById("sebujikmu").value == "") {
            alert("세부직무를 작성해주세요");
            document.getElementById("sebujikmu").focus();
            return false;
        }
        if (document.getElementById("ubmu").value == "") {
            alert("업무내용을 작성해주세요");
            document.getElementById("ubmu").focus();
            return false;
        }
        if (document.getElementById("jikmu1").value == "") {
            alert("직무요건 내 [자격]을 작성해주세요");
            document.getElementById("jikmu1").focus();
            return false;
        }
        if (document.getElementById("jikmu2").value == "") {
            alert("직무요건 내 [지식]을 작성해주세요");
            document.getElementById("jikmu2").focus();
            return false;
        }
        if (document.getElementById("jikmu3").value == "") {
            alert("직무요건 내 [기술]을 작성해주세요");
            document.getElementById("jikmu3").focus();
            return false;
        }
        if (document.getElementById("jikmu4").value == "") {
            alert("직무요건 내 [역량]을 작성해주세요");
            document.getElementById("jikmu4").focus();
            return false;
        }
        
    	if($('select[name="memberTypeSelect"]').val() == "2") {
    		alert("증원이 필요하실 경우 [정원 증원시 인력운영계획서] 를 추가로 작성해 주십시오.");
    	}
		
        
     	// 3. validation check 후 기안기에 내용 입력
		// 요청부서 : 기안부서, 요청일 : 기안일자
		
		// 요청인력 기초사항
		// 요청인원 : peopleNum, 고용형태 - 정규직 : emplStatus1, 공무직 : emplStatus2, 계약직 : emplStatus3
		// 직군 - 의료직 : jobGroup1, 약무직 : jobGroup2, 간호직 : jobGroup3, 보건직 : jobGroup4
		//		  관리직 : jobGroup5, 연구직 : jobGroup6, 기능직 : jobGroup7, 운영지원직 : jobGroup8
		// 직종 : jobClass
		// 경력기간 - 경력무관 : needCareer1, 경력필요 : needCareer2, 년수 : needCareerYear
		// 기타세부자격사항 - 필수 : essential, 입력칸 : essential_txt, 우대 : prefer, 입력칸 : prefer_txt
		
		// 충원 요청사유
		// 정원내 - 퇴직 : memberType1, 휴직 : memberType2, 기타 : memberType3, 입력칸 : memberType3_txt
		// 정원증원 - 업무량증가 : memberType4, 신규사업 : memberType5, 기타 : memberType6, 입력칸 : memberType6_txt
		// 세부요청사유 : chungwonsayou
		
		// 직무설명서
		// 채용분야 - 직군 : jikgunName, 직종 : jobClass, 부서 : 기안부서
		// 개요 : gaeyo, 세부직무 : sebujikmu, 업무내용 : ubmu
		// 직무요건 - 자격 : jikmu1, 지식 : jikmu2, 기술 : jikmu3, 역량 : jikmu4
		// 비고 : bigo
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		// 요청부서 : 기안부서, 요청일 : 기안일자
		_$hwpObj.insertSignData('기안부서', HGW_APPR_BANK.loginVO.dept_nm); // 기안부서
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일')); // 기안일자
		
		// 요청인력 기초사항
		// 요청인원 : peopleNum
		_$hwpObj.insertSignData('peopleNum', $('#peopleNum').val()); // 요청인원
		
		// 고용형태 - 정규직 : emplStatus1, 공무직 : emplStatus2, 계약직 : emplStatus3
		if ($('#emplStatus option:selected').val() == '1') {
			_$hwpObj.insertSignData('emplStatus1', '■');
			_$hwpObj.insertSignData('emplStatus2', '□');
			_$hwpObj.insertSignData('emplStatus3', '□');
		} else if ($('#emplStatus option:selected').val() == '2') {
			_$hwpObj.insertSignData('emplStatus1', '□');
			_$hwpObj.insertSignData('emplStatus2', '■');
			_$hwpObj.insertSignData('emplStatus3', '□');
		} else {
			_$hwpObj.insertSignData('emplStatus1', '□');
			_$hwpObj.insertSignData('emplStatus2', '□');
			_$hwpObj.insertSignData('emplStatus3', '■');
		}
		
		// 직군 - 의료직 : jobGroup1, 약무직 : jobGroup2, 간호직 : jobGroup3, 보건직 : jobGroup4
		//		  관리직 : jobGroup5, 연구직 : jobGroup6, 기능직 : jobGroup7, 운영지원직 : jobGroup8
		if ($('#jobGroup option:selected').val() == '1') {
			_$hwpObj.insertSignData('jobGroup1', '■');
			_$hwpObj.insertSignData('jobGroup2', '□');
			_$hwpObj.insertSignData('jobGroup3', '□');
			_$hwpObj.insertSignData('jobGroup4', '□');
			_$hwpObj.insertSignData('jobGroup5', '□');
			_$hwpObj.insertSignData('jobGroup6', '□');
			_$hwpObj.insertSignData('jobGroup7', '□');
			_$hwpObj.insertSignData('jobGroup8', '□');
		} else if ($('#jobGroup option:selected').val() == '2') {
			_$hwpObj.insertSignData('jobGroup1', '□');
			_$hwpObj.insertSignData('jobGroup2', '■');
			_$hwpObj.insertSignData('jobGroup3', '□');
			_$hwpObj.insertSignData('jobGroup4', '□');
			_$hwpObj.insertSignData('jobGroup5', '□');
			_$hwpObj.insertSignData('jobGroup6', '□');
			_$hwpObj.insertSignData('jobGroup7', '□');
			_$hwpObj.insertSignData('jobGroup8', '□');
		} else if ($('#jobGroup option:selected').val() == '3') {
			_$hwpObj.insertSignData('jobGroup1', '□');
			_$hwpObj.insertSignData('jobGroup2', '□');
			_$hwpObj.insertSignData('jobGroup3', '■');
			_$hwpObj.insertSignData('jobGroup4', '□');
			_$hwpObj.insertSignData('jobGroup5', '□');
			_$hwpObj.insertSignData('jobGroup6', '□');
			_$hwpObj.insertSignData('jobGroup7', '□');
			_$hwpObj.insertSignData('jobGroup8', '□');
		} else if ($('#jobGroup option:selected').val() == '4') {
			_$hwpObj.insertSignData('jobGroup1', '□');
			_$hwpObj.insertSignData('jobGroup2', '□');
			_$hwpObj.insertSignData('jobGroup3', '□');
			_$hwpObj.insertSignData('jobGroup4', '■');
			_$hwpObj.insertSignData('jobGroup5', '□');
			_$hwpObj.insertSignData('jobGroup6', '□');
			_$hwpObj.insertSignData('jobGroup7', '□');
			_$hwpObj.insertSignData('jobGroup8', '□');
		} else if ($('#jobGroup option:selected').val() == '5') {
			_$hwpObj.insertSignData('jobGroup1', '□');
			_$hwpObj.insertSignData('jobGroup2', '□');
			_$hwpObj.insertSignData('jobGroup3', '□');
			_$hwpObj.insertSignData('jobGroup4', '□');
			_$hwpObj.insertSignData('jobGroup5', '■');
			_$hwpObj.insertSignData('jobGroup6', '□');
			_$hwpObj.insertSignData('jobGroup7', '□');
			_$hwpObj.insertSignData('jobGroup8', '□');
		} else if ($('#jobGroup option:selected').val() == '6') {
			_$hwpObj.insertSignData('jobGroup1', '□');
			_$hwpObj.insertSignData('jobGroup2', '□');
			_$hwpObj.insertSignData('jobGroup3', '□');
			_$hwpObj.insertSignData('jobGroup4', '□');
			_$hwpObj.insertSignData('jobGroup5', '□');
			_$hwpObj.insertSignData('jobGroup6', '■');
			_$hwpObj.insertSignData('jobGroup7', '□');
			_$hwpObj.insertSignData('jobGroup8', '□');
		} else if ($('#jobGroup option:selected').val() == '7') {
			_$hwpObj.insertSignData('jobGroup1', '□');
			_$hwpObj.insertSignData('jobGroup2', '□');
			_$hwpObj.insertSignData('jobGroup3', '□');
			_$hwpObj.insertSignData('jobGroup4', '□');
			_$hwpObj.insertSignData('jobGroup5', '□');
			_$hwpObj.insertSignData('jobGroup6', '□');
			_$hwpObj.insertSignData('jobGroup7', '■');
			_$hwpObj.insertSignData('jobGroup8', '□');
		} else if ($('#jobGroup option:selected').val() == '8') {
			_$hwpObj.insertSignData('jobGroup1', '□');
			_$hwpObj.insertSignData('jobGroup2', '□');
			_$hwpObj.insertSignData('jobGroup3', '□');
			_$hwpObj.insertSignData('jobGroup4', '□');
			_$hwpObj.insertSignData('jobGroup5', '□');
			_$hwpObj.insertSignData('jobGroup6', '□');
			_$hwpObj.insertSignData('jobGroup7', '□');
			_$hwpObj.insertSignData('jobGroup8', '■');
		}
		
		// 경력기간 - 경력무관 : needCareer1, 경력필요 : needCareer2, 년수 : needCareerYear
		if ($('#needCareer option:selected').val() == '01') {
			_$hwpObj.insertSignData('needCareer1', '■');
		} else if ($('#needCareer option:selected').val() == '02') {
			_$hwpObj.insertSignData('needCareer1', '□');
			_$hwpObj.insertSignData('needCareer2', '■');
			_$hwpObj.insertSignData('needCareerYear', $('input[id="needCareerYear"]').val());
		} else {
			_$hwpObj.insertSignData('needCareer1', '□');
			_$hwpObj.insertSignData('needCareer2', '□');
			_$hwpObj.insertSignData('needCareerYear', '(00)');
		}
		
		// 기타세부자격사항 - 필수 : essential, 입력칸 : essential_txt, 우대 : prefer, 입력칸 : prefer_txt
		if ($('input[id="essential"]:checked').val() == '1') {
			_$hwpObj.insertSignData('essential', '■');
			_$hwpObj.insertSignData('essential_txt', $('#essential_txt').val());
		} else if ($('input[id="essential"]:checked').val() == null) {
			_$hwpObj.insertSignData('essential', '□');
			_$hwpObj.deleteSignData('essential_txt');
		}
		if ($('input[id="prefer"]:checked').val() == '2') {
			_$hwpObj.insertSignData('prefer', '■');
			_$hwpObj.insertSignData('prefer_txt', $('#prefer_txt').val());
		} else if ($('input[id="prefer"]:checked').val() == null) {
			_$hwpObj.insertSignData('prefer', '□');
			_$hwpObj.deleteSignData('prefer_txt');
		}
		
		// 정원내 - 퇴직 : memberType1, 휴직 : memberType2, 기타 : memberType3, 입력칸 : memberType3_txt
		// 정원증원 - 업무량증가 : memberType4, 신규사업 : memberType5, 기타 : memberType6, 입력칸 : memberType6_txt
		if ($('select[name="memberTypeSelect"]').val() == "0") {
			_$hwpObj.insertSignData('memberType1', '□');
			_$hwpObj.insertSignData('memberType2', '□');
			_$hwpObj.insertSignData('memberType3', '□');
			_$hwpObj.insertSignData('memberType4', '□');
			_$hwpObj.insertSignData('memberType5', '□');
			_$hwpObj.insertSignData('memberType6', '□');
			_$hwpObj.deleteSignData('memberType3_txt');
			_$hwpObj.deleteSignData('memberType6_txt');
		} else if ($('select[name="memberTypeSelect"]').val() == "1") {
			if ($('input[id="memberType1"]:checked').val() == "1") {
				_$hwpObj.insertSignData('memberType1', '■');
				_$hwpObj.insertSignData('memberType2', '□');
				_$hwpObj.insertSignData('memberType3', '□');
				_$hwpObj.insertSignData('memberType4', '□');
				_$hwpObj.insertSignData('memberType5', '□');
				_$hwpObj.insertSignData('memberType6', '□');
				_$hwpObj.deleteSignData('memberType3_txt');
				_$hwpObj.deleteSignData('memberType6_txt');
				
			} else if ($('input[id="memberType2"]:checked').val() == "2") {
				_$hwpObj.insertSignData('memberType1', '□');
				_$hwpObj.insertSignData('memberType2', '■');
				_$hwpObj.insertSignData('memberType3', '□');
				_$hwpObj.insertSignData('memberType4', '□');
				_$hwpObj.insertSignData('memberType5', '□');
				_$hwpObj.insertSignData('memberType6', '□');
				_$hwpObj.deleteSignData('memberType3_txt');
				_$hwpObj.deleteSignData('memberType6_txt');
			} else {
				_$hwpObj.insertSignData('memberType1', '□');
				_$hwpObj.insertSignData('memberType2', '□');
				_$hwpObj.insertSignData('memberType3', '■');
				_$hwpObj.insertSignData('memberType4', '□');
				_$hwpObj.insertSignData('memberType5', '□');
				_$hwpObj.insertSignData('memberType6', '□');
				_$hwpObj.insertSignData('memberType3_txt', $('#memberType3_txt').val());
				_$hwpObj.deleteSignData('memberType6_txt');
			}
		} else if ($('select[name="memberTypeSelect"]').val() == "2") {
			if ($('input[id="memberType4"]:checked').val() == "4") {
				_$hwpObj.insertSignData('memberType1', '□');
				_$hwpObj.insertSignData('memberType2', '□');
				_$hwpObj.insertSignData('memberType3', '□');
				_$hwpObj.insertSignData('memberType4', '■');
				_$hwpObj.insertSignData('memberType5', '□');
				_$hwpObj.insertSignData('memberType6', '□');
				_$hwpObj.deleteSignData('memberType3_txt');
				_$hwpObj.deleteSignData('memberType6_txt');
			} else if ($('input[id="memberType5"]:checked').val() == "5") {
				_$hwpObj.insertSignData('memberType1', '□');
				_$hwpObj.insertSignData('memberType2', '□');
				_$hwpObj.insertSignData('memberType3', '□');
				_$hwpObj.insertSignData('memberType4', '□');
				_$hwpObj.insertSignData('memberType5', '■');
				_$hwpObj.insertSignData('memberType6', '□');
				_$hwpObj.deleteSignData('memberType3_txt');
				_$hwpObj.deleteSignData('memberType6_txt');
			} else {
				_$hwpObj.insertSignData('memberType1', '□');
				_$hwpObj.insertSignData('memberType2', '□');
				_$hwpObj.insertSignData('memberType3', '□');
				_$hwpObj.insertSignData('memberType4', '□');
				_$hwpObj.insertSignData('memberType5', '□');
				_$hwpObj.insertSignData('memberType6', '■');
				_$hwpObj.insertSignData('memberType6_txt', $('#memberType6_txt').val());
				_$hwpObj.deleteSignData('memberType3_txt');
			}
		}
		
		// 세부요청사유 : chungwonsayou
		_$hwpObj.insertSignData('chungwonsayou', $('#chungwonsayou').val());
		
		// 채용분야 - 직군 : jikgunName, 직종 : jobClass, 부서 : 기안부서
		_$hwpObj.insertSignData('jikgunName', $('#jobGroup option:selected').text());
		
		// 개요 : gaeyo, 세부직무 : sebujikmu, 업무내용 : ubmu
		_$hwpObj.insertSignData('gaeyo', $('#gaeyo').val());
		_$hwpObj.insertSignData('sebujikmu', $('#sebujikmu').val());
		_$hwpObj.insertSignData('ubmu', $('#ubmu').val());
		
		// 직무요건 - 자격 : jikmu1, 지식 : jikmu2, 기술 : jikmu3, 역량 : jikmu4
		_$hwpObj.insertSignData('jikmu1', $('#jikmu1').val());
		_$hwpObj.insertSignData('jikmu2', $('#jikmu2').val());
		_$hwpObj.insertSignData('jikmu3', $('#jikmu3').val());
		_$hwpObj.insertSignData('jikmu4', $('#jikmu4').val());

		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기		
	$('#FM00000304_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<form id="FORM_FM00000304">
	<span>
		<h4>
			<b>1. 요청인력 기초사항</b>
		</h4>
	</span> 
	<br>
	
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr>
					<th>요청인원</th>
					<td colspan="2"><input id="peopleNum" type="text" style="width: 60%; height: 25px;" maxlength="3" />&nbsp;명</td>
					<th>고용형태</th>
					<td colspan="2">
						<select name="emplStatus" id="emplStatus" style="width: 60%; height: 25px;">
							<option value="1">정규직</option>
							<option value="2">공무직</option>
							<option value="3">계약직</option>
						</select>
					</td>
				</tr>
				
				<tr>
					<th>직군</th>
					<td colspan="2">
						<select name="jobGroup" id="jobGroup" style="width: 60%; height: 25px;" onchange="categoryChange(this)">
							<option value="0">선택하세요.</option>
							<option value="1">의료직</option>
							<option value="2">약무직</option>
							<option value="3">간호직</option>
							<option value="4">보건직</option>
							<option value="5">관리직</option>
							<option value="6">연구직</option>
							<option value="7">기능직</option>
							<option value="8">운영지원직</option>
						</select>
					</td>
					<th>직종</th>
					<td colspan="2">
						<select name="jobClass" id="jobClass" style="width: 60%; height: 25px;">
							<option></option>
						</select>
					</td>
				</tr>
				
				<tr>
					<th style="border-bottom: none;">경력기간</th>
					<td colspan="2" style="border-bottom: none;">
						<select id="needCareer" onchange="selectChange(this)" style="width: 60%; height: 25px;" >
							<option value="00">선택하세요.</option>
							<option value="01">경력무관</option>
							<option value="02">경력필요</option>
						</select>
					<th style="border-bottom: none;">필요 경력기간</th>
					<td colspan="2" style="border-bottom: none;">
						<input id="needCareerYear" type="text" style="width: 20%; height: 25px;" maxlength="3" disabled />&nbsp;년 이상
					</td>
				</tr>
				
			</table>
		</div>

		<div class="tablewrap-line" style="margin-top: 10px;">
			<table class="table-datatype01">

				<tr>
					<th colspan="6" style="border-right: none; text-align: left;">
						<b>기타 세부자격사항(필요시 체크 후 작성) ※서류전형시 증빙서류 등으로 확인가능한 조건만 제시</b>
					</th>
				</tr>
				
				<tr>
					<td style="width: 15%; border-right: 1px solid #dbdbdb;">
						<input type="checkbox" class="checkbox" value="1" id="essential" onclick='toggleTextbox(this)' />&nbsp;
							<label for="essential">필수사항</label>
					</td>
					<td colspan="5">&nbsp;
						<input type="text" id="essential_txt" style="width: 85%; height: 25px;" maxlength="50" disabled />
					</td>
				</tr>
				
				<tr>
					<td style="width: 15%; border-right: 1px solid #dbdbdb; border-bottom: none;">
						<input type="checkbox" class="checkbox" value="2" id="prefer" onclick='toggleTextbox2(this)'/>&nbsp;
							<label for="prefer">우대사항</label>
					</td>
					<td colspan="5" style="border-bottom: none;">&nbsp;
						<input type="text" id="prefer_txt" style="width: 85%; height: 25px;" maxlength="50" disabled />
					</td>
				</tr>

			</table>
		</div>

		<br> 
		<span>
			<h4>
				<b>2. 충원 요청사유</b>
			</h4>
		</span>
		<br>

		<div class="tablewrap-line" style="margin-top: 10px;">
			<table class="table-datatype01">

				<tr>
			        <th style="width:5%" rowspan="2">구분</th>
			        <td style="width:20%; border-right: 1px solid #dbdbdb;" rowspan="2">
			            <select name="memberTypeSelect" id="memberTypeSelect" style="width:80%; height:25px;" onchange="selectOption()">
			              <option value="0">선택하세요.</option>
			              <option value="1">정원내</option>
			              <option value="2">정원증원필요</option>
			            </select>
			        </td> 
			        <td style="width:12%; border-right:1px solid #dbdbdb;">
			            <input type="radio" class="memberTypeA" name="memberTypeA" value="1" id="memberType1" onchange="selectOption()" disabled>&nbsp;<label for="memberType1">퇴직</label>
			        </td>
			        <td style="width:10%; border-right:1px solid #dbdbdb;">
			            <input type="radio" class="memberTypeA" name="memberTypeA" value="2" id="memberType2" onchange="selectOption()" disabled>&nbsp;<label for="memberType2">휴직</label> 
			        </td>
			        <td style="width:40%;" colspan="2">
			            <input type="radio" class="memberTypeA" name="memberTypeA" value="3" id="memberType3" onchange="selectOption()" disabled>&nbsp;<label for="memberType3">기타</label>&nbsp;<input id="memberType3_txt" type="text" style="width:80%; height:25px;" disabled/>
			
			        </td>
			    </tr>
			    <tr>
			        <td style="width:12%; border-right:1px solid #dbdbdb;">
			            <input type="radio" class="memberTypeB" name="memberTypeB" value="4" id="memberType4" onchange="selectOption()" disabled>&nbsp;<label for="memberType4">업무량 증가</label>
			        </td>
			        <td style="width:10%; border-right:1px solid #dbdbdb;">
			            <input type="radio" class="memberTypeB" name="memberTypeB" value="5" id="memberType5" onchange="selectOption()" disabled>&nbsp;<label for="memberType5">신규사업</label> 
			        </td>
			        <td style="width:40%" colspan="2">
			            <input type="radio" class="memberTypeB" name="memberTypeB" value="6" id="memberType6" onchange="selectOption()" disabled>&nbsp;<label for="memberType6">기타</label>&nbsp;<input onFocus="this.value=''; return true;" id="memberType6_txt" type="text" style="width:80%; height:25px;" disabled/>
			        </td>
			    </tr>
				<tr>
					<td colspan="6" style="width: 100%; height: 20px; text-align: center;">
						
						<span style="color: blue; display: none;" id="memberType7" onchange="selectOption()">
						* 증원이 필요하실 경우 
						<span><strong>[정원 증원시 인력운영계획서]</strong></span> 를 추가로 작성해 주십시오.
					</span>

					</td>
				</tr>
				<tr>
					<th colspan="6"
						style="width: 100%; text-align: left; border-right: none;"><b>요청사유
							세부기재(필수)</b></th>
				</tr>
				<tr>
					<td colspan="6" style="border-bottom: none;"><textarea
							id="chungwonsayou" style="width: 100%; height: 35%;" rows="8">
예시) 충원사유가 휴직으로 인한 경우
1. 직원 000 휴직에 따른 충원 요청 
- 휴직기간 
ㆍ 모성보호 휴직 : 0000.00.00. ~ 0000.00.00.
ㆍ 출산휴가        : 0000.00.00. ~ 0000.00.00.
ㆍ 육아휴직        : 0000.00.00. ~ 0000.00.00.</textarea></td>
				</tr>

			</table>
		</div>

		<br> <span><h4>
				<b>직무설명서</b>
			</h4></span> <br>

		<div class="tablewrap-line" style="margin-top: 10px;">
			<table class="table-datatype01">

				<tr>
					<th style="width: 100%; text-align: left;"><b>개요</b></th>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 13px; padding-bottom: 13px">예시)
						<br />• 조직의 중장기 경영전략을 수립하고 경영성과 분석 및 평가를 통해 조직 성과를 극대화 하는 업무를 수행<br />
					</td>
				</tr>
				<tr>
					<td colspan="4" style="border-bottom: none;"><textarea
							id="gaeyo" style="width: 100%; height: 70px;" rows="3"></textarea></td>
				</tr>
			</table>
		</div>

		<div class="tablewrap-line" style="margin-top: 10px;">
			<table class="table-datatype01">

				<tr>
					<th style="width: 100%; text-align: left;"><b>세부직무</b></th>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 13px; padding-bottom: 13px">예시)
						<br />• 경영기획 : 회사의 중장기 전략 방향 설정, 경영 개선 등 외부 성장과 내부 안정성 확보를 통해 전사
						성과 극대화를 이끄는 직무 <br />• 경영평가 : 경영실적관리, 조직성과 관리 등 경영전략에 대한 성과를 평가하고
						분석하는 직무 <br />• 예산편성 및 통제 : 보조금 관리 및 부서별 예산 편성 관리에 관한 직무<br />
					</td>
				</tr>
				<tr>
					<td colspan="4" style="border-bottom: none;"><textarea
							id="sebujikmu" style="width: 100%; height: 70px;" rows="4"></textarea></td>
				</tr>

			</table>
		</div>

		<div class="tablewrap-line" style="margin-top: 10px;">
			<table class="table-datatype01">

				<tr>
					<th style="width: 100%; text-align: left;"><b>업무내용</b></th>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 13px; padding-bottom: 13px">예시)
						<br />• 경쟁사 분석을 통해 회사의 경영성과를 비교 <br />• 영업 전략 수립, 프로젝트 기획 및 개발 등
						각종 사업을 기획 <br />• 당해 연도 경영실적 종합분석 및 익년도 사업계획 편성을 위한 업적협의회 주관 <br />•
						조직성과를 공유하고 주요 사업을 보고 <br />• 조직목표 달성정도, 자원사용의 효율성, 그 밖의 경영성과에 대한
						분석 및 평가 <br />• 조직의 비전, 목표 등을 고려하여 홍보계획을 수립<br />
					</td>
				</tr>
				<tr>
					<td colspan="4" style="border-bottom: none;"><textarea
							id="ubmu" style="width: 100%; height: 70px;" rows="7"></textarea></td>
				</tr>

			</table>
		</div>

		<div class="tablewrap-line" style="margin-top: 10px;">
			<table class="table-datatype01">

				<tr>
					<th style="width: 100%; text-align: left;"><b>직무요건</b></th>
				</tr>
				<tr>
					<th style="width: 100%; text-align: left;"><b>자격</b></th>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 13px; padding-bottom: 13px">예시)
						<br />• 경영, 경제, 회계, 통계 관련 자격증 <br />• 인사 및 조직관리 관련 자격증<br />
					</td>
				</tr>
				<tr>
					<td colspan="4"><textarea id="jikmu1"
							style="width: 100%; height: 70px;" rows="3"></textarea></td>
				</tr>
				<tr>
					<th style="width: 100%; text-align: left;"><b>지식</b></th>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 13px; padding-bottom: 13px">예시)
						<br />• 사업 혹은 프로젝트 기획 추진 관련 경험 <br />• 병원 행정 관련 지식 전반<br />

					</td>
				</tr>
				<tr>
					<td colspan="4"><textarea id="jikmu2"
							style="width: 100%; height: 70px;" rows="3"></textarea></td>
				</tr>
				<tr>
					<th style="width: 100%; text-align: left;"><b>기술</b></th>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 13px; padding-bottom: 13px">예시)
						<br />• 업무용 소프트웨어 및 사무기기 활용 기술 필수 (엑셀, 파워포인트)<br />
					</td>
				</tr>
				<tr>
					<td colspan="4"><textarea id="jikmu3"
							style="width: 100%; height: 70px;" rows="3"></textarea></td>
				</tr>
				<tr>
					<th style="width: 100%; text-align: left;"><b>역량</b></th>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 13px; padding-bottom: 13px">예시)
						<br />• 커뮤니케이션 능력, 문제해결 능력, 대인관계 능력<br />
					</td>
				</tr>
				<tr>
					<td colspan="4" style="border-bottom: none;"><textarea
							id="jikmu4" style="width: 100%; height: 70px;" rows="3"></textarea></td>
				</tr>
			
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000304_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000304_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>