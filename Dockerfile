FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["MVC_K8S/MVC_K8S.csproj", "MVC_K8S/"]
RUN dotnet restore "MVC_K8S/MVC_K8S.csproj"
COPY . .
WORKDIR "/src/MVC_K8S"
RUN dotnet build "MVC_K8S.csproj" -c Release -o /app/build
RUN dotnet publish --runtime alpine-x64 -c Release --self-contained true -o /publish /p:PublishSingleFile=true /p:PublishTrimmed=true


FROM alpine:3.9.4
# Add some libs required by .NET runtime 
RUN apk add --no-cache libstdc++ libintl
EXPOSE 80
EXPOSE 443
# Copy 
WORKDIR /app
COPY ./publish ./
ENTRYPOINT ["./MVC_K8S", "--urls", "http://0.0.0.0:80"]
