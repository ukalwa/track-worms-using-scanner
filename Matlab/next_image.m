function [ file,num,name ] = next_image( files,index,direction )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

file = files(index).name;
num = index;

if(direction > 0)
    endindex = size(files,1);
    index = index+direction;
else
    endindex = 1;
    index = index+direction;
end

for i = index:direction:endindex
    [~,name,ext] = fileparts(files(i).name);
    if(strcmp(ext,'.jpg'))
        file = files(i).name;
        num = i;
        break
    end
end




end

