# Etapa de construcción
# Usamos la imagen oficial de .NET SDK 8.0 para construir la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copiamos el archivo de proyecto (.csproj) al contenedor y restauramos las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiamos el resto de los archivos de la aplicación al contenedor
COPY . ./

# Publicamos la aplicación en modo Release y guardamos los archivos en la carpeta "out"
RUN dotnet publish -c Release -o out

# Etapa de ejecución
# Usamos la imagen oficial de ASP.NET Core 8.0 para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copiamos los archivos generados en la etapa de construcción desde la carpeta "out"
COPY --from=build-env /app/out .

# Definimos una variable de entorno donde almacenaremos el nombre del archivo ejecutable (.dll)
# Esto permite flexibilidad para cambiar el nombre del archivo sin modificar el Dockerfile
ENV APP_NET_CORE pc_02.dll  

# Definimos el comando para ejecutar la aplicación
# La variable de entorno ASPNETCORE_URLS define en qué puerto se ejecutará la app
# Usamos la variable $PORT para que el puerto se pueda configurar dinámicamente
CMD ASPNETCORE_URLS=http://*:$PORT dotnet $APP_NET_CORE