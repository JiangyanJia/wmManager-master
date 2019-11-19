package com.faster.slt;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import tech.qting.DefaultContext;
import tech.qting.IContext;
import tech.qting.bcore.sdb.ISdb;
import tech.qting.cache.ICache;
import tech.qting.cache.SimpleCache;
import tech.qting.mcore.Conf;
import tech.qting.qson.JSON;
import tech.qting.qson.JSONArray;
import tech.qting.qson.JSONObject;
import tech.qting.util.TL;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLEncoder;
import java.util.Enumeration;

public class ServletContext extends DefaultContext {
    private final HttpServletRequest req;
    private final HttpServletResponse rsp;
    private final HttpSession session;
    private static final SimpleCache<String, Object> CTX_CACHE = new SimpleCache();
    protected static final Logger LOG = LogManager.getLogger();
    private final String[] uriVals;

    public ServletContext(HttpServletRequest req, HttpServletResponse rsp) {
        this.req = req;
        this.session = req.getSession();
        this.rsp = rsp;
        this.uriVals = (req.getServletPath() + req.getPathInfo()).split("/");
    }

    public HttpServletRequest req() {
        return req;
    }

    public HttpServletResponse rsp() {
        return rsp;
    }

    public String method() {
        return this.req.getMethod();
    }

    public String body() {
        StringBuilder sb = new StringBuilder();

        try {
            this.req.getReader().lines().forEach((t) -> {
                sb.append(t);
            });
        } catch (IOException var3) {
            LOG.warn("read request body stream error. 「{}」", var3.getMessage());
        }

        return sb.toString();
    }

    public String cookie(String name) {
        Cookie[] var2 = this.req.getCookies();
        int var3 = var2.length;

        for(int var4 = 0; var4 < var3; ++var4) {
            Cookie ck = var2[var4];
            if (name.equalsIgnoreCase(ck.getName())) {
                return ck.getValue();
            }
        }

        return null;
    }

    public IContext cookie(String name, String value, String domain, long maxAge) {
        if (TL.isEmpty(new Object[]{name, value})) {
            throw new RuntimeException("");
        } else {
            Cookie ck = new Cookie(name, value);
            if (TL.isNotEmpty(new Object[]{domain})) {
                ck.setDomain(domain);
            }

            if (maxAge > -1L) {
                ck.setMaxAge((int)maxAge);
            }

            this.rsp.addCookie(ck);
            return this;
        }
    }

    public Object attr(String name, Scope scope) {
        if (scope == Scope.Method) {
            return this.req.getMethod();
        } else if (name != null && scope != null) {
            switch(scope) {
                case Request:
                    return this.req.getAttribute(name);
                case Session:
                    return this.req.getSession().getAttribute(name);
                case Context:
                    return CTX_CACHE.get(name);
                case Header:
                    return this.req.getHeader(name);
                case Method:
                    return this.req.getMethod();
                default:
                    return null;
            }
        } else {
            return null;
        }
    }

    public IContext attr(String name, Object o, Scope scope) {
        if (scope == null) {
            return null;
        } else {
            switch(scope) {
                case Request:
                    if (o == null) {
                        this.req.removeAttribute(name);
                    } else {
                        this.req.setAttribute(name, o);
                    }
                    break;
                case Session:
                    if (o == null) {
                        this.req.getSession().removeAttribute(name);
                    } else {
                        this.req.getSession().setAttribute(name, o);
                    }
                    break;
                case Context:
                    if (o == null) {
                        CTX_CACHE.remove(name);
                    } else {
                        CTX_CACHE.put(name, o);
                    }
                    break;
                case Header:
                    return null;
            }

            return this;
        }
    }

    public String para(String name) {
        String val = this.req.getParameter(name);
        if (val == null) {
            return (String)this.REQ_PARA_EXTR.get(name);
        } else {
            return val.isEmpty() ? (String)this.REQ_PARA_EXTR.getOrDefault(name, "") : val;
        }
    }

    public JSONObject params() {
        Enumeration<String> keys = this.req.getParameterNames();
        JSONObject para = (new JSONObject()).fluentPutAll(this.REQ_PARA_EXTR);

        while(keys.hasMoreElements()) {
            String key = (String)keys.nextElement();
            para.put(key, this.req.getParameter(key));
        }

        return para;
    }

    public String remoteHost() {
        String ip = this.req.getHeader("X-Real-IP");
        return ip == null ? this.req.getRemoteAddr() : ip;
    }

    public IContext logout() {
        this.session.invalidate();
        return this;
    }

    public void redirect(String location) {
        try {
            this.rsp.sendRedirect(location);
            this.rsp.setStatus(301);
        } catch (IOException var3) {
            LOG.warn("指定前端跳转失败", var3);
        }

    }

    public void forward(String path) {
        try {
            this.req.getRequestDispatcher(path).forward(this.req, this.rsp);
        } catch (IOException | ServletException var3) {
            LOG.warn("forward fails", var3);
        }

    }

