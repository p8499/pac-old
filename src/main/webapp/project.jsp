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
                <a href="/project?path=${requestScope.path}">${target.name}</a>
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
                    <form onsubmit="event.preventDefault();$.ajax({url:'/project?path=${requestScope.path}',type:'PUT',data:{name:$('#name').val()},success:function(response){window.location.reload();}});">
                        <div class="form-group">
                            <label for="name">Name</label>
                            <input class="form-control" id="name" type="text" value="${requestScope.target.name}"/>
                        </div>
                        <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-ok"></span> Save
                        </button>
                    </form>
                    <button class="btn btn-link" type="button">
                        <a href="/envJtee?path=${requestScope.path}.envJtee">J2EE Environment</a>
                    </button>
                    <button class="btn btn-link" type="button">
                        <a href="/envAndroid?path=${requestScope.path}.envAndroid">Android Environment</a>
                    </button>
                    <button class="btn btn-link" type="button">
                        <a href="/modules?path=${requestScope.path}.modules">Modules</a>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
