<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!-- 수습사원평가표 2차 결재자 화면 -->
<!-- 연동아님 -->

<style>
	img.ui-datepicker-trigger {
		margin-left: 4px;
	}
	
	.shortenDay {
		margin-right: 5px;
	}
	
	#calDay {
		margin-left: 8px;
	}
	
	.time {
		margin-left: 5px;
	}
	
	.info {
		height: 18px;
	}
	
	#selectButton {
		margin-left: 5px;
		padding: 3px 3px 3px 3px;
	}
	
	.evaluation {
		border-right: 1px solid #dbdbdb;
	}
	
	#FORM_FM00000302 {
		min-height: 404px !important;
		max-height: 500px !important;
		overflow-y: auto !important;
		margin-bottom: 10px;
	}
</style>

<script>
	//점수 누적합 구하기
	$(document).ready(function() {
	    $(".form-check-input").on("change",function() {
	        var chkTotal=0;
	        var chkLen = $(".form-check-input").length;
	        for(var i=1; i<chkLen; i++) {
	            if($("[name='grade"+i+"']:checked").val() != undefined) {
	                chkTotal += Number($("[name='grade"+i+"']:checked").val());
	            }
	        }
	        $("#chk_total").val(chkTotal);
	    });
		
	    
	});	
	
</script>

<script>
	
	var data1 = '';
	var data2 = '';
	var data3 = '';
	var data4 = '';
	var data5 = '';
	var data6 = '';
	var opinion1 = '';
	var opinion2 = '';
	var a_1 = '';
	var a_2 = '';
	var a_3 = '';
	var a_4 = '';
	var a_5 = '';
	var a_6 = '';
	var a_7 = '';
	var a_8 = '';
	var a_9 = '';
	var a_10 = '';
	var a_tot = '';
	var drafter = '';
	var eval1 = '';
	
	$('#FM00000302_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000302').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var legacydata = [];
		
		// 1. 데이터 저장
		legacydata.push({
			NOT_LINK      	 : '연동아님'
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
//  		if ($('#data1').val() == '') {
// 			alert('수습사원 대상자를 선택해 주세요.');
// 			$('#data1').focus();
// 			return false;			
// 		}
// 		if ($('#chk_total').val() == '') {
// 			alert('평가항목 모두를 선택해 주세요.');
// 			return false;			
// 		}
// 		if ($('#eval1').val() == '') {
// 			alert('2차평가자 의견을 입력해 주세요');
// 			$('#eval1').focus();
// 			return false;			
// 		}
// 		if ($('input[class="passyn"]:checked').val() == null) {
// 			alert('채용여부를 체크해 주세요.');
// 			return false;			
// 		}
		
		// 3. validation check 후 기안기에 내용 입력
		// 작성일 : 기안일자
		// 인적사항 : 성명 : data1, 주민등록번호 : data2, 부서명 : data3, 직종 및 직급 : data4, 입사일자 : data5, 평가기간 : data6 - 1차기안내용 출력
		// 수습사원의견 : opinion1, 건의사항 : opinion2 - 1차기안내용 출력
		// 2차평가자 : b_1~10, 합계 : b_tot
		// 평가자의견 - 2차평가자 : 결재자, 2차평가자의견 : eval2
		// 채용여부 : passyn
		
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		
		// 작성일
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));
		
		// 인적사항
/* 		_$hwpObj.insertSignData('data1', $('#data1').val());
		_$hwpObj.insertSignData('data2', $('#data2').val());
		_$hwpObj.insertSignData('data3', $('#data3').val());
		_$hwpObj.insertSignData('data4', $('#data4').val());
		_$hwpObj.insertSignData('data5', $('#data5').val());
		_$hwpObj.insertSignData('data6', $('#data6').val()); */
		// 1차화면 출력
				
		// 수습사원의견,건의사항
