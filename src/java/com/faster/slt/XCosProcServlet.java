package com.faster.slt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author lovel
 */
public class XCosProcServlet extends HttpServlet {

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doOptions(req, resp); //To change body of generated methods, choose Tools | Templates.
        resp.setContentType("text/html;charset=UTF-8");
        resp.setHeader("access-control-allow-headers", "access-control-allow-credentials,access-control-allow-headers,access-control-allow-methods,access-control-allow-origin,enctype,"
                + "x-requested-with,content-type");
        resp.setHeader("access-control-allow-methods", "OPTIONS,POST,GET");
        resp.setHeader("access-control-allow-origin", "*");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp); //To change body of generated methods, choose Tools | Templates.
    }

}
