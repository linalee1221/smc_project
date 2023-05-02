<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<link rel="stylesheet" type="text/css" href="/emr/css/emr.css" />
<link rel="stylesheet" type="text/css" href="/css/themes/base/jquery.ui.all.css" />
<link href="/css/hgw/ui.dynatree.css" rel="stylesheet">
<link href="/css/bootstrap.css" rel="stylesheet"> 
<link href="/css/bootstrap-table.css" rel="stylesheet">
<link href="/css/fixs_basic.css" rel="stylesheet">
<link href="/hipo_js/js/style.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="/css/layout.css" />
<link rel="stylesheet" type="text/css" href="/css/hicss_btn_set.css" />
<link rel="stylesheet" type="text/css" href="/css/fontawesome/all.min.css">

<script type="text/javascript" src="/js/jquery-1.11.1.js"></script>
<script type="text/javascript" src="/js/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="/js/bootstrap.js"></script>

<%
	String ssoToken = request.getParameter("ssoToken");                                
%>

<script>
var pNoticeBoardID = "B0000600";
var pNewBoardID = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
var pScheduleGubun = "D";
var ContentID = "noticeitem";
var ssoToken = "<%= ssoToken %>"; 
var user_id = "";
var user_emp_id = "";
var pEmr = "N";
var morningNum = 0;
var lunchNum = 0;
var dinnerNum = 0;
var date = "";
var menu1 = "";
var menu2 = "";
var menu3 = "";
var menu4 = "";
var menu5 = "";
var menu6 = "";
var menu7 = "";
var menu8 = "";
var menu9 = "";
var list = "";
var cnt = "";
var morningMenu = "";
var lunchMenu = "";
var dinnerMenu = "";
var today = new Date();
var todayYear = today.getFullYear();
var todayMonth = today.getMonth()+1;
var todayDay = today.getDate();
var DayWeek = today.getDay();
var todaySikdan = todayYear+"-"+(("00"+todayMonth.toString()).slice(-2))+"-"+(("00"+todayDay.toString()).slice(-2))

if (DayWeek == '0') {
	DayWeek = "일요일";
} else if (DayWeek == '1') {
	DayWeek = "월요일";
} else if (DayWeek == '2') {
	DayWeek = "화요일";
} else if (DayWeek == '3') {
	DayWeek = "수요일";
} else if (DayWeek == '4') {
	DayWeek = "목요일";
} else if (DayWeek == '5') {
	DayWeek = "금요일";
} else if (DayWeek == '6') {
	DayWeek = "토요일";
}

$(function(){
	console.log('토큰 ::',ssoToken);
	//사용자 기본 정보 가져오기
	
	$.ajax({
		url: '/emruserinfo.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {'ssoToken':ssoToken}
	})
	.success(function(res) {
		console.log(res);
		if(res.user_id != undefined){
			user_id = res.user_id;
		}
		if(res.user_emp_id != undefined && res.user_emp_id != ""){
			user_emp_id = res.user_emp_id;
		}
	});
	
// 	user_id = 'US00001520';
// 	user_emp_id = '04132';
	
});

// 건수 가져오기
$(document).ready(function () {
	
	console.log("로그인한 유저ID :: ", user_id);
	
	$.ajax({
		url: '/interwork/countBox.hi',
		dataType: 'json',
		type: 'POST',
		async:false,
		data: {
			'user_id' : user_id
		}
	}).success(function(response) {
		console.log("건수 데이터 : ", response);
		
		$('#waitAppr').text(response.rows[0].boxCNT);
		$('#apprProgress').text(response.rows[1].boxCNT);
		$('#waitReception').text(response.rows[2].boxCNT);
		$('#returnDoc').text(response.rows[3].boxCNT);
	});
	
	getNoticeList();
	getScheduleList();
	
	function getToday() {
    var today = new Date();
    var days = ['일', '월', '화', '수', '목', '금', '토'];
    var year = today.getFullYear();
    var month = today.getMonth() + 1;
    var date = today.getDate();
    var day = days[today.getDay()];

    return '- ' + month + '월 ' + date + '일 ' + '(' + day + ')';
  }

  // id가 today인 span 요소에 오늘 날짜와 요일을 추가
  document.getElementById('today').innerText = getToday();
	
	
    if (navigator.appName.indexOf("Microsoft") > -1) {
        try {
            icdbho.bIESetting1 = false;
            icdbho.bIESetting2 = false;
            icdbho.bIESetting3 = false;
            icdbho.bIESetting4 = false;
            icdbho.bIESetting5 = false;
            icdbho.bIESetting6 = false;
            icdbho.bIESetting7 = false;
            icdbho.bIESetting8 = false;
            icdbho.bIESetting9 = false;
            icdbho.bIESetting10 = false;
            icdbho.bIESetting11 = false;
            icdbho.bIESetting12 = false;
            icdbho.bIESetting13 = false;
            icdbho.bIESetting14 = false;
            icdbho.bIESetting15 = false;
            icdbho.bIESetting16 = false;
            icdbho.bIESetting17 = true;
            icdbho.bIESetting19 = true;
            icdbho.bUseExitIE = false;

            var TrustSite = icdbho.IsStartIESetting("http://gw.seoulmc.or.kr", "0");
            if (TrustSite) {
                icdbho.excuteIESetting("http://gw.seoulmc.or.kr");
            }

            var TrustSite1 = icdbho.IsStartIESetting("https://gw.seoulmc.or.kr", "0");
            if (TrustSite1) {
                icdbho.excuteIESetting("https://gw.seoulmc.or.kr");
            }
        } catch (e) {}
    }

    if (navigator.userAgent.indexOf('Firefox') != -1) {
        $('body').css({
            'MozUserSelect': 'none',
            'WebkitUserSelect': 'none',
            'khtmlUserSelect': 'none',
            'oUserSelect': 'none',
            'UserSelect': 'none'
        });
    }

    $('#dw').show();
});

