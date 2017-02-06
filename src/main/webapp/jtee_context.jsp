<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:task="http://www.springframework.org/schema/task"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task-3.0.xsd">
    <context:property-placeholder location="WEB-INF/*.properties"/>
    <bean id="validatorFactory" class="org.springframework.validation.beanvalidation.LocalValidatorFactoryBean">
        <property name="providerClass" value="org.hibernate.validator.HibernateValidator"/>
    </bean>
    <bean id="jackson" class="com.fasterxml.jackson.databind.ObjectMapper"/>
<c:forEach items="${sessionScope.json.envJtee.datasources}" var="datasource">
    <bean id="${datasource.id}" class="org.apache.commons.dbcp2.BasicDataSource" destroy-method="close">
        <property name="driverClassName" value="${String.format("${%s.driverClassName}",datasource.id)}"/>
        <property name="url" value="${String.format("${%s.url}",datasource.id)}"/>
        <property name="username" value="${String.format("${%s.username}",datasource.id)}"/>
        <property name="password" value="${String.format("${%s.password}",datasource.id)}"/>
    </bean>
    <bean id="${datasource.id}_factory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="${datasource.id}"/>
        <property name="configLocation" value="WEB-INF/mybatis-config.xml"/>
    </bean>
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <property name="basePackage" value="${sessionScope.json.envJtee.packageMapper}.${datasource.id}"/>
        <property name="sqlSessionFactoryBeanName" value="${datasource.id}_factory"/>
    </bean></c:forEach>
    <%--<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver"--%>
          <%--p:defaultEncoding="UTF-8" p:maxUploadSize="5400000"/>--%>
    <context:component-scan base-package="${sessionScope.json.envJtee.packageBase}">
        <context:exclude-filter type="regex" expression="${sessionScope.json.envJtee.packageMapper}.*"/>
    </context:component-scan>
    <mvc:annotation-driven enable-matrix-variables="true"/>
</beans>
