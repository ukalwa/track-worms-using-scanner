%SCN motility analysis
clc
clear all
close all

%% Select a directory containing images
if(exist('init_motilityAnalysis.mat','file'))
    load('init_motilityAnalysis.mat','prev_path');
    direct = uigetdir([prev_path,'\..']);
    prev_path = direct;
else
    direct = uigetdir; 
    prev_path = direct;
end
save('init_motilityAnalysis.mat','prev_path');

%% Read in images from directory
if(direct == 0)
    disp('No directory was selected');
    return
end
efile = [direct,'.xls'];
if(~exist(efile,'file'))
    disp('The excel file cannot be read or is missing')
    return;
end

files = dir(direct);
vido = VideoWriter([efile(1:end-4),'_motile.avi'],'Uncompressed AVI');
vido.FrameRate = 2;
open(vido);

%% Read in excel file
data = xlsread(efile);
efile2 = [efile(1:end-4),'_motile.xls'];

%% Create excel write variable
output = cell(3,size(data,2)/2);
output(1,1) = {'Percent Active'};

%% Loop through frames and indicate non motile worms
num = 1;
for j = 1:2:size(data,2)-1
	%copy first frame
	if(j==1)
		[image_file,num] = next_image(files,num,1);
		image = imread([direct,'\',image_file]);
		imshow(image);
		%random plot to make code work...
		hold on;
		index_prev = find(isnan(data(:,j)),1,'first');
		if(isempty(index_prev))
			index_prev = size(data,1);
		else
			index_prev = index_prev-1;
		end
		for y = 1:index_prev
			plot(data(y,j),data(y,j+1),'go','linewidth',5,'MarkerSize',15);
		end
		pause(.01);
		frame = getframe;
		writeVideo(vido,frame);
	else
		image = imread([direct,'\',files((j+1)/2+2).name]);
		clf('reset')
		imshow(image);
		hold on;
		index_prev = find(isnan(data(:,j-2)),1,'first');
		index_curr = find(isnan(data(:,j)),1,'first');
		if(isempty(index_prev))
			index_prev = size(data,1);
		else
			index_prev = index_prev-1;
		end
		if(isempty(index_curr))
			index_curr = size(data,1);
		else
			index_curr = index_curr - 1;
		end
		for y = 1:index_curr
			plot(data(y,j),data(y,j+1),'bo','linewidth',5,'MarkerSize',15);
		end
		
		curr_data = data(1:index_curr,j:j+1);
		prev_data = data(1:index_prev,j-2:j-1);
		count = 0;
		for k = 1:size(curr_data,1)
			dist = zeros(size(prev_data,1),1);
			for y = 1:size(prev_data,1)
				dist(y,1) = sqrt((prev_data(y,1)-curr_data(k,1))^2+(prev_data(y,2)-curr_data(k,2))^2);
			end
			[val,ind] = min(dist);
			if(val < 30)
				plot(data(k,j),data(k,j+1),'ro','linewidth',5,'MarkerSize',15);
				prev_data(ind,:) = [];
				count = count + 1;
			end
		end
		if((index_curr-count)>0)
			output(2,(j+1)/2) = {(index_curr-count)/index_curr*100};
		else
			output(2,(j+1)/2) = {0};
		end
		output(3,(j+1)/2) = {index_curr};
		frame = getframe;
		writeVideo(vido,frame)
		hold off;
	end
end

xlswrite(efile2,output);
close(vido);
close all;
disp('Completed');
beep