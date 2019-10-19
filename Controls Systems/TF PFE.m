%
%
%     Prints the Partial Fraction Expansion
%     of a Transfer Function (1x1 tf)
%
%

function dispPFE(my_tf)

    [my_num, my_den] = tfdata(my_tf);
    my_num = cell2mat(my_num);
    my_den = cell2mat(my_den);

    [my_r, my_p] = residue(my_num, my_den);

    line1 = "       ";
    line2 = "Y(s) = ";
    line3 = "       ";

    for n = 1:length(my_r)

        valP = my_p(n);
        valR = my_r(n);

        sP = num2str([real(valP) imag(valP)], '%.4f%+.4fj');
        sR = num2str([real(valR) imag(valR)], '%.4f%+.4fj');

        numD = 4 + strlength(sP);

        div = "";
        for i = 1:(numD+2)
            div = div + "-";
        end

        head = "";
        for i = 1:((numD+2-strlength(sR))/2)
            head = head + " ";
        end
        tail = "";
        for i = 1:(strlength(div)-strlength(head)-strlength(sR))
            tail = tail + " ";
        end

        line1 = line1 + head + sR + tail;
        line2 = line2 + div;
        line3 = line3 + " s-(" + sP + ") ";

        if(n<length(my_r))
            line1 = line1 + "     ";
            line2 = line2 + "  +  ";
            line3 = line3 + "     ";
        end

    end

    fprintf("%s\n%s\n%s", line1, line2, line3)

end
