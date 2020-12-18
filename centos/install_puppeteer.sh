


# 安装cnpm，以使用淘宝镜像（用npm直接安装puppeteer会报错...）
npm install -g cnpm --registry=https://registry.npm.taobao.org

 

# 全局安装 puppeteer
cnpm install -g puppeteer

 

# 依赖库
yum install pango.x86_64 libXcomposite.x86_64 libXcursor.x86_64 libXdamage.x86_64 libXext.x86_64 libXi.x86_64 libXtst.x86_64 cups-libs.x86_64 libXScrnSaver.x86_64 libXrandr.x86_64 GConf2.x86_64 alsa-lib.x86_64 atk.x86_64 gtk3.x86_64 -y

 

# 字体
yum install ipa-gothic-fonts xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-utils xorg-x11-fonts-cyrillic xorg-x11-fonts-Type1 xorg-x11-fonts-misc -y

wget https://storage.googleapis.com/chromium-browser-snapshots/Linux_x64/706915/chrome-linux.zip


## /usr/local/lib/nodejs/node-v15.2.0-linux-x64/lib/node_modules/puppeteer/.local-chromium/linux-818858/chrome-linux

# 忽略Chromium安装
npm install puppeteer --ignore-scripts --save
# 下载一个Chromium放到指定位置

# mac: 'https://storage.googleapis.com/chromium-browser-snapshots/Mac/%d/chrome-mac.zip',
# win32: 'https://storage.googleapis.com/chromium-browser-snapshots/Win/%d/chrome-win32.zip',
# win64: 'https://storage.googleapis.com/chromium-browser-snapshots/Win_x64/%d/chrome-win32.zip',

# 下载时将%d替换为具体编号，编号可以在node_modules/puppeteer/package.json中puppeteer.chromium_revision获得。拼接好链接后直接在浏览器就可以直接下载了（当然，你得科学上网才可以）。

# 下载后上传到服务器，存储位置为node_modules/puppeteer/.local-chromium/linux-%d，.local-chromium/linux-%d文件夹需要自己创建，同样将%d替换为具体编号。将下载的Chromium压缩包上传到该位置后解压。


# https://stackoverflow.com/questions/52993002/headless-chrome-node-api-and-puppeteer-installation
# sudo apt-get install gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget