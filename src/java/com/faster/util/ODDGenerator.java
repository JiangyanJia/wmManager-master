package com.faster.util;

import com.faster.slt.SltLsn;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.FastDateFormat;
import tech.qting.cache.redis.Redis;

import java.time.Instant;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 编号策略
 *
 * @author shaohong-zhu
 * @version 1.0.0
 * @project common-utils
 * @fileName ODDGenerator.java
 * @Description
 * @date 2019年9月18日
 */
public abstract class ODDGenerator {
    private static final FastDateFormat pattern = FastDateFormat.getInstance("yyyyMMdd");
    private static final AtomicInteger atomicInteger = new AtomicInteger(1);
    private static ThreadLocal<StringBuilder> threadLocal = new ThreadLocal<StringBuilder>();

    /**
     * 【长码生成策略】
     *
     * @param lock 生成的UUID32位参数
     * @return 长码机制
     * @时间20180511231532
     * @二位随机数
     * @lock的hash-code编码
     */
    public static String getC(String lock) {
        StringBuilder builder = new StringBuilder(pattern.format(Instant.now().toEpochMilli()));// 取系统当前时间作为订单号前半部分
        builder.append("-");// HASH-CODE
        builder.append(Math.abs(lock.hashCode()));// HASH-CODE
        builder.append(atomicInteger.getAndIncrement());// 自增顺序
        threadLocal.set(builder);
        return threadLocal.get().toString();
    }

    /**
     * 【短码生成策略】
     *
     * @param lock
     * @return
     */
    public static String getD(String lock) {
        StringBuilder builder = new StringBuilder(ThreadLocalRandom.current().nextInt(0, 999));// 随机数
        builder.append(Math.abs(lock.hashCode()));// HASH-CODE
        builder.append(atomicInteger.getAndIncrement());// 自增顺序
        threadLocal.set(builder);
        return threadLocal.get().toString();
    }

    /**
     * 生成预警工单号(简称+告警发生日期+序号)
     *
     * @param abbr 前缀
     * @return java.lang.String
     * @date 2019/10/23 17:06
     * @author shaohong-zhu
     */
    public static String getByWarning(String abbr) {
        Redis redis = SltLsn.redis;
        StringBuilder builder = new StringBuilder(pattern.format(Instant.now().toEpochMilli()));// 取系统当前时间作为订单号前半部分
        String key = abbr + builder.toString();
        String num = redis.incr(key) + "";
        return key + String.format("%04d", Integer.parseInt(num));
    }

    /**
     * 1000个线程并发测试
     *
     * @param args
     * @throws InterruptedException
     * @throws ExecutionException
     */
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        Set<String> set = new HashSet<String>();
        FutureTask<String> task = null;
        long startTime = System.currentTimeMillis();
        for (int i = 0; i < 10; i++) {
            Callable<String> callable = new Callable<String>() {
                @Override
                public String call() throws Exception {
                    // System.out.println("当前线程:>>>>> ".concat(Thread.currentThread().getName()));
                    // return getC(StringUtils.replace(UUID.randomUUID().toString(), "-", ""));
                    return getC(StringUtils.replace(UUID.randomUUID().toString(), "-", ""));
                }
            };
            task = new FutureTask<String>(callable);
            new Thread(task).start();
            //System.out.println(task.get());
            set.add(task.get());
        }
        System.out.println("总共耗时:" + ((System.currentTimeMillis() - startTime)) + "ms");
        System.out.println("*************** " + set.size());
        System.out.println("*************** " + set);
    }
}