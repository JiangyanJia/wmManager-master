package com.faster.slt;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author HMQ
 */
@WebServlet(name = "checkCode", urlPatterns = {"/checkCode"})
public class CheckCode extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputStr = request.getParameter("inputStr").toLowerCase();
        String session = request.getSession().getAttribute("verifyCode").toString().toLowerCase();
        System.out.println(inputStr + "===================" + session);
        try (PrintWriter out = response.getWriter()) {
            if (session.equals(inputStr)) {
                out.print("true");
            } else {
                out.print("false");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