    public void send(Object obj) {
        this.RSP_HEAD_INFO.forEach((k, v) -> {
            this.rsp.setHeader(k, v);
        });
        if (obj != null) {
            if (obj instanceof JSONObject) {
                this.rsp.setContentType("application/json;charset=UTF-8");
                if (!((JSONObject)obj).containsKey("err")) {
                    ((JSONObject)obj).fluentPut("err", 0);
                }
            } else if (obj instanceof JSONArray) {
                this.rsp.setContentType("application/json;charset=UTF-8");
                obj = (new JSONObject()).fluentPut("err", 0).fluentPut("data", obj);
            } else {
                if (obj instanceof File) {
                    this.send(TL.scod(), (File)obj);
                    return;
                }

                if (!(obj instanceof String) && !(obj instanceof Number)) {
                    LOG.info("暂时不支持此业务类型{}", obj);
                    return;
                }

                this.rsp.setContentType("text/plain;charset=UTF-8");
            }

            try {
                PrintWriter out = this.rsp.getWriter();

                try {
                    out.print(obj);
                } catch (Throwable var6) {
                    if (out != null) {
                        try {
                            out.close();
                        } catch (Throwable var5) {
                            var6.addSuppressed(var5);
                        }
                    }

                    throw var6;
                }

                if (out != null) {
                    out.close();
                }
            } catch (IOException var7) {
                LOG.warn("返回数据失败", var7);
            }

        }
    }

    public void send(byte[] obj, String contentType) {
        this.rsp.setContentType(contentType);

        try {
            ServletOutputStream os = this.rsp.getOutputStream();

            try {
                os.write(obj);
            } catch (Throwable var7) {
                if (os != null) {
                    try {
                        os.close();
                    } catch (Throwable var6) {
                        var7.addSuppressed(var6);
                    }
                }

                throw var7;
            }

            if (os != null) {
                os.close();
            }
        } catch (IOException var8) {
            LOG.warn("返回数据失败", var8);
        }

    }

    public void send(String fileName, File file) {
        try {
            this.rsp.setContentType("application/octet-stream");
            this.rsp.setHeader("content-disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
        } catch (UnsupportedEncodingException var9) {
            ;
        }

        try {
            ServletOutputStream os = this.rsp.getOutputStream();

            try {
                FileInputStream is = new FileInputStream(file);

                try {
                    byte[] tmp = new byte[4096];

                    int t;
                    while((t = is.read(tmp)) != -1) {
                        os.write(tmp, 0, t);
                    }
                } catch (Throwable var10) {
                    try {
                        is.close();
                    } catch (Throwable var8) {
                        var10.addSuppressed(var8);
                    }

                    throw var10;
                }

                is.close();
            } catch (Throwable var11) {
                if (os != null) {
                    try {
                        os.close();
                    } catch (Throwable var7) {
                        var11.addSuppressed(var7);
                    }
                }

                throw var11;
            }

            if (os != null) {
                os.close();
            }
        } catch (IOException var12) {
            LOG.warn("返回文件传输失败", var12);
        }

    }

    public IContext notice(String string, byte[] bytes) {
        return this;
    }

    public byte[] call(String uri, byte[] info) {
        return null;
    }

    public ISdb sdb() {
        return Conf.getSdb();
    }

    public ICache cdb() {
        return Conf.getICache();
    }

    public String[] getUriVals() {
        return this.uriVals;
    }

    public String loadModUri(int size) {
        if (size >= this.uriVals.length) {
            size = this.uriVals.length - 1;
        }

        StringBuilder sb = new StringBuilder();

        for(int i = 1; i <= size; ++i) {
            sb.append("/").append(this.uriVals[i]);
        }

        return sb.toString();
    }

    public void sendCode(int code) {
        this.RSP_HEAD_INFO.forEach((k, v) -> {
            this.rsp.setHeader(k, v);
        });
        this.rsp.setContentType("text/plain;charset=UTF-8");
        this.rsp.addDateHeader("Expires", -1L);
        this.rsp.setStatus(code);
    }

    /**
     * 返回post中的jsonObject数据
     * @return
     * @throws IOException
     */
    public JSONObject postJsonObjectData() throws IOException {
        BufferedReader br = null;
        req.setCharacterEncoding("utf-8");
        try {
            //请求参数
            String inputLine;
            String jsonStr = "";
            br = req.getReader();
            while ((inputLine = br.readLine()) != null) {
                jsonStr += inputLine;
            }

            if (jsonStr.length() == 0){
                throw new IOException();
            }

            return JSON.parseObject(jsonStr);
        }catch (IOException e){
            throw e;
        }finally {
            if (br != null){
                br.close();
            }
        }
    }

    /**
     * 返回post中的jsonArray数据
     * @return
     * @throws IOException
     */
    public JSONArray postJsonArrayData() throws IOException {
        BufferedReader br = null;
        try {
            //请求参数
            String inputLine;
            String jsonStr = "";
            br = req.getReader();
            while ((inputLine = br.readLine()) != null) {
                jsonStr += inputLine;
            }

            if (jsonStr.length() == 0){
                throw new IOException();
            }

            return JSON.parseArray(jsonStr);
        }catch (IOException e){
            throw e;
        }finally {
            if (br != null){
                br.close();
            }
        }
    }
}
