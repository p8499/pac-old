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
                <a href="${baseUrl}project?path=${pac:parent(requestScope.path)}">${pac:read(sessionScope.json,pac:parent(requestScope.path)).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    Modules
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a href="${baseUrl}envJtee?path=${pac:parent(requestScope.path)}.envJtee">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="${baseUrl}envAndroid?path=${pac:parent(requestScope.path)}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li class="active">
                        <a href="${baseUrl}modules?path=${requestScope.path}">
                            Modules</a>
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
                            <th>${target.size()} module(s) found.</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.target}" var="module" varStatus="moduleStatus">
                            <tr>
                                <td><span class="col-sm-2">
                            <a href="${baseUrl}module?path=${requestScope.path}[${moduleStatus.index}]">${module.id}</a></span>
                                    <span class="col-sm-2">${module.description}</span>
                                    <span class="col-sm-5">${module.databaseTable}@${module.datasource}</span>
                                    <span class="col-sm-3">
                                <button type="button"
                                        class="btn btn-default<c:if test="${moduleStatus.first}"> disabled</c:if>"
                                        onclick="$.get({url:'${baseUrl}modules/swap?path=${requestScope.path}',data:{i:${moduleStatus.index-1},j:${moduleStatus.index}},success:function(response){window.location.reload();}});">
                                    <span class="glyphicon glyphicon-arrow-up"></span></button>
                                <button type="button"
                                        class="btn btn-default<c:if test="${moduleStatus.last}"> disabled</c:if>"
                                        onclick="$.get({url:'${baseUrl}modules/swap?path=${requestScope.path}',data:{i:${moduleStatus.index},j:${moduleStatus.index+1}},success:function(response){window.location.reload();}});">
                                    <span class="glyphicon glyphicon-arrow-down"></span></button>
                                <button type="button" class="btn btn-danger"
                                        onclick="$.ajax({url:'${baseUrl}modules/${moduleStatus.index}?path=${requestScope.path}',method:'DELETE',success:function(response){window.location.reload();}});">
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
                      onsubmit="event.preventDefault();$.ajax({url:'${baseUrl}modules?path=${requestScope.path}',type:'POST',data:{id:$('#id').val(),description:$('#description').val(),comment:$('#comment').val(),datasource:$('#datasource').val(),databaseTable:$('#databaseTable').val(),databaseView:$('#databaseView').val(),jteeBeanAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1),jteeMaskAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1)+'Mask',jteeMapperAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1)+'Mapper',jteeServiceAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1)+'Service',jteeControllerBaseAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1)+'ControllerBase',jteeControllerPath:'api/'+$('#id').val()+'/',jteeAttachmentControllerPath:'api/'+$('#id').val()+'_attachment/',androidBeanAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1),androidMaskAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1)+'Mask',androidStubAlias:$('#id').val().substr(0,1).toUpperCase()+$('#id').val().substr(1)+'Stub'},success:function(response){window.location.reload();}});">
                    <div class="modal-header">
                        <button class="close" type="button" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="post_label">Add a New Model</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="id">ID</label>
                            <input class="form-control" id="id" type="text" pattern="^[A-Za-z_$]+[a-zA-Z0-9_$]*$"
                                   onchange="this.value=this.value.toLowerCase();"/>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <input class="form-control" id="description" type="text"/>
                        </div>
                        <div class="form-group">
                            <label for="comment">Comment</label>
                            <input class="form-control" id="comment" type="text"/>
                        </div>
                        <div class="form-group">
                            <label for="datasource">Data Source</label>
                            <select class="form-control" id="datasource">
                                <c:forEach items="${sessionScope.json.envJtee.datasources}" var="datasource">
                                    <option value="${datasource.id}">${datasource.id}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="databaseTable">Database Table</label>
                            <input class="form-control" id="databaseTable" type="text"/>
                        </div>
                        <div class="form-group">
                            <label for="databaseView">Database View</label>
                            <input class="form-control" id="databaseView" type="text"/>
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
