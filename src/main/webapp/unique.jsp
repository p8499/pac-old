<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set scope="request" var="target" value="${pac:read(sessionScope.json,requestScope.path)}"/>
<html>
<head>
    <title>PAC Workbench</title>
    <link rel="stylesheet" href="/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/bootstrap-tagsinput.css"/>
    <link rel="stylesheet" href="/css/tree.css">
    <script src="/js/jquery-3.1.1.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/bootstrap3-typeahead.min.js"></script>
    <script src="/js/bootstrap-tagsinput.min.js"></script>
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
                <a href="/project?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}">${pac:read(sessionScope.json,pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Modules
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="/envJtee?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}.envJtee">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="/envAndroid?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li class="active">
                        <a href="/modules?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}">
                            Modules</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(pac:parent(pac:parent(requestScope.path)))}] -
                    ${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path))).id}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach
                            items="${pac:read(sessionScope.json,pac:parent(pac:parent(pac:parent(requestScope.path))))}"
                            var="module" varStatus="moduleStatus">
                        <li<c:if test="${moduleStatus.index==pac:id(pac:parent(pac:parent(requestScope.path)))}">
                            class="active"</c:if>>
                            <a href="/module?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${module.id}</a>
                        </li>
                    </c:forEach>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Uniques
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="/fields?path=${pac:parent(pac:parent(requestScope.path))}.fields">
                            Fields</a>
                    </li>
                    <li class="active">
                        <a href="/uniques?path=${pac:parent(requestScope.path)}">
                            Uniques</a>
                    </li>
                    <li>
                        <a href="/references?path=${pac:parent(pac:parent(requestScope.path))}.references">
                            References</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(requestScope.path)}] -
                    ${pac:join(",",requestScope.target.items)}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach items="${pac:read(sessionScope.json,pac:parent(requestScope.path))}"
                               var="unique" varStatus="moduleStatus">
                        <li<c:if test="${moduleStatus.index==pac:id(requestScope.path)}">
                            class="active"</c:if>>
                            <a href="/unique?path=${pac:parent(requestScope.path)}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${pac:join(",",unique.items)}</a>
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
                    <form onsubmit="event.preventDefault();$.ajax({url:'/unique?path=${requestScope.path}',type:'PUT',data:{item:$('#item').val(),key: $('#key').is(':checked'),serial: $('#serial').is(':checked')},success:function(response){window.location.reload();}});">
                        <div class="form-group">
                            <input class="form-control" id="item" type="text"
                                   value="${pac:join(",",requestScope.target.items)}"/>
                        </div>
                        <div class="checkbox">
                            <label>
                                <input id="key" type="checkbox"
                                       <c:if test="${requestScope.target.key}">checked</c:if>/>Key
                            </label>
                        </div>
                        <div class="checkbox">
                            <label>
                                <input id="serial" type="checkbox"
                                       <c:if test="${requestScope.target.serial}">checked</c:if>/>Serial
                            </label>
                        </div>
                        <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-ok"></span> Save
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $("#item").tagsinput({
        typeahead: {
            source: [
                <c:forEach items="${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path))).fields}" var="field" varStatus="moduleStatus">
                <c:choose>
                <c:when test="${!moduleStatus.last}">'${field.databaseColumn}', </c:when>
                <c:otherwise>'${field.databaseColumn}'</c:otherwise>
                </c:choose>
                </c:forEach>
            ]
        }
    });
</script>
</body>
</html>