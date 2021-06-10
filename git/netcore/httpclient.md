


## MultipartFormDataContent
```cs
static async Task uploaddocAsync()
{
    MultipartFormDataContent form = new MultipartFormDataContent();
    Dictionary<string, string> parameters = new Dictionary<string, string>();
    //parameters.Add("username", user.Username);
    //parameters.Add("FullName", FullName);
    HttpContent DictionaryItems = new FormUrlEncodedContent(parameters);
    form.Add(DictionaryItems, "model");

    try
    {
        var stream = new FileStream(@"D:\10th.jpeg", FileMode.Open);
        HttpClient client = new HttpClient();
        client.BaseAddress = new Uri(@"http:\\xyz.in");
            
        HttpContent content = new StringContent("");
        content.Headers.ContentDisposition = new ContentDispositionHeaderValue("form-data")
        {
            Name = "uploadedFile1",
            FileName = "uploadedFile1"
        };
        content = new StreamContent(stream);
        form.Add(content, "uploadedFile1"); 

        client.DefaultRequestHeaders.Add("Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dsfdsfdsfdsfsdfkhjhjkhjk.vD056hXETFMXYxOaLZRwV7Ny1vj-tZySAWq6oybBr2w");
                 
        var response = client.PostAsync(@"\api\UploadDocuments\", form).Result;
        var k = response.Content.ReadAsStringAsync().Result;
    }
    catch (Exception ex)
    {


    }
}
```


## Upload
```cs
public static async Task<string> Upload(byte[] image)
{
     using (var client = new HttpClient())
     {
         using (var content =
             new MultipartFormDataContent("Upload----" + DateTime.Now.ToString(CultureInfo.InvariantCulture)))
         {
             content.Add(new StreamContent(new MemoryStream(image)), "bilddatei", "upload.jpg");

              using ( var message = await client.PostAsync("http://www.directupload.net/index.php?mode=upload", content))
              {
                  var input = await message.Content.ReadAsStringAsync();

                  return !string.IsNullOrWhiteSpace(input) ? Regex.Match(input, @"http://\w*\.directupload\.net/images/\d*/\w*\.[a-z]{3}").Value : null;
              }
          }
     }
}
```

## c-sharp-httpclient-4-5-multipart-form-data-upload
```cs
//https://stackoverflow.com/questions/16416601/c-sharp-httpclient-4-5-multipart-form-data-upload
private static void Upload()
{
    using (var client = new HttpClient())
    {
        client.DefaultRequestHeaders.Add("User-Agent", "CBS Brightcove API Service");

        using (var content = new MultipartFormDataContent())
        {
            var path = @"C:\B2BAssetRoot\files\596086\596086.1.mp4";

            string assetName = Path.GetFileName(path);

            var request = new HTTPBrightCoveRequest()
                {
                    Method = "create_video",
                    Parameters = new Params()
                        {
                            CreateMultipleRenditions = "true",
                            EncodeTo = EncodeTo.Mp4.ToString().ToUpper(),
                            Token = "x8sLalfXacgn-4CzhTBm7uaCxVAPjvKqTf1oXpwLVYYoCkejZUsYtg..",
                            Video = new Video()
                                {
                                    Name = assetName,
                                    ReferenceId = Guid.NewGuid().ToString(),
                                    ShortDescription = assetName
                                }
                        }
                };

            //Content-Disposition: form-data; name="json"
            var stringContent = new StringContent(JsonConvert.SerializeObject(request));
            stringContent.Headers.Add("Content-Disposition", "form-data; name=\"json\"");
            content.Add(stringContent, "json");

            FileStream fs = File.OpenRead(path);

            var streamContent = new StreamContent(fs);
            streamContent.Headers.Add("Content-Type", "application/octet-stream");
            //Content-Disposition: form-data; name="file"; filename="C:\B2BAssetRoot\files\596090\596090.1.mp4";
            streamContent.Headers.Add("Content-Disposition", "form-data; name=\"file\"; filename=\"" + Path.GetFileName(path) + "\"");
            content.Add(streamContent, "file", Path.GetFileName(path));

            //content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");

            Task<HttpResponseMessage> message = client.PostAsync("http://api.brightcove.com/services/post", content);

            var input = message.Result.Content.ReadAsStringAsync();
            Console.WriteLine(input.Result);
            Console.Read();
        }
    }
}
```