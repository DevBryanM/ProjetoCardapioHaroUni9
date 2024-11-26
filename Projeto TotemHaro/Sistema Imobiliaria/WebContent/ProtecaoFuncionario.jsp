<%
if (session.getAttribute("nome_funcionario")==null){
	response.sendRedirect("PageLogin.jsp");
}
%>