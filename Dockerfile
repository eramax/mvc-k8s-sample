FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /app
COPY . ./
RUN dotnet publish -c Release -o /app/publish 

FROM mcr.microsoft.com/dotnet/core/runtime:3.1.2-buster-slim
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet MVC_K8S.dll"]
