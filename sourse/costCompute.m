function [J, grad] = costCompute(nn_params, input_layer_size, hidden_layer_size, num_labels, X, y, lambda)

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), hidden_layer_size, (input_layer_size + 1));
Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), num_labels, (hidden_layer_size + 1));

% m为训练样本个数
m = size(X, 1);
         
% 两个权值矩阵的梯度，代价函数的初始化
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% 初始化独热编码
yNum = zeros(m, num_labels);

% 转换独热编码
for i = 1:m
  yNum(i, y(i)) = 1;
end

% 开始训练
a1 = X;

% 第一层结果的计算
z2 = (Theta1 * [ones(m, 1) a1]')';
a2 = Sigmoid(z2);

% 第二层结果的计算
z3 = (Theta2 * [ones(m, 1) a2]')';
a3 = Sigmoid(z3);

for i = 1:m
  J = J + (-yNum(i, :) * log(a3(i, :))' - (1.- yNum(i, :)) * log(1.- a3(i, :))');%前向传播的过程
end

J = J / m;

%正则化防止过拟合
t1 = Theta1(:, 2:end);
t2 = Theta2(:, 2:end);

%正则化项
regularization = lambda / (2 * m) * (sum(sum(t1 .^ 2)) + sum(sum(t2 .^ 2)));
J = J + regularization;

% 反向传播
d3 = a3-yNum;

d2 = (d3 * Theta2(:, 2:end)) .* SigmoidGradient(z2);

a2_with_a0 = [ones(m, 1) a2];
D2 = d3' * a2_with_a0;

%Theta2梯度
Theta2_grad = D2 / m;

%正则化项
regularization = lambda / m * [zeros(size(Theta2, 1), 1) Theta2(:, 2:end)];
Theta2_grad = Theta2_grad + regularization;

% 200 x 401 Theta1_grad
a1_with_a0 = [ones(m, 1) a1];
D1 = d2' * a1_with_a0;
Theta1_grad = D1 / m;
regularization = lambda / m * [zeros(size(Theta1, 1), 1) Theta1(:, 2:end)];
Theta1_grad = Theta1_grad + regularization;

% 将梯度放在一个矩阵里面
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
