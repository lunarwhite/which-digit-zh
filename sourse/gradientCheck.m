function gradientCheck(lambda)
% 设置一个神经网络进行梯度检测
% 当使用梯度检验的时候，尽量使用小型NN，带有少数量的是输入单元和隐藏单元，因此参数也相对较少
% 当确定梯度计算准确时，关闭梯度检验
% from: Andrew Ng's exercises
disp('计算[数值梯度][解析梯度]');

if ~exist('lambda', 'var') || isempty(lambda)
    lambda = 0;
end

input_layer_size = 3;
hidden_layer_size = 5;
num_labels = 3;
m = 5;

Theta1 = weightInitDebug(hidden_layer_size, input_layer_size);
Theta2 = weightInitDebug(num_labels, hidden_layer_size);
X  = weightInitDebug(m, input_layer_size - 1);
y  = 1 + mod(1:m, num_labels)';

nn_params = [Theta1(:) ; Theta2(:)];

costFunc = @(p) costCompute(p, input_layer_size, hidden_layer_size, ...
                               num_labels, X, y, lambda);

[~, grad] = costFunc(nn_params);
numgrad = gradientCompute(costFunc, nn_params);

disp([numgrad grad]);

disp('check1--两栏数值是否非常接近');

disp('计算[Relative Difference]');

diff = norm(numgrad-grad)/norm(numgrad+grad);
fprintf('%g\n\n', diff);

disp('check2--数值是否小于 1e-9');

end