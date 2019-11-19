package com.faster.util;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.WildcardFileFilter;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.Properties;

/**
 * @ProjectName: fstControlManager
 * @Package: com.faster.util
 * @ClassName: PropertiesUtil
 * @Author: shaohong-zhu
 * @Description: 配置文件工具类
 * @Date: 2019/9/26 16:34
 * @Version: 1.0
 */
public class PropertiesUtil {
    private static final Properties pro = new Properties();

    static {

        URL fileUrl = PropertiesUtil.class.getResource("/");
        File file = new File(fileUrl.getFile());

        WildcardFileFilter wildcardFileFilter = new WildcardFileFilter("*.properties");
        List<File> fileList = (List<File>) FileUtils.listFiles(file, wildcardFileFilter, null);

        for (File f : fileList) {
            try {
                Properties tmp = new Properties();
                tmp.load(PropertiesUtil.class.getResourceAsStream("/" + f.getName()));
                pro.putAll(tmp);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    public static String getProperty(String key) {
        return (String) pro.get(key);
    }

    public static String getProperty(String key, String defaultValue) {
        String val = getProperty(key);
        return (val == null) ? defaultValue : val;
    }

}
