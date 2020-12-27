%% 准备工作，清空工作区
clear; 
close all; 
clc;
newline;

%% 准备工作，导入并预处理data
disp('——>数据导入ing...');
path_data = 'D:\MEDESKTOP\089\group089--project2\data2\handwritingPictures\';

files = dir(fullfile(path_data,'*.jpg'));
m = length(files);
n = 400;

y = zeros(m, 1);
X = zeros(m, n);

for i = 1 : m
    Img = imread(strcat(path_data,files(i).name));        

    Img = imageCrop(Img);
    Img = imbinarize(Img,0.1);
    Img = imcomplement(Img);
    Img = imageResize(Img);
    Img = reshape(Img,20,20);

    kkk = strsplit(files(i).name, {'_', '.'});
    id = str2double(cell2mat(kkk(4)));
    y(i, :) = id;
    X(i, :) = (Img(:))';
end

for i = 1 : m
    minn = min(X(i, :));
    meann = mean(X(i,:));
    maxx = max(X(i, :));
    X(i, :) = (X(i, :) - meann) / (maxx - minn);
end

R = randperm(m);
num_train = 10000;

X_train = X(R(1:num_train), :);
y_train = y(R(1:num_train), :);

R(1:num_train) = [];

X_test = X(R, :);
y_test = y(R, :);

disp('——>完成！');
fprintf('\n\n');

disp('——>数据预处理ing...');
m = size(X_train, 1);

% disp('@预处理过的图片可视化（参见figure）');
% a = size(X_train,1);
% sel = randperm(a);
% sel = sel(1:900);
% dataView(X_train(sel, :));

disp('——>完成！');
fprintf('\n\n');

%% 准备工作，设置权值矩阵
disp('——>权值矩阵设置ing...');
L_out1=200;
L_in1=400;
L_out2=15;
L_in2=200;

% 初始化Theta
Theta1 = zeros(L_out1, 1 + L_in1);
Theta2 = zeros(L_out2, 1 + L_in2);

% 随机初始化Theta，使其符合正态分布
Theta1 = weightInit(L_in1, L_out1);
Theta2 = weightInit(L_in2, L_out2);

% save('weight.mat','Theta1','Theta2');

% load('weights.mat');%两个权值矩阵，theta1和theta2

nn_params = [Theta1(:) ; Theta2(:)];%变成一列

disp('——>完成！');
fprintf('\n\n');

%% 神经网络，前向传播测试

% 设置隐藏神经元个数，输入，输出
input_layer_size  = 400;  % 20*20
hidden_layer_size =200;   % 200的隐层神经元
num_labels = 15;          % 15个标签，表示零到亿

disp('@前向传播')

% 先设置正则化超参数lambda为0
lambda = 0;
% 第一个参数是权值矩阵，第二个参数是输入层的神经元个数400，
% 第三个参数是隐层的神经元个数200，第四个参数是输出的个数，
% X是输入的样本y是标签不过不是独热码的形式而是1,2,3,4...的形式，lambda是正则化超参
J = costCompute(nn_params, input_layer_size, hidden_layer_size, num_labels, X_train, y_train, lambda);

fprintf('计算代价J: %f\n\n\n', J);

%% 神经网络，添加正则化
disp('@添加正则化1');

% 首先将正则化前面的常数设置成1.
lambda = 1;
J = costCompute(nn_params, input_layer_size, hidden_layer_size, num_labels, X_train, y_train, lambda);

fprintf('计算代价J: %f\n\n\n', J);

%% 神经网络，随机初始化权值
disp('——>随机初始化权值ing...');

initial_Theta1 = weightInit(input_layer_size, hidden_layer_size);
initial_Theta2 = weightInit(hidden_layer_size, num_labels);

% 放在一个矩阵中
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

disp('——>完成！');
fprintf('\n\n');

%% 神经网络，反向传播梯度检验
disp('——>反向传播梯度检验ing...');

gradientCheck;
disp('——>完成！');
fprintf('\n\n');

%% 神经网络，添加反向传播正则化
disp('@添加正则化2');

lambda = 0.01;
% gradientCheck(lambda);
debug_J  = costCompute(nn_params, input_layer_size, hidden_layer_size, num_labels, X_train, y_train, lambda);

% 有lambda的反向传播代价
fprintf('代价J: %f\n\n', debug_J);

%% 神经网络，训练
disp('——>神经网络训练ing...');

% 设置正则化超参数
numinput1 = input('-->请输入正则化超参数，按回车提交：');
lambda = numinput1;

% 设置迭代次数
numinput2 = input('-->请输入迭代次数，按回车提交：');
Iterations = numinput2;

options = optimset('MaxIter', Iterations);

% 一次迭代
costFunction = @(p) costCompute(p, input_layer_size, hidden_layer_size, num_labels, X_train, y_train, lambda);

% 迭代函数
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% 训练好的Theta1和Theta2
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), hidden_layer_size, (input_layer_size + 1));
Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), num_labels, (hidden_layer_size + 1));

disp('——>完成！');
fprintf('\n\n');

%% 神经网络，权值可视化，中间层输出可视化
% disp('@权值可视化（参见figure）');
% dataView(Theta1(:, 2:end));
% fprintf('\n\n');

%% 评估模型，给出准确率
disp('@模型准确率');

thisPrediction1 = dataPredict(Theta1, Theta2, X_train);
thisPrediction2 = dataPredict(Theta1, Theta2, X_test);
acc_train=mean(double(thisPrediction1 == y_train));
acc_test= mean(double(thisPrediction2 == y_test));
fprintf('——>在训练集上的表现： %f\n', acc_train);
fprintf('——>在测试集上的表现： %f\n\n', acc_test);

disp('——>演示结束，thanks~~');