<%--
  Created by IntelliJ IDEA.
  User: cmm
  Date: 2018-7-25
  Time: 17:08
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    request.setAttribute("ctx", request.getContextPath());
%>
<script>
    var loc = window.location;
    loc.href = loc.protocol + "//" + loc.host + "${ctx}/page/login/loginPage";
</script>
