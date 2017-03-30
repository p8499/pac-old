package com.p8499.pac.controls;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;
import com.jayway.jsonpath.Configuration;
import com.p8499.pac.Util;
import jdk.internal.util.xml.impl.Input;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspContext;
import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

@Controller
@RequestMapping(value = "/json", produces = "application/json;charset=UTF-8")
public class Json {
    @RequestMapping(value = "", method = RequestMethod.GET, produces = "application/octet-stream;charset=UTF-8")
    public void get(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
        Map json = (Map) request.getSession().getAttribute("json");
        response.setHeader("Content-Disposition", "attachment; filename=" + json.get("name") + ".txt");
        OutputStreamWriter writer = new OutputStreamWriter(response.getOutputStream());
        writer.write(new ObjectMapper().writeValueAsString(json));
        writer.flush();
        writer.close();
    }

    @RequestMapping(value = "", method = RequestMethod.POST)
    public void set(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam MultipartFile file) throws IOException {
        session.setAttribute("json", Configuration.defaultConfiguration().jsonProvider().parse(new String(file.getBytes())));
    }

    @RequestMapping(value = "/check", method = RequestMethod.GET)
    public String check(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
        return "/_check.jsp";
    }

    @RequestMapping(value = "/build/db", method = RequestMethod.GET)
    public void buildDb(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
        File folder = new File(FileUtils.getTempDirectory(), String.valueOf(System.currentTimeMillis()));
        Map project = (Map) request.getSession().getAttribute("json");
        Map envJtee = (Map) project.get("envJtee");
        List<Map> datasources = (List) envJtee.get("datasources");
        for (int d = 0; d < datasources.size(); d++) {
            downloadSql(request, "db_tabl", d, folder, "", String.format("%s_db_tabl", datasources.get(d).get("id")));
            downloadSql(request, "db_func", d, folder, "", String.format("%s_db_func", datasources.get(d).get("id")));
            downloadSql(request, "db_view", d, folder, "", String.format("%s_db_view", datasources.get(d).get("id")));
        }
        File zip = zip(folder.listFiles(), new File(folder, envJtee.get("app") + "_db.zip"));
        response.setHeader("Content-Disposition", String.format("attachment; filename=%s", zip.getName()));
        response.setContentLength((int) zip.length());
        InputStream input = new FileInputStream(zip);
        OutputStream output = response.getOutputStream();
        StreamUtils.copy(input, output);
        input.close();
        output.close();
    }

