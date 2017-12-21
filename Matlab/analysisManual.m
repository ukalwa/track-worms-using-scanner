clc
clear all
close all
folder=uigetdir;
files=dir(folder);
%setting these variables should no longer be necessary
%numRows = 5;
%numCols = 5;

index = find(folder=='\',1,'last');
excelName=[folder(index+1:end),'.xls'];
excelName=[folder(1:index),excelName];

[image,index] = next_image(files,1,1);
while(~isempty(image))
    [~,temp] = next_image(files,index,1);
    if(temp == index)
        break
    end
    if(temp)
        index = temp;
    end  
end
numFiles = index;

worms = cell(500,numFiles*2);
%check if excel file exists
if(exist(excelName,'file'))
    [~,~,raw] = xlsread(excelName);
    for i = 1:size(raw,1)
        for j = 1:size(raw,2)
            if(~isnan(cell2mat(raw(i,j))))
                worms(i,j+4) = raw(i,j);
            else
                worms(i,j+4) = {[]};
            end
        end
    end
end
fig_h = figure;

[image,index] = next_image(files,1,1);

image = imread([folder,'\',image]);
numRows = ceil(size(image,1)./650);
numCols = ceil(size(image,2)./650);

imshow(image);
hold on
%divide picture into subsections
indexesRow = ones(numRows);
indexesCol = ones(numCols);

count = 1;
sectors = cell(1,numCols*numRows);

for j = 1:numRows
    for k = 1:numCols
        if(j==1 && k==1)
            sectors(count) = {[1,1;fix(size(image,1)/numRows*j),fix(size(image,2)/numCols*k)]};
        elseif(j==1)
            sectors(count) = {[1,fix(size(image,2)/numCols*(k-1));fix(size(image,1)/numRows*j),fix(size(image,2)/numCols*k)]};
        elseif(k==1)
            sectors(count) = {[fix(size(image,1)/numRows*(j-1)),1;fix(size(image,1)/numRows*j),fix(size(image,2)/numCols*k)]};
        else
            sectors(count) = {[fix(size(image,1)/numRows*(j-1)),fix(size(image,2)/numCols*(k-1));fix(size(image,1)/numRows*j),fix(size(image,2)/numCols*k)]};
        end   
        count = count+1;
    end
end

sectorI = 1;
clf('reset');
imshow(image(sectors{sectorI}(1,1):sectors{sectorI}(2,1),sectors{sectorI}(1,2):sectors{sectorI}(2,2),:),'Border','tight');


while(1)
    k = waitforbuttonpress;
    if(k==0)
        type = get(fig_h,'SelectionType');
        switch type
            case 'alt'
                key = 'right click';
            case 'normal'
                key = 'left click';
        end
    else
        key = get(fig_h,'CurrentKey');
    end
    
    switch key
        case 'e'
            %clf('reset')
            [image,index] = next_image(files,index,1);
            image = imread([folder,'\',image]);
            
            
        case 'q'
            %clf('reset')
            [image,index] = next_image(files,index,-1);
            image = imread([folder,'\',image]);
            
            
        case 'a'
            clf('reset')
            if(sectorI>1)
                sectorI = sectorI-1;
            end
            
        case 'd'
            clf('reset')
            if(sectorI < length(sectors))
                sectorI = sectorI+1;
            end
            
        case 'w'
            clf('reset')
            if(sectorI-numCols>0)
                sectorI = sectorI - numCols;
            end
            
        case 's'
            clf('reset')
            if(sectorI+numCols<length(sectors)+1)
                sectorI = sectorI + numCols;
            end
            
        case 'escape'
            break;
            
        case 'left click'
            tempimage = image(sectors{sectorI}(1,1):sectors{sectorI}(2,1),sectors{sectorI}(1,2):sectors{sectorI}(2,2),:);
            point = get(fig_h,'CurrentPoint');
            col = point(1);
            row = size(tempimage,1)-point(2);
            col = col+sectors{sectorI}(1,2);
            row = row+sectors{sectorI}(1,1);
            s = find(cell2mat(worms(:,index*2-1)),1,'last');
            if(~isempty(s))
                s = s+1;
            else
                s=1;
            end
            worms(s:s+length(col)-1,index*2-1:index*2) = num2cell([col,row]);
            
        case 'right click'
            tempimage = image(sectors{sectorI}(1,1):sectors{sectorI}(2,1),sectors{sectorI}(1,2):sectors{sectorI}(2,2),:);
            point = get(fig_h,'CurrentPoint');
            row = size(tempimage,1)-point(2);
            col = point(1)+sectors{sectorI}(1,2);
            row = row+sectors{sectorI}(1,1);
            data = cell2mat(worms(:,index*2-1:index*2));
            dist = zeros(size(data,1),1);
            for i = 1:size(data,1)
                dist(i,1) = sqrt((data(i,1)-col)^2+(data(i,2)-row)^2);
            end
            [val,ind] = min(dist);
            if(val < 5)
                worms(ind:end-1,index*2-1:index*2) = worms(ind+1:end,index*2-1:index*2);
            end
            
    end
    set(fig_h,'Name',['Frame ',num2str(index-2)],'NumberTitle','off')
    imshow(image(sectors{sectorI}(1,1):sectors{sectorI}(2,1),sectors{sectorI}(1,2):sectors{sectorI}(2,2),:),'Border','tight');
    
    s = find(cell2mat(worms(:,index*2-1)),1,'first');
    f = find(cell2mat(worms(:,index*2-1)),1,'last');
    if(~isempty(s))
        points = cell2mat(worms(s:f,index*2-1:index*2));
        points(:,1) = points(:,1) - sectors{sectorI}(1,2);
        points(:,2) = points(:,2) - sectors{sectorI}(1,1);
        hold on;
        plot(points(:,1),points(:,2),'ro');
    end
    hold off
    title(index-2)
end

imshow(image)
s = find(cell2mat(worms(:,index*2-1)),1,'first');
f = find(cell2mat(worms(:,index*2-1)),1,'last');
if(~isempty(s))
    points = cell2mat(worms(s:f,index*2-1:index*2));
    hold on;
    plot(points(:,1),points(:,2),'r*');
end

disp('writing excel file')
copyfile('4hr_15min_24hr_1hr_template.xls',excelName)
xlswrite(excelName,worms(:,5:end),1);

%automate the counting of # of worms
[~,~,raw] = xlsread(excelName,'Number of Worms');
data = xlsread(excelName);
numWorms = zeros(length(raw)-1,1);
for i = 1:length(numWorms)
    if(size(data,2)>=i*2)
        temp = data(:,i*2);
        numWorms(i,1) = sum(temp>0);
    else
        numWorms(i,1) = 0;
    end
end
maxNum = max(numWorms);
percentWorms = numWorms./maxNum*100;
raw(2:end,2) = num2cell(numWorms);
raw(2:end,3) = num2cell(percentWorms);
xlswrite(excelName,raw,2);

VideoScript






    