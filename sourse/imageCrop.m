function bw2 = imageCrop(bw,~)

% 找到图像边界，提取边界
[y2temp, x2temp] = size(bw);
x1=1;
y1=1;
x2=x2temp;
y2=y2temp;

flag=30;

% 左边
cntB=1;
while (sum(bw(:,cntB))<=flag)

    x1=x1+1;
    cntB=cntB+1;
end
 
% 右边
cntB=1;
while (sum(bw(cntB,:))<=flag)
   y1=y1+1;
   cntB=cntB+1;
end
 
% 上边
cntB=x2temp;
while (sum(bw(:,cntB))<=flag)
   x2=x2-1;
   cntB=cntB-1;
end
 
% 下边
cntB=y2temp;
while (sum(bw(cntB,:))<=flag)
   y2=y2-1;
   cntB=cntB-1;
end

% 裁剪
bw2=imcrop(bw,[x1,y1,(x2-x1),(y2-y1)]);

end
