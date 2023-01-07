### jar location /spring-petclinic/target/spring-petclinic-2.7.3.jar
FROM openjdk:11
LABEL "project" = "spc"
LABEL "author" = "krishnaprasad"
EXPOSE 8080
COPY ./target/spring-petclinic-2.7.3.jar /spring-petclinic-2.7.3.jar
CMD ["java", "-jar", "spring-petclinic-2.7.3.jar"]
