package com.p8499.pac;

import com.jayway.jsonpath.JsonPath;
import net.minidev.json.JSONArray;

import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.*;

/**
 * Created by Administrator on 12/29/2016.
 */
public class Util {
    public static void println(Object obj) {
        System.out.println(obj);
    }

    public static String id(String path) {
        int tol = path.lastIndexOf("[");
        int tor = path.lastIndexOf("]");
        int to2 = path.lastIndexOf(".");
        return to2 > tol ? path.substring(to2 + 1) : path.substring(tol + 1, tor);
    }

    public static boolean indexed(String path) {
        return path.lastIndexOf("[") > path.lastIndexOf(".");
    }

    public static String parent(String path) {
        int to1 = path.lastIndexOf("[");
        int to2 = path.lastIndexOf(".");
        return path.substring(0, to1 > to2 ? to1 : to2);
    }

    public static String[] routes(String path) {
        List<String> rt = new ArrayList<>();
        while (!path.equals("$")) {
            rt.add(0, path);
            path = parent(path);
        }
        rt.add(0, "$");
        return rt.toArray(new String[]{});
    }

    public static String alias(String table) {
        int dot = table.indexOf(".");
        return dot > -1 ? table.substring(dot + 1) : table;
    }

    public static Object read(Object doc, String path) {
        return JsonPath.read(doc, path);
    }

    public static String join(String d, Object s) {
        if (s == null)
            return null;
        if (s.getClass().isArray())
            return String.join(d, (CharSequence[]) s);
        else if (s instanceof List)
            return String.join(d, ((List<String>) s).toArray(new String[((List<String>) s).size()]));
        else
            return null;
    }

    public static Object extract(String params, String param) throws UnsupportedEncodingException {
        List<String> rt = new ArrayList<>();
        String[] ps = params.split("&");
        for (String p : ps) {
            String[] lr = p.split("=");
            if (lr[0].equals(param))
                rt.add(lr.length == 2 ? URLDecoder.decode(lr[1], "UTF-8") : "");
        }
        return rt.size() == 0 ? null : rt.size() == 1 ? rt.get(0) : rt.toArray(new String[]{});
    }

    public static void swap(List list, int i, int j) {
        Object oj = list.get(j);
        list.remove(j);
        list.add(i, oj);
    }

    public static String wrap(String[] elements) {
        String[] results = new String[elements.length];
        for (int i = 0; i < elements.length; i++)
            results[i] = (String.format("\"%s\"", elements[i]));
        return "[" + String.join(",", results) + "]";
    }

    public static Object lowerFirst(Object s) {
        if (s instanceof String)
            return _lowerFirst((String) s);
        if (s instanceof String[])
            return _lowerFirstByArray((String[]) s);
        else if (s instanceof Collection)
            return _lowerFirstByCollection((Collection<String>) s);
        else
            return null;
    }

    private static String _lowerFirst(String s) {
        if (Character.isLowerCase(s.charAt(0)))
            return s;
        else
            return (new StringBuilder()).append(Character.toLowerCase(s.charAt(0))).append(s.substring(1)).toString();
    }

    private static String[] _lowerFirstByArray(String[] s) {
        String[] result = new String[s.length];
        for (int i = 0; i < result.length; i++)
            result[i] = _lowerFirst(s[i]);
        return result;
    }

    private static List<String> _lowerFirstByCollection(Collection<String> s) {
        return Arrays.asList(_lowerFirstByArray(s.toArray(new String[s.size()])));
    }

    public static Object upperFirst(Object s) {
        if (s instanceof String)
            return _upperFirst((String) s);
        else if (s instanceof String[])
            return _upperFirstByArray((String[]) s);
        else if (s instanceof Collection)
            return _upperFirstByCollection((Collection<String>) s);
        else
            return null;
    }

    private static String _upperFirst(String s) {
        if (Character.isUpperCase(s.charAt(0)))
            return s;
        else
            return (new StringBuilder()).append(Character.toUpperCase(s.charAt(0))).append(s.substring(1)).toString();
    }

    private static String[] _upperFirstByArray(String[] s) {
        String[] result = new String[s.length];
        for (int i = 0; i < result.length; i++)
            result[i] = _upperFirst(s[i]);
        return result;
    }

    private static List<String> _upperFirstByCollection(Collection<String> s) {
        return Arrays.asList(_upperFirstByArray(s.toArray(new String[s.size()])));
    }

    public static Object upper(Object s) {
        if (s instanceof String)
            return _upper((String) s);
        else if (s instanceof String[])
            return _upperByArray((String[]) s);
        else if (s instanceof Collection)
            return _upperByCollection((Collection<String>) s);
        else
            return null;
    }

    private static String _upper(String s) {
        return s.toUpperCase();
    }

    private static String[] _upperByArray(String[] s) {
        String[] result = new String[s.length];
        for (int i = 0; i < result.length; i++) {
            result[i] = _upper(s[i]);
        }
        return result;
    }

    private static List<String> _upperByCollection(Collection<String> s) {
        return Arrays.asList(_upperByArray(s.toArray(new String[s.size()])));
    }

    public static Object lower(Object s) {
        if (s instanceof String)
            return _lower((String) s);
        else if (s instanceof String[])
            return _lowerByArray((String[]) s);
        else if (s instanceof Collection)
            return _lowerByCollection((Collection<String>) s);
        else
            return null;
    }

    private static String _lower(String s) {
        return s.toLowerCase();
    }

    private static String[] _lowerByArray(String[] s) {
        String[] result = new String[s.length];
        for (int i = 0; i < result.length; i++) {
            result[i] = _lower(s[i]);
        }
        return result;
    }

    private static List<String> _lowerByCollection(Collection<String> s) {
        return Arrays.asList(_lowerByArray(s.toArray(new String[s.size()])));
    }

    public static Map newMap() {
        return new HashMap();
    }

    public static List newList() {
        return new ArrayList();
    }

    public static String gmt() {
        return "GMT" + String.format("%+d", Integer.valueOf(Calendar.getInstance().getTimeZone().getRawOffset() / 3600000));
    }

    public static void n(Object o) {

    }
}
