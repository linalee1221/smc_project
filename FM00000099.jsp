<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 계약만료대상자 의견서 -->
<!-- GW 연동 아님! -->

<style>

	.pagination-detail{margin: 10px 0 0 0px !important;}
	
	.fixed-table-container {
		height: 395px !important;
	}

</style>

<script>
		
	$('#FM00000099_confirm').unbind().on('click', function() {
		/*-- TODO: validation check후 완료 시 HGW_APPR_INFO에 데이터 삽입 후 다이얼로그 창 닫기 --*/
	
		var formData = $('#FORM_FM00000099').serializeObject();
		var formDatas = [];
		formDatas.push(formData);
		var legacydata = [];
		
		// 1. 데이터 저장 (연동 아님!!!!)
		legacydata.push({
			NOT_LINK      	 : '연동아님'
		});
		
		HGW_APPR_INFO.legacy_data = encodeURIComponent(JSON.stringify(legacydata));
		
		// 2. validation check
		if (document.getElementById("UserID").innerText == "") {
            alert("대상자를 선택해 주세요.");
            return;
		}
		
		// 3. validation check 후 기안기에 내용 입력
		// 부서 : it_dept, 사번 : it_sabun, 성명 : it_name, 입사일 : it_date, 직종 : it_jikjong, 직급 : it_jikgub
		// 기안일자 : 기안일자
		var _$hwpObj = HGW_hdlr.rtnObj(1);
		
		// 일치하는 속성값을 먼저 삽입
		$.each(formData, function(keys, values) {
			_$hwpObj.insertSignData(keys, values);
		});
		
		_$hwpObj.insertSignData('it_dept', $('#DepartNM').text());
		_$hwpObj.insertSignData('it_sabun', $('#UserID').text());
		_$hwpObj.insertSignData('it_name', $('#UserNM').text());
		_$hwpObj.insertSignData('it_date', $('#EnterDate').text());
		_$hwpObj.insertSignData('it_jikjong', $('#Jikjong').text());
		_$hwpObj.insertSignData('it_jikgub', $('#Jikgub').text());
		_$hwpObj.insertSignData('기안일자', new Date().hgwDateFormat('yyyy년 MM월 dd일'));

		
		// 4. 저장 후 확인 누르면 기안기에 데이터를 입력하면서 다이얼로그 창 닫기
		$('#gw_sp_dialog').dialog('close');
	});
		
		// 5. 취소 버튼 누르면 폼 초기화하며 닫기
	$('#FM00000099_reset').unbind().on('click', function() {
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
		
		//사용자 검색 버튼
		 $("#SearchUserBtn").on("click", function(){
		    $('#table-userList').bootstrapTable('refresh',queryParamsUser);
		});
		
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

				$('#DepartNM').text(response.rows[0].DESCRIPTION);
				$('#UserID').text(row.user_emp_id);
				$('#UserNM').text(row.user_nm);
				$('#EnterDate').text(response.rows[0].IBSA_YMD);
 				$('#Jikjong').text(response.rows[0].JIKJONG_CODE_NAME);
 		 		$('#Jikgub').text(response.rows[0].JIKGEUB_CODE_NAME);
				
			});
			
			$('#selectsearchuserModal').dialog('close');
		}
	};
	
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

</script>

<form id="FORM_FM00000099">
	<div class="tablewrap-line" style="margin-top: 10px;">
		<table class="table-datatype01">
			
			<tr>
				<th>대상자변경</th>
					<td colspan="5">
						<button type="button" class="btn btn-outline-dark" id="popShareBtn">검색</button>
						<span>(* 대상자를 먼저 선택해 주세요!)</span>
					</td>
			</tr>

			<tr>
				<th>부서</th>
				<td colspan="2" id="DepartNM"></td>
				<th>사번</th>
				<td colspan="2" id="UserID"></td>
			</tr>

			<tr>
				<th>성명</th>
				<td colspan="2" id="UserNM"></td>
				<th>입사일</th>
				<td colspan="2" id="EnterDate"></td>
			</tr>

			<tr>
				<th style="border-bottom: none;">직종</th>
				<td colspan="2" style="border-bottom: none;" id="Jikjong"></td>
				<th style="border-bottom: none;">직급</th>
				<td colspan="2" style="border-bottom: none;" id="Jikgub"></td>
			</tr>
			
		</table>
	</div>

<!-- 버튼영역 -->
	<div class="btn-area-wrap" style="margin-top: 20px;">
		<button type="button" id="FM00000099_confirm" class="btn_large_basic_setting btn_large_accent_box"><spring:message code='button.confirm'/></button>
		<button type="button" id="FM00000099_reset" class="btn_large_basic_setting btn_large_normal_box"><spring:message code='button.reset'/></button>
	</div>
<!--// 버튼영역 -->
</form>

<!-- 사용자 검색 -->
<div id="selectsearchuserModal" style="display:none">
    <div id="aregTabContent" class="tab-content03">
        <div class="scroll-area-wrap02 pull-left w262" style="margin-top:24px;">
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
                <div style="border-bottom: 1px solid #e4e4e4;">
					<input class="posibox" id="user_nm_input" name="user_nm_input" type="text" value="" placeholder="<spring:message code='hicss.appr.extra.searchUserDept'/>" style="height:26px; margin: 5px 0px 5px 10px; width: calc( 100% - 20px);">
				</div>
            	<div class="SearchdeptTree padUl" style="overflow:auto;height:400px;"></div>
            	</div>
        	</div>
        <div class="scroll-area-wrap02 pull-right" style="width:520px; margin-top: -30px; height:550px; ">
            <table id="table-userList" data-toggle="table" data-url="/interwork/getUserListView.hi" data-side-pagination="server" data-pagination="true"
            data-page-size="10" data-page-list="[ 10, 20, 50]" data-show-refresh="true" data-show-columns="true" data-query-params="queryParamsUser" data-height="250">
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