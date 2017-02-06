<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<?xml version="1.0" encoding="UTF-8"?>
<configuration status="error">
    <appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <ThresholdFilter level="trace" onMatch="ACCEPT" onMismatch="DENY"/>
            <PatternLayout pattern="%d{HH:mm:ss.SSS} %-5level %class{36} %L %M - %msg%xEx%n"/>
        </Console>
        <RollingFile name="RollingFile" fileName="${"${web:rootDir}"}/WEB-INF/logs/app.log"
                     filePattern="${"${web:rootDir}"}/WEB-INF/logs/${"${date:yyyy-MM}"}/app-%d{MM-dd-yyyy}-%i.log.gz">
            <PatternLayout pattern="%d{yyyy.MM.dd 'at' HH:mm:ss z} %-5level %class{36} %L %M - %msg%xEx%n"/>
            <SizeBasedTriggeringPolicy size="500 MB"/>
        </RollingFile>
    </appenders>
    <loggers>
        <root level="trace">
            <appender-ref ref="RollingFile"/>
            <appender-ref ref="Console"/>
        </root>
        <c:forEach items="${sessionScope.json.envJtee.datasources}" var="datasource">
            <logger name="${sessionScope.json.envJtee.packageMapper}.${datasource.id}" level="TRACE" additivity="false">
                <appender-ref ref="RollingFile"/>
                <appender-ref ref="Console"/>
            </logger></c:forEach>
    </loggers>
</configuration>