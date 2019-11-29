package com.briup.cms;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@ServletComponentScan
@EnableSwagger2
public class Cms2Application extends SpringBootServletInitializer{

	public static void main(String[] args) {
		SpringApplication.run(Cms2Application.class, args);
	}
		//为springboot打包项目用的
	     @Override
	     protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
	         // TODO Auto-generated method stub
	         return builder.sources(this.getClass());
	     }
}
