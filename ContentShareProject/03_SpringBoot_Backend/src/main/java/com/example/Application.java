package com.example;

import com.example.util.DatabaseInitUtil;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        System.out.println("正在初始化数据库...");
        DatabaseInitUtil.main(new String[]{});
        System.out.println("数据库初始化完成，启动应用...");
        SpringApplication.run(Application.class, args);
    }

}
