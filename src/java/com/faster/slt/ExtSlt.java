package com.faster.slt;

import com.faster.util.Base64Utils;
import com.faster.util.Result;
import tech.qting.IContext;
import tech.qting.ist.IceInst;
import tech.qting.ist.IceParse;
import tech.qting.util.TL;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;

/**
 *
 * @author lhh 接口权限控制
 */
@WebServlet(name = "ExtSlt", urlPatterns = {"/gateway/*"})
public class ExtSlt extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("access-control-allow-headers", "access-control-allow-credentials,access-control-allow-headers,access-control-allow-methods,access-control-allow-origin,enctype,"
                + "x-requested-with,content-type");
        resp.setHeader("access-control-allow-methods", "OPTIONS,POST,GET");
        resp.setHeader("access-control-allow-origin", "*");
        if ("options".equals(req.getMethod())) {
            return;
        }
        String action = req.getPathInfo();
        try (PrintWriter out = resp.getWriter()) {
            if (!filterAuth(action)) {

            }
            IceInst tmp = IceParse.get(action);
            if (tmp == null) {
                out.println("{\"code\":90,\"msg\":\"Not Found Action\"}");
            } else {
                try {
                    Object rst = tmp.exec(new ServletContext(req, resp));
                    if (rst != null) {
                        out.println(rst);
                    }
                } catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException ex) {
                    ex.printStackTrace();
                    out.println("{\"code\":91,\"msg\":\"" + ex.getLocalizedMessage() + "\"}");
                }
            }
        }
    }

    private boolean filterAuth(String action) {
        String[] filterStrings = {"/loginout"};
        for (int i = 0; i < filterStrings.length; i++) {
            if (filterStrings[i].equals(action)) {
                return true;
            }
        }
        return false;
    }

}
