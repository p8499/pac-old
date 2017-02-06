<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
apply plugin: 'war'

repositories {
mavenCentral()
}

dependencies {
compile 'javax.servlet:javax.servlet-api:3.1.0'
compile 'org.apache.logging.log4j:log4j-web:2.7'

compile 'commons-fileupload:commons-fileupload:1.3.2'
compile 'commons-httpclient:commons-httpclient:3.1'
compile 'org.apache.commons:commons-dbcp2:2.1.1'
<c:if test="${pac:read(sessionScope.json.envJtee,\"$.datasources[?(@.databaseType=='postgresql')]\").size()>0}">
compile 'org.postgresql:postgresql:9.4.1209'</c:if><c:if test="${pac:read(sessionScope.json.envJtee,\"$.datasources[?(@.databaseType=='oracle')]\").size()>0}">
compile files('ojdbc6.jar')</c:if><c:if test="${pac:read(sessionScope.json.envJtee,\"$.datasources[?(@.databaseType=='mysql')]\").size()>0}">
compile 'mysql:mysql-connector-java:6.0.5'
</c:if>
compile 'org.mybatis:mybatis:3.4.1'
compile 'org.mybatis:mybatis-spring:1.3.0'
compile 'org.hibernate:hibernate-validator:5.2.4.Final'
compile 'com.fasterxml.jackson.core:jackson-databind:2.8.1'

compile 'org.springframework:spring-webmvc:4.3.2.RELEASE'
compile 'org.springframework:spring-jdbc:4.3.2.RELEASE'

}
