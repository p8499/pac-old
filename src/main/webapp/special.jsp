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
    <link rel="stylesheet" href="${baseUrl}css/bootstrap-tagsinput.css"/>
    <link rel="stylesheet" href="${baseUrl}css/tree.css">
    <script src="${baseUrl}js/jquery-3.1.1.min.js"></script>
    <script src="${baseUrl}js/bootstrap.min.js"></script>
    <script src="${baseUrl}js/validator.min.js"></script>
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
                    Special
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li class="active">
                        <a href="${baseUrl}special?path=${requestScope.path}">
                            Special</a>
                    </li>
                    <li>
                        <a href="${baseUrl}values?path=${pac:parent(requestScope.path)}.values">
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
                    <form>
                        <div class="panel-group" id="group">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="radio">
                                        <label>
                                            <input name="type" type="radio" value="" data-toggle="collapse"
                                                   data-parent="#group"
                                                   <c:if test="${empty requestScope.target.type}">checked</c:if>
                                                   data-target="#none"/>None
                                        </label>
                                    </div>
                                </div>
                                <div id="none"
                                     class="panel-collapse collapse<c:if test="${empty requestScope.target.type}"> in</c:if>">
                                    <div class="panel-body"></div>
                                </div>
                            </div>
                            <c:if test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"String\"}">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="radio">
                                            <label>
                                                <input name="type" type="radio" value="password" data-toggle="collapse"
                                                       <c:if test="${requestScope.target.type==\"password\"}">checked</c:if>
                                                       data-parent="#group"
                                                       data-target="#password"/>Password
                                            </label>
                                        </div>
                                    </div>
                                    <div id="password"
                                         class="panel-collapse collapse<c:if test="${requestScope.target.type==\"password\"}"> in</c:if>">
                                        <div class="panel-body"></div>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"java.util.Date\"}">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="radio">
                                            <label>
                                                <input name="type" type="radio" value="created" data-toggle="collapse"
                                                       <c:if test="${requestScope.target.type==\"created\"}">checked</c:if>
                                                       data-parent="#group"
                                                       data-target="#created"/>Created
                                            </label>
                                        </div>
                                    </div>
                                    <div id="created"
                                         class="panel-collapse collapse<c:if test="${requestScope.target.type==\"created\"}"> in</c:if>">
                                        <div class="panel-body"></div>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"java.util.Date\"}">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="radio">
                                            <label>
                                                <input name="type" type="radio" value="updated" data-toggle="collapse"
                                                       <c:if test="${requestScope.target.type==\"updated\"}">checked</c:if>
                                                       data-parent="#group"
                                                       data-target="#updated"/>Updated
                                            </label>
                                        </div>
                                    </div>
                                    <div id="updated"
                                         class="panel-collapse collapse<c:if test="${requestScope.target.type==\"updated\"}"> in</c:if>">
                                        <div class="panel-body"></div>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${pac:read(sessionScope.json,pac:parent(requestScope.path)).javaType==\"Integer\"}">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="radio">
                                            <label>
                                                <input name="type" type="radio" value="next" data-toggle="collapse"
                                                       <c:if test="${requestScope.target.type==\"next\"}">checked</c:if>
                                                       data-parent="#group"
                                                       data-target="#next"/>Next
                                            </label>
                                        </div>
                                    </div>
                                    <div id="next"
                                         class="panel-collapse collapse<c:if test="${requestScope.target.type==\"next\"}"> in</c:if>">
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <input class="form-control" id="scope" type="text"
                                                       value="${pac:join(",",requestScope.target.scope)}"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="radio">
                                        <label>
                                            <input name="type" type="radio" value="view" data-toggle="collapse"
                                                   <c:if test="${requestScope.target.type==\"view\"}">checked</c:if>
                                                   data-parent="#group"
                                                   data-target="#view"/>View
                                        </label>
                                    </div>
                                </div>
                                <div id="view"
                                     class="panel-collapse collapse<c:if test="${requestScope.target.type==\"view\"}"> in</c:if>">
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <input class="form-control" id="func" type="text"
                                                   value="${requestScope.target.func}"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="radio">
                                        <label>
                                            <input name="type" type="radio" value="other" data-toggle="collapse"
                                                   <c:if test="${requestScope.target.type==\"other\"}">checked</c:if>
                                                   data-parent="#group"
                                                   data-target="#other"/>Other
                                        </label>
                                    </div>
                                </div>
                                <div id="other"
                                     class="panel-collapse collapse<c:if test="${requestScope.target.type==\"other\"}"> in</c:if>">
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <label for="insertClass">Who provide the data for this field during HTTP POST?</label>
                                            <select class="form-control" id="insertClass">
                                                <option value="nonnull"
                                                        <c:if test="${requestScope.target.insertClass==\"nonnull\"}">selected</c:if>>
                                                    Client
                                                </option>
                                                <option value="nullable"
                                                        <c:if test="${requestScope.target.insertClass==\"nullable\"}">selected</c:if>>
                                                    Client / Server
                                                </option>
                                                <option value="null"
                                                        <c:if test="${requestScope.target.insertClass==\"null\"}">selected</c:if>>
                                                    Client should never provide data for this field
                                                </option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="updateClass">Who provide the data for this field during HTTP PUT?</label>
                                            <select class="form-control" id="updateClass">
                                                <option value="nonnull"
                                                        <c:if test="${requestScope.target.updateClass==\"nonnull\"}">selected</c:if>>
                                                    Client
                                                </option>
                                                <option value="nullable"
                                                        <c:if test="${requestScope.target.updateClass==\"nullable\"}">selected</c:if>>
                                                    Client / Server
                                                </option>
                                                <option value="null"
                                                        <c:if test="${requestScope.target.updateClass==\"null\"}">selected</c:if>>
                                                    Client should never provide data for this field
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
    $("#scope").tagsinput({
        typeahead: {
            source: [
                <c:forEach items="${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path)))}" var="field" varStatus="moduleStatus">
                <c:choose>
                <c:when test="${!moduleStatus.last}">'${field.databaseColumn}', </c:when>
                <c:otherwise>'${field.databaseColumn}'</c:otherwise>
                </c:choose>
                </c:forEach>
            ]
        }
    });
    $(document).on("submit", "form", function (event) {
        event.preventDefault();

        if ($("input[name=type]:checked").val() == "")
            $.get({
                url: "${baseUrl}special/clear?path=${requestScope.path}",
                success: function (response) {
                    window.location.reload();
                }
            });
        else
            $.ajax({
                url: "${baseUrl}special?path=${requestScope.path}",
                type: "PUT",
                data: {
                    type: $("input[name=type]:checked").val(),
                    serial: $("#serial").is(":checked"),
                    scope: $("#scope").val(),
                    func: $("#func").val(),
                    insertClass: $('#insertClass').val(),
                    updateClass: $('#updateClass').val()
                },
                success: function (response) {
                    window.location.reload();
                }
            });
    });
</script>
</body>
</html>
