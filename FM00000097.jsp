<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 교육신청서 -->
<!-- EZSP_GETEDUCODE0 - VW_PPE_GW_INTERFACE54
	 EZSP_GETEDUCODE1 - VW_PPE_GW_INTERFACE16
	 EZSP_GETEDUCODE2 - VW_PPE_GW_INTERFACE17
	 EZSP_EDU_GETPK - PR_PPE_CREATE_PKNRS2001
	 EZSP_EDU_INSERT - PR_PPE_INSERT_NRS2002
	 EZSP_HUGASCHEDULEUPDATE - TBLSCHEDULE, TBHugaSchedule
	 TBLSCHEDULE, TBHugaSchedule, TBINTERFACEURL
	 EZSP_HUGABANSONG - TBLSCHEDULE, TBHugaSchedule -->


<style>
	img.ui-datepicker-trigger {
		margin-left: 5px;
	}
	
	#num {
		margin-left: 84px;
		margin-top: 3px;
	}
	
	#FORM_FM00000097 {
		min-height: 404px !important;
		max-height: 500px !important;
		overflow-y: auto !important;
		margin-bottom: 10px;
	}
</style>

<script>

var gunmuCode = "";
var gunmuNM = "";
var yesan1txt = "";
var yesan1Code = "";
var yesan2txt = "";
var yesan2Code = "";
var yesan3txt = "";
var yesan3Code = "";
var selusernumber = 0;

//사용자목록
var queryParamsUser = function(params) {
    
    var srchUserName = $('#srchUserName').val();
    return {
        recordCountPerPage: params.pageSize,
        firstIndex: params.pageSize * (params.pageNumber - 1),
        search: params.searchText,
        name: params.sortName,
        order: params.sortOrder,    
        srchUserName: $('#srchUserName').val(),
        code_id: $('input[name=auth_code_id]').val(),
        //dept_id: $('input[name=auth_dept_id]').val()
        dept_id: $('input[name=auth_sel_dept_id]').val()
    };
};
// 목록 트리
var setTree = function(treeType) {
ROLE_INFO = [];

var callUrl = '/util/dynaDeptTreeAsync.hi?type=dept&rootId='; // default : dept

//2017.11.30 hsim 1depth까지 나오도록 변경
$('.SearchdeptTree').dynatree({
    initAjax: {
        url: callUrl
    },
    onCreate: function(node) {
        if(node.getLevel() < 2) node.expand(true);
    },
    onLazyRead: function(node){
        if (node.data.key.indexOf('US') == 0) {
            return false;
        }
        node.appendAjax({
            url: '/util/dynaDeptTreeAsync.hi?type=dept&rootId='+node.data.key,                
            data: {
                'key': node.data.key,
                'mode': 'all'
            },
            success: function(node) {
                
            },
            error: function(node, XMLHttpRequest, textStatus, errorThrown) {
            }
            
        });
    },
    onActivate: function(node) {
        generateListGrid(node.data.key, treeType);
    },
    onPostInit: function(isReloading, isError) {
        try{
            this.$tree.dynatree('getRoot').visit(function(node){
                node.expand(true);
            });
        }catch(e){}
    }
});
};
// grid generate
var generateListGrid = function(key, treeType) {
ROLE_INFO = [];
$('#userList .rolRegUserListChk').css('display', 'inline');
// 부서클릭했을때(사용자목록그리드)
	if (treeType == 'dept') {
	    //$('input[name=auth_dept_id]').val(key);
	    $('input[name=auth_sel_dept_id]').val(key);
	    $('#userList').show(); 
	    $('#table-userList').bootstrapTable('refresh');
	    checkList = false;
	}
};

$(function() { 	
	$('#userList .bs-checkbox').addClass('rolRegUserListChk');
	setTree('dept'); // default tree dept
	$('#table-userList').bootstrapTable();
	
	$('#btnFormExpand').click(function() {
	    $('.SearchdeptTree').dynatree('getRoot').visit(function(node) {
	        node.expand(true);
	    });
	    return false;
	});//expand end
	
	$('#btnFormCollapse').click(function() {
	    $('.SearchdeptTree').dynatree('getRoot').visit(function(node) {
	        node.expand(false);
	    });
	    return false;
	});//collapse end
	
	 $('#popShareBtn').on('click', function(){
	        $('#selectsearchuserModal').dialog({
	            title: '사용자 검색',
	            width: '850px',
	            Height: '660px',
	            position : { my: 'center top', at: 'center top+110', of: window },
	            autoOpen: true,
	            modal: true,
	            resizable: false,
	            create: function() {
	                $('#table-userList').bootstrapTable('refresh');
	            }
	        });
	    });
});

