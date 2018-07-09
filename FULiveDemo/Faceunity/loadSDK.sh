#!/bin/sh
basepath=${0%/*}
echo $1
cd "$basepath"
cd FaceUnity-SDK-iOS
filename=libnama.a
echo "----------------------------------------------------------------------"

grep -q "version https://git-lfs.github.com/" $filename
if [ $? -eq 0 ];then
echo ""
echo "----当前 libnama.a 为 git-lfs 服务器上的文件指针，需下载原文件后才能使用。----"
echo ""
fi

#如果libnama.a不存在，直接下载
if ! [ -f "$filename" ]
then
echo ""
echo "------------------libnama.a 不存在，需下载后才能使用。----------------------"
echo ""
fi

echo ""
echo "--------------------------download libnama.a-----------------------------"
echo ""
echo "------------------请在libnama.a下载完成后再次运行工程-------------------"
echo ""
curl -o libnama.download "https://media.githubusercontent.com/media/Faceunity/FULiveDemo/dev/FULiveDemo/Faceunity/FaceUnity-SDK-iOS/libnama.a" --retry 5

mdcode=$(md5 libnama.download)
echo $mdcode
if [ ${mdcode##*=}x = "73e64de38955d47cdb023d0ec1bbdf10"x ]; then
echo ""
echo "-----------------------下载成功，请重新运行工程！--------------------------"
echo ""
mv -f libnama.download libnama.a
else
echo ""
echo "---------------------------下载失败，请重试！-----------------------------"
echo ""
rm -f libnama.download
fi
echo "----------------------------------------------------------------------"