function getDW() {
    openLocation = "https://edw.seoulmc.or.kr/OBIP/ku_dash/html/dashMain.html";
    window.open(openLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=700,width=1200");
}

function Content_onclikc(pID) {
    document.getElementById(pID).className = "on";
    ContentID = pID;
    switch (pID) {
        case "noticeitem":
        	getNoticeList();
            document.getElementById("contentmore").style.display = "";
            document.getElementById("newitem").className = "";
            document.getElementById("menuitem").className = "";
            document.getElementById("dw").className = "";
            break;

        case "newitem":
        	getRecentList();
            document.getElementById("contentmore").style.display = "";
            document.getElementById("noticeitem").className = "";
            document.getElementById("menuitem").className = "";
            document.getElementById("dw").className = "";
            break;

        case "menuitem":
        	weekMenuDisplay();
            document.getElementById("contentmore").style.display = "";
            document.getElementById("noticeitem").className = "";
            document.getElementById("newitem").className = "";
            document.getElementById("dw").className = "";
            break;
        case "dw":
            document.getElementById("contentmore").style.display = "";
            document.getElementById("noticeitem").className = "";
            document.getElementById("menuitem").className = "";
            document.getElementById("newitem").className = "";
            getDW();
            break;
    }
}

function onclick_menu(obj, target) {

    var objUrl = "";

    switch (obj) {
        case "mail":
            objUrl = "/hicssSSOLogin.hi?viewType=moveMail&ssoToken=" + ssoToken;
            break;
        case "approval":
            objUrl = "/hicssSSOLogin.hi?viewType=moveApprProg&ssoToken=" + ssoToken;
            break;
        case "approval2":
            objUrl = "/hicssSSOLogin.hi?viewType=moveApprPend&ssoToken=" + ssoToken;
            break;
        case "approval3":
            objUrl = "/hicssSSOLogin.hi?viewType=moveAppring&ssoToken=" + ssoToken;
            break;
        case "approval4":
            objUrl = "/hicssSSOLogin.hi?viewType=moveApprProg&ssoToken=" + ssoToken;
            break;
        case "gumjin":
            objUrl = "/hicssSSOLogin.hi?viewType=gumjin&ssoToken=" + ssoToken;
            break;            
        default:
            break;
        }

        if (objUrl != "")
            window.open(objUrl, target);
        else
            alert("권한이 없습니다. 담당자에게 문의하세요.");
}

function contentmore_onclick() {
	window.open("/hicssSSOLogin.hi?viewType=contentMore&ssoToken=" + ssoToken, "_blank");
}

function refresh() {       
    window.location.reload(false);
}

document.addEventListener('keydown', closePopupOnEsc);

function closePopup() {
	  document.getElementById("popup").style.display = "none";
	}

//ESC 키 누를 때 팝업창 닫기
function closePopupOnEsc(event) {
    if (event.keyCode === 27) {
        closePopup();
    }
}

//식당메뉴 탭을 눌렀을때 오늘날짜 기준 일주일 식단을 표시
function weekMenuDisplay() {
	
	$('#content_list').empty();
	
	$("#sDate").datepicker({
	    dateFormat : 'yy-mm-dd',
	    showOn : 'both',
	    buttonImage : '/emr/img/ico_date_drop.gif',
	    buttonImageOnly : true,
	    showButtonPanel: true,
	    closeText: '닫기'
	}).datepicker("setDate", new Date());
	
	document.getElementById("popup").style.display = "block";
	
	$.ajax({
		url: '/interwork/selectDayMenu.hi',
		dataType: 'json',
		type: 'POST',
		async:false,
		data: {
			start_date : todaySikdan
		}
	}).success(function(res) {
		
		$("#mormingMenu").text('');
		$("#lunchMenu").text('');
		$("#dinnerMenu").text('');
		$('#date').text('');
		list = res.rows;
        cnt = list.length;
		morningMenu = "";
		lunchMenu = "";
		dinnerMenu = "";
		
		if(list.length == 0) {
			
			$('#nothing').show();
			$('#nothing').text('');
			none = "※ 표시할 식단이 없습니다.";
			$('#nothing').append(none);
			
		} else {
			
			$('#nothing').hide();
 
		// 아침
 		for(var i=0; i<list.length; i+=3) {
 			
 			var dateString = list[i].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(187, 227, 219, 0.49)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[i].BANCHAN1_NAME;
 			menu2 = list[i].BANCHAN2_NAME;
 			menu3 = list[i].BANCHAN3_NAME;
 			menu4 = list[i].BANCHAN4_NAME;
 			menu5 = list[i].BANCHAN5_NAME;
 			menu6 = list[i].BANCHAN6_NAME;
 			menu7 = list[i].BANCHAN7_NAME;
 			menu8 = list[i].BANCHAN8_NAME;
 			menu9 = list[i].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			morningMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
	
			html = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekMorning'+morningNum+'">'+morningMenu+'</td>';
			$("#mormingMenu").append(html);
			morningNum++;
			
			str = '<td style="border: 1px solid white; border-right: none; border-radius: 15px; width:280px; height:35px; text-align:center; background-color: #f9f9f9;" id="weekDate'+morningNum+'">' + formattedDate + '</td>';
			$("#date").append(str);
			morningNum++;
 		}
		
		// 점심
 		for(var j=1; j<list.length; j+=3) {
 			
 			var dateString = list[j].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(243, 245, 194, 0.55)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[j].BANCHAN1_NAME;
 			menu2 = list[j].BANCHAN2_NAME;
 			menu3 = list[j].BANCHAN3_NAME;
 			menu4 = list[j].BANCHAN4_NAME;
 			menu5 = list[j].BANCHAN5_NAME;
 			menu6 = list[j].BANCHAN6_NAME;
 			menu7 = list[j].BANCHAN7_NAME;
 			menu8 = list[j].BANCHAN8_NAME;
 			menu9 = list[j].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			lunchMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
			
			html2 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekLunch'+lunchNum+'">'+lunchMenu+'</td>';
			$("#lunchMenu").append(html2);
			lunchNum++;
 		}
 		
		// 저녁
		for(var k=2; k<list.length; k+=3) {
			
			var dateString = list[k].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(255, 238, 209, 1)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
			
 			menu1 = list[k].BANCHAN1_NAME;
 			menu2 = list[k].BANCHAN2_NAME;
 			menu3 = list[k].BANCHAN3_NAME;
 			menu4 = list[k].BANCHAN4_NAME;
 			menu5 = list[k].BANCHAN5_NAME;
 			menu6 = list[k].BANCHAN6_NAME;
 			menu7 = list[k].BANCHAN7_NAME;
 			menu8 = list[k].BANCHAN8_NAME;
 			menu9 = list[k].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			dinnerMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
			
			html3 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekDinner'+dinnerNum+'">'+dinnerMenu+'</td>';
			$("#dinnerMenu").append(html3);
			dinnerNum++;
 		}
		
		}
	})
};

//지난주 메뉴
function lastWeek() {
	$.ajax({
		url: '/interwork/lastWeekMenu.hi',
		dataType: 'json',
		type: 'POST',
		async:false,
		data: {
			start_date : $('#sDate').val()
		}
	}).success(function(responseData1) {
		
		var date1 = new Date($('#sDate').datepicker('getDate'));

		$("#mormingMenu").text('');
		$("#lunchMenu").text('');
		$("#dinnerMenu").text('');
		$('#date').text('');
		list = responseData1.rows;
        cnt = list.length;
		morningMenu = "";
		lunchMenu = "";
		dinnerMenu = "";
		
		if(list.length == 0) {
			
			$('#nothing').show();
			$('#nothing').text('');
			none = "※ 표시할 식단이 없습니다.";
			$('#nothing').append(none);
			
		} else {
			
			$('#nothing').hide();
 		
		// 지난주 아침식단
 		for(var i=0; i<list.length; i+=3) {
 			
 			var dateString = list[i].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(187, 227, 219, 0.49)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[i].BANCHAN1_NAME;
 			menu2 = list[i].BANCHAN2_NAME;
 			menu3 = list[i].BANCHAN3_NAME;
 			menu4 = list[i].BANCHAN4_NAME;
 			menu5 = list[i].BANCHAN5_NAME;
 			menu6 = list[i].BANCHAN6_NAME;
 			menu7 = list[i].BANCHAN7_NAME;
 			menu8 = list[i].BANCHAN8_NAME;
 			menu9 = list[i].BANCHAN9_NAME;
 			
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			morningMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
			
			html = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekMorning'+morningNum+'">'+morningMenu+'</td>';
			$("#mormingMenu").append(html);
			morningNum++;
			
			str = '<td style="border: 1px solid white; border-right: none; border-radius: 15px; width:280px; height:35px; text-align:center; background-color: #f9f9f9;" id="weekDate'+morningNum+'">' + formattedDate + '</td>';
			$("#date").append(str);
			morningNum++;
			
 		}
		
		// 지난주 점심식단
 		for(var j=1; j<list.length; j+=3) {
 			
 			var dateString = list[j].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(243, 245, 194, 0.55)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[j].BANCHAN1_NAME;
 			menu2 = list[j].BANCHAN2_NAME;
 			menu3 = list[j].BANCHAN3_NAME;
 			menu4 = list[j].BANCHAN4_NAME;
 			menu5 = list[j].BANCHAN5_NAME;
 			menu6 = list[j].BANCHAN6_NAME;
 			menu7 = list[j].BANCHAN7_NAME;
 			menu8 = list[j].BANCHAN8_NAME;
 			menu9 = list[j].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			lunchMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
			
			html2 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekLunch'+lunchNum+'">'+lunchMenu+'</td>';
			$("#lunchMenu").append(html2);
			lunchNum++;
 		}
 		
		// 지난주 저녁식단
		for(var k=2; k<list.length; k+=3) {
			
			var dateString = list[k].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(255, 238, 209, 1)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
			
 			menu1 = list[k].BANCHAN1_NAME;
 			menu2 = list[k].BANCHAN2_NAME;
 			menu3 = list[k].BANCHAN3_NAME;
 			menu4 = list[k].BANCHAN4_NAME;
 			menu5 = list[k].BANCHAN5_NAME;
 			menu6 = list[k].BANCHAN6_NAME;
 			menu7 = list[k].BANCHAN7_NAME;
 			menu8 = list[k].BANCHAN8_NAME;
 			menu9 = list[k].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			dinnerMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;

			html3 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekDinner'+dinnerNum+'">'+dinnerMenu+'</td>';
			$("#dinnerMenu").append(html3);
			dinnerNum++;
 		}
		
		}
		
	})
	
	
	var keepLastWeek = new Date($('#sDate').val());
	
	var srchLastWeek = new Date(keepLastWeek.setDate(keepLastWeek.getDate() - 7));
	
	var year = srchLastWeek.getFullYear();
	var month = ('0' + (srchLastWeek.getMonth() + 1)).slice(-2);
	var day = ('0' + srchLastWeek.getDate()).slice(-2);
	var dateString = year + '-' + month + '-' + day;

	$('#sDate').val(dateString);
}

// 다음주 메뉴

function nextWeek() {
	$.ajax({
		url: '/interwork/nextWeekMenu.hi',
		dataType: 'json',
		type: 'POST',
		async:false,
		data: {
			start_date : $('#sDate').val()
		}
	}).success(function(responseData2) {
		
		$("#mormingMenu").text('');
		$("#lunchMenu").text('');
		$("#dinnerMenu").text('');
		$('#date').text('');
		list = responseData2.rows;
        cnt = list.length;
		morningMenu = "";
		lunchMenu = "";
		dinnerMenu = "";
		
		if(list.length == 0) {
			
			$('#nothing').show();
			$('#nothing').text('');
			none = "※ 표시할 식단이 없습니다.";
			$('#nothing').append(none);
			
			
		} else {
			
			$('#nothing').hide();
 
		// 다음주 아침식단
 		for(var i=0; i<list.length; i+=3) {
 			
 			var dateString = list[i].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(187, 227, 219, 0.49)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[i].BANCHAN1_NAME;
 			menu2 = list[i].BANCHAN2_NAME;
 			menu3 = list[i].BANCHAN3_NAME;
 			menu4 = list[i].BANCHAN4_NAME;
 			menu5 = list[i].BANCHAN5_NAME;
 			menu6 = list[i].BANCHAN6_NAME;
 			menu7 = list[i].BANCHAN7_NAME;
 			menu8 = list[i].BANCHAN8_NAME;
 			menu9 = list[i].BANCHAN9_NAME;
 			
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			morningMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
			
			html = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekMorning'+morningNum+'">'+morningMenu+'</td>';
			$("#mormingMenu").append(html);
			morningNum++;
			
			str = '<td style="border: 1px solid white; border-right: none; border-radius: 15px; width:280px; height:35px; text-align:center; background-color: #f9f9f9;" id="weekDate'+morningNum+'">'+formattedDate+'</td>';
			$("#date").append(str);
			morningNum++;
 		}
		
		// 다음주 점심식단
 		for(var j=1; j<list.length; j+=3) {
 			
 			var dateString = list[j].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(243, 245, 194, 0.55)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[j].BANCHAN1_NAME;
 			menu2 = list[j].BANCHAN2_NAME;
 			menu3 = list[j].BANCHAN3_NAME;
 			menu4 = list[j].BANCHAN4_NAME;
 			menu5 = list[j].BANCHAN5_NAME;
 			menu6 = list[j].BANCHAN6_NAME;
 			menu7 = list[j].BANCHAN7_NAME;
 			menu8 = list[j].BANCHAN8_NAME;
 			menu9 = list[j].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			lunchMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;

			html2 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekLunch'+lunchNum+'">'+lunchMenu+'</td>';
			$("#lunchMenu").append(html2);
			lunchNum++;
 		}
 		
		// 다음주 저녁식단
		for(var k=2; k<list.length; k+=3) {
			
			var dateString = list[k].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(255, 238, 209, 1)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
			
 			menu1 = list[k].BANCHAN1_NAME;
 			menu2 = list[k].BANCHAN2_NAME;
 			menu3 = list[k].BANCHAN3_NAME;
 			menu4 = list[k].BANCHAN4_NAME;
 			menu5 = list[k].BANCHAN5_NAME;
 			menu6 = list[k].BANCHAN6_NAME;
 			menu7 = list[k].BANCHAN7_NAME;
 			menu8 = list[k].BANCHAN8_NAME;
 			menu9 = list[k].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			dinnerMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;

			html3 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekDinner'+dinnerNum+'">'+dinnerMenu+'</td>';
			$("#dinnerMenu").append(html3);
			dinnerNum++;
 		}
		
		}
        
	})
	
	var keepNextWeek = new Date($('#sDate').val());
	
	var srchNextWeek = new Date(keepNextWeek.setDate(keepNextWeek.getDate() + 7));

	var year = srchNextWeek.getFullYear();
	var month = ('0' + (srchNextWeek.getMonth()+1)).slice(-2);
	var day = ('0' + srchNextWeek.getDate()).slice(-2);
	var dateString = year + '-' + month + '-' + day;
	
	$('#sDate').val(dateString);
}
	
function getNoticeList() {
	
	$('#content_list').text('');
	 
	$.ajax({
		url: '/interwork/getNoticeList.hi',
		dataType: 'json',
		type: 'POST', 
		async: false,
		data: {}
	}).success(function(data1) {
        console.log('getNoticeList', data1);
        if(data1 == null || data1 == undefined) {
	        } else {
	          var list1 = data1.rows;
	          if(list1.length == 0) {
	          } else {
	            for(var i=0; i<list1.length; i++) {
	              var item1 = list1[i];
	              
	              $("#content_list").append('<li data-type="notice"><span class="txt">'+ item1.ARTICLE_SUBJECT +'</span><span class="date">'+item1.FIRST_REG_DATE+'</span></li>');0
	            }
	          }
            }
  	 });
}

function getRecentList() {
	  
	$('#content_list').text('');
	 
	$.ajax({
		url: '/interwork/getRecentList.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {}
	}).success(function(data2) {
        console.log('getRecentList', data2);
        if(data2 == null || data2 == undefined) {
	        } else {
	          var list2 = data2.rows;
	          if(list2.length == 0) {
	          } else {
	            for(var i=0; i<list2.length; i++) {
	              var item2 = list2[i];
	              $("#content_list").append('<li data-type="recent"><span class="txt">'+ item2.ARTICLE_SUBJECT +'</span><span class="date">'+item2.FIRST_REG_DATE+'</span></li>');
	            }
	          }
            }
  	 });
}

function getScheduleList() {
	
	console.log("누가 로그인했어?:: ", user_id);
	
	$.ajax({
		url: '/interwork/getScheduleList.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {
			'user_id' : user_id
		}
	}).success(function(data3) {
        console.log('getScheduleList', data3);
        if(data3 == null || data3 == undefined) {
	        } else {
	          var list3 = data3.rows;
	          if(list3.length == 0) {
	          } else {
	            for(var i=0; i<list3.length; i++) {
	              var item3 = list3[i];
	              var startDate = item3.START_DATE;
	              var endDate = item3.END_DATE;
	              $("#scheduleList").append('<li data-type="schedule"><span class="txt">'+ item3.SUBJECT +'</span><span class="date">'+ startDate + ' ~ ' + endDate +'</span></li>');
	            }
	          }
            }
  	 });
}

