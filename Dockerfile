FROM adoptopenjdk/openjdk8:alpine-slim as build
EXPOSE 8080
ARG JAR_FILE=tsarget/*.jar
RUN addgroup -S pipeline && adduser -S K8s-pipeline -G pipeline
COPY --from=build ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]