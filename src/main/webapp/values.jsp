<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set scope="request" var="target" value="${pac:read(sessionScope.json,requestScope.path)}"/>
<c:set var="baseUrl"
       value='<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"%>'/>
<html>
<head>
    <title>PAC Workbench</title>
    <link rel="stylesheet" href="${baseUrl}css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${baseUrl}css/tree.css">
    <script src="${baseUrl}js/jquery-3.1.1.min.js"></script>
    <script src="${baseUrl}js/bootstrap.min.js"></script>
    <script src="${baseUrl}js/validator.min.js"></script>
    <script src="${baseUrl}js/jquery.form.min.js"></script>
    <script src="${baseUrl}js/tree.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <jsp:include page="_menu.jsp"/>
    </div>
    <div class="row">
        <ol class="breadcrumb">
            <li>
                <a href="${baseUrl}project?path=${pac:parent(pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path)))))}">${pac:read(sessionScope.json,pac:parent(pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path)))))).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Modules
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="${baseUrl}envJtee?path=${pac:parent(pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path)))))}.envJtee">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="${baseUrl}envAndroid?path=${pac:parent(pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path)))))}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li class="active">
                        <a href="${baseUrl}modules?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}">
                            Modules</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(pac:parent(pac:parent(pac:parent(requestScope.path))))}] -
                    ${pac:read(sessionScope.json,pac:parent(pac:parent(pac:parent(requestScope.path)))).id}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach
                            items="${pac:read(sessionScope.json,pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path)))))}"
                            var="module" varStatus="moduleStatus">
                        <li<c:if
                                test="${moduleStatus.index==pac:id(pac:parent(pac:parent(pac:parent(requestScope.path))))}">
                            class="active"</c:if>>
                            <a href="${baseUrl}module?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${module.id}</a>
                        </li>
                    </c:forEach>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Fields
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li class="active">
                        <a href="${baseUrl}fields?path=${pac:parent(pac:parent(requestScope.path))}">
                            Fields</a>
                    </li>
                    <li>
                        <a href="${baseUrl}uniques?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}.uniques">
                            Uniques</a>
                    </li>
                    <li>
                        <a href="${baseUrl}references?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}.references">
                            References</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(pac:parent(requestScope.path))}] -
                    ${pac:read(sessionScope.json,pac:parent(requestScope.path)).databaseColumn}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach items="${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path)))}"
                               var="field" varStatus="moduleStatus">
                        <li<c:if test="${moduleStatus.index==pac:id(pac:parent(requestScope.path))}">
                            class="active"</c:if>>
                            <a href="${baseUrl}field?path=${pac:parent(pac:parent(requestScope.path))}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${field.databaseColumn}</a>
                        </li>
                    </c:forEach>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Values
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="${baseUrl}special?path=${pac:parent(requestScope.path)}.special">
                            Special</a>
                    </li>
                    <li class="active">
                        <a href="${baseUrl}values?path=${requestScope.path}">
                            Values</a>
                    </li>
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
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>${target.size()} value(s) found.</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.target}" var="field" varStatus="moduleStatus">
                            <tr>
                                <td><span class="col-sm-3">
                            <a href="${baseUrl}value?path=${requestScope.path}[${moduleStatus.index}]">${field.value}</a></span>
                                    <span class="col-sm-3">${field.code}</span>
                                    <span class="col-sm-3">${field.label}</span>
                                    <span class="col-sm-3">
                                <button type="button"
                                        class="btn btn-default<c:if test="${moduleStatus.first}"> disabled</c:if>"
                                        onclick="$.get({url:'${baseUrl}values/swap?path=${requestScope.path}',data:{i:${moduleStatus.index-1},j:${moduleStatus.index}},success:function(response){window.location.reload();}});">
                                    <span class="glyphicon glyphicon-arrow-up"></span></button>
                                <button type="button"
                                        class="btn btn-default<c:if test="${moduleStatus.last}"> disabled</c:if>"
                                        onclick="$.get({url:'${baseUrl}values/swap?path=${requestScope.path}',data:{i:${moduleStatus.index},j:${moduleStatus.index+1}},success:function(response){window.location.reload();}});">
                                    <span class="glyphicon glyphicon-arrow-down"></span></button>
                                <button type="button" class="btn btn-danger"
                                        onclick="$.ajax({url:'${baseUrl}values/${moduleStatus.index}?path=${requestScope.path}',method:'DELETE',success:function(response){window.location.reload();}});">
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
                      onsubmit="event.preventDefault();$.ajax({url:'${baseUrl}values?path=${requestScope.path}',type:'POST',data:{value:$('#value').val(),code:$('#code').val(),label:$('#label').val()},success:function(response){window.location.reload();}});">
                    <div class="modal-header">
                        <button class="close" type="button" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="post_label">Add a New Field</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="value">Value</label>
                            <input class="form-control" id="value"<c:choose>
                                <c:when test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"String\"}">type="text"</c:when>
                                <c:when test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"Integer\"}">type="number"</c:when>
                                <c:when test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"Double\"}">type="number" step="any"</c:when>
                                <c:when test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"java.util.Date\"}">type="datetime"</c:when></c:choose>/>
                        </div>
                        <div class="form-group">
                            <label for="code">Code</label>
                            <input class="form-control" id="code" type="text"
                                   onchange="this.value=this.value.toUpperCase().trim();"/>
                        </div>
                        <div class="form-group">
                            <label for="label">Label</label>
                            <input class="form-control" id="label" type="text"/>
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
