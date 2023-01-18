function base_script2()
    fig = figure;
    fslid = uicontrol(fig, 'Style', 'slider', 'Units', 'normalized','Position', [0.002 0 0.0400 0.02]);
    fslid.SliderStep = [1/3 1];
    fslid.Value = 2/3; fslid.Callback = @changefsize;

    tobj = uicontrol(fig, 'Style', 'text', 'Units', 'normalized', 'Position', [0.5 0.5 0.15 0.05]);
    tobj.String = 'Generic Text'; tobj.Tag = 'tx';

    function changefsize(fslid,~)
    obj = findobj('Tag','tx');
    choice = fslid.Value;
        if abs(choice-1/3)< 10^(-3)
            obj.FontSize = 8;
        elseif abs(choice-2/3)< 10^(-3)
            obj.FontSize = 10;
        else
            obj.FontSize = 12;
        end
    end
end