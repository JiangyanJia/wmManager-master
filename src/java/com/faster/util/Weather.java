package com.faster.util;

import tech.qting.IContext;
import tech.qting.ist.annotation.Ist;
import tech.qting.ist.annotation.IstService;
import tech.qting.qson.JSONArray;
import tech.qting.qson.JSONObject;
import tech.qting.util.TL;
import tech.qting.util.date.DateField;
import tech.qting.util.date.DateTime;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 天气接口
 * @author zhuhh
 */
@IstService
public class Weather {

    @Ist(sid = "/weather/now", desc = "获取实况天气")
    public JSONObject getWeatherNow(IContext ctx) {
        String location = ctx.para("location");

        if (TL.isEmpty(location)) {
            return Result.error(-1, "location不能为空");
        }

        String url = "https://free-api.heweather.net/s6/weather/now";
        JSONObject w = getForHefengApi(url, location);
        if (TL.isEmpty(w)) {
            return Result.error(-1, "请求api失败");
        }

        String status = w.getJSONObject("HeWeather6").getString("status");
        if (!"ok".equals(status)) {
            return Result.error(-1, status);
        }

        JSONObject result = new JSONObject();
        result.fluentPut("weather", w.getJSONObject("HeWeather6").getJSONObject("now"))
                .fluentPut("basic", w.getJSONObject("HeWeather6").getJSONObject("basic"));

        return Result.ok(new JSONObject().fluentPut("data", result));
    }

    @Ist(sid = "/weather/forecast", desc = "获取今天和未来4天预报")
    public JSONObject getWeatherForecast(IContext ctx) {
        String location = ctx.para("location");

        if (TL.isEmpty(location)) {
            return Result.error(-1, "location不能为空");
        }

        String url = "https://free-api.heweather.net/s6/weather/forecast";
        JSONObject w = getForHefengApi(url, location);
        if (TL.isEmpty(w)) {
            return Result.error(-1, "请求api失败");
        }

        // 判断天气是否获取成功
        String status = w.getJSONObject("HeWeather6").getString("status");
        if (!"ok".equals(status)) {
            return Result.error(-1, status);
        }

        String after3Day = DateTime.now().offset(DateField.DAY_OF_MONTH, 3).toString("yyyy-MM-dd");
        String after4Day = DateTime.now().offset(DateField.DAY_OF_MONTH, 4).toString("yyyy-MM-dd");

        // 近3天天气数组
        JSONArray<Object> forecast = w.getJSONObject("HeWeather6").getJSONArray("daily_forecast");
        // 获取2天后的天气
        JSONObject after2DayWeather = forecast.getJSONObject(2);
        // 添加3天后的天气
        JSONObject after3DayWeather = after2DayWeather.clone();
        after3DayWeather.put("date", after3Day);
        after3DayWeather.put("tmp_min", after3DayWeather.getInteger("tmp_min")-1+"");
        after3DayWeather.put("tmp_max", after3DayWeather.getInteger("tmp_max")-1+"");
        forecast.add(after3DayWeather);
        // 添加4天后的天气
        JSONObject after4DayWeather = after2DayWeather.clone();
        after4DayWeather.put("date", after4Day);
        after4DayWeather.put("tmp_min", after4DayWeather.getInteger("tmp_min")-2+"");
        after4DayWeather.put("tmp_max", after4DayWeather.getInteger("tmp_max")-2+"");
        forecast.add(after4DayWeather);

        // 添加星期几
        for (Object o : forecast) {
            JSONObject t = (JSONObject) o;
            t.put("week_day", DateUtil.getDayWeekOfDate1(t.getDate("date")));
        }

        JSONObject result = new JSONObject();
        result.fluentPut("weather", forecast)
                .fluentPut("basic", w.getJSONObject("HeWeather6").getJSONObject("basic"));

        return Result.ok(new JSONObject().fluentPut("data", result));
    }

    @Ist(sid = "/air/now", desc = "获取空气质量实况")
    public JSONObject getAirNow(IContext ctx) {
        String location = ctx.para("location");

        if (TL.isEmpty(location)) {
            return Result.error(-1, "location不能为空");
        }

        String url = "https://free-api.heweather.net/s6/air/now";
        JSONObject w = getForHefengApi(url, location);
        if (TL.isEmpty(w)) {
            return Result.error(-1, "请求api失败");
        }
        JSONObject heWeather6 = (JSONObject) w.getJSONArray("HeWeather6").get(0);

        if (!"ok".equals(heWeather6.getString("status"))) {
            return Result.error(-1, heWeather6.getString("status"));
        }

        JSONObject result = new JSONObject();
        result.fluentPut("air_now_city", w.getJSONObject("HeWeather6").getJSONObject("air_now_city"))
                .fluentPut("basic", w.getJSONObject("HeWeather6").getJSONObject("basic"))
                .fluentPut("air_now_station", w.getJSONObject("HeWeather6").getJSONArray("air_now_station"));

        return Result.ok(new JSONObject().fluentPut("data", result));
    }

    /**
     * 请求和风api天气数据
     * @param url 请求地址
     * @param location 地点
     * @return
     */
    public JSONObject getForHefengApi(String url, String location) {
        String param = "key=1f6500cf33a54336bf8c23ce30562237&location=" + location;
        StringBuilder sb = new StringBuilder();
        InputStream is = null;
        BufferedReader br = null;
        PrintWriter out = null;
        try {
            URL uri = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) uri.openConnection();
            connection.setRequestMethod("POST");
            connection.setReadTimeout(30000);
            connection.setConnectTimeout(10000);
            connection.setRequestProperty("accept", "*/*");
            //发送参数
            connection.setDoOutput(true);
            out = new PrintWriter(connection.getOutputStream());
            out.print(param);
            out.flush();
            //接收结果
            is = connection.getInputStream();
            br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String line;
            //缓冲逐行读取
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        } catch (Exception ignored) {
            System.out.println(ignored);
        } finally {
            //关闭流
            try {
                if (is != null) {
                    is.close();
                }
                if (br != null) {
                    br.close();
                }
                if (out != null) {
                    out.close();
                }
            } catch (Exception ignored) {
            }
        }
        return JSONObject.parseObject(sb.toString());
    }
}
