FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["k8s-assignment.csproj", "."]
RUN dotnet restore "./k8s-assignment.csproj"
COPY . .
RUN dotnet build "k8s-assignment.csproj" -c Release -o /app/build
RUN dotnet publish "k8s-assignment.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "k8s-assignment.dll"]
