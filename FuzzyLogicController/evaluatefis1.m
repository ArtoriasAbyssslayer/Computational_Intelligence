function y = evaluatefis1(fis,x)
    %#codegen
    opt = evalfisOptions('NumSamplePoints',51);
    y = evalfis(fis,x,opt);
end
