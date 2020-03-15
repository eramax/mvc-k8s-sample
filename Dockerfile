FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
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

# Configure web servers to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Set the invariant mode since icu_libs isn't included (see https://github.com/dotnet/announcements/issues/20)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

EXPOSE 80
EXPOSE 443
# Copy 
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["./MVC_K8S", "--urls", "http://0.0.0.0:80"]
