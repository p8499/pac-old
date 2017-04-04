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
                <a href="${baseUrl}project?path=${pac:parent(pac:parent(requestScope.path))}">${pac:read(sessionScope.json,pac:parent(pac:parent(requestScope.path))).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Modules
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="${baseUrl}envJtee?path=${pac:parent(pac:parent(requestScope.path))}.envJtee">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="${baseUrl}envAndroid?path=${pac:parent(pac:parent(requestScope.path))}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li class="active">
                        <a href="${baseUrl}modules?path=${pac:parent(requestScope.path)}">
                            Modules</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    [${pac:id(requestScope.path)}] -
                    ${requestScope.target.id}
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach items="${pac:read(sessionScope.json,pac:parent(requestScope.path))}" var="module"
                               varStatus="moduleStatus">
                        <li<c:if test="${moduleStatus.index==pac:id(requestScope.path)}">
                            class="active"</c:if>>
                            <a href="${baseUrl}module?path=${pac:parent(requestScope.path)}[${moduleStatus.index}]">
                                [${moduleStatus.index}] - ${module.id}</a>
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
                          onsubmit="event.preventDefault();$.ajax({url:'${baseUrl}module?path=${requestScope.path}',type:'PUT',data:{id:$('#id').val(),description:$('#description').val(),comment:$('#comment').val(),datasource:$('#datasource').val(),databaseTable:$('#databaseTable').val(),databaseView:$('#databaseView').val(),jteeBeanAlias:$('#jteeBeanAlias').val(),jteeMaskAlias:$('#jteeMaskAlias').val(),jteeMapperAlias:$('#jteeMapperAlias').val(),jteeServiceAlias:$('#jteeServiceAlias').val(),jteeControllerBaseAlias:$('#jteeControllerBaseAlias').val(),jteeControllerPath:$('#jteeControllerPath').val(),jteeAttachmentControllerPath:$('#jteeAttachmentControllerPath').val(),androidBeanAlias:$('#androidBeanAlias').val(),androidMaskAlias:$('#androidMaskAlias').val(),androidStubAlias:$('#androidStubAlias').val()},success:function(response){window.location.reload();}});">
                        <div class="form-group">
                            <label for="id">ID</label>
                            <input class="form-control" id="id" type="text" value="${requestScope.target.id}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"
                                   onchange="this.value=this.value.toLowerCase();"/>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <input class="form-control" id="description" type="text"
                                   value="${requestScope.target.description}"/>
                        </div>
                        <div class="form-group">
                            <label for="comment">Comment</label>
                            <textarea class="form-control" id="comment" type="text"
                                      rows="4">${requestScope.target.comment}</textarea>
                        </div>
                        <div class="form-group">
                            <label for="datasource">Data Source</label>
                            <select class="form-control" id="datasource">
                                <c:forEach items="${sessionScope.json.envJtee.datasources}" var="datasource">
                                    <option value="${datasource.id}"
                                            <c:if test="${requestScope.target.datasource==datasource.id}">selected</c:if>>
                                            ${datasource.id}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="databaseTable">Database Table</label>
                            <input class="form-control" id="databaseTable" type="text"
                                   value="${requestScope.target.databaseTable}"/>
                        </div>
                        <div class="form-group">
                            <label for="databaseView">Database View</label>
                            <input class="form-control" id="databaseView" type="text"
                                   value="${requestScope.target.databaseView}"/>
                        </div>
                        <div class="form-group">
                            <label for="jteeBeanAlias">J2EE Bean Alias</label>
                            <input class="form-control" id="jteeBeanAlias" type="text"
                                   value="${requestScope.target.jteeBeanAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <div class="form-group">
                            <label for="jteeMaskAlias">J2EE Mask Alias</label>
                            <input class="form-control" id="jteeMaskAlias" type="text"
                                   value="${requestScope.target.jteeMaskAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <div class="form-group">
                            <label for="jteeMapperAlias">J2EE Mapper Alias</label>
                            <input class="form-control" id="jteeMapperAlias" type="text"
                                   value="${requestScope.target.jteeMapperAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <div class="form-group">
                            <label for="jteeServiceAlias">J2EE Service Alias</label>
                            <input class="form-control" id="jteeServiceAlias" type="text"
                                   value="${requestScope.target.jteeServiceAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <div class="form-group">
                            <label for="jteeControllerBaseAlias">J2EE Controller Base Alias</label>
                            <input class="form-control" id="jteeControllerBaseAlias" type="text"
                                   value="${requestScope.target.jteeControllerBaseAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <div class="form-group">
                            <label for="jteeControllerPath">J2EE Controller Path</label>
                            <input class="form-control" id="jteeControllerPath" type="text"
                                   value="${requestScope.target.jteeControllerPath}"/>
                        </div>
                        <div class="form-group">
                            <label for="jteeAttachmentControllerPath">J2EE Attachment Controller Path</label>
                            <input class="form-control" id="jteeAttachmentControllerPath" type="text"
                                   value="${requestScope.target.jteeAttachmentControllerPath}"/>
                        </div>
                        <div class="form-group">
                            <label for="androidBeanAlias">Android Bean Alias</label>
                            <input class="form-control" id="androidBeanAlias" type="text"
                                   value="${requestScope.target.androidBeanAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <div class="form-group">
                            <label for="androidMaskAlias">Android Mask Alias</label>
                            <input class="form-control" id="androidMaskAlias" type="text"
                                   value="${requestScope.target.androidMaskAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <div class="form-group">
                            <label for="androidStubAlias">Android Stub Alias</label>
                            <input class="form-control" id="androidStubAlias" type="text"
                                   value="${requestScope.target.androidStubAlias}"
                                   pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"/>
                        </div>
                        <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-ok"></span> Save
                        </button>
                    </form>
                    <button class="btn btn-link" type="button">
                        <a href="${baseUrl}fields?path=${requestScope.path}.fields">Fields</a>
                    </button>
                    <button class="btn btn-link" type="button">
                        <a href="${baseUrl}uniques?path=${requestScope.path}.uniques">Uniques</a>
                    </button>
                    <button class="btn btn-link" type="button">
                        <a href="${baseUrl}references?path=${requestScope.path}.references">References</a>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