    @RequestMapping(value = "/build/jtee", method = RequestMethod.GET)
    public void buildJtee(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException, FormatterException {
        File folder = new File(FileUtils.getTempDirectory(), String.valueOf(System.currentTimeMillis()));
        unzip(new File(request.getServletContext().getRealPath("jtee.zip")), folder);
        Map project = (Map) request.getSession().getAttribute("json");
        Map envJtee = (Map) project.get("envJtee");
        downloadGradle(request, "jtee_gradle", folder, "", "build");
        downloadXml(request, "jtee_web", new File(folder, "src/main/webapp/WEB-INF"), "", "web");
        downloadXml(request, "jtee_log4j2", new File(folder, "src/main/webapp/WEB-INF"), "", "log4j2");
        downloadXml(request, "jtee_context", new File(folder, "src/main/webapp/WEB-INF"), "", "springContext");
        downloadXml(request, "jtee_mybatisconfig", new File(folder, "src/main/webapp/WEB-INF"), "", "mybatis-config");
        downloadProperties(request, "jtee_properties", new File(folder, "src/main/webapp/WEB-INF"), "", "database");
        downloadJava(request, "base_jtee_filter", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "FilterExpr");
        downloadJava(request, "base_jtee_filter_logic", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "FilterLogicExpr");
        downloadJava(request, "base_jtee_filter_condition", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "FilterConditionExpr");
        downloadJava(request, "base_jtee_filter_operand", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "FilterOperandExpr");
        downloadJava(request, "base_jtee_filter_serializer", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "FilterSerializer");
        downloadJava(request, "base_jtee_filter_deserializer", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "FilterDeserializer");
        downloadJava(request, "base_jtee_orderby", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "OrderByExpr");
        downloadJava(request, "base_jtee_orderbylist", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "OrderByListExpr");
        downloadJava(request, "base_jtee_range", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "RangeExpr");
        downloadJava(request, "base_jtee_rangelist", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "RangeListExpr");
        downloadJava(request, "base_jtee_defaultdateformatter", new File(folder, "src/main/java"), (String) envJtee.get("packageBase"), "DefaultDateFormatter");
        List<Map> modules = (List<Map>) project.get("modules");
        for (int i = 0; i < modules.size(); i++) {
            downloadJava(request, "jtee_bean", i, new File(folder, "src/main/java"), (String) envJtee.get("packageBean"), (String) modules.get(i).get("jteeBeanAlias"));
            downloadJava(request, "jtee_mask", i, new File(folder, "src/main/java"), (String) envJtee.get("packageMask"), (String) modules.get(i).get("jteeMaskAlias"));
            downloadJava(request, "jtee_mapper", i, new File(folder, "src/main/java"), (String) envJtee.get("packageMapper") + "." + modules.get(i).get("datasource"), (String) modules.get(i).get("jteeMapperAlias"));
            downloadJava(request, "jtee_controllerbase", i, new File(folder, "src/main/java"), (String) envJtee.get("packageControllerBase"), (String) modules.get(i).get("jteeControllerBaseAlias"));
        }
        File zip = zip(folder.listFiles(), new File(folder, envJtee.get("app") + ".zip"));
        response.setHeader("Content-Disposition", String.format("attachment; filename=%s", zip.getName()));
        response.setContentLength((int) zip.length());
        InputStream input = new FileInputStream(zip);
        OutputStream output = response.getOutputStream();
        StreamUtils.copy(input, output);
        input.close();
        output.close();
    }

    @RequestMapping(value = "/build/android", method = RequestMethod.GET)
    public void buildAndroid(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException, FormatterException {
        File folder = new File(FileUtils.getTempDirectory(), String.valueOf(System.currentTimeMillis()));
        unzip(new File(request.getServletContext().getRealPath("android.zip")), folder);
        Map project = (Map) request.getSession().getAttribute("json");
        Map envAndroid = (Map) project.get("envAndroid");
        downloadXml(request, "android_manifest", new File(folder, "src/main"), "", "AndroidManifest");
        downloadXml(request, "android_strings", new File(folder, "src/main/res/values"), "", "strings");
        downloadXml(request, "android_constants", new File(folder, "src/main/res/values"), "", "constants");
        downloadJava(request, "base_android_filter", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "FilterExpr");
        downloadJava(request, "base_android_filter_logic", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "FilterLogicExpr");
        downloadJava(request, "base_android_filter_condition", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "FilterConditionExpr");
        downloadJava(request, "base_android_filter_operand", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "FilterOperandExpr");
        downloadJava(request, "base_android_filter_serializer", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "FilterSerializer");
        downloadJava(request, "base_android_filter_deserializer", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "FilterDeserializer");
        downloadJava(request, "base_android_orderby", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "OrderByExpr");
        downloadJava(request, "base_android_orderbylist", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "OrderByListExpr");
        downloadJava(request, "base_android_range", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "RangeExpr");
        downloadJava(request, "base_android_rangelist", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "RangeListExpr");
        downloadJava(request, "base_android_defaultdateformatter", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "DefaultDateFormatter");
        downloadJava(request, "base_android_retrofitfactory", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "RetrofitFactory");
        downloadJava(request, "base_android_cookiemanager", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "CookieManager");
        downloadJava(request, "base_android_persistentcookiestore", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "PersistentCookieStore");
        downloadJava(request, "base_android_serializablecookie", new File(folder, "src/main/java"), (String) envAndroid.get("packageBase"), "SerializableCookie");
        List<Map> modules = (List<Map>) project.get("modules");
        for (int i = 0; i < modules.size(); i++) {
            downloadJava(request, "android_bean", i, new File(folder, "src/main/java"), (String) envAndroid.get("packageBean"), (String) modules.get(i).get("androidBeanAlias"));
            downloadJava(request, "android_mask", i, new File(folder, "src/main/java"), (String) envAndroid.get("packageMask"), (String) modules.get(i).get("androidMaskAlias"));
            downloadJava(request, "android_view", i, new File(folder, "src/main/java"), (String) envAndroid.get("packageView"), (String) modules.get(i).get("androidBeanAlias") + "View");
            downloadJava(request, "android_listview", i, new File(folder, "src/main/java"), (String) envAndroid.get("packageView"), (String) modules.get(i).get("androidBeanAlias") + "ListView");
            downloadJava(request, "android_stub", i, new File(folder, "src/main/java"), (String) envAndroid.get("packageStub"), (String) modules.get(i).get("androidStubAlias"));
        }
        File zip = zip(folder.listFiles(), new File(folder, envAndroid.get("app") + ".zip"));
        response.setHeader("Content-Disposition", String.format("attachment; filename=%s", zip.getName()));
        response.setContentLength((int) zip.length());
        InputStream input = new FileInputStream(zip);
        OutputStream output = response.getOutputStream();
        StreamUtils.copy(input, output);
        input.close();
        output.close();
    }

    private static void downloadProperties(HttpServletRequest request, String template, File folder, String pkg, String name) throws IOException {
        String strUrl = String.format("%s://%s:%d%s/%s", request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath(), template);
        File file = new File(new File(folder, pkg.replace(".", "/")), name + ".properties");
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        FileUtils.writeStringToFile(file, fetch(new URL(strUrl), request.getHeader("Cookie")).trim(), "UTF-8");
    }

    private static void downloadBat(HttpServletRequest request, String template, File folder, String pkg, String name) throws IOException {
        String strUrl = String.format("%s://%s:%d%s/%s", request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath(), template);
        File file = new File(new File(folder, pkg.replace(".", "/")), name + ".bat");
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        FileUtils.writeStringToFile(file, fetch(new URL(strUrl), request.getHeader("Cookie")).trim(), "UTF-8");
    }

    private static void downloadGradle(HttpServletRequest request, String template, File folder, String pkg, String name) throws IOException {
        String strUrl = String.format("%s://%s:%d%s/%s", request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath(), template);
        File file = new File(new File(folder, pkg.replace(".", "/")), name + ".gradle");
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        FileUtils.writeStringToFile(file, fetch(new URL(strUrl), request.getHeader("Cookie")).trim(), "UTF-8");
    }

    private static void downloadSql(HttpServletRequest request, String template, Integer d, File folder, String pkg, String name) throws IOException {
        String strUrl = String.format("%s://%s:%d%s/%s/%d", request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath(), template, d);
        File file = new File(new File(folder, pkg.replace(".", "/")), name + ".sql");
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        FileUtils.writeStringToFile(file, fetch(new URL(strUrl), request.getHeader("Cookie")).trim(), "UTF-8");
    }

    private static void downloadXml(HttpServletRequest request, String template, File folder, String pkg, String name) throws IOException, FormatterException {
        String strUrl = String.format("%s://%s:%d%s/%s", request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath(), template);
        File file = new File(new File(folder, pkg.replace(".", "/")), name + ".xml");
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        FileUtils.writeStringToFile(file, fetch(new URL(strUrl), request.getHeader("Cookie")).trim(), "UTF-8");
    }

    private static void downloadJava(HttpServletRequest request, String template, File folder, String pkg, String name) throws IOException, FormatterException {
        String strUrl = String.format("%s://%s:%d%s/%s", request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath(), template);
        File file = new File(new File(folder, pkg.replace(".", "/")), name + ".java");
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        FileUtils.writeStringToFile(file, new Formatter().formatSource(fetch(new URL(strUrl), request.getHeader("Cookie")).trim()), "UTF-8");
    }

    private static void downloadJava(HttpServletRequest request, String template, Integer i, File folder, String pkg, String name) throws IOException, FormatterException {
        String strUrl = String.format("%s://%s:%d%s/%s/%d", request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath(), template, i);
        File file = new File(new File(folder, pkg.replace(".", "/")), name + ".java");
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        FileUtils.writeStringToFile(file, new Formatter().formatSource(fetch(new URL(strUrl), request.getHeader("Cookie")).trim()), "UTF-8");
    }

    private static String fetch(URL url, String cookie) throws IOException {
        URLConnection conn = url.openConnection();
        conn.setRequestProperty("Cookie", cookie);
        InputStream input = conn.getInputStream();
        String s = StreamUtils.copyToString(input, Charset.forName("UTF-8"));
        input.close();
        return s;
    }

    private static File zip(File[] sources, File target) throws IOException {
        ZipOutputStream output = new ZipOutputStream(new FileOutputStream(target));
        for (File source : sources) {
            recvZip("", source, output);
        }
        output.close();
        return target;
    }

    private static void recvZip(String path, File source, ZipOutputStream output) throws IOException {
        if (source.isDirectory()) {
            for (File f : source.listFiles())
                recvZip(path + source.getName() + File.separator, f, output);
        } else {
            output.putNextEntry(new ZipEntry(path + source.getName()));
            InputStream input = new FileInputStream(source);
            StreamUtils.copy(input, output);
            input.close();
        }
    }

    private static File unzip(File source, File folder) throws IOException {
        ZipInputStream input = new ZipInputStream(new FileInputStream(source));
        ZipEntry entry;
        while ((entry = input.getNextEntry()) != null) {
            File file = new File(folder, entry.getName());
            if (entry.isDirectory()) {
                if (!file.exists())
                    file.mkdirs();
            } else {
                File parent = file.getParentFile();
                if (!parent.exists())
                    parent.mkdirs();
                OutputStream output = new FileOutputStream(file);
                StreamUtils.copy(input, output);
                output.close();
            }
        }
        input.close();
        return folder;
    }
}
