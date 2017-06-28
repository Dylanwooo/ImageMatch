function R = correlation(win1, win2, wSize)
    R = 0;
    R1 = 0;
    R2 = 0;
    winMean1 = 0;
    winMean2 = 0;
    for i=1:wSize*wSize
        winMean1 = winMean1 + win1(i);
        winMean2 = winMean2 + win2(i);
    end
    winMean1 = winMean1 / (wSize * wSize);
    winMean2 = winMean2 / (wSize * wSize);
    for i=1:wSize*wSize
        R = R + (win1(i)-winMean1)*(win2(i)-winMean2);
    end
    for i=1:wSize*wSize
        R1 = R + (win1(i)-winMean1)^2;
    end
    for i=1:wSize*wSize
        R2 = R + (win2(i)-winMean2)^2;
    end
    R = R/sqrt(R1 * R2);
end