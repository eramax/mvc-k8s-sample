FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /app
COPY . ./
RUN dotnet publish -c Release -o /app/publish --runtime alpine-x64 --self-contained true /p:PublishSingleFile=true /p:PublishTrimmed=true

FROM alpine:3.9.4
# Add some libs required by .NET runtime 
RUN apk add --no-cache libstdc++ libintl
EXPOSE 80
EXPOSE 443
# Copy 
WORKDIR /app
COPY ./app/publish ./
ENTRYPOINT ["./MVC_K8S", "--urls", "http://0.0.0.0:80"]
