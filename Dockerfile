FROM openjdk:8-jdk-alpine as build

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN chmod +x ./mvnw
RUN ./mvnw dependency:go-offline -B

COPY src src

RUN ./mvnw package -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM openjdk:8
WORKDIR /final
COPY --from=build  /app/target/users-mysql.jar /final
EXPOSE 8086
ENTRYPOINT ["java", "-jar", "users-mysql.jar"]
