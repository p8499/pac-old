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
    <script src="${baseUrl}js/bootstrap3-typeahead.min.js"></script>
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
                    Fields
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li class="active">
                        <a href="${baseUrl}fields?path=${pac:parent(requestScope.path)}">
                            Fields</a>
                    </li>
                    <li>
                        <a href="${baseUrl}uniques?path=${pac:parent(pac:parent(requestScope.path))}.uniques">
                            Uniques</a>
                    </li>
                    <li>
                        <a href="${baseUrl}references?path=${pac:parent(pac:parent(requestScope.path))}.references">
                            References</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(requestScope.path)}] -
                    ${target.databaseColumn}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach items="${pac:read(sessionScope.json,pac:parent(requestScope.path))}"
                               var="field" varStatus="moduleStatus">
                        <li<c:if test="${moduleStatus.index==pac:id(requestScope.path)}">
                            class="active"</c:if>>
                            <a href="${baseUrl}field?path=${pac:parent(requestScope.path)}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${field.databaseColumn}</a>
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
                          onsubmit="event.preventDefault();$.ajax({url:'${baseUrl}field?path=${requestScope.path}',type:'PUT',data:{source:$('#source').val(),notnull: $('#notnull').is(':checked'),databaseColumn:$('#databaseColumn').val(),description:$('#description').val(),javaType:$('#javaType').val(),stringLength:$('#stringLength').val(),integerLength:$('#integerLength').val(),fractionLength:$('#fractionLength').val(),defaultValue:$('#defaultValue').val()},success:function(response){window.location.reload();}});">
                        <div class="form-group">
                            <label for="source">Source</label>
                            <select class="form-control" id="source" onchange="onSourceChange();">
                                <option value="table"
                                        <c:if test="${requestScope.target.source==\"table\"}"> selected</c:if>>
                                    Table
                                    - ${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path))).databaseTable}
                                </option>
                                <option value="view"
                                        <c:if test="${requestScope.target.source==\"view\"}"> selected</c:if>>
                                    View
                                    - ${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path))).databaseView}
                                </option>
                            </select>
                        </div>
                        <div class="checkbox">
                            <label>
                                <input id="notnull" type="checkbox"
                                       <c:if test="${requestScope.target.notnull}">checked</c:if>/>Not Null
                            </label>
                        </div>
                        <div class="form-group">
                            <label for="databaseColumn">Database Column</label>
                            <input class="form-control" id="databaseColumn" type="text"
                                   value="${requestScope.target.databaseColumn}"
                                   onchange="this.value=this.value.toLowerCase().trim();"/>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <input class="form-control" id="description" type="text"
                                   value="${requestScope.target.description}"/>
                        </div>
                        <div class="form-group">
                            <label for="javaType">Java Type</label>
                            <select class="form-control" id="javaType"
                                    onchange="onJavaTypeChange();">
                                <option value="String"
                                        <c:if test="${requestScope.target.javaType==\"String\"}"> selected</c:if>>
                                    java.lang.String
                                </option>
                                <option value="Integer"
                                        <c:if test="${requestScope.target.javaType==\"Integer\"}"> selected</c:if>>
                                    java.lang.Integer
                                </option>
                                <option value="Double"
                                        <c:if test="${requestScope.target.javaType==\"Double\"}"> selected</c:if>>
                                    java.lang.Double
                                </option>
                                <option value="java.util.Date"
                                        <c:if test="${requestScope.target.javaType==\"java.util.Date\"}"> selected</c:if>>
                                    java.util.Date
                                </option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="stringLength">String Length</label>
                            <input class="form-control" id="stringLength" type="number"
                                   value="${requestScope.target.stringLength}"/>
                        </div>
                        <div class="form-group">
                            <label for="integerLength">Integer Length</label>
                            <input class="form-control" id="integerLength" type="number"
                                   value="${requestScope.target.integerLength}"/>
                        </div>
                        <div class="form-group">
                            <label for="fractionLength">Fraction Length</label>
                            <input class="form-control" id="fractionLength" type="number"
                                   value="${requestScope.target.fractionLength}"/>
                        </div>
                        <div class="form-group">
                            <label for="defaultValue">Default Value</label>
                            <input class="form-control" id="defaultValue" type="text"
                                   value="${requestScope.target.defaultValue}"/>
                        </div>
                        <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-ok"></span> Save
                        </button>
                    </form>
                    <button class="btn btn-link" type="button">
                        <a href="${baseUrl}values?path=${requestScope.path}.values">Values</a>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    window.onSourceChange = function () {
        if ($("#source").val() == "table") {
            $("#notnull").removeAttr("disabled");
        }
        else if ($("#source").val() == "view") {
            $("#notnull").removeAttr("checked");
            $("#notnull").attr("disabled", "disabled");
        }
    };
    window.onJavaTypeChange = function () {
        if ($("#javaType").val() == "String") {
            $("#stringLength").removeAttr("disabled");
            $("#integerLength").val("");
            $("#integerLength").attr("disabled", "disabled");
            $("#fractionLength").val("");
            $("#fractionLength").attr("disabled", "disabled");
            $("#defaultValue").removeAttr("disabled");
            $("#defaultValue").attr("type", "text");
            $("#defaultValue").removeAttr("step");
        }
        else if ($("#javaType").val() == "Integer") {
            $("#stringLength").val("");
            $("#stringLength").attr("disabled", "disabled");
            $("#integerLength").removeAttr("disabled");
            $("#fractionLength").val("");
            $("#fractionLength").attr("disabled", "disabled");
            $("#defaultValue").removeAttr("disabled");
            $("#defaultValue").attr("type", "number");
            $("#defaultValue").removeAttr("step");
        }
        else if ($("#javaType").val() == "Double") {
            $("#stringLength").val("");
            $("#stringLength").attr("disabled", "disabled");
            $("#integerLength").removeAttr("disabled");
            $("#fractionLength").removeAttr("disabled");
            $("#defaultValue").removeAttr("disabled");
            $("#defaultValue").attr("type", "number");
            $("#defaultValue").attr("step", "any");
        }
        else if ($("#javaType").val() == "java.util.Date") {
            $("#stringLength").val("");
            $("#stringLength").attr("disabled", "disabled");
            $("#integerLength").val("");
            $("#integerLength").attr("disabled", "disabled");
            $("#fractionLength").val("");
            $("#fractionLength").attr("disabled", "disabled");
            $("#defaultValue").val("");
            $("#defaultValue").attr("disabled", "disabled");
            $("#defaultValue").removeAttr("type");
            $("#defaultValue").removeAttr("step");
        }
    };
    onSourceChange();
    onJavaTypeChange();
</script>
</body>
</html>
