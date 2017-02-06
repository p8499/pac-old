<%--@formatter:off--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
cd %~dp0
psql -U postgres -c "CREATE DATABASE ${sessionScope.json.envJtee.app}"
psql -U postgres -d ${sessionScope.json.envJtee.app} -f ./db_tabl.sql
set /p db_func=Please enter function file, for example db_func.sql:
psql -U postgres -d ${sessionScope.json.envJtee.app} -f ./%db_func%
psql -U postgres -d ${sessionScope.json.envJtee.app} -f ./db_view.sql
pause