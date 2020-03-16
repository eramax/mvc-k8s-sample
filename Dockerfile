FROM mcr.microsoft.com/dotnet/core/sdk:3.1.102-alpine3.11 AS build
WORKDIR /app
COPY . ./
RUN dotnet publish -c Release -o /app/publish --runtime alpine-x64 --self-contained true /p:PublishSingleFile=true /p:PublishTrimmed=true


FROM alpine:3.11

RUN apk add --no-cache \
    ca-certificates \
    \
    # .NET Core dependencies
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    zlib

ENV DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

EXPOSE 80
EXPOSE 443

WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["./MVC_K8S"]
