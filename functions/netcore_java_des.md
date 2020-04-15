C#版：

using System; using System.Security.Cryptography; using System.Text; namespace ConsoleApplication1
{ class EncryptHelper
    { /// <summary>
        /// MD5加密 /// </summary>
        /// <param name="plaintext">明文</param>
        /// <param name="bytesEncoding">编码</param>
        /// <returns></returns>
        public static string MD5Encrypt(string plaintext, Encoding bytesEncoding)
        { byte[] sourceBytes = bytesEncoding.GetBytes(plaintext);
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider(); byte[] hashedBytes = md5.ComputeHash(sourceBytes); return BitConverter.ToString(hashedBytes).Replace("-", "");
        } /// <summary>
        /// 以UTF8编码做MD5加密 /// </summary>
        /// <param name="plaintext">明文</param>
        /// <returns></returns>
        public static string MD5Encrypt(string plaintext)
        { return MD5Encrypt(plaintext, Encoding.UTF8);
        } private const string DefaultDESKey = "loogn789"; /// <summary>   
        /// 利用DES加密算法加密字符串（可解密） /// </summary>   
        /// <param name="plaintext">被加密的字符串</param>   
        /// <param name="key">密钥（只支持8个字节的密钥）</param>   
        /// <returns>加密后的字符串</returns>   
        public static string EncryptString(string plaintext, string key = DefaultDESKey)
        {
            DES des = new DESCryptoServiceProvider();
            des.Key = Encoding.UTF8.GetBytes(key);
            des.IV = Encoding.UTF8.GetBytes(key); byte[] bytes = Encoding.UTF8.GetBytes(plaintext); byte[] resultBytes = des.CreateEncryptor().TransformFinalBlock(bytes, 0, bytes.Length); return Convert.ToBase64String(resultBytes);
        } /// <summary>   
        /// 利用DES解密算法解密密文（可解密） /// </summary>   
        /// <param name="ciphertext">被解密的字符串</param>   
        /// <param name="key">密钥（只支持8个字节的密钥，同前面的加密密钥相同）</param>   
        /// <returns>返回被解密的字符串</returns>   
        public static string DecryptString(string ciphertext, string key = DefaultDESKey)
        {
            DES des = new DESCryptoServiceProvider();
            des.Key = Encoding.UTF8.GetBytes(key);
            des.IV = Encoding.UTF8.GetBytes(key); byte[] bytes = Convert.FromBase64String(ciphertext); byte[] resultBytes = des.CreateDecryptor().TransformFinalBlock(bytes, 0, bytes.Length); return Encoding.UTF8.GetString(resultBytes);
        }
    }
}
 

JAVA版：

package net.loogn.utils; import sun.misc.BASE64Decoder; import sun.misc.BASE64Encoder; import javax.crypto.Cipher; import javax.crypto.SecretKey; import javax.crypto.SecretKeyFactory; import javax.crypto.spec.DESKeySpec; import javax.crypto.spec.IvParameterSpec; import java.security.MessageDigest; /** * Created by loogn on 2016/8/31 0031. */
public class EncryptHelper { public final static String md5(String s) { char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}; try { byte[] btInput = s.getBytes(); // 获得MD5摘要算法的 MessageDigest 对象
            MessageDigest mdInst = MessageDigest.getInstance("MD5"); // 使用指定的字节更新摘要
 mdInst.update(btInput); // 获得密文
            byte[] md = mdInst.digest(); // 把密文转换成十六进制的字符串形式
            int j = md.length; char str[] = new char[j * 2]; int k = 0; for (int i = 0; i < j; i++) { byte byte0 = md[i];
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                str[k++] = hexDigits[byte0 & 0xf];
            } return new String(str);
        } catch (Exception e) {
            e.printStackTrace(); return null;
        }
    } public static String encryptString(String plaintext, String key) throws Exception {
        Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");

        DESKeySpec desKeySpec = new DESKeySpec(key.getBytes("UTF-8"));

        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
        SecretKey secretKey = keyFactory.generateSecret(desKeySpec);
        IvParameterSpec iv = new IvParameterSpec(key.getBytes("UTF-8"));
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, iv); byte[] bt = cipher.doFinal(plaintext.getBytes("UTF-8"));
        String strs = new BASE64Encoder().encode(bt); return strs;
    } public static String decryptString(String ciphertext, String key) throws Exception {
        Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
        DESKeySpec desKeySpec = new DESKeySpec(key.getBytes("UTF-8"));
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
        SecretKey secretKey = keyFactory.generateSecret(desKeySpec);
        IvParameterSpec iv = new IvParameterSpec(key.getBytes("UTF-8"));
        cipher.init(Cipher.DECRYPT_MODE, secretKey, iv); byte[] bt = cipher.doFinal(new BASE64Decoder().decodeBuffer(ciphertext));
        String strs = new String(bt); return strs;
    }
}