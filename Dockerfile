FROM mcr.microsoft.com/dotnet/core/sdk:3.1.102-alpine3.11 AS build
WORKDIR /app
COPY . ./
RUN dotnet publish -c Release -o /app/publish --runtime alpine-x64 --self-contained true /p:PublishSingleFile=true /p:PublishTrimmed=true


FROM eramax/dotnetcore:latest
ENV ASPNETCORE_ENVIRONMENT=Development
# Copy 
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["./MVC_K8S", "--urls", "http://0.0.0.0:80"]
