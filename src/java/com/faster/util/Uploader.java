package com.faster.util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.*;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.FileUploadBase.InvalidContentTypeException;
import org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException;
import org.apache.commons.fileupload.util.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;

import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;

import javax.servlet.http.HttpServletRequest;
/**
 * UEditor文件上传辅助类
 *
 */
public class Uploader {
	// 输出文件地址
	private String url = "";
	// 上传文件名
	private String fileName = "";
	// 状态
	private String state = "";
	// 文件类型
	private String type = "";
	// 原始文件名
	private String originalName = "";
	// 文件大小
	private long size = 0;

	private HttpServletRequest request = null;
	private String title = "";

	// 保存路径
	private String savePath = "upload";
	// 文件允许格式
	private String[] allowFiles = { ".rar", ".doc", ".docx", ".zip", ".pdf",".txt", ".swf", ".wmv", ".gif", ".png", ".jpg", ".jpeg", ".bmp" };
	// 文件大小限制，单位KB
	private int maxSize = 10000;
	
	private HashMap<String, String> errorInfo = new HashMap<String, String>();

	public Uploader(HttpServletRequest request) {
		this.request = request;
		HashMap<String, String> tmp = this.errorInfo;
		tmp.put("SUCCESS", "SUCCESS"); //默认成功
		tmp.put("NOFILE", "未包含文件上传域");
		tmp.put("TYPE", "不允许的文件格式");
		tmp.put("SIZE", "文件大小超出限制");
		tmp.put("ENTYPE", "请求类型ENTYPE错误");
		tmp.put("REQUEST", "上传请求异常");
		tmp.put("IO", "IO异常");
		tmp.put("DIR", "目录创建失败");
		tmp.put("UNKNOWN", "未知错误");
		
	}

	public void upload() throws Exception {
		boolean isMultipart = ServletFileUpload.isMultipartContent(this.request);
		if (!isMultipart) {
			this.state = this.errorInfo.get("NOFILE");
			return;
		}
		DiskFileItemFactory dff = new DiskFileItemFactory();
		String savePath = this.getFolder(this.savePath);
		dff.setRepository(new File(savePath));
//		System.out.println(dff.getRepository().getAbsolutePath());
		try {
			ServletFileUpload sfu = new ServletFileUpload(dff);
			sfu.setSizeMax(this.maxSize * 1024);
			sfu.setHeaderEncoding("utf-8");
			FileItemIterator fii = sfu.getItemIterator(this.request);
			while (fii.hasNext()) {
				FileItemStream fis = fii.next();
				if (!fis.isFormField()) {
					/*this.originalName = fis.getName().substring(fis.getName().lastIndexOf(System.getProperty("file.separator")) + 1);
					if (!this.checkFileType(this.originalName)) {
						this.state = this.errorInfo.get("TYPE");
						continue;
					}
					this.fileName = this.getName(this.originalName);
					this.type = this.getFileExt(this.fileName);
					this.url = savePath + "/" + this.fileName;
					BufferedInputStream in = new BufferedInputStream(fis.openStream());
					File file = new File(this.getPhysicalPath(this.url));
					FileOutputStream out = new FileOutputStream( file );
					BufferedOutputStream output = new BufferedOutputStream(out);
					Streams.copy(in, output, true);
					this.state=this.errorInfo.get("SUCCESS");
					this.size = file.length();*/

					//上传到远程服务器
					//UploadFile.upload(file,"https://media.ytzhly.com/upload");
					InputStream uploadedStream = fis.openStream();

					HashMap<String, InputStream> files = new HashMap<String, InputStream>();
					files.put(fis.getName(), uploadedStream);
					String rest = uploadToFarService(files);
//					System.out.println("上传图片返回结果:"+rest);
					uploadedStream.close();
					if(rest!=null) {
						JSONObject obj = JSON.parseObject(rest);
						String creatTime = obj.getString("creat_time");
						if(creatTime!=null) {
							this.url = obj.getString("path");
							this.fileName = url.substring(url.lastIndexOf("/") + 1);
							this.type = obj.getString("type");
						}else{
							this.url = obj.getJSONArray("path").getString(0);
							this.fileName = url.substring(url.lastIndexOf("/") + 1);
							this.type = obj.getJSONArray("type").getString(0);
						}
						this.state=this.errorInfo.get("SUCCESS");
						this.size = 0;
					}else{

					}
					//UE中只会处理单张上传，完成后即退出
					break;
				} else {
					String fname = fis.getFieldName();
					//只处理title，其余表单请自行处理
					if(!fname.equals("pictitle")){
						continue;
					}
                    BufferedInputStream in = new BufferedInputStream(fis.openStream());
                    BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                    StringBuffer result = new StringBuffer();  
                    while (reader.ready()) {  
                        result.append((char)reader.read());  
                    }
                    this.title = new String(result.toString().getBytes(),"utf-8");
                    reader.close();  
                    
				}
			}
		} catch (SizeLimitExceededException e) {
			this.state = this.errorInfo.get("SIZE");
		} catch (InvalidContentTypeException e) {
			this.state = this.errorInfo.get("ENTYPE");
		} catch (FileUploadException e) {
			this.state = this.errorInfo.get("REQUEST");
		} catch (Exception e) {
			this.state = this.errorInfo.get("UNKNOWN");
		}
	}

