using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using com.itextpdf.text.pdf.security;
using iTextSharp;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;
using iTextSharp.text.pdf.security;
using Org.BouncyCastle.Security;
using Org.BouncyCastle.X509;
/******
 * 生成数字签名
 * https://stackoverflow.com/questions/47526151/how-to-place-the-same-digital-signatures-to-multiple-places-in-pdf-using-itextsh
 * https://stackoverflow.com/questions/22407897/pdf-digital-signature-in-java-and-signature-verification-in-c-sharp-itext
 * 
 * ******/
namespace ConsoleApp1
{
    class Class1
    {

        public void hand()
        {
            string unsignedPdf = @"C:\log\222.pdf";
            PdfReader reader = new PdfReader(unsignedPdf);
            FileStream os = File.OpenWrite(@"C:\log\111.pdf");
            PdfStamper stamper = PdfStamper.CreateSignature(reader, os, '\0');
            PdfSignatureAppearance appearance = stamper.SignatureAppearance;

            appearance.Reason = "Reason1";
            appearance.Contact = "";
            appearance.Location = "Location1";
            appearance.Acro6Layers = false;
            appearance.Image = null;
            appearance.SignatureRenderingMode = PdfSignatureAppearance.RenderingMode.DESCRIPTION;
            appearance.SetVisibleSignature(new iTextSharp.text.Rectangle(36, 748, 144, 780), 1, null);
            for (int i = 1; i < 8; i++)
            {
                var signatureField = PdfFormField.CreateSignature(stamper.Writer);
                var signatureRect = new Rectangle(200, 200, 100, 100);
                signatureField.Put(PdfName.T, new PdfString("ClientSignature_" + i.ToString()));
                PdfIndirectReference PRef = stamper.Writer.PdfIndirectReference;
                signatureField.Put(PdfName.V, PRef);
                signatureField.Put(PdfName.F, new PdfNumber("132"));
                signatureField.SetWidget(signatureRect, null);
                signatureField.Put(PdfName.SUBTYPE, PdfName.WIDGET);

                PdfDictionary xobject1 = new PdfDictionary();
                PdfDictionary xobject2 = new PdfDictionary();
                xobject1.Put(PdfName.N, appearance.GetAppearance().IndirectReference);
                xobject2.Put(PdfName.AP, xobject1);
                signatureField.Put(PdfName.AP, xobject1);
                signatureField.SetPage();
                PdfDictionary xobject3 = new PdfDictionary();
                PdfDictionary xobject4 = new PdfDictionary();
                xobject4.Put(PdfName.FRM, appearance.GetAppearance().IndirectReference);
                xobject3.Put(PdfName.XOBJECT, xobject4);
                signatureField.Put(PdfName.DR, xobject3);

                stamper.AddAnnotation(signatureField, i);
            }

            IExternalSignatureContainer external = new ExternalBlankSignatureContainer(PdfName.ADOBE_PPKMS, PdfName.ADBE_PKCS7_DETACHED);
            MakeSignature.SignExternalContainer(appearance, external, 8192);
            stamper.Close();

            byte[] SignedHash = SHA256Managed.Create().ComputeHash(appearance.GetRangeStream());
            os.Close();
            reader.Close();
        }
    }
    public class AllPagesSignatureContainer : IExternalSignatureContainer
    {
        public AllPagesSignatureContainer(PdfSignatureAppearance appearance, IExternalSignature externalSignature, ICollection<X509Certificate> chain)
        {
            this.appearance = appearance;
            this.chain = chain;
            this.externalSignature = externalSignature;
        }

        public void ModifySigningDictionary(PdfDictionary signDic)
        {
            signDic.Put(PdfName.FILTER, PdfName.ADOBE_PPKMS);
            signDic.Put(PdfName.SUBFILTER, PdfName.ADBE_PKCS7_DETACHED);

            PdfStamper stamper = appearance.Stamper;
            PdfReader reader = stamper.Reader;
            PdfDictionary xobject1 = new PdfDictionary();
            PdfDictionary xobject2 = new PdfDictionary();
            xobject1.Put(PdfName.N, appearance.GetAppearance().IndirectReference);
            xobject2.Put(PdfName.AP, xobject1);

            PdfIndirectReference PRef = stamper.Writer.PdfIndirectReference;
            PdfLiteral PRefLiteral = new PdfLiteral((PRef.Number + 1 + 2 * (reader.NumberOfPages - 1)) + " 0 R");

            for (int i = 1; i < reader.NumberOfPages; i++)
            {
                var signatureField = PdfFormField.CreateSignature(stamper.Writer);

                signatureField.Put(PdfName.T, new PdfString("ClientSignature_" + i.ToString()));
                signatureField.Put(PdfName.V, PRefLiteral);
                signatureField.Put(PdfName.F, new PdfNumber("132"));
                signatureField.SetWidget(appearance.Rect, null);
                signatureField.Put(PdfName.SUBTYPE, PdfName.WIDGET);

                signatureField.Put(PdfName.AP, xobject1);
                signatureField.SetPage();
                Console.WriteLine(signatureField);

                stamper.AddAnnotation(signatureField, i);
            }
        }

        public byte[] Sign(Stream data)
        {
            String hashAlgorithm = externalSignature.GetHashAlgorithm();
            PdfPKCS7 sgn = new PdfPKCS7(null, chain, hashAlgorithm, false);
            Org.BouncyCastle.Crypto.IDigest messageDigest = DigestUtilities.GetDigest(hashAlgorithm);
            byte[] hash = DigestAlgorithms.Digest(data, hashAlgorithm);
            byte[] sh = sgn.getAuthenticatedAttributeBytes(hash, null, null, CryptoStandard.CMS);
            byte[] extSignature = externalSignature.Sign(sh);
            sgn.SetExternalDigest(extSignature, null, externalSignature.GetEncryptionAlgorithm());
            return sgn.GetEncodedPKCS7(hash, null, null, null, CryptoStandard.CMS);
        }

        PdfSignatureAppearance appearance;
        ICollection<X509Certificate> chain;
        IExternalSignature externalSignature;
    }
    public class MyExternalSignatureContainer : IExternalSignatureContainer
    {
        private readonly byte[] signedBytes;

        public MyExternalSignatureContainer(byte[] signedBytes)
        {
            this.signedBytes = signedBytes;
        }

        public byte[] Sign(Stream data)
        {
            return signedBytes;
        }

        public void ModifySigningDictionary(PdfDictionary signDic)
        {
        }
    }
}
