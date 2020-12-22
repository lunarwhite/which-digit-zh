function numgrad = gradientCompute(J, theta)
% 返回：梯度的数值估计  
% from: Andrew Ng's exercises

e = 1e-4;
numgrad = zeros(size(theta));
perturb = zeros(size(theta));

for p = 1:numel(theta)
    % 设置扰动向量
    perturb(p) = e;
    loss1 = J(theta - perturb);
    loss2 = J(theta + perturb);
    
    % 计算数值梯度
    numgrad(p) = (loss2 - loss1) / (2*e);
    perturb(p) = 0;
end

end
