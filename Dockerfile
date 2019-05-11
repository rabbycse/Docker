FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["Applications/SMS4BD.Web/SMS4BD.Web.csproj", "Applications/SMS4BD.Web/"]
RUN dotnet restore "Applications/SMS4BD.Web/SMS4BD.Web.csproj"
COPY . .
WORKDIR "/src/Applications/SMS4BD.Web"
RUN dotnet build "SMS4BD.Web.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SMS4BD.Web.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SMS4BD.Web.dll"]