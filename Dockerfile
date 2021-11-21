﻿FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/OzonEdu.MerchandiseService/OzonEdu.MerchandiseService.csproj", "src/OzonEdu.MerchandiseService/"]
RUN dotnet restore "src/OzonEdu.MerchandiseService/OzonEdu.MerchandiseService.csproj"
COPY . .
WORKDIR "/src/src/OzonEdu.MerchandiseService"
RUN dotnet build "OzonEdu.MerchandiseService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OzonEdu.MerchandiseService.csproj" -c Release -o /app/publish
COPY "entrypoint.sh" "/app/publish/."

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS runtime
WORKDIR /app
EXPOSE 5000
EXPOSE 5002

FROM runtime AS final
WORKDIR /app

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OzonEdu.MerchandiseService.dll"]

RUN chmod +x entrypoint.sh
CMD /bin/bash entrypoint.sh