<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<c:set scope="request" var="target" value="${pac:read(sessionScope.json,requestScope.path)}"/>
<c:set var="baseUrl"
       value='<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"%>'/>
<html>
<head>
    <title>PAC Workbench</title>
    <link rel="stylesheet" href="${baseUrl}css/bootstrap.min.css">
    <link rel="stylesheet" href="${baseUrl}css/bootstrap-tagsinput.css"/>
    <link rel="stylesheet" href="${baseUrl}css/tree.css">
    <script src="${baseUrl}js/jquery-3.1.1.min.js"></script>
    <script src="${baseUrl}js/bootstrap.min.js"></script>
    <script src="${baseUrl}js/bootstrap3-typeahead.min.js"></script>
    <script src="${baseUrl}js/bootstrap-tagsinput.min.js"></script>
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
                <a href="${baseUrl}project?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}">${pac:read(sessionScope.json,pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Modules
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="${baseUrl}envJtee?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}.envJtee">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="${baseUrl}envAndroid?path=${pac:parent(pac:parent(pac:parent(pac:parent(requestScope.path))))}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li class="active">
                        <a href="${baseUrl}modules?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}">
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
                            <a href="${baseUrl}module?path=${pac:parent(pac:parent(pac:parent(requestScope.path)))}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${module.id}</a>
                        </li>
                    </c:forEach>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    References
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="${baseUrl}fields?path=${pac:parent(pac:parent(requestScope.path))}.fields">
                            Fields</a>
                    </li>
                    <li>
                        <a href="${baseUrl}uniques?path=${pac:parent(pac:parent(requestScope.path))}.uniques">
                            Uniques</a>
                    </li>
                    <li class="active">
                        <a href="${baseUrl}references?path=${pac:parent(requestScope.path)}">
                            References</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(requestScope.path)}] -
                    ${pac:join(",",requestScope.target.domestic)}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach items="${pac:read(sessionScope.json,pac:parent(requestScope.path))}"
                               var="reference" varStatus="moduleStatus">
                        <li<c:if test="${moduleStatus.index==pac:id(requestScope.path)}">
                            class="active"</c:if>>
                            <a href="${baseUrl}reference?path=${pac:parent(requestScope.path)}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${pac:join(",",reference.domestic)}</a>
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
                    <form onsubmit="event.preventDefault();$.ajax({url:'${baseUrl}reference?path=${requestScope.path}',type:'PUT',data:{domestic:$('#domestic').val(),foreignModule:$('#foreignModule').val(),foreign:$('#foreign').val()},success:function(response){window.location.reload();}});">
                        <div class="form-group">
                            <input class="form-control" id="domestic" type="text"
                                   value="${pac:join(",",requestScope.target.domestic)}"/>
                        </div>
                        <div class="form-group">
                            <label for="foreignModule">References from</label>
                            <select class="form-control" id="foreignModule" onchange="onForeignModuleChange();">
                                <c:forEach
                                        items="${pac:read(sessionScope.json,String.format(\"$.modules[?(@.datasource=='%s')]\",pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path))).datasource))}"
                                        var="module">
                                    <option value="${module.id}"
                                            <c:if test="${requestScope.target.foreignModule==module.id}">selected</c:if>>${module.id}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <input class="form-control" id="foreign" type="text"
                                   value="${pac:join(",",requestScope.target.foreign)}"
                                   data-role="tagsinput"/>
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
    $("#domestic").tagsinput({
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
    window.onForeignModuleChange = function () {
        $.get({
            url: "${baseUrl}module/fieldIds?path=$.modules[?(@.id=='" + $("#foreignModule").val() + "')]",
            dataType: "json",
            success: function (response) {
                $("#foreign").tagsinput("destroy");
                $("#foreign").tagsinput({typeahead: {source: response}});
            }
        });
    };
    onForeignModuleChange();
</script>
</body>
</html>
