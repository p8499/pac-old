<%--@formatter:off--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pac" uri="/WEB-INF/pac.tld" %>
<pac:java>
package ${sessionScope.json.envAndroid.packageBase};

import android.content.Context;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jakewharton.retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

public class RetrofitFactory {
    private static OkHttpClient okHttpClient;
    private static Retrofit retrofit;
    private static ObjectMapper objectMapper;

    public static OkHttpClient getOkHttpClient(Context context) {
        if (okHttpClient == null) {
            HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
            logging.setLevel(HttpLoggingInterceptor.Level.BODY);
            okHttpClient = new OkHttpClient.Builder().cookieJar(new CookieManager(context)).addInterceptor(logging).build();
        }
        return okHttpClient;
    }

    public static Retrofit getInstance(Context context) {
        if (retrofit == null)
            retrofit =
                    new Retrofit.Builder()
                            .baseUrl("${sessionScope.json.envJtee.baseUrl}")
                            .addConverterFactory(JacksonConverterFactory.create(getObjectMapper()))
                            .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                            .client(getOkHttpClient(context))
                            .build();
        return retrofit;
    }

    public static ObjectMapper getObjectMapper() {
        if (objectMapper == null) objectMapper = new ObjectMapper();
        return objectMapper;
    }
}
</pac:java>