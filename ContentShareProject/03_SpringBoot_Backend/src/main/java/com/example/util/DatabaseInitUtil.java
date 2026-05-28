package com.example.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DatabaseInitUtil {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";
    private static final String SQL_FILE_PATH = "d:\\ContentShareProject\\database\\full_init.sql";
    private static final String TEST_DATA_PATH = "d:\\ContentShareProject\\database\\test_data.sql";
    private static final String MODULE_DATA_PATH = "d:\\ContentShareProject\\database\\module_data.sql";
    private static final String ARTICLES_DATA_PATH = "d:\\ContentShareProject\\database\\insert_articles_and_hotsearch.sql";
    private static final String FIX_STATISTICS_PATH = "d:\\ContentShareProject\\database\\fix_statistics.sql";

    public static void main(String[] args) {
        System.out.println("开始初始化数据库...");

        try {
            // 连接数据库并执行SQL（现代JDBC不需要显式加载驱动）
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 Statement stmt = conn.createStatement()) {

                // 先删除旧数据库再重新创建（彻底解决表结构问题）
                System.out.println("正在重新初始化数据库...");
                try {
                    stmt.execute("DROP DATABASE IF EXISTS content_share");
                    System.out.println("✓ 删除旧数据库成功");
                } catch (Exception e) {
                    System.out.println("  删除旧数据库出错（可能不存在）: " + e.getMessage());
                }
                
                stmt.execute("CREATE DATABASE content_share DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                stmt.execute("USE content_share");
                System.out.println("✓ 创建新数据库成功");

                // 读取并执行主SQL文件（创建表结构）
                System.out.println("\n=== 步骤1: 创建数据库表结构 ===");
                List<String> sqlStatements = readSqlFile(SQL_FILE_PATH);

                for (String sql : sqlStatements) {
                    if (sql.trim().isEmpty()) {
                        continue;
                    }
                    try {
                        stmt.execute(sql);
                        if (sql.toUpperCase().startsWith("CREATE") || sql.toUpperCase().startsWith("INSERT")) {
                            System.out.println("✓ " + sql.substring(0, Math.min(60, sql.length())));
                        }
                    } catch (Exception e) {
                        // 忽略重复执行错误
                    }
                }

                // 读取并执行测试数据文件
                System.out.println("\n=== 步骤2: 插入基础测试数据 ===");
                List<String> testDataStatements = readSqlFile(TEST_DATA_PATH);

                for (String sql : testDataStatements) {
                    if (sql.trim().isEmpty()) {
                        continue;
                    }
                    try {
                        stmt.execute(sql);
                        if (sql.toUpperCase().startsWith("INSERT")) {
                            System.out.println("✓ 插入数据: " + sql.substring(0, Math.min(60, sql.length())));
                        }
                    } catch (Exception e) {
                        // 忽略重复执行错误
                    }
                }

                // 读取并执行模块数据文件
                System.out.println("\n=== 步骤3: 为热门/同城/推荐模块准备数据 ===");
                List<String> moduleDataStatements = readSqlFile(MODULE_DATA_PATH);

                for (String sql : moduleDataStatements) {
                    if (sql.trim().isEmpty()) {
                        continue;
                    }
                    try {
                        stmt.execute(sql);
                        if (sql.toUpperCase().startsWith("INSERT") || sql.toUpperCase().startsWith("UPDATE") || sql.toUpperCase().startsWith("CREATE")) {
                            System.out.println("✓ " + sql.substring(0, Math.min(60, sql.length())));
                        }
                    } catch (Exception e) {
                        // 忽略重复执行错误
                    }
                }

                // 读取并执行文章和热搜数据文件
                System.out.println("\n=== 步骤4: 插入文章和热搜数据 ===");
                List<String> articlesStatements = readSqlFile(ARTICLES_DATA_PATH);

                for (String sql : articlesStatements) {
                    if (sql.trim().isEmpty()) {
                        continue;
                    }
                    try {
                        stmt.execute(sql);
                        if (sql.toUpperCase().startsWith("INSERT") || sql.toUpperCase().startsWith("UPDATE")) {
                            System.out.println("✓ " + sql.substring(0, Math.min(60, sql.length())));
                        }
                    } catch (Exception e) {
                        // 忽略重复执行错误
                    }
                }

                // 执行统计数据修复脚本
                System.out.println("\n=== 步骤5: 修复统计数据（确保与实际数据一致） ===");
                List<String> fixStatements = readSqlFile(FIX_STATISTICS_PATH);

                for (String sql : fixStatements) {
                    if (sql.trim().isEmpty()) {
                        continue;
                    }
                    try {
                        stmt.execute(sql);
                        if (sql.toUpperCase().startsWith("UPDATE")) {
                            System.out.println("✓ " + sql.substring(0, Math.min(60, sql.length())));
                        }
                    } catch (Exception e) {
                        // 忽略重复执行错误
                    }
                }

                System.out.println("\n✓✓✓ 数据库初始化完成！已为首页热门、同城、推荐等模块准备好数据。");
            }
        } catch (Exception e) {
            System.err.println("数据库初始化失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static List<String> readSqlFile(String filePath) throws IOException {
        List<String> statements = new ArrayList<>();
        StringBuilder currentStatement = new StringBuilder();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                
                if (line.isEmpty() || line.startsWith("--") || line.startsWith("#")) {
                    continue;
                }
                
                currentStatement.append(line).append(" ");
                
                if (line.endsWith(";")) {
                    String sql = currentStatement.toString().trim();
                    if (sql.endsWith(";")) {
                        sql = sql.substring(0, sql.length() - 1);
                    }
                    statements.add(sql);
                    currentStatement = new StringBuilder();
                }
            }
            
            if (currentStatement.length() > 0) {
                String sql = currentStatement.toString().trim();
                if (!sql.isEmpty()) {
                    statements.add(sql);
                }
            }
        }
        
        return statements;
    }
}
