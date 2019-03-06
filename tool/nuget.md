nuget spec
nuget pack Dapper.DBContext.csproj -Prop Configuration=Release
nuget setApiKey Your-API-Key  -Source https://www.nuget.org/api/v2/package


dotnet nuget push DynamicWebService.1.0.0.nupkg -k abc -s http://localhost:803/nuget
dotnet nuget push DynamicWebService.1.0.0.nupkg -k oy2if27ack72vtwr6y2qhucyql7uwtwu5hdhor7qtkegpm2222 -s https://api.nuget.org/v3/index.json

nuget push Dapper.DBContext.0.1.0.0.nupkg -Source https://www.nuget.org/api/v2/package