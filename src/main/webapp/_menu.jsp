<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<ul class="nav nav-pills pull-right">
    <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Build Project
            <span class="caret"></span></a>
        <ul class="dropdown-menu">
            <li>
                <a href="#"
                   onclick="event.preventDefault();$.get({url:'/json/check',success:function(response){$('#check').modal('show');$('#check_span').text(response);}});">
                    Check</a></li>
            <li>
                <a href="/json/build/db">Download Database Scripts (Future)</a>
            </li>
            <li>
                <a href="/json/build/jtee">Download J2EE Project</a>
            </li>
            <li>
                <a href="/json/build/android">Download Android Project</a>
            </li>
        </ul>
    </li>
    <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Source
            <span class="caret"></span></a>
        <ul class="dropdown-menu">
            <li>
                <a href="/json">Download</a></li>
            <li>
                <a href="#" data-toggle="modal" data-target="#upload">Upload</a></li>
        </ul>
    </li>
</ul>
<div class="modal fade" id="upload" aria-labelledby="upload_label" aria-hidden="true" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="upload_form" enctype="multipart/form-data"
                  onsubmit="event.preventDefault();$('#upload_form').ajaxSubmit({type: 'POST',url:'/json',success:function(response){window.location='/project';}});">
                <div class="modal-header">
                    <button class="close" type="button" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="upload_label">Upload JSON Code</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="file">File</label>
                        <input class="form-control" id="file" name="file" type="file"/>
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
<div class="modal fade" id="check" aria-labelledby="check_label" aria-hidden="true" tabindex="-2">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button class="close" type="button" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="check_label">Check Project</h4>
            </div>
            <div class="modal-body">
                <span id="check_span"></span>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default" type="button" data-dismiss="modal">
                    <span class="glyphicon glyphicon-remove"></span> Close
                </button>
            </div>
        </div>
    </div>
</div>
