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
                <a href="/project?path=${pac:parent(pac:parent(requestScope.path))}">${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path))).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    J2EE Environment
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li class="active">
                        <a href="/envJtee?path=${pac:parent(requestScope.path)}">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="/envAndroid?path=${pac:parent(pac:parent(requestScope.path))}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li>
                        <a href="/modules?path=${pac:parent(pac:parent(requestScope.path))}.modules">
                            Modules</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="/datasources?path=${requestScope.path}">Data Sources</a>
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
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>${target.size()} data source(s) found.</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.target}" var="datasource" varStatus="datasourceStatus">
                            <tr>
                                <td><span class="col-sm-3">
                            <a href="/datasource?path=${requestScope.path}[${datasourceStatus.index}]">${datasource.id}</a></span>
                                    <span class="col-sm-6">${datasource.url}</span>
                                    <span class="col-sm-3">
                                <button type="button"
                                        class="btn btn-default<c:if test="${datasourceStatus.first}"> disabled</c:if>"
                                        onclick="$.get({url:'/datasources/swap?path=${requestScope.path}',data:{i:${datasourceStatus.index-1},j:${datasourceStatus.index}},success:function(response){window.location.reload();}});">
                                    <span class="glyphicon glyphicon-arrow-up"></span></button>
                                <button type="button"
                                        class="btn btn-default<c:if test="${datasourceStatus.last}"> disabled</c:if>"
                                        onclick="$.get({url:'/datasources/swap?path=${requestScope.path}',data:{i:${datasourceStatus.index},j:${datasourceStatus.index+1}},success:function(response){window.location.reload();}});">
                                    <span class="glyphicon glyphicon-arrow-down"></span></button>
                                <button type="button" class="btn btn-danger"
                                        onclick="$.ajax({url:'/datasources/${datasourceStatus.index}?path=${requestScope.path}',method:'DELETE',success:function(response){window.location.reload();}});">
                                    <span class="glyphicon glyphicon-remove"></span></button></span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                        <tfoot>
                        <tr>
                            <td>
                                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#post">
                                    <span class="glyphicon glyphicon-plus"></span> Add
                                </button>
                            </td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="post" aria-labelledby="post_label" aria-hidden="true" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form data-toggle="validator"
                      onsubmit="event.preventDefault();$.ajax({url:'/datasources?path=${requestScope.path}',type:'POST',data:{id:$('#id').val(),databaseType:$('#databaseType').val(),url:$('#url').val(),username:$('#username').val(),password:$('#password').val()},success:function(response){window.location.reload();}});">
                    <div class="modal-header">
                        <button class="close" type="button" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="post_label">Add a New Data Source</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="id">ID</label>
                            <input class="form-control" id="id" type="text" pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"
                                   onchange="this.value=this.value.toLowerCase();"/>
                        </div>
                        <div class="form-group">
                            <label for="databaseType">Database Type</label>
                            <select class="form-control" id="databaseType">
                                <option value="oracle">Oracle</option>
                                <option value="mysql">MySQL</option>
                                <option value="postgresql">PostgreSQL</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="url">URL</label>
                            <input class="form-control" id="url" type="text"/>
                        </div>
                        <div class="form-group">
                            <label for="username">User Name</label>
                            <input class="form-control" id="username" type="text"/>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input class="form-control" id="password" type="text"/>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" type="button" data-dismiss="modal">
                            <span class="glyphicon glyphicon-remove"></span> Close
                        </button>
                        <button class="btn btn-primary" type="submit">
                            <span class="glyphicon glyphicon-ok"></span> Save
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
