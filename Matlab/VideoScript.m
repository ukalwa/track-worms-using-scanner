%make video script
%first select images
% Folder already set by the parent script
files = dir(folder);
%next select excel file
efile = [folder,'.xls'];
data = xlsread(efile,1);
%% generate video of the recorded positions of the worms overlayed on the scanned images
close all
vido = VideoWriter([efile(1:end-3),'avi'],'Uncompressed AVI');
vido.FrameRate = 2;

open(vido)
index = 1;
for i = 1:length(files)
    [PATHSTR,NAME,EXT] = fileparts([folder,'\',files(i).name]);
    if(strcmp(EXT,'.jpg'))
        image = imread([folder,'\',files(i).name]);
        imshow(image,'border','tight');
        hold on;
        if(size(data,2)>=index*2)
            plot(data(:,index*2-1),data(:,index*2),'ro');
        end
        frame = getframe(gcf);
        writeVideo(vido,frame);
        hold off
        index = index+1;
    end
end

close(vido);
close all