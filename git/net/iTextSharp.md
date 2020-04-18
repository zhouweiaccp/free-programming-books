



## url
- [nuget](https://www.nuget.org/packages/iTextSharp/)





## PDF header signature not found
- [1] PdfReader reader = new PdfReader(fileName);
FileStream fout = new FileStream(SignedFileName, FileMode.Create, FileAccess.ReadWrite);
fout.position=0;
- [2](https://stackoverflow.com/questions/16286935/itextsharp-digital-signature-issue-on-pdf-file)  添加签名
```
using iTextSharp;
using iTextSharp.text;
using iTextSharp.text.pdf;

using (Document document = new Document())
        {
            PdfWriter writer = PdfWriter.GetInstance(document, new System.IO.FileStream(@"C:\Users\myusername\Desktop\test.pdf", System.IO.FileMode.Create));
            document.Open();
            document.Add(new Paragraph("A paragraph"));
            PdfFormField sig = PdfFormField.CreateSignature(writer);
            sig.SetWidget(new Rectangle(100, 100, 250, 150), null);
            sig.FieldName = "testSignature";
            sig.Flags = PdfAnnotation.FLAGS_PRINT;
            sig.SetPage();
            sig.MKBorderColor = BaseColor.BLACK;
            sig.MKBackgroundColor = BaseColor.WHITE;
            PdfAppearance appearance = PdfAppearance.CreateAppearance(writer, 72, 48);
            appearance.Rectangle(0.5f, 0.5f, 71.5f, 47.5f);
            appearance.Stroke();
            sig.SetAppearance(
              PdfAnnotation.APPEARANCE_NORMAL, appearance
            );
            writer.AddAnnotation(sig);
        }

```

## c# itextsharp how to get digital signature image
- [] (https://stackoverflow.com/questions/38430974/c-sharp-itextsharp-how-to-get-digital-signature-image)
 ```
 PdfReader pdf = new PdfReader("location.pdf");
AcroFields acroFields = pdf.AcroFields;
List<string> names = acroFields.GetSignatureNames();

foreach (var name in names)
{
    PdfDictionary dict = acroFields.GetSignatureDictionary(name);
}
````

 ## pdf添加签名
- [](iTextSharp_digital_signature.cs)
