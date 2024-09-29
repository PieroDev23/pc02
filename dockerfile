# Etapa de construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copiar el archivo .csproj y restaurar las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar todo el resto de los archivos y construir la aplicación
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Etapa de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copiar los archivos publicados de la etapa de construcción
COPY --from=build-env /app/out .

# Definir el puerto por defecto si no está configurado externamente
ENV ASPNETCORE_URLS=http://+:80

# Definir el nombre del archivo DLL de la aplicación
ENV APP_NET_CORE=pc_02.dll

# Ejecutar la aplicación
ENTRYPOINT ["dotnet", "pc_02.dll"]