/* 		_$hwpObj.insertSignData('opinion1', $('#opinion1').val());
		_$hwpObj.insertSignData('opinion2', $('#opinion2').val()); */
		// 1차화면 출력
		
		// 2차평가자이름
		_$hwpObj.insertSignData('결재자', HGW_APPR_BANK.loginVO.user_nm);
		
		// 2차평가자의견
		_$hwpObj.insertSignData('eval2', $('#eval2').val());
		
		// 2차평가자 평가점수
		_$hwpObj.insertSignData('b_1', $('input[name="grade1"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_2', $('input[name="grade2"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_3', $('input[name="grade3"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_4', $('input[name="grade4"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_5', $('input[name="grade5"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_6', $('input[name="grade6"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_7', $('input[name="grade7"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_8', $('input[name="grade8"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_9', $('input[name="grade9"]:checked').closest('label').text());
		_$hwpObj.insertSignData('b_10', $('input[name="grade10"]:checked').closest('label').text());
		
		// 합계, 1차평가자 합계도 같이 출력해주어야 함
		_$hwpObj.insertSignData('b_tot', $('#chk_total').val());
		
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
	
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기		
	$('#FM00000302_reset').unbind().on('click', function() {
		alert("취소 하시겠습니까? 저장하지 않은 내역은 사라집니다.");
		$('form').each(function() {
		    this.reset();
		  });
		$('#gw_sp_dialog').dialog('close');
	});
		
</script>

<script>
	
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
	
	
	// 1차 평가 정보 가져오기 ------------------------
	$(function() { 	
		$.ajax({
			url: '/interwork/getUserInfo1.hi',
			dataType: 'json',
			type: 'POST',
			async: false,
			data: {
				'appr_id': HGW_APPR_INFO.appr_id
			}
		}).success(function(data) {
	        console.log('getUserInfo1', data);
	        var jdata;
	        var item;
	        var item2;
	        if(data == null || data == undefined) {
	        } else {
	        	var list = data.rows;
		          if(list.length == 0) {
		          } else {
		            for(var i=0; i<list.length; i++) {
		              item = list[i];
		            }
		            var list2 = item.IFKEY_DATA;
		            for(var j=0; j<list2.length; j++) {
			              item2 = list2[j];
			        }
		            data1 = item2.data1;
		            data2 = item2.data2;
		            data3 = item2.data3;
		            data4 = item2.data4;
		            data5 = item2.data5;
		            data6 = item2.data6;
		            opinion1 = item2.opinion1;
		            opinion2 = item2.opinion2;
		            a_1 = item2.a_1;
		            a_2 = item2.a_2;
		            a_3 = item2.a_3;
		            a_4 = item2.a_4;
		            a_5 = item2.a_5;
		            a_6 = item2.a_6;
		            a_7 = item2.a_7;
		            a_8 = item2.a_8;
		            a_9 = item2.a_9;
		            a_10 = item2.a_10;
		            a_tot = item2.a_tot;
		            drafter = item2.drafter;
		            eval1 = item2.eval1;
		          }
            }
	   });
	
		$('#data1').val(data1);
		$('#data2').val(data2);
		$('#data3').val(data3);
		$('#data4').val(data4);
		$('#data5').val(data5);
		$('#data6').val(data6);
		$('#opinion1').val(opinion1);
		$('#opinion2').val(opinion2);
		$('#a_1').text(a_1.trim());
		$('#a_2').text(a_2.trim());
		$('#a_3').text(a_3.trim());
		$('#a_4').text(a_4.trim());
		$('#a_5').text(a_5.trim());
		$('#a_6').text(a_6.trim());
		$('#a_7').text(a_7.trim());
		$('#a_8').text(a_8.trim());
		$('#a_9').text(a_9.trim());
		$('#a_10').text(a_10.trim());
		$('#a_tot').text(a_tot);
		$('#drafter').val(drafter);
		$('#eval1').val(eval1);
		// 1차 평가정보 end
		// -------------------------------------------
		
		
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
		
		//사용자 검색 버튼
		 $("#SearchUserBtn").on("click", function(){
		    $('#table-userList').bootstrapTable('refresh',queryParamsUser);
		});
		
		 $('#popShareBtn').on('click', function(){
		        $('#selectsearchuserModal').dialog({
		            title: '사용자 검색',
		            width: '1100px',
		            Height: '600px',
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
				
				/* var evalDate = new Date(response.rows[0].ibsa_ymd);
				console.log("입사일자", evalDate);
				
				var gigan1 = new Date(evalDate.setMonth(evalDate.getMonth() + 3));
				console.log("입사 3개월 후 : ", gigan1); 
				
				var gigan2 = new Date(evalDate.setDate(evalDate.getDate() - 15));
				console.log("15일전 : ", gigan2)
				
				var year = gigan1.getFullYear();
				var month = ('0' + (gigan1.getMonth()+1)).slice(-2);
				var day = ('0' + gigan1.getDate()).slice(-2);
				
				console.log("기간1 날짜 변환 : ", year + '-' + month + '-' + day);
				
				var year2 = gigan2.getFullYear();
				var month2 = ('0' + (gigan2.getMonth()+1)).slice(-2);
				var day2 = ('0' + gigan2.getDate()).slice(-2);
				
				console.log("기간2 날짜변환 : ", year2 + '-' + month2 + '-' + day2);
				
				
				
				var dateString = year2 + '-' + month2 + '-' + day2 + " ~ " + year + '-' + month + '-' + day;
				
				console.log("날짜 변환!! : " , dateString);

				$('#data1').val(row.user_nm);
				$('#data2').val(response.rows[0].jumin_no1 + '-*******');
				$('#data3').val(response.rows[0].description);
				$('#data4').val(response.rows[0].jikjong_code_name + " / " + response.rows[0].jikgeub_code_name);
 				$('#data5').val(response.rows[0].ibsa_ymd);
 		 		$('#data6').val(dateString); */ // 1차평가 기안내용 출력해줘야함
				
				
			});
			
			$('#selectsearchuserModal').dialog('close');
		}
	};

</script>

<form id="FORM_FM00000302">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr style="height: 20px;">
				<td colspan="6" class="info">1. 수습사원 대상자 인정사항
<!-- 					<button type="button" class="btn btn-outline-dark" id="popShareBtn">대상자선택</button> -->
				</td>
			</tr>
			
			<tr>
				<th>성명</th>
				<td colspan="2"><input id="data1" type="text" style="width: 230px; height: 25px;" readonly /></td>
				<th>주민등록번호</th>
				<td colspan="2"><input id="data2" type="text" style="width: 230px; height: 25px;" readonly /></td>
			</tr>

			<tr>
				<th>부서명</th>
				<td colspan="2"><input id="data3" type="text" style="width: 230px; height: 25px;" readonly /></td>
				<th>직종 및 직급</th>
				<td colspan="2"><input id="data4" type="text" style="width: 230px; height: 25px;" readonly /></td>
			</tr>

			<tr>
				<th style="border-bottom: none;">입사일자</th>
				<td colspan="2" style="border-bottom: none;">
					<input id="data5" type="text" style="width: 230px; height: 25px;" readonly /></td>
				<th style="border-bottom: none;">평가기간</th>
				<td colspan="2" style="border-bottom: none;">
					<input id="data6" type="text" style="width: 230px; height: 25px;" readonly /></td>
			</tr>
		</table>
	</div>

	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">

			<tr>
				<td colspan="6">2. 본인의견(1차평가자 면담란)</td>
			</tr>

			<tr>
				<th>수습사원 의견</th>
				<td colspan="5"><input id="opinion1" type="text" style="width: 100%; height: 25px;" readonly /></td>
			</tr>
			<tr>
				<th class="secondCol" style="padding: 5px 5px 5px 5px; border-bottom: none;">수습사원 건의사항</th>
				<td colspan="5" style="border-bottom: none;">
					<input id="opinion2" type="text" style="width: 100%; height: 25px;" readonly />
				</td>
			</tr>

		</table>
	</div>


	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">

			<tr>
				<td colspan="11">3. 평가항목 (등급 : S(10), A(8), B(6), C(4), D(2))</td>
			</tr>

			<tr>
				<th>평가<br>항목
				</th>
				<th>구분</th>
				<th colspan="5">평가검토사항</th>
				<th>1차<br>평가자</th>
				<th colspan="3" style="border-right: none;">평가등급</th>
			</tr>

			<tr>
				<td rowspan="5" class="evaluation" style="text-align: center;">태도<br>고과</td>
			</tr>


			<tr>
				<td class="evaluation" style="text-align: center;">도덕성</td>
				<td colspan="5" class="evaluation">복무규정과 근태 준수 및 언행의 적정성</td>
				<td id="a_1" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade1" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade1" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade1" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade1" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade1" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center;">적극성</td>
				<td colspan="5" class="evaluation">업무를 능동적 자세로 대처하고 의욕적으로 추진하는 능력</td>
				<td id="a_2" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade2" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade2" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade2" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade2" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade2" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center;">근면성</td>
				<td colspan="5" class="evaluation">모든 일에 솔선수범하고 책임감있게 업무를 수행하는 능력</td>
				<td id="a_3" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade3" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade3" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade3" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade3" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade3" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center;">협동성</td>
				<td colspan="5" class="evaluation">유대관계가 원만하고 업무수행에 있어 상호협동하는 능력</td>
				<td id="a_4" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade4" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade4" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade4" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade4" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade4" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td rowspan="5"
					style="text-align: center; border-right: 1px solid #dbdbdb;">능력<br>고과
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center;">업무지식</td>
				<td colspan="5" class="evaluation">담당직무에 필요한 보유지식 정도 및 활용 능력</td>
				<td id="a_5" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade5" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade5" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade5" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade5" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade5" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center;">수행능력</td>
				<td colspan="5" class="evaluation">주어진 업무를 기한내에 효율적으로 처리할 수 있는 능력</td>
				<td id="a_6" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade6" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade6" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade6" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade6" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade6" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center;">이 해 력</td>
				<td colspan="5" class="evaluation">문제 핵심을 이해하고 명확한 결과를 제시하는 능력</td>
				<td id="a_7" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade7" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade7" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade7" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade7" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade7" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center;">학습능력</td>
				<td colspan="5" class="evaluation">직무에 대해 능동적 자세로 학습하려는 태도</td>
				<td id="a_8" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade8" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade8" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade8" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade8" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade8" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td rowspan="3" class="evaluation" style="text-align: center;">성적<br>고과
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center; padding:0px 0px 0px 0px;">업무의 질</td>
				<td colspan="5" class="evaluation">내,외부고객의 민원 정도 및 대응 능력</td>
				<td id="a_9" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade9" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade9" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade9" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade9" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade9" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" style="text-align: center; padding:0px 0px 0px 0px;">업무의 양</td>
				<td colspan="5" class="evaluation">병원에서 주어진 업무량의 충족 능력</td>
				<td id="a_10" style="border-right:1px solid #dbdbdb; text-align: center;"></td>
				<td colspan="3" style="text-align: center; padding:0px 0px 0px 0px; letter-spacing: 3px">
					<label><input class="form-check-input" type="radio" name="grade10" value="10" style="margin-right:10px;"/>S </label> 
					<label><input class="form-check-input" type="radio" name="grade10" value="8" style="margin-right:10px;"/>A </label>
					<label><input class="form-check-input" type="radio" name="grade10" value="6" style="margin-right:10px;"/>B </label>
					<label><input class="form-check-input" type="radio" name="grade10" value="4" style="margin-right:10px;"/>C </label>
					<label><input class="form-check-input" type="radio" name="grade10" value="2" style="margin-right:10px;"/>D</label>
				</td>
			</tr>

			<tr>
				<td class="evaluation" colspan="7" style="text-align: center; border-bottom: none;">합 계</td>
				<td id="a_tot" style="border-right:1px solid #dbdbdb; border-bottom:none; text-align: center;"></td>
				<td colspan="3" style="border-bottom: none;">
					<input type="text" id="chk_total" style="height: 25px; text-align: right;" readonly />
				</td>
			</tr>
		</table>
	</div>

	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">

			<tr>
				<td colspan="10">4. 평가자 의견</td>
			</tr>

			<tr>
				<th colspan="2">1차평가자</th>
				<td colspan="8">
					<input id="eval1" type="text" style="height: 25px; width: 580px;" readonly />
				</td>
			</tr>

			<tr>
				<th colspan="2">2차평가자</th>
				<td colspan="8">
					<input id="eval2" type="text" style="height: 25px; width: 580px;">
				</td>
			</tr>

			<tr>
				<th colspan="2" style="border-bottom: none;">채용여부</th>
				<td colspan="8" style="border-bottom: none;">
					<label><input class="passyn" type="radio" name="passyn" value="합격" /> 합격 </label> 
					<label><input class="passyn" type="radio" name="passyn" value="불합격" /> 불합격 </label> 
				</td>
			</tr>
			
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000302_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000302_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>

<!-- 사용자 검색 -->
<div id="selectsearchuserModal" style="display:none">
        <ul style="height:25px;">
            <div class="pull-left" style="font-size: 12px; position: absolute; z-index: 99;">
            </div>
        </ul>
        <div id="aregTabContent" class="tab-content03">
            <div class="scroll-area-wrap02 pull-left w262">
                <div class="scroll_box">
                    <div class="scroll_top">
                        <div class="pull-left tree">
                            <h4 class="tit"><spring:message code="hicss.system.extra.departmentalList"/></h4>
                        </div>
                        <div class="pull-right">
                            <div class="ctrl_btn">                        
                                <button type="button" title="<spring:message code='hicss.menu.sub.elApprMgr.formsMgr.apprFormsMgr.Expand'/>" class="btn_asd" id="btnFormExpand"></button>
                                <button type="button" title="<spring:message code='hicss.menu.sub.elApprMgr.formsMgr.apprFormsMgr.Collapse'/>" class="btn_desd" id="btnFormCollapse"></button>
                            </div>
                        </div>
                    </div>
                <div class="SearchdeptTree padUl" style="overflow:auto;height:430px;"></div>
                </div>
            </div>
            <div class="scroll-area-wrap02 pull-right" style="width:780px; margin-top: -53px;">
                <table id="table-userList" data-toggle="table" data-url="/interwork/getUserListView.hi" data-side-pagination="server" data-pagination="true"
                data-page-size="10" data-page-list="[ 10, 20, 50]" data-show-refresh="true" data-show-columns="true" data-query-params="queryParamsUser" data-height="505">
                    <thead>
                        <tr>
                            <th data-width="20" data-field="user_nm" data-align="center" data-sortable="true">이름</th>    
                            <th data-width="20" data-field="memb_postion" data-align="center" data-sortable="true">직위</th>
                            <th data-width="20" data-field="memb_rank" data-align="center" data-sortable="true">직급</th>
                            <th data-width="10" data-field="" data-align="center" data-formatter="selectuseraddbutton" data-events="Addflowevent" data-sortable="true">선택</th>
                        </tr>
                    </thead>
                </table>                
            </div>
            <form:form commandName="sysVO" name="sysVO">
                <input type="hidden" name="first_reg_id" value="${loginVO.user_id}"/>
                <input type="hidden" name="role_view_type" value="hicss_dept_role"/>
                <input type="hidden" name="auth_code_id" value=""/>
                <input type="hidden" name="auth_user_id" value=""/>
                <input type="hidden" name="auth_memb_seq" value=""/>
                <input type="hidden" name="copy_user_id" value=""/>
                <input type="hidden" name="copy_memb_seq" value=""/>
                <input type="hidden" name="copy_role_type" value=""/>
                <input type="hidden" name="auth_dept_id" value=""/>
                <input type="hidden" name="auth_sel_dept_id" value=""/>
                <input type="hidden" name="srchUserName" value=""/>
            </form:form>
        </div>
    </div>