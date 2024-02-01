FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
 
 
EXPOSE 8094
ENV ASPNETCORE_URLS=http://*:8094
 
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["CSCMasters.csproj", "."]
RUN dotnet restore "./CSCMasters.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "CSCMasters.csproj" -c Release -o /app/build
 
FROM build AS publish
RUN dotnet publish "CSCMasters.csproj" -c Release -o /app/publish /p:UseAppHost=false
 
FROM base AS final
 
RUN addgroup --group cscgroup && adduser --disabled-password "cscuser"
USER cscuser
 
ENV TZ="Asia/Calcutta"
WORKDIR /app
COPY --from=publish /app/publish .
 
RUN whoami
 
ENTRYPOINT ["dotnet", "CSCMasters.dll"]
