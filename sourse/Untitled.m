%% 直接运行 main.m 即可
Files= dir('D:\MEDESKTOP\手写src\data2\handwritingPictures');
LengthFiles= length(Files);

for i = 3:LengthFiles 
     if strcmp(Files(i).name,'.')||strcmp(Files(i).name,'..')
     else        
Img = imread(strcat('D:\MEDESKTOP\手写src\data2\handwritingPictures','/',Files(i).name));

X(i,:) = (Img(:))';%将图片转换为矩阵形式存储进X
kkk= strsplit(Files(i).name,{'_','.'});
Y(i) = str2double(cell2mat(kkk(4)));%将图片的label存储进Y
     end
end

%rand_indices = randperm(LengthFiles);
%sel1=X(rand_indices(1:25),:);
%displayData(sel1);

for i=1:15000
    I1 = X(i+2,:);%读取矩阵第i行（第i张图片）
    Ibw = im2bw(I1,graythresh(I1)); %对I1进行二值化处理
    bw2 = edu_imgcrop(Ibw);%对图像进行裁剪，使边框完全贴紧字符
    charvec = edu_imgresize(bw2);%提取特征值
    charvec1(:,i)=charvec;%特征值(纵向数组)存入矩阵 charvec1
end

Y =charvec1';%转置charvec1，变成横向数组
X_cut2=fastPCA(Y,20);%对Y进行PCA降维

%随机输出X_cut2中的25张图
rand_indices = randperm(LengthFiles-2);
sel2=X_cut2(rand_indices(1:25),: );
displayData(sel2);