$(document).on("click", ".txt", function() {
    var type = $(this).parent("li").data("type");
    if (type === "notice") {
      window.open("/hicssSSOLogin.hi?viewType=moveNotice&ssoToken=" + ssoToken, "_blank");
    } else if (type === "recent") {
      window.open("/hicssSSOLogin.hi?viewType=moveRecent&ssoToken=" + ssoToken, "_blank");
    } else if (type === "schedule") {
      window.open("/hicssSSOLogin.hi?viewType=moveSchedule&ssoToken=" + ssoToken, "_blank");
    }
});

//날짜선택후 조회하기 눌렀을때 표시
function setDisplay() {
	$.ajax({
		url: '/interwork/selectDayMenu.hi',
		dataType: 'json',
		type: 'POST',
		async:false,
		data: {
			start_date : $('#sDate').val()
		}
	}).success(function(res) {
		
		$("#mormingMenu").text('');
		$("#lunchMenu").text('');
		$("#dinnerMenu").text('');
		$('#date').text('');
		list = res.rows;
        cnt = list.length;
		morningMenu = "";
		lunchMenu = "";
		dinnerMenu = "";
		
		if(list.length == 0) {
			
			$('#nothing').show();
			$('#nothing').text('');
			none = "※ 표시할 식단이 없습니다.";
			$('#nothing').append(none);
			
		} else {
			
			$('#nothing').hide();
 
		// 아침
 		for(var i=0; i<list.length; i+=3) {
 			
 			var dateString = list[i].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(187, 227, 219, 0.49)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[i].BANCHAN1_NAME;
 			menu2 = list[i].BANCHAN2_NAME;
 			menu3 = list[i].BANCHAN3_NAME;
 			menu4 = list[i].BANCHAN4_NAME;
 			menu5 = list[i].BANCHAN5_NAME;
 			menu6 = list[i].BANCHAN6_NAME;
 			menu7 = list[i].BANCHAN7_NAME;
 			menu8 = list[i].BANCHAN8_NAME;
 			menu9 = list[i].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			morningMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
	
			html = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekMorning'+morningNum+'">'+morningMenu+'</td>';
			$("#mormingMenu").append(html);
			morningNum++;
			
			str = '<td style="border: 1px solid white; border-right: none; border-radius: 15px; width:280px; height:35px; text-align:center; background-color: #f9f9f9;" id="weekDate'+morningNum+'">' + formattedDate + '</td>';
			$("#date").append(str);
			morningNum++;
 		}
		
		// 점심
 		for(var j=1; j<list.length; j+=3) {
 			
 			var dateString = list[j].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(243, 245, 194, 0.55)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
 			
 			menu1 = list[j].BANCHAN1_NAME;
 			menu2 = list[j].BANCHAN2_NAME;
 			menu3 = list[j].BANCHAN3_NAME;
 			menu4 = list[j].BANCHAN4_NAME;
 			menu5 = list[j].BANCHAN5_NAME;
 			menu6 = list[j].BANCHAN6_NAME;
 			menu7 = list[j].BANCHAN7_NAME;
 			menu8 = list[j].BANCHAN8_NAME;
 			menu9 = list[j].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			lunchMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
			
			html2 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekLunch'+lunchNum+'">'+lunchMenu+'</td>';
			$("#lunchMenu").append(html2);
			lunchNum++;
 		}
 		
		// 저녁
		for(var k=2; k<list.length; k+=3) {
			
			var dateString = list[k].SIKDAN_DATE;
 			var date = new Date(dateString);
 			var dayOfWeek = date.getDay();
 			var dayOfWeekString;
 			var color = "black"; // 기본 색상(검은색) 지정
 			var backgroundColor = "rgba(255, 238, 209, 1)"; // 기본 배경색 지정
 			switch (dayOfWeek) {
 			  case 0:
 			    dayOfWeekString = "일요일";
 			    color = "red"; // 일요일인 경우 글자색 빨강 적용
 			    break;
 			  case 6:
 			    dayOfWeekString = "토요일";
 			    color = "blue"; // 토요일인 경우 글자색 파랑 적용
 			    break;
 			  default:
 			    dayOfWeekString = ["일", "월", "화", "수", "목", "금", "토"][dayOfWeek] + "요일";
 			    break;
 			}
 			var formattedDate = "<span style='color:" + color + "'><p>" + dateString + "</p> " + dayOfWeekString + "</span>";
			
 			menu1 = list[k].BANCHAN1_NAME;
 			menu2 = list[k].BANCHAN2_NAME;
 			menu3 = list[k].BANCHAN3_NAME;
 			menu4 = list[k].BANCHAN4_NAME;
 			menu5 = list[k].BANCHAN5_NAME;
 			menu6 = list[k].BANCHAN6_NAME;
 			menu7 = list[k].BANCHAN7_NAME;
 			menu8 = list[k].BANCHAN8_NAME;
 			menu9 = list[k].BANCHAN9_NAME;
			
			if (menu1 != "") {menu1 += '<br>'};
			if (menu2 != "") {menu2 += '<br>'};
			if (menu3 != "") {menu3 += '<br>'};
			if (menu4 != "") {menu4 += '<br>'};
			if (menu5 != "") {menu5 += '<br>'};
			if (menu6 != "") {menu6 += '<br>'};
			if (menu7 != "") {menu7 += '<br>'};
			if (menu8 != "") {menu8 += '<br>'};
			if (menu9 != "") {menu9 += '<br>'};
			
			dinnerMenu = menu1+'\n'+menu2+'\n'+menu3+'\n'+menu4+'\n'+menu5+'\n'+menu6+'\n'+menu7+'\n'+menu8+'\n'+menu9;
			
			html3 = '<td style="border: 1px solid white; border-radius: 15px; width:280px; height:160px; text-align:center; background-color:' + backgroundColor + ';" id="weekDinner'+dinnerNum+'">'+dinnerMenu+'</td>';
			$("#dinnerMenu").append(html3);
			dinnerNum++;
 		}
		
		}
	})
}


