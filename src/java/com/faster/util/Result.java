package com.faster.util;

import tech.qting.qson.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * 页面响应result
 * 创建者 LHH
 * 创建时间	2019年8月18日18:41:30
 */
public class Result extends JSONObject {

	private static final long serialVersionUID = 1L;

	public Result() {
		put("code", 0);
	}

	public static Result error() {
		return error(500, "未知异常，请联系管理员");
	}

	public static Result error(String msg) {
		return error(500, msg);
	}

	public static Result error(int code, String msg) {
		Result r = new Result();
		r.put("code", code);
		r.put("msg", msg);
		return r;
	}

	public static Result ok(Object msg) {
		Result r = new Result();
		r.put("msg", msg);
		return r;
	}


	public static Result ok(JSONObject obj) {
		Result r = new Result();
		r.put("msg", "success");
		r.putAll(obj);
		return r;
	}

	public static Result resultOk(JSONObject obj) {
		Result r = new Result();
		r.putAll(obj);
		return r;
	}

	public static Result ok() {
		return new Result();
	}

	@Override
	public Result put(String key, Object value) {
		super.put(key, value);
		return this;
	}
}