package com.faster.slt;

import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URL;
import java.net.URLConnection;

/**
 *
 * @author HMQ
 */
@WebServlet(name = "UploadImg", urlPatterns = {"/gateway/UploadImg"})
public class UploadImg extends XCosProcServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("access-control-allow-headers", "x-requested-with,content-type");
        response.setHeader("access-control-allow-methods", "OPTIONS,POST");
        response.setHeader("access-control-allow-origin", "*");
        URLConnection conn;
        //获取配置的上传文件路径
        RecordSet<Record> rs = HSF.query("select cfgkey,itemval from t_sys_config where cfgkey='defupservice'");
        String uploadUrl = "";
        if(rs.next()) {
            uploadUrl = rs.getString("itemval");
//            uploadUrl = uploadUrl.replace("https","http");
            try (
                //1.获取URLConnection对象对应的输出流
                ServletInputStream in = request.getInputStream()) {
                URL realUrl = new URL(uploadUrl);
                // 打开和URL之间的连接
                conn = realUrl.openConnection();
                // 设置通用的请求属性
                conn.setRequestProperty("accept", "*/*");
                conn.setRequestProperty("connection", "Keep-Alive");
                conn.setRequestProperty("content-type", request.getHeader("Content-Type"));
                conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
                // 发送POST请求必须设置如下两行
                conn.setDoOutput(true);
                conn.setDoInput(true);
                try ( //1.获取URLConnection对象对应的输出流
                      OutputStream os = conn.getOutputStream()) {
                    byte[] buff = new byte[4096];
                    int pos;
                    while ((pos = in.read(buff)) != -1) {
                        os.write(buff, 0, pos);
                    }
                }
            }
            try {
                BufferedReader bin = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                PrintWriter pw = response.getWriter();
                String line;
                while ((line = bin.readLine()) != null) {
                    pw.print(line);
                }
                pw.close();
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }
}