	public String uploadToFarService(HashMap<String, InputStream> files) {

		StringBuffer result = new StringBuffer();
		try {
			//获取配置的上传文件路径
			RecordSet<Record> rs = HSF.query("select cfgkey,itemval from t_sys_config where cfgkey='defupservice'");
			String uploadUrl = "";
			if(rs.next()) {
				uploadUrl = rs.getString("itemval");
				uploadUrl = uploadUrl.replace("https","http");
//				System.out.println("uploadUrl:" + uploadUrl);
			}
			if(uploadUrl!=""&&uploadUrl!=null) {
				String BOUNDARY = "---------7d4a6d158c9"; // 定义数据分隔线
				URL url = new URL(uploadUrl);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				// 发送POST请求必须设置如下两行
				conn.setDoOutput(true);
				conn.setDoInput(true);
				conn.setUseCaches(false);
				conn.setRequestMethod("POST");
				conn.setRequestProperty("connection", "Keep-Alive");
				conn.setRequestProperty("user-agent",
						"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
				conn.setRequestProperty("Charsert", "UTF-8");
				conn.setRequestProperty("Content-Type",
						"multipart/form-data; boundary=" + BOUNDARY);

				OutputStream out = new DataOutputStream(conn.getOutputStream());
				byte[] end_data = ("\r\n--" + BOUNDARY + "--\r\n").getBytes();// 定义最后数据分隔线
				Iterator iter = files.entrySet().iterator();
				int i = 0;
				while (iter.hasNext()) {
					i++;
					Map.Entry entry = (Map.Entry) iter.next();
					String key = (String) entry.getKey();
					InputStream val = (InputStream) entry.getValue();
					String fname = key;
					File file = new File(fname);
					StringBuilder sb = new StringBuilder();
					sb.append("--");
					sb.append(BOUNDARY);
					sb.append("\r\n");
					sb.append("Content-Disposition: form-data;name=\"file"
							+ "\";filename=\"" + key + "\"\r\n");
					sb.append("Content-Type:application/octet-stream\r\n\r\n");

					byte[] data = sb.toString().getBytes();
					out.write(data);
					DataInputStream in = new DataInputStream(val);
					int bytes = 0;
					byte[] bufferOut = new byte[1024];
					while ((bytes = in.read(bufferOut)) != -1) {
						out.write(bufferOut, 0, bytes);
					}
					out.write("\r\n".getBytes()); // 多个文件时，二个文件之间加入这个
					in.close();
				}
				out.write(end_data);
				out.flush();
				out.close();

				// 定义BufferedReader输入流来读取URL的响应
				BufferedReader reader = new BufferedReader(new InputStreamReader(
						conn.getInputStream(), "UTF-8"));
				String line = null;
				while ((line = reader.readLine()) != null) {
					//System.out.println(line);
					result.append(line);
				}
			}
		} catch (Exception e) {
			System.out.println("发送POST请求出现异常！" + e);
			e.printStackTrace();
		}
		return result.toString();
	}

	/**
	 * 接受并保存以base64格式上传的文件
	 * @param fieldName
	 */
	public void uploadBase64(String fieldName){
		/*String savePath = this.getFolder(this.savePath);
		String base64Data = this.request.getParameter(fieldName);
		this.fileName = this.getName("test.png");
		this.url = savePath + "/" + this.fileName;
		BASE64Decoder decoder = new BASE64Decoder();
		try {
			File outFile = new File(this.getPhysicalPath(this.url));
			OutputStream ro = new FileOutputStream(outFile);
			byte[] b = decoder.decodeBuffer(base64Data);
			for (int i = 0; i < b.length; ++i) {
				if (b[i] < 0) {
					b[i] += 256;
				}
			}
			ro.write(b);
			ro.flush();
			ro.close();
			this.state=this.errorInfo.get("SUCCESS");
		} catch (Exception e) {
			this.state = this.errorInfo.get("IO");
		}*/
	}

	/**
	 * 文件类型判断
	 * 
	 * @param fileName
	 * @return
	 */
	private boolean checkFileType(String fileName) {
		Iterator<String> type = Arrays.asList(this.allowFiles).iterator();
		while (type.hasNext()) {
			String ext = type.next();
			if (fileName.toLowerCase().endsWith(ext)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 获取文件扩展名
	 * 
	 * @return string
	 */
	private String getFileExt(String fileName) {
		return fileName.substring(fileName.lastIndexOf("."));
	}

	/**
	 * 依据原始文件名生成新文件名
	 * @return
	 */
	private String getName(String fileName) {
		Random random = new Random();
		return this.fileName = "" + random.nextInt(10000)
				+ System.currentTimeMillis() + this.getFileExt(fileName);
	}

	/**
	 * 根据字符串创建本地目录 并按照日期建立子目录返回
	 * @param path 
	 * @return 
	 */
	private String getFolder(String path) {
		SimpleDateFormat formater = new SimpleDateFormat("yyyyMMdd");
		path += "/" + formater.format(new Date());
		File dir = new File(this.getPhysicalPath(path));
		if (!dir.exists()) {
			try {
				dir.mkdirs();
			} catch (Exception e) {
				this.state = this.errorInfo.get("DIR");
				return "";
			}
		}
		return path;
	}

	/**
	 * 根据传入的虚拟路径获取物理路径
	 * 
	 * @param path
	 * @return
	 */
	private String getPhysicalPath(String path) {
		String servletPath = this.request.getServletPath();
		String realPath = this.request.getSession().getServletContext()
				.getRealPath(servletPath);
		return new File(realPath).getParent() +"/" +path;
	}

	public void setSavePath(String savePath) {
		this.savePath = savePath;
	}

	public void setAllowFiles(String[] allowFiles) {
		this.allowFiles = allowFiles;
	}

	public void setMaxSize(int size) {
		this.maxSize = size;
	}

	public long getSize() {
		return this.size;
	}

	public String getUrl() {
		return this.url;
	}

	public String getFileName() {
		return this.fileName;
	}

	public String getState() {
		return this.state;
	}
	
	public String getTitle() {
		return this.title;
	}

	public String getType() {
		return this.type;
	}

	public String getOriginalName() {
		return this.originalName;
	}
}