</script>
</head>
<body>   
<OBJECT id=UCW_OCX style="display:none" codeBase="/ucw_x_control.ocx#version=1,0,0,6" classid=clsid:6A17B3C0-CB5F-4C5D-9F8F-1777AA640292 width=0 height=0></OBJECT>    
<OBJECT id="icdbho" style="DISPLAY: none" codeBase="/ezIcd2.cab#version=1,0,0,20" data="data:application/x-oleobject;base64,GvFdR8IrqUGKl+mJ4CPlFwADAADYEwAA2BMAAA=="	 classid="CLSID:9E1C0C21-48B8-455a-9005-48C8D78B7900" ></OBJECT>
<div class="sectionLayout01">
 <span title="재조회" style="float:left;cursor:pointer;" ><img src="/emr/img/img_Refresh.png" onclick="refresh();" alt="" /></span>
<dl class="infoCount01">   
<dt onclick="onclick_menu('mail', '_blank');">        
	<span class="counImg"><img src="/emr/img/img_infoCount01.png" alt="" /></span>
	<span class="counText">메일</span>
	<span class="count01"><span>1</span></span>
</dt>
</dl>
<dl class="infoCount02">
<dt>
	<span class="counImg"><img src="/emr/img/img_infoCount02.png" alt="" /></span>
	<span class="counText">결재</span>