var selectuseraddbutton = function(value , row){
	return  '<button type="button" class="btn btn-outline-dark" id="seluser">선택</button>'
};
	var Addflowevent = {
		'click #seluser' : function(e, val ,row ){
			console.log(row.user_nm);
			console.log(row);
			
			$.ajax({
				url: '/interwork/selectUserDetailInfo.hi',
				dataType: 'json',
				type: 'POST',
				async: false,
				data: {
					'user_emp_id': row.user_emp_id
				}
			}).success(function(response) {
				console.log('response', response);
				
				gunmuCode = response.rows[0].DEPARTMENT;
				gunmuNM = response.rows[0].DESCRIPTION;	
				userCn = response.rows[0].CN;
				
				$('#attend').show();
				
				var rows = document.getElementById("strhtml").getElementsByTagName("tr");
				for (var i=0; i<rows.length; i++) {
					var cells = rows[i].getElementsByTagName("td");
					var cell_1 = cells[0].firstChild.data;
						
						if (cell_1 == userCn) {
							alert("선택한 사용자는 이미 추가되어 있습니다.");
							return;
						}
// 					console.log("cell_1의 값은?? ::: ", cell_1);
// 					console.log("userCn의 값은?? ::: ", userCn);
				}
				
				var list = response.rows;
				
				var item = list[0];
				
				html = '<tr id="attendUser'+selusernumber+'">';
				html += '<td style="border: 1px solid #dbdbdb; width:37%; text-align: center;" value="' + item.CN + '">'+item.CN+'</td>';
				html += '<td style="border: 1px solid #dbdbdb; width:37%; text-align: center;" value="' + item.DISPLAYNAME + '">'+item.DISPLAYNAME+'</td>';
				html += '<td style="border: 1px solid #dbdbdb; text-align:center;"><button type="button" onclick="selectDel(this);" class="btn btn-outline-dark">삭제</button></td>';
				html += '</tr>';
				$("#strhtml").append(html);
				selusernumber++;
				
			});
		}
	};
	
	
	 function selectDel(obj) {
		 
		 var rows1 = document.getElementById("strhtml").getElementsByTagName("tr");
		 var td = obj.parentNode.parentNode;
	     td.parentNode.removeChild(td);
	     
 	     if (rows1.length == 0) {
 	    	$('#attend').hide();
 	    	$('#attend1').hide();
	     } else {
	    	 return false;
	     }
	 }
	 
	 function attendUserList() {
		 
		 $('.test').remove();
		 $('#attendPerson').show();
		 
		 var userName = "";
			var rows2 = document.getElementById("strhtml").getElementsByTagName("tr");
			for (var i=0; i<rows2.length; i++) {
				var cells2 = rows2[i].getElementsByTagName("td");
				var cell_2 = cells2[0].firstChild.data;
				var cell_3 = cells2[1].firstChild.data;
				
				$('#attend1').show();
				
				html = '<tr class = "test">';
				html += '<td style="border: 1px solid #dbdbdb; width:180px; height:25px; text-align: center;" value="' + cell_2 + '">'+cell_2+'</td>';
				html += '<td style="border: 1px solid #dbdbdb; width:180px; height:25px; text-align: center;" value="' + cell_3 + '">'+cell_3+'</td>';
				html += '</tr>';
				$("#attendPerson").append(html);
				
				
				
	  			console.log("cells[0]의 값은??? : : :", cell_2);
	  			console.log("cells[1]의 값은??? : : :", cell_3);
	  			console.log("userids의 값은???: : : : : ", userName);
			}
			$('#selectsearchuserModal').dialog('close');
	 }
	 
	 
	 $('#authAppendOrgLine').find('span[spanVal="${loginVO.org_id}"]').closest('label').click();
		
		var sync_autoComplete_source = function(request, response) {
			var orgId = $('#authDropOrgLine').find('.selecttext>span').attr('selOrgId');
			if (undefined == orgId || null == orgId) {
				if ($SA) {
					orgId = '';	
				} else {
					orgId = '${loginVO.org_id}';
				}
			}
			
			$.ajax({
				type: 'post',
				url: '/approval/getApprSearchList.hi',
				dataType: 'json',
				data: {
					'appr_user_search_name': $( '#user_nm_input' ).val(),
					'appr_search_type': 'A',
					'orgId': orgId
				},
				success: function(data) {
					//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
					response( 
						$.map(data, function(item) {
							return {
								label: item.id == item.id2 ? item.name : item.name + '(' +item.name2+ ')',
								id: item.id,
								id2: item.id2,
								name:item.name,
								name2: item.name2,
								position: item.position,
								memb_postion_cd: item.memb_postion_cd,
								memb_rank: item.memb_rank,
								memb_rank_cd: item.memb_rank_cd,
								memb_seq: item.memb_seq
							}
						})
					);
				}
			});
		};
		
		$('#user_nm_input').autocomplete({
			//appr_search_type A:부서 + 사용자  , U : 유저 , D : 부서 , Docu : 문서단위부서
			source: sync_autoComplete_source,
	       	focus: function( event, ui ) {
	           return false;
	    	},
		    //조회를 위한 최소글자수
	    	minLength: 2,
		    select: function( event, ui ) {
		    	var item = ui.item;
		    	$( '#user_nm_input' ).val(item.name);
			    	$('.deptTree').HGW_DynatreeCtrl('srchKeyPath', '', item.id2);
			    	
			    	generateListGrid(item.id2, 'dept');
			    	
			    	// 나중에 수정해야함
			    	if (item.id != item.id2) {
			    		setTimeout(function() {
		 		    	$('input[name=role_view_type]').val('hicss_user_role');
		 	   			$('input[name=auth_code_id]').val('');
		 	   			$('input[name=auth_dept_id]').val('');
		 	   			$('input[name=auth_user_id]').val(item.id);
		 	   			$('input[name=auth_memb_seq]').val(item.memb_seq);
		 	   			$('#roleList').show();
		 	   			$('#roleGridSubTit').html('('+item.name+')');
		 	   			$('#table-roleList').bootstrapTable('refresh');
			    		},500);
			    	}
		   			
		        return false;
		   	},
		   	autoFocus: true,
	      	close: function () {
	      		//$(this).val('');
	      	}
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
	
	// 예산과목
	
	$.ajax({
		url: '/interwork/getYesan1txt.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {}
	}).success(function(data1) {
        console.log('getYesan1txt', data1);
        if(data1 == null || data1 == undefined) {
	        } else {
	          var list1 = data1.rows;
	          if(list1.length == 0) {
	          } else {
	            for(var i=0; i<list1.length; i++) {
	              var item1 = list1[i];
	              
	              yesan1txt = item1.BDGT_NAME;
	              yesan1Code = item1.BDGT_CODE;
	              
	              $("#yesan1txt").append('<option value='+ item1.BDGT_CODE +'>'+ item1.BDGT_NAME +'</option>');
	              
	              console.log("옵션이름1 : ", yesan1txt);
	            }
	          }
            }
  	 });
	
	// 교육구분
	
	$.ajax({
		url: '/interwork/getYesan2txt.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {}
	}).success(function(data2) {
        console.log('getYesan2txt', data2);
        if(data2 == null || data2 == undefined) {
	        } else {
	          var list2 = data2.rows;
	          if(list2.length == 0) {
	          } else {
	            for(var i=0; i<list2.length; i++) {
	              var item2 = list2[i];
	              
	              yesan2Code = item2.BUNRYU1;
	              yesan2txt = item2.BUNRYU1_NAME;
	              
	              $("#yesan2txt").append('<option value='+ item2.BUNRYU1 +'>'+ item2.BUNRYU1_NAME +'</option>');

	              console.log("옵션이름2 : ", yesan2txt);
	            }
	          }
            }
  	 });
	
	// 세부과목

	$.ajax({
		url: '/interwork/getYesan3txt.hi',
		dataType: 'json',
		type: 'POST',
		async: false,
		data: {}
	}).success(function(data3) {
        console.log('getYesan3txt', data3);
        if(data3 == null || data3 == undefined) {
	        } else {
	          var list3 = data3.rows;
	          if(list3.length == 0) {
	          } else {
	            for(var i=0; i<list3.length; i++) {
	              var item3 = list3[i];
	              yesan3Code = item3.BUNRYU2;
	              yesan3txt = item3.BUNRYU2_NAME;
	              $("#yesan3txt").append('<option value='+ item3.BUNRYU2 +'>'+ item3.BUNRYU2_NAME +'</option>');
	              
	              console.log("옵션이름3 : ", yesan3txt);

	            }
	          }
            }
  	 });
	
	function optfee_click() {
        if ($('input[name="optfee"]:checked').val() == '1') {
    		$('input[id="fee"]').prop("disabled", false);
    		$('input[id="feehan"]').prop("disabled", false);
            $('#trcode3').show();
            $('#trcode4').show();
            $('#feehan').focus();
        }
        else if ($('input[name="optfee"]:checked').val() == '2') {
            $('#fee').val('');
            $('#feehan').val('');
            $('input[id="fee"]').prop("disabled", true);
    		$('input[id="feehan"]').prop("disabled", true);
            $('#trcode3').hide();
            $('#trcode4').hide();
        }
    }
		
	$('#FM00000097_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000097').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var legacydata = [];
		var userids = "";
		// 사용자 사번 합쳐서 넘기기
/* 		for(var i=0 ; i < $('#attendUser'+selusernumber).find("td:eq(0)").length ; i++){
		    userids = userids + $('#attendUser'+selusernumber).find("td:eq(0)").text();
		    if( $('#attendUser'+selusernumber).find("td:eq(0)").length != i+1){ userids += ';' };
		    selusernumber++;
		}; */
		
		var rows = document.getElementById("strhtml").getElementsByTagName("tr");
		for (var i=0; i<rows.length; i++) {
			var cells = rows[i].getElementsByTagName("td");
			
// 			console.log("td의 값은??? : : : ", cells);
			
			var cell_1 = cells[0].firstChild.data;
			userids = userids+cell_1;
			if (rows.length != i+1){ userids += ';' };
// 			console.log("cells[0]의 값은??? : : :", cell_1);
// 			console.log("userids의 값은???: : : : : ", userids);
		}
// 		console.log("tr의 갯수는? : : : ", rows.length);
// 		console.log("사번 합치기 ? : : : : ", userids);
		
		// 1. validation check
		var edutimeCheck = $('#edutime').val();
		var feeCheck = $('#fee').val();
		
		if (document.getElementById("edutitle").value == "") {
            alert("교육명을 입력해 주세요.");
            document.getElementById("edutitle").focus();
            return;
        }

        if (document.getElementById("organ").value == "") {
            alert("교육기관을 입력해 주세요.");
            document.getElementById("organ").focus();
            return;
        }

        if (document.getElementById("loc").value == "") {
            alert("교육장소를 입력해 주세요.");
            document.getElementById("loc").focus();
            return;
        }

        if (document.getElementById("edutime").value == "") {
            alert("교육시간을 입력해 주세요.");
            document.getElementById("edutime").focus();
            return;
        }
        
     	// 숫자인지 판별 후 숫자면 데이터저장(기안기입력), 아니면 경고창
	 	if ($.isNumeric(edutimeCheck) == true) {
	 		true;
		} else {
			alert('교육시간은 숫자만 입력해 주세요.');
			$('#edutime').focus();
			return;
		}

        if ($('#attend').text() == "") {
            alert("교육참석자를 선택해 주세요.");
            return;
        }
        
	 	if ($.isNumeric(edutimeCheck) == true) {
	 		true;
		} else {
			alert('교육비를 숫자로 입력해 주세요.');
			$('#edutime').focus();
			return;
		}

	 	function onlyKor(){
			if((event.keyCode < 12592) || (event.keyCode > 12687)){
			alert("교육비를 한글로 입력해 주세요.");
			event.returnValue = false
			}
		}
        

        if (document.getElementById("yesan2txt").value == "") {
            alert("교육구분을 선택해 주세요");
            document.getElementById("yesan2txt").focus();
            return;
        }

        if (document.getElementById("yesan3txt").value == "") {
            alert("세부과목을 선택해 주세요");
            document.getElementById("yesan3txt").focus();
            return;
        }
        
        
        if ($('input[name="optfee"]:checked').val() == '1') {
        	if (gunmuCode.indexOf("42010") > -1 || gunmuNM.indexOf("의학연구소") > -1) {
                if ($('#yesan1txt').val() != '21132') {
                    alert("부서에 해당하는 예산과목을 선택해 주세요.");
                    document.getElementById("yesan1txt").focus();
                    return;
        		}
            } 
        }
        if ($('input[name="optfee"]:checked').val() == '1') {
        	if ((gunmuCode.indexOf("21021") > -1 && gunmuNM.indexOf("시민공감서비스디자인센터") >-1) || (gunmuCode.indexOf("43010") > -1 && gunmuNM.indexOf("의생명윤리위원회") > -1 )) {//20200709 '43010__'의생명윤리위원회 추가
        		 if ($('#yesan1txt').val() != '22104') {
                     alert("부서에 해당하는 예산과목을 선택해 주세요.");
                     document.getElementById("yesan1txt").focus();
                      return;
        		}
           	}
        }
        if ($('input[name="optfee"]:checked').val() == '1') {
        	if (!(gunmuCode.indexOf("21021") > -1 || gunmuCode.indexOf("42010") > -1 || gunmuCode.indexOf("43010") > -1)) { //20200709 '43010__'의생명윤리위원회 추가
        		if ($('#yesan1txt').val() != '21219') {
	                alert("부서에 해당하는 예산과목을 선택해 주세요.");
	                document.getElementById("yesan1txt").focus();
	                return;
        		}
            }
        }
        
        var studyNum = "";
        if ($('#fee').val() == null || $('#fee').val() == '') {
        	studyNum = "0";
        } else {
        	studyNum = $('#fee').val();
        }
        
        codeA = $('#yesan2txt option:selected').val();
        cadeB = $('#yesan3txt option:selected').val();
		
		// 2. 데이터 저장
 		legacydata.push({
			I_USER_ID        : HGW_APPR_BANK.loginVO.user_emp_id,
			I_PKNRS2001		 : '',
			I_EDU_CODE_A     : codeA,
			I_EDU_CODE_B     : cadeB,
			I_EDU_CODE_C     : '',
			I_EDU_NAME       : $('#edutitle').val(),
			i_JANGSO         : $('#loc').val(),
			I_EDU_GIKWAN     : $('#organ').val(),
			I_EDU_START_DATE : $("#sDate").val(),
			I_EDU_END_DATE   : $("#eDate").val(),
			i_EDU_SIGAN      : $('#edutime').val(),
			I_GANGSA_NAME    : '',
			i_STUDY_NUM      : studyNum,
			I_BUNRYU1        : codeA,
			I_BUNRYU2        : cadeB,
			I_BUNRYU3        : '',
			I_BUNRYU4        : '',
			I_BUNRYU5        : '',
			I_SABUN          : userids,
			I_IF_DOCID       : '',
			I_BUGT_CODE      : yesan1Code
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 3. validation check 후 기안기에 내용 입력
		// 교육명 : edutitle, 교육기관 : organ, 장소 : loc 
		// 일시 - 년 : startyear, 월 : startmonth, 일 : startday, 시 : starthour, 분 : startmin
		//		  년 : endyear, 월 : endmonth, 일 : endday, 시 : endhour, 분 : endmin
		// 교육자 : attend, 교육비 : feetxt, 예산과목 : yesan1txt, 교육구분 : yesan2txt, 세부구분 : yesan3txt
		// 지출방법 : yesan4txt
		// 기안일자 : 기안일자

		var _$hwpObj = HGW_hdlr.rtnObj(1);
		var date1 = $('#sDate').val().split("-");
		var date2 = $('#eDate').val().split("-");
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		// 교육명, 기관, 장소
		_$hwpObj.insertSignData('edutitle', $('#edutitle').val());
		_$hwpObj.insertSignData('organ', $('#organ').val());
		_$hwpObj.insertSignData('loc', $('#loc').val());
		
		// 일시 - 년 : startyear, 월 : startmonth, 일 : startday, 시 : starthour, 분 : startmin
		//		  년 : endyear, 월 : endmonth, 일 : endday, 시 : endhour, 분 : endmin
		_$hwpObj.insertSignData('startyear', date1[0]);
		_$hwpObj.insertSignData('startmonth', date1[1]);
		_$hwpObj.insertSignData('startday', date1[2]);
		_$hwpObj.insertSignData('starthour', $('#hour1').val());
		_$hwpObj.insertSignData('startmin', $('#min1').val());

		_$hwpObj.insertSignData('endyear', date2[0]);
		_$hwpObj.insertSignData('endmonth', date2[1]);
		_$hwpObj.insertSignData('endday', date2[2]);
		_$hwpObj.insertSignData('endhour', $('#hour2').val());
		_$hwpObj.insertSignData('endmin', $('#min2').val());
		

		// 교육자 : attend, 교육비 : feetxt, 예산과목 : yesan1txt, 교육구분 : yesan2txt, 세부구분 : yesan3txt
		
		var userName = "";
		var rows2 = document.getElementById("strhtml").getElementsByTagName("tr");
		for (var i=0; i<rows2.length; i++) {
			var cells2 = rows2[i].getElementsByTagName("td");
			var cell_2 = cells2[1].firstChild.data + '(' + cells2[0].firstChild.data + ')';
			userName = userName+cell_2;
			if (rows2.length != i+1){ userName += ',' };
//  			console.log("cells[0]의 값은??? : : :", cell_2);
//  			console.log("userids의 값은???: : : : : ", userName);
		}
		var msg =  '';
		if($('#strhtml').children(0).length == 1 ) {
			msg = $('#strhtml').children(0).children(0)[1].innerHTML + ' (' + $('#strhtml').children(0).children(0)[0].innerHTML + ')';
		} else if ($('#strhtml').children(0).length > 1 ) {
			msg = userName;
		}
		
		_$hwpObj.insertSignData('attend', msg);
		
		if ($('#fee').val() == '') {
			_$hwpObj.insertSignData('feetxt', '교육비없음');
		} else {
			_$hwpObj.insertSignData('feetxt', '금 ' + $('.edu-fee-num').val() + '원 (금 ' + $('.edu-fee-kor').val() + ')');
		}
		
		if ($('#yesan1txt option:selected').val() == '0') {
			_$hwpObj.insertSignData('yesan1txt', '해당없음');
		} else {
			_$hwpObj.insertSignData('yesan1txt', $('#yesan1txt option:selected').text());
		}
		
		_$hwpObj.insertSignData('yesan2txt', $('#yesan2txt option:selected').text());
		_$hwpObj.insertSignData('yesan3txt', $('#yesan3txt option:selected').text());
		
		// 지출방법 : yesan4txt
		_$hwpObj.insertSignData('yesan4txt', $('input[name="spend"]:checked').closest('label').text());
		
		// 기안일자 : 기안일자
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));

		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
			
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
		$('#FM00000097_reset').unbind().on('click', function() {
			alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
			$('form').each(function() {
			    this.reset();
			  });
			$('#gw_sp_dialog').dialog('close');
		});
	
</script>

<form id="FORM_FM00000097">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr style="display:none">
		        <th style="width:15%">소속<input type="hidden" id="DepartCD" /></th>
		        <td style="width:35%" id="DepartNM"></td>
		        <th style="width:15%">직명</th>
		        <td style="width:35%" id="UserTitle"></td>
		    </tr>
		    
		    <tr style="display:none">
		        <th style="width:15%">성명</th>
		        <td style="width:35%" id="UserNM"></td>
		        <th style="width:15%">사번</th>
		        <td style="width:35%" id="UserID"></td>
		    </tr>

			<tr>
				<th scope="row" class="radius-th">교육명</th>
				<td colspan="4"><input id="edutitle" type="text" style="height: 25px;"></td>
			</tr>
			
			<tr>
				<th scope="row" class="radius-th">교육기관</th>
				<td colspan="4"><input id="organ" type="text" style="height: 25px;"></td>
			</tr>
			
			<tr>
				<th scope="row" class="radius-th">장소</th>
				<td colspan="4"><input id="loc" type="text" style="height: 25px;"></td>
			</tr>
			
			<tr>
				<th scope="row">교육일시</th>
					<td colspan="2">
						<input type="text" name="sDate" id="sDate" title="시작일" style="width: 90px; height: 25px;" readonly/> 
							<select id="hour1" style="height: 25px; padding: 4px 4px 4px 4px;">
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
								<option value="6">6</option>
								<option value="7">7</option>
								<option value="8">8</option>
								<option value="9">9</option>
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
							<select id="min1" style="height: 25px; padding: 4px 4px 4px 4px;">
								<option value="00">00</option>
								<option value="30">30</option>
							</select> 
						<span>분&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;~</span>
					</td>

				<td colspan="2">
					<input type="text" name="eDate" id="eDate" title="종료일" style="width: 90px; height: 25px;" readonly/> 
						<select id="hour2" style="height: 25px; padding: 4px 4px 4px 4px;">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
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
						<select id="min2" style="height: 25px; padding: 4px 4px 4px 4px;">
							<option value="00">00</option>
							<option value="30">30</option>
						</select> 
					<span> 분</span>
				</td>
			</tr>

			<tr>
				<th scope="row" class="radius-th">교육시간</th>
				<td colspan="4">
					<span>총 <input id="edutime" style="width: 80px;" dir="rtl"> 시간(* 숫자만 입력해 주세요)</span>
				</td>
			</tr>

			<tr>
				<th class="radius-th">교육자</th>
				<td colspan="3" id="attendPerson">
					<table style="display:none;" id="attend1">
					 	<tr id="attendList1">
							<th style="border: 1px solid #dbdbdb; width:180px; height:25px;">사번</th>
							<th style="border: 1px solid #dbdbdb; width:180px; height:25px;">이름</th>
						</tr>
					</table>
				</td>
				<td style="border-left: 1px solid #dbdbdb"><button type="button" id="popShareBtn" class="btn btn-outline-dark">검색</button></td>
			</tr>
			
			<tr>
				<th class="radius-th">교육비</th>
				<td colspan="4">
				
					<label><input type="radio" name="optfee" value="1" style="margin-right: 5px;" onclick="optfee_click()" />교육비 있음</label> 
					<label style="margin-left: 10px;"><input type="radio" name="optfee" value="2" style="margin-right: 5px;" onclick="optfee_click()" />교육비 없음</label>
					<br>
					<span style="margin-top:8px;">교육비 - 한글 : 일금 <input id="feehan" class="edu-fee-kor" onKeyPress="onlyKor();"> (예 : 일십만원) </span> 
					<span id="num">숫자 <input id="fee" class="edu-fee-num"> (예 : 100000) </span>
				</td>
			</tr>
			
			<tr id="trcode3">
				<th scope="row" class="radius-th">지출방법</th>
				<td colspan="4">
					<div class="form-check">
						<label><input type="radio" name="spend" value="1" style="margin-right: 5px;" />교육자 선지출 후 통장 입금 </label> 
						<label style="margin-left: 10px;"><input type="radio" name="spend" value="2" style="margin-right: 5px;" />교육기관으로 입금</label>
					</div>
				</td>
			</tr>

			<tr id="trcode4">
				<th scope="row">예산과목</th>
				<td colspan="4">
					<select style="height: 25px;" id="yesan1txt" name="yesan1txt">
					<option value="0">선택하세요.</option>
					</select> 
					<br> 
					<span>※ 부서별 예산과목 선택</span><br> 
					<span>의학연구소 -> [부설연구소운영비]</span><br> 
					<span>시민공감서비스디자인센터, 의생명윤리위원회 -> [기타의료외비용]</span><br> 
					<span>그외부서 -> [교육훈련비(매출)]</span></td>
			</tr>
			
			<tr>
				<th scope="row">세부과목</th>
				<td colspan="4"></td>
			</tr>
			
			<tr>
				<th scope="row">- 교육구분</th>
				<td colspan="4">
					<select id="yesan2txt" name="yesan2txt" style="height: 25px; width: 130px;">
					<option value="0">선택하세요.</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th scope="row">- 세부과목</th>
				<td colspan="4">
					<select id="yesan3txt" style="height: 25px; width: 130px;">
					<option value="0">선택하세요.</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="5" style="border-bottom: none;">
				<span>※ 교육 일시, 장소, 등록비 등을 확인할 수 있는 관련 문서(공문, 프로그램 등)를 반드시 첨부하여 주시기 바랍니다.</span></td>
			</tr>
			
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000097_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000097_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>


<!-- 사용자 검색 -->
<div id="selectsearchuserModal" style="display: none">
	<div id="aregTabContent" class="tab-content03">
		<div class="scroll-area-wrap02 pull-left w262" style="margin-top: 24px;">
			<div class="scroll_box">
				<div class="scroll_top">
					<div class="pull-left tree">
						<h4 class="tit"> <spring:message code="hicss.system.extra.departmentalList" /> </h4>
					</div>
					<div class="pull-right">
						<div class="ctrl_btn">
							<button type="button" title="<spring:message code='hicss.menu.sub.elApprMgr.formsMgr.apprFormsMgr.Expand'/>"
								class="btn_asd" id="btnFormExpand"></button>
							<button type="button" title="<spring:message code='hicss.menu.sub.elApprMgr.formsMgr.apprFormsMgr.Collapse'/>"
								class="btn_desd" id="btnFormCollapse"></button>
						</div>
					</div>
				</div>
				<div style="border-bottom: 1px solid #e4e4e4;">
					<input class="posibox" id="user_nm_input" name="user_nm_input"
						type="text" value="" placeholder="<spring:message code='hicss.appr.extra.searchUserDept'/>"
						style="height: 26px; margin: 5px 0px 5px 10px; width: calc(100% - 20px);">
				</div>
				<div class="SearchdeptTree padUl" style="overflow: auto; height: 500px;"></div>
			</div>
		</div>

		<!-- 사용자 목록 -->
		<div class="scroll-area-wrap02 pull-right"
			style="width: 520px; margin-top: -30px; height: 650px;">
			<table id="table-userList" data-toggle="table"
				data-url="/interwork/getUserListView.hi"
				data-side-pagination="server" data-pagination="true"
				data-page-size="10" data-page-list="[ 10, 20, 50]"
				data-show-refresh="true" data-show-columns="true"
				data-query-params="queryParamsUser" data-height="250">
				<thead>
					<tr>
						<th data-width="20" data-field="user_nm" data-align="center" data-sortable="true">이름</th>
						<th data-width="20" data-field="memb_postion" data-align="center" data-sortable="true">직위</th>
						<th data-width="20" data-field="memb_rank" data-align="center" data-sortable="true">직 급</th>
						<th data-width="10" data-field="" data-align="center" data-formatter="selectuseraddbutton" data-events="Addflowevent" data-sortable="true">선택</th>
					</tr>
				</thead>
			</table>

			<!-- 추가된 사용자 목록 -->
			<div id="roleList"
				style="position: relative; overflow: hidden; _zoom: 1;">
				<div id="custom-toolbar-role">
					<h4 style="margin-bottom: 10px;">
						추가된 사용자 목록
						<button type="button" class="btn btn-outline-dark" onclick="javascript:attendUserList(this);">
							<spring:message code="button.create" />
						</button>
					</h4>
				</div>
				<table id="attend">
					<tr id="attendList">
						<th style="border: 1px solid #dbdbdb; width: 180px; height: 35px;">사번</th>
						<th style="border: 1px solid #dbdbdb; width: 180px; height: 35px;">이름</th>
						<th style="border: 1px solid #dbdbdb; width: 180px; height: 35px;"></th>
					</tr>
					<tbody id="strhtml" style="width: 99%"></tbody>
				</table>
			</div>
		</div>

		<form:form commandName="sysVO" name="sysVO">
			<input type="hidden" name="first_reg_id" value="${loginVO.user_id}" />
			<input type="hidden" name="role_view_type" value="hicss_dept_role" />
			<input type="hidden" name="auth_code_id" value="" />
			<input type="hidden" name="auth_user_id" value="" />
			<input type="hidden" name="auth_memb_seq" value="" />
			<input type="hidden" name="copy_user_id" value="" />
			<input type="hidden" name="copy_memb_seq" value="" />
			<input type="hidden" name="copy_role_type" value="" />
			<input type="hidden" name="auth_dept_id" value="" />
			<input type="hidden" name="auth_sel_dept_id" value="" />
			<input type="hidden" name="srchUserName" value="" />
		</form:form>

	</div>
</div>