function p = dataPredict(Theta1, Theta2, X)
% 输入：权值theta1 theta2，测试集X
% 返回：计算出的y

% 变量初始化
m = size(X, 1);
num_labels = size(Theta2, 1);

% 前向传播
p = zeros(size(X, 1), 1);
h1 = Sigmoid([ones(m, 1) X] * Theta1');
h2 = Sigmoid([ones(m, 1) h1] * Theta2');

% 取最大值作为预测值
[~, p] = max(h2, [], 2);

end
