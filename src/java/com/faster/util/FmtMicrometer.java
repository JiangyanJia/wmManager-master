package com.faster.util;

import java.text.DecimalFormat;

/**
 * @desc: 格式化数字为千分位工具类
 * @author lhh
 *
 */
public class FmtMicrometer {

    /**
     * @desc: 格式化数字为千分位
     * @param text
     * @return String    返回类型
     */
    public static String fmtMicrometer(String text) {
        DecimalFormat df = null;
        if (text.indexOf(".") > 0) {
            if (text.length() - text.indexOf(".") - 1 == 0) {
                df = new DecimalFormat("###,##0.");
            } else if (text.length() - text.indexOf(".") - 1 == 1) {
                df = new DecimalFormat("###,##0.0");
            } else {
                df = new DecimalFormat("###,##0.00");
            }
        } else {
            df = new DecimalFormat("###,##0");
        }
        double number = 0.0;
        try {
            number = Double.parseDouble(text);
        } catch (Exception e) {
            number = 0.0;
        }
        return df.format(number);
    }

    public static void main(String[] args) {
        System.out.println(fmtMicrometer("9390."));
    }
}
