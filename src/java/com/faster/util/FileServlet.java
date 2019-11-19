package com.faster.util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;

/**
 * 公共模板下载
 */
@WebServlet(name = "FileServlet", urlPatterns = {"/fileDownload"})
public class FileServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	public static final String CONTENT_TYPE = "application/octet-stream; charset=utf-8";
	public static final String CONTENT_LENGTH = "Content-Length";
	public static final String CONTENT_DISPOSITION = "Content-Disposition";
	protected static final Logger LOG = LogManager.getLogger();

	public FileServlet() {
		super();
	}

	public void destroy() {
		super.destroy();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request,response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html;charset=UTF-8");
		response.setHeader("access-control-allow-headers", "x-requested-with,content-type");
		response.setHeader("access-control-allow-methods", "OPTIONS,POST");
		response.setHeader("access-control-allow-origin", "*");

//		String realPath = request.getSession().getServletContext().getRealPath("/");
		String realPath = request.getServletContext().getRealPath("");
		String directory = request.getParameter("directory");//目录
		String fileName = request.getParameter("fileName");//文件名称
		String path = realPath + directory + File.separator + fileName;

		writeFileToResponse(new File(path), response, fileName, request);
	}

	/**
	 * 将文件写到http输出流
	 * @param file
	 * @param response
	 * @param newFileName
	 * @throws IOException
	 */
	public static void writeFileToResponse(File file,HttpServletResponse response,String newFileName,HttpServletRequest request) throws IOException{
		response.setContentType(CONTENT_TYPE);
		response.setHeader(CONTENT_LENGTH, String.valueOf(file.length()));
		String explorerType = getExplorerType(request);
		if(explorerType==null||explorerType.contains("IE")){
			//IE
			response.setHeader(CONTENT_DISPOSITION,"attachment; filename=\""
					+ encode(newFileName, "UTF-8") + "\"");
		}else{
			//fireFox/Chrome
			response.setHeader(CONTENT_DISPOSITION, "attachment; filename="
					+ new String(newFileName.getBytes("utf-8"), "ISO8859-1"));
		}
		setOutputStream(response,file);
	}

	public static void setOutputStream(final HttpServletResponse response, final File file)
			throws IOException{
		BufferedOutputStream output = null;
		BufferedInputStream input = null;

		try {
			input = new BufferedInputStream(new FileInputStream(file));
			output = new BufferedOutputStream(response.getOutputStream());
			byte[] buff = new byte[2048];
			int readLen = 0;
			while((readLen = input.read(buff, 0, buff.length)) != -1){
				output.write(buff, 0, readLen);
			}
			output.flush();
		} catch (IOException e) {
			throw e;
		} finally {
			if(input != null){
				try {
					input.close();
				} catch (IOException e) {
				} finally {
					input = null;
				}
			}
			if(output != null){
				try {
					output.close();
				} catch (IOException e) {
				} finally {
					output = null;
				}
			}
		}
	}

	public static String encode(String fileName,String encode){
		String name=null;
		try {
			name= URLEncoder.encode(fileName,encode);
			name=name.replace("+", "%20");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return name;
	}

	/**
	 * 获取浏览器类型
	 * @param request
	 * @return
	 */
	public static String getExplorerType(HttpServletRequest request){
		try{
			String agent = request.getHeader("User-Agent");

			if(agent.contains("MSIE")){
				return agent.split(";")[1];
			}else if(agent.contains("Firefox")){
				return "Firefox";
			}else if(agent.contains("Chrome")){
				return "Chrome";
			}
			return null;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
}