</dt>
<dd onclick="onclick_menu('approval', '_blank');">결재대기 <span class="count02"><span id="waitAppr"></span></span></dd>
<dd onclick="onclick_menu('approval2', '_blank');">결재진행 <span class="count02"><span id="apprProgress"></span></span></dd>
</dl>
<dl class="infoCount03">
<dt>
	<span class="counImg"><img src="/emr/img/img_infoCount03.png" alt="" /></span>
	<span class="counText">기안</span>
</dt>
<dd onclick="onclick_menu('approval3', '_blank');">접수대기 <span class="count03"><span id="waitReception"></span></span></dd>
<dd onclick="onclick_menu('approval4', '_blank');">회수/반려 <span class="count03"><span id="returnDoc"></span></span></dd>
</dl>
<p class="btn_infoCount"><img src="/emr/img/btn_img_infoCount.png" onclick='OpenWindow(event, "/myoffice/ezPersonal/PersonSearch/Personsearch.aspx", "", "height=550px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0")' /></p>
<p class="btn_infoCount"><img src="/emr/img/btn_img_gumjin.png" onclick="onclick_menu('gumjin', '_blank');" /></p>
</div>
<div class="sectionLayout02">
<!-- today -->
<div class="content_today">
  <div class="today_title">
    <span>오늘의 일정</span>
    <span id="today" style="font-weight:bold; font-size:12px; color:black;"></span>
	<span id="contentmore2" onclick="contentmore_onclick()"></span>
