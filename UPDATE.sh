#!/bin/bash
distro=$1
if [ -z ${distro+x} ]; then 
    distro='master'
fi
rm -rf $distro master_temp
wget https://github.com/ShinobiCCTV/Shinobi/tarball/$distro
mkdir master_temp
tar -xzf $distro -C master_temp --strip-components=1
pm2 stop camera.js
pm2 stop cron.js
pm2 kill
mv master_temp/UPDATE.sh UPDATE.sh
chmod +x UPDATE.sh
sed -i 's/\r//' UPDATE.sh
mv master_temp/languages languages
mv master_temp/definitions definitions
mv master_temp/web web
mv master_temp/LICENSE LICENSE
mv master_temp/COPYING COPYING
mv master_temp/package.json package.json
mv master_temp/camera.js camera.js
mv master_temp/cron.js cron.js
mv master_temp/plugins/motion/shinobi-motion.js plugins/motion/shinobi-motion.js
mv master_temp/plugins/opencv/shinobi-opencv.js plugins/motion/shinobi-opencv.js
npm install
rm -rf $distro master_temp
pm2 start camera.js
pm2 start cron.js
if [ ! -f plugins/motion/conf.json ]; then
    pm2 start plugins/motion/shinobi-motion.js
fi