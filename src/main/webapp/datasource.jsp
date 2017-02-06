<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set scope="request" var="target" value="${pac:read(sessionScope.json,requestScope.path)}"/>
<html>
<head>
    <title>PAC Workbench</title>
    <link rel="stylesheet" href="/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="/css/tree.css">
    <script src="/js/jquery-3.1.1.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/validator.min.js"></script>
    <script src="/js/jquery.form.min.js"></script>
    <script src="/js/tree.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <jsp:include page="_menu.jsp"/>
    </div>
    <div class="row">
        <ol class="breadcrumb">
            <li>
                <a href="/project?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}">${pac:read(sessionScope.json,pac:parent(pac:parent(pac:parent(requestScope.path)))).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    J2EE Environment
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li class="active">
                        <a href="/envJtee?path=${pac:parent(pac:parent(requestScope.path))}">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="/envAndroid?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li>
                        <a href="/modules?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}.modules">
                            Modules</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="/datasources?path=${pac:parent(requestScope.path)}">Data Sources</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(requestScope.path)}] -
                    ${requestScope.target.id}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach items="${pac:read(sessionScope.json,pac:parent(requestScope.path))}" var="datasource"
                               varStatus="datasourceStatus">
                        <li<c:if test="${datasourceStatus.index==pac:id(requestScope.path)}">
                            class="active"</c:if>>
                            <a href="/datasource?path=${pac:parent(requestScope.path)}[${datasourceStatus.index}]">
                                [${datasourceStatus.index}] - ${datasource.id}</a>
                        </li>
                    </c:forEach>
                </ul>
            </li>
        </ol>
    </div>
    <div class="row">
        <div class="col-sm-3">
            <jsp:include page="_tree.jsp"/>
        </div>
        <div class="col-sm-9">
            <div class="panel panel-default">
                <div class="panel-body">
                    <form data-toggle="validator"
                          onsubmit="event.preventDefault();$.ajax({url:'/datasource?path=${requestScope.path}',type:'PUT',data:{id:$('#id').val(),databaseType:$('#databaseType').val(),url:$('#url').val(),username:$('#username').val(),password:$('#password').val()},success:function(response){window.location.reload();}});">
                        <div class="form-group">
                            <label for="id">ID</label>
                            <input class="form-control" id="id" type="text" value="${requestScope.target.id}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"
                                   onchange="this.value=this.value.toLowerCase();"/>
                        </div>
                        <div class="form-group">
                            <label for="databaseType">Database Type</label>
                            <select class="form-control" id="databaseType">
                                <option value="oracle"
                                        <c:if test="${requestScope.target.databaseType==\"oracle\"}">selected</c:if>>
                                    Oracle
                                </option>
                                <option value="mysql"
                                        <c:if test="${requestScope.target.databaseType==\"mysql\"}">selected</c:if>>
                                    MySQL
                                </option>
                                <option value="postgresql"
                                        <c:if test="${requestScope.target.databaseType==\"postgresql\"}">selected</c:if>>
                                    PostgreSQL
                                </option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="url">URL</label>
                            <input class="form-control" id="url" type="text" value="${requestScope.target.url}"/>
                        </div>
                        <div class="form-group">
                            <label for="username">User Name</label>
                            <input class="form-control" id="username" type="text"
                                   value="${requestScope.target.username}"/>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input class="form-control" id="password" type="text"
                                   value="${requestScope.target.password}"/>
                        </div>
                        <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-ok"></span> Save
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
