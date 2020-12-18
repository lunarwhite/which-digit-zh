function W = weightInitDebug(fan_out, fan_in)
% 用fan_in初始化图层的权重
% 输入 connections and fan_out
% 输出 connections using a fix set of values

% Set W to zeros
W = zeros(fan_out, 1 + fan_in);

% Initialize W using "sin", this ensures that W is always of the same
% values and will be useful for debugging
W = reshape(sin(1:numel(W)), size(W)) / 10;

end
