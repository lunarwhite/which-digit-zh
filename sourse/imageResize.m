function lett = imageResize(bw2)
% 提取特征，转成20*20的特征矢量,把图像中每10*10的点进行划分相加，进行相加成一个点
% 即统计每个小区域中图像象素所占百分比作为特征数据

% 其实就是提取特征，进行图片缩放

bw_2020=imresize(bw2,[200,200]);

for cnt=1:20
   for cnt2=1:20
       data_temp=bw_2020(((cnt*10-9):(cnt*10)),((cnt2*10-9):(cnt2*10)));
       atemp=sum(data_temp);
       lett((cnt-1)*20+cnt2)=sum(atemp);
   end
end

lett=lett';

end

