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
                <a href="/project?path=${pac:parent(requestScope.path)}">${pac:read(sessionScope.json,pac:parent(requestScope.path)).name}</a>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    J2EE Environment
                    <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                    <li class="active">
                        <a href="/envJtee?path=${requestScope.path}">
                            J2EE Environment</a>
                    </li>
                    <li>
                        <a href="/envAndroid?path=${pac:parent(requestScope.path)}.envAndroid">
                            Android Environment</a>
                    </li>
                    <li>
                        <a href="/modules?path=${pac:parent(requestScope.path)}.modules">
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
                    <form data-toggle="validator"
                          onsubmit="event.preventDefault();$.ajax({url:'/envJtee?path=${requestScope.path}',type:'PUT',data:{app:$('#app').val(),baseUrl:$('#baseUrl').val(),packageBase:$('#packageBase').val(),packageBean:$('#packageBean').val(),packageMask:$('#packageMask').val(),packageMapper:$('#packageMapper').val(),packageConfigurator:$('#packageConfigurator').val(),packageController:$('#packageController').val(),packageControllerAttachment:$('#packageControllerAttachment').val()},success:function(response){window.location.reload();}});">
                        <div class="form-group">
                            <label for="app">App</label>
                            <input class="form-control" id="app" type="text" pattern="^[A-Za-z0-9_]+$"
                                   value="${requestScope.target.app}"/>
                        </div>
                        <div class="form-group">
                            <label for="baseUrl">Base URL</label>
                            <input class="form-control" id="baseUrl" type="text"
                                   value="${requestScope.target.baseUrl}"
                                   onchange="if(this.value.length>0&&this.value.substring(this.value.length-1)!='/')this.value=this.value+'/';"/>
                        </div>
                        <div class="form-group">
                            <label for="packageBase">Package Base</label>
                            <input class="form-control" id="packageBase" type="text"
                                   pattern="^([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)$"
                                   value="${requestScope.target.packageBase}"/>
                        </div>
                        <div class="form-group">
                            <label for="packageBean">Package Bean</label>
                            <input class="form-control" id="packageBean" type="text"
                                   pattern="^([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)$"
                                   value="${requestScope.target.packageBean}"/>
                        </div>
                        <div class="form-group">
                            <label for="packageMask">Package Mask</label>
                            <input class="form-control" id="packageMask" type="text"
                                   pattern="^([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)$"
                                   value="${requestScope.target.packageMask}"/>
                        </div>
                        <div class="form-group">
                            <label for="packageMapper">Package Mapper</label>
                            <input class="form-control" id="packageMapper" type="text"
                                   pattern="^([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)$"
                                   value="${requestScope.target.packageMapper}"/>
                        </div>
                        <div class="form-group">
                            <label for="packageConfigurator">Package Configurator</label>
                            <input class="form-control" id="packageConfigurator" type="text"
                                   pattern="^([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)$"
                                   value="${requestScope.target.packageConfigurator}"/>
                        </div>
                        <div class="form-group">
                            <label for="packageController">Package Controller</label>
                            <input class="form-control" id="packageController" type="text"
                                   pattern="^([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)$"
                                   value="${requestScope.target.packageController}"/>
                        </div>
                        <div class="form-group">
                            <label for="packageControllerAttachment">Package Controller Attachment</label>
                            <input class="form-control" id="packageControllerAttachment"
                                   type="text" pattern="^([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)$"
                                   value="${requestScope.target.packageControllerAttachment}"/>
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
