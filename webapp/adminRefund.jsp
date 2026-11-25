<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" import="java.util.*"%>
<%
	request.setCharacterEncoding("UTF-8"); 
%>	
<%
        String id = (String) session.getAttribute("ID");
		String type = (String)session.getAttribute("TYPE");
		
		String zero = "0";
		if(id == null || !type.equals(zero)) {
        	%>
        	<script>
	        	alert("어드민외 접속금지");
				location.href="index.jsp";
        	</script>
        	<%   	
%>
	<%@include file="top.jsp" %>
<% 
        } else if(type.equals(zero)) {
%>
	<%@include file="adminLoggedinTop.jsp" %>
<%
        } else {
%>    	
 	<%@include file="userLoggedinTop.jsp" %>
<%
        }
%>

<%
	
	Connection conn = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs = null;
	
	try{
		
		Class.forName("com.mysql.jdbc.Driver");
		String url="jdbc:mysql://localhost:3306/newdb";
		String userName="root";
		String password="pjypjypjy";
		conn = DriverManager.getConnection(url, userName, password);
		
		
		String sql = "SELECT LPAD(주문.주문번호,8,0), 고객.고객아이디, 주문.주문수량, 상품.상품명, DATE_FORMAT(주문.주문일자,'%Y-%m-%d'),상품.가격 * 주문.주문수량 합계 FROM 주문, 상품, 고객 WHERE 주문.상품번호 = 상품.상품번호 AND 고객.고객아이디=주문.고객아이디 AND 주문.환불상태 = 1";
		
		
		pstmt1 = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		
		pstmt1.executeQuery();
		
		rs = pstmt1.executeQuery();

		
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>주문</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/track.css" rel="stylesheet" />
        <link href="css/styles.css" rel="stylesheet" />
      	
    </head>
    <body>
        
        <!-- Header-->
        <header class="bg-dark py-5">
            <div class="container px-4 px-lg-5 my-5">
                <div class="text-center text-white">
                    <h1 class="display-4 fw-bolder">환불관리</h1>
                </div>
            </div>
        </header>
        <div class="container px-4 px-lg-5">
            <div class="common-data-box p-5">
            	<h5 class="title-sub5depth">환불 관리</h5>
                <div class="common-hrTable-1">
                    <table>
                      <colgroup>
                            <col style="width:15%;">
                            <col style="width:10%;">
                            <col style="width:20%;">
                            <col style="width:10%;">
                            <col style="width:15%;">
                            <col style="width:15%;">
                            <col style="width:15%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col" class="number">주문일자<br />[주문번호]</th>
                                <th scope="col" class="thumb">이미지</th>
                                <th scope="col" class="product">상품정보</th>
                                <th scope="col" class="quantity">수량</th>
                                <th scope="col" class="price">상품구매금액</th>
                                <th scope="col" class="state">고객아이디</th>
                                <th scope="col" class="service">환불 확인</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        rs.last();
                        do{ %>
                            <tr>
                                <td class="text-alignCenter">
                                    <%=rs.getString(5) %>
                                    <p>[<%=rs.getString(1) %>]</p>
                                </td>
                                <td class="text-alignCenter"><img src="snackImgs/<%=rs.getString(4) %>.PNG" onerror="this.src='http://img.echosting.cafe24.com/thumb/img_product_small.gif';" alt="" width=120px /></td>
                                <td class="text-alignCenter"><strong><%=rs.getString(4) %></strong>
                                </td>
                                <td class="text-alignCenter"><%=rs.getString(3) %>개</td>
                                <td class="text-alignCenter"><strong><script>document.writeln((<%=rs.getInt(6)%>).toLocaleString()+"원"); </script></strong>
                                <td class="text-alignCenter"><%=rs.getString(2) %></td>
                                <td class="text-alignCenter">
                                <a href="adminRefundPro.jsp?주문번호=<%=rs.getString(1)%>" class="button"><img src="image/cancel2.gif" alt="환불요청"/></a>
                                </td>
                            </tr>
                            <%}while(rs.previous()); %>
                        </tbody>         
                    </table>
                </div>
            </div>
        </div>
        <div style="margin-bottom: 246px !important;"></div>
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2022</p></div>
        </footer>
    </body>
</html>

<%		
	rs.close();
	pstmt1.close();     // Statement 종료
	conn.close();

	} catch (ClassNotFoundException e){
		out.println(e);
	} catch (SQLException e){
		out.println(e);
	} finally {
		
		 	// Connection 종료
	}
	
%>