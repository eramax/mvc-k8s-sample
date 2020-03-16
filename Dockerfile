FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /app
COPY . ./
RUN dotnet publish -c Release -o /app/publish --runtime alpine-x64 --self-contained true /p:PublishSingleFile=true /p:PublishTrimmed=true


FROM alpine:latest

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT false
RUN apk add --no-cache icu-libs
ENV LC_ALL=en_US.UTF-8 \ 
	LANG=en_US.UTF-8 \
	DOTNET_RUNNING_IN_CONTAINER=true

EXPOSE 80
EXPOSE 443
# Copy 
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["./MVC_K8S"]
