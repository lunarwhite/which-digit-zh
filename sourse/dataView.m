function [h, display_array] = dataView(X, example_width)
%将矩阵转换成的图片显示出来

if ~exist('example_width', 'var') || isempty(example_width) 
	example_width = round(sqrt(size(X, 2)));
end

% 灰度图
colormap(gray);

% 计算行列
[m, n] = size(X);
example_height = (n / example_width);

display_rows = floor(sqrt(m));
display_cols = ceil(m / display_rows);

% 图像之间填充
pad = 1;

% 设置空白显示
display_array = - ones(pad + display_rows * (example_height + pad), pad + display_cols * (example_width + pad));

% 将每个示例复制到显示阵列上的修补程序中
curr_ex = 1;
for j = 1:display_rows
	for i = 1:display_cols
		if curr_ex > m
			break; 
        end
        
		max_val = max(abs(X(curr_ex, :)));
		display_array(pad + (j - 1) * (example_height + pad) + (1:example_height), ...
		              pad + (i - 1) * (example_width + pad) + (1:example_width)) = ...
						reshape(X(curr_ex, :), example_height, example_width) / max_val;
		curr_ex = curr_ex + 1;
	end
	if curr_ex > m 
		break; 
	end
end

% 显示图像
h = imagesc(display_array, [-1 1]);
axis image off
view(-90,-90);
drawnow;

end