<!--     <span id="mon" onclick="schedule_onclick(this)" style="display:inline-block; margin-left:80px;">일</span> -->
<!--     <span class="bar"></span> -->
<!--     <span id="week" onclick="schedule_onclick(this)">주</span> -->
<!--     <span class="bar"></span> -->
<!--     <span class="on" id="dd" onclick="schedule_onclick(this)">월</span> -->
  </div>
  <ul id="scheduleList"></ul>
</div>
<!-- /today -->
<!-- nbsp -->
<div class="nbsp"></div>
<!-- /nbsp -->
<!-- notice -->
<div class="content_notice">
<div class="c_notice_tab">
  <span id="noticeitem" class="on" onclick="Content_onclikc(this.id)"><span>공지사항</span></span>
  <span class="bar"></span>
  <span id="newitem" onclick="Content_onclikc(this.id)"><span>최근 게시글</span></span>
  <span class="bar"></span>
  <span id="menuitem" onclick="Content_onclikc(this.id)"><span>식당메뉴</span></span>
  <span class="bar"></span>
  <span id="dw" onclick="Content_onclikc(this.id)"><span>병원통계</span></span>
  <span class="bar"></span>
  <span id="contentmore" onclick="contentmore_onclick()"></span>
</div>
<ul id="content_list"></ul>
</div>
<!-- /notice -->
</div>

