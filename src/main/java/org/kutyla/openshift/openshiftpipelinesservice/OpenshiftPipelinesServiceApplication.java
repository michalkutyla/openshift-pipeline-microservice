package org.kutyla.openshift.openshiftpipelinesservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class OpenshiftPipelinesServiceApplication {

	@GetMapping("/")
	String status() {
		return "I'm allright. I'm running on host " + System.getenv().getOrDefault("HOSTNAME", "unknown");
	}

	public static void main(String[] args) {
		SpringApplication.run(OpenshiftPipelinesServiceApplication.class, args);
	}
}
