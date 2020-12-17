function W = weightInit(L_in, L_out)
% 将权重随机初始化为小值

r = rand(L_out, 1 + L_in);
x = 0.12;
W = r * x * 2 - x;

end