<!-- menu -->
<div id="popup" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5);">
	<div id="dialog_menu_detail_popup"
		style="width: 95%; margin: 0 auto; margin-top: 50px; background-color: white;">
		<div id="dialog_menu_detail" style="overflow-y: auto;">
			<input type="text" id="firstFocus" style="width: 0px; height: 0px; border: 0px;" readonly/>
			<table style="width: 95%; margin: auto;">
				<tr>
					<th scope="row" style="width: 10%;">식단일자</th>
					<td><input type="text" name="sDate" id="sDate" title="시작일"
						style="margin-left: 5px; width: 90px; height: 25px;" readonly /></td>
					<td style="width: 55.5%;">
						<button class="btn btn-outline-dark" onclick="setDisplay()">조회하기</button>
					</td>
					<td style="float: left;">
						<button id="lastWeekBtn" class="btn btn-outline-dark"
							onclick="lastWeek()" style="margin-right: 5px;">◀ 지난주</button>
					</td>
					<td style="float: right; margin-left: -10px;">
						<button id="nextWeekBtn" class="btn btn-outline-dark"
							onclick="nextWeek()">다음주 ▶</button>
					</td>
				</tr>
			</table>

			<div id="menuDetail" style="width: 95%; margin: auto;">
				<div style="float: left; width: 50px; height: 520px;">
					<table>
						<tr>
							<td id="weekDate"><b>날짜</b></td>
						</tr>
						<tr>
							<td id="weekMenusMorning">조식</td>
						</tr>
						<tr>
							<td id="weekMenusLunch">중식</td>
						</tr>
						<tr>
							<td id="weekMenusDinner">석식</td>
						</tr>
					</table>
				</div>

				<div style="">
					<table id="Table2" style="margin-top: 15px;">
						<tr id="date"></tr>
						<tr id="mormingMenu"></tr>
						<tr id="lunchMenu"></tr>
						<tr id="dinnerMenu"></tr>
					</table>
				</div>
				<p id="nothing"
					style="text-align: center; margin-top: 250px; font-weight: bold; display: none;"></p>
			</div>
			<button class="btn gray small" id="closeButton" onclick="closePopup()">닫기</button>
		</div>
	</div>
</div>


</body>
</html>