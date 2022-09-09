FROM adoptopenjdk/openjdk8:alpine-slim as build
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S pipeline 
RUN useradd -S K8s-pipeline pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]