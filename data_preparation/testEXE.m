currentPath = pwd;
libPath='E:\\Dropbox\\GaitPaper1\\OptiTrack\\Klaudia_MARS\\RevisionPLOS\\GaitTrends\\libs\\'
cd(libPath)

cmd='surrogates.exe &'
%!surrogates.exe -o out.txt -m 2 -I 563 in.txt
%system('surrogates.exe &')
system(cmd)
cd(currentPath)

%%
cmd = sprintf('cd "%s" & runner.exe &');
system(cmd);

%%
cmd= strcat('surrogates.exe -o',{' '},pwd,'\out.txt -m 2 -I 563',{' '},pwd, '\in.txt',{' '},'&') 
system(cmd{1})
% cd(currentPath)