<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<?xml version="1.0" encoding="UTF-8"?>
<beans:beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xmlns:beans="http://www.springframework.org/schema/beans"
             xmlns:context="http://www.springframework.org/schema/context"
             xmlns:mvc="http://www.springframework.org/schema/mvc"
             xmlns:task="http://www.springframework.org/schema/task"
             xmlns:tx="http://www.springframework.org/schema/tx"
             xsi:schemaLocation="
       http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
       http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.3.xsd
       http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.3.xsd
       http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task-4.3.xsd
       http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.3.xsd">
    <context:property-placeholder location="WEB-INF/*.properties"/>
    <beans:bean id="validatorFactory" class="org.springframework.validation.beanvalidation.LocalValidatorFactoryBean">
        <beans:property name="providerClass" value="org.hibernate.validator.HibernateValidator"/>
    </beans:bean>
    <beans:bean id="jackson" class="com.fasterxml.jackson.databind.ObjectMapper"/>
    <c:forEach items="${sessionScope.json.envJtee.datasources}" var="datasource">
        <beans:bean id="${datasource.id}" class="org.apache.commons.dbcp2.BasicDataSource" destroy-method="close">
            <beans:property name="driverClassName" value="${String.format("${%s.driverClassName}",datasource.id)}"/>
            <beans:property name="url" value="${String.format("${%s.url}",datasource.id)}"/>
            <beans:property name="username" value="${String.format("${%s.username}",datasource.id)}"/>
            <beans:property name="password" value="${String.format("${%s.password}",datasource.id)}"/>
        </beans:bean>
        <beans:bean id="${datasource.id}_factory" class="org.mybatis.spring.SqlSessionFactoryBean">
            <beans:property name="dataSource" ref="${datasource.id}"/>
            <beans:property name="configLocation" value="WEB-INF/mybatis-config.xml"/>
        </beans:bean>
        <beans:bean id="${datasource.id}_transaction" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
            <beans:property name="dataSource" ref="${datasource.id}"/>
        </beans:bean>
        <beans:bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
            <beans:property name="basePackage" value="${sessionScope.json.envJtee.packageMapper}.${datasource.id}"/>
            <beans:property name="sqlSessionFactoryBeanName" value="${datasource.id}_factory"/>
        </beans:bean>
        <tx:annotation-driven transaction-manager="${datasource.id}_transaction"/>
    </c:forEach>
    <context:component-scan base-package="${sessionScope.json.envJtee.packageBase}">
        <context:exclude-filter type="regex" expression="${sessionScope.json.envJtee.packageMapper}.*"/>
    </context:component-scan>
    <mvc:annotation-driven enable-matrix-variables="true"/>
    <task:executor id="executor" pool-size="3"/>
    <task:scheduler id="scheduler" pool-size="3"/>
    <task:annotation-driven scheduler="scheduler" executor="executor"/>
</beans:beans>
</beans>
