neuromat = '/home/paulo/Documents/PauloPosDoc/Pos-Doc/Bag_codesANDdata';
neuromat2 = '/home/paulo/Documents/PauloPosDoc/Pos-Doc/Mixture Models';
home1 = '/home/roberto/Documents/Pos-Doc/Goalkeeper+EEG_dataANDroutines/Git';
home2 = '/home/roberto/Documents/Pos-Doc/Mixture Models';


addpath(genpath(home1))
load([home2 '/SandFmodels.mat'])
load([home2 '/Cmodels.mat'])
load([home2 '/choices.mat'])
load([home2 '/ArticleData101022.mat'])

contexts = {'0','01', '11', '21', '2'};

% For S and F models
valid_p(7) = 0; valid_p(17) = 0; % 32 bits system exclusion
ctx = 5; bwid = 0.04;
valid = find(valid_p == 1);

for a = 1%:9
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
p = valid(a); 
Xs= repo_comp{ctx,1,p}; Xs = Xs.^(1/3);
XofFXs = Smodel_results{ctx,6,p};
preFXs = Smodel_results{ctx,7,p};
[bwid_s, FXs] = optimizing_histogram(Xs,XofFXs,preFXs);
hs = histogram(Xs,'BinWidth',bwid_s,'FaceColor','g');
hold on
plot(XofFXs,FXs,'k-', 'LineWidth',2)
ylim([0 max(FXs)])
axs = gca;
    for b = 1:size(axs.YTickLabel,1)
        axs.YTickLabel{b,1} = num2str(str2num(axs.YTickLabel{b,1})/sum(hs.Values),'%.2f');
    end
xlim([0 1.5])
title([ 'N = ' num2str( length(Xs) ) ' , w = ' contexts{ctx}])
%
subplot(2,1,2)
Xf= repo_comp{ctx,2,p}; Xf = Xf.^(1/3);
XofFXf = Fmodel_results{ctx,6,p};
preFXf = Fmodel_results{ctx,7,p};
[bwid_f, FXf] = optimizing_histogram(Xf,XofFXf,preFXf);
hf = histogram(Xf,'BinWidth',bwid_f, 'FaceColor','r');
hold on
plot(XofFXf,FXf,'k-', 'LineWidth',2)
ylim([0 max(FXf)])
axf = gca;
    for b = 1:size(axf.YTickLabel,1)
        axf.YTickLabel{b,1} = num2str(str2num(axf.YTickLabel{b,1})/sum(hf.Values),'%.2f');
    end
title([ 'N = ' num2str( length(Xf) )  ' , w = ' contexts{ctx} ])
end


% For C models

ctx = 1; 
valid = find(valid_p == 1);
figure('units','normalized','outerposition',[0 0 1 1])

for a = 1:sum(valid_p)
subplot(5,5,a)
p = valid(a); 
X = [repo_comp{ctx,1,p}; repo_comp{ctx,2,p} ]; X = X.^(1/3);
XofFX = Cmodel_results{ctx,6,p};
preFX = Cmodel_results{ctx,7,p};
[bwid, FX] = optimizing_histogram(X,XofFX,preFX);
h = histogram(X,'BinWidth',bwid);
hold on
plot(XofFX,FX,'k-', 'LineWidth',2)
ax = gca;
for b = 1:size(ax.YTickLabel,1)
    ax.YTickLabel{b,1} = num2str(str2num(ax.YTickLabel{b,1})/sum(h.Values),'%.2f');
end
title([ 'N = ' num2str(length(repo_comp{ctx,1,p})+length(repo_comp{ctx,2,p}))])
end

% Boxplots

data_v = zeros(sum(valid_p)*2,1);
group_id = [ ones(sum(valid_p),1); 2*ones(sum(valid_p),1)]; ctx = 2;
aux = 1; npart = 31;
for cond = 1:2
    for p = 1:npart
        if valid_p(p)== 1
          if cond == 1
             ncomps = length(Smodel_results{ctx,1,p});
             for comps = 1:ncomps  
                 data_v(aux) = data_v(aux)+Smodel_results{ctx,1,p}(comps)*Smodel_results{ctx,3,p}(comps);
             end
          else
             ncomps = length(Fmodel_results{ctx,1,p});
             for comps = 1:ncomps  
                 data_v(aux) = data_v(aux)+Fmodel_results{ctx,1,p}(comps)*Fmodel_results{ctx,3,p}(comps);
             end
          end
        aux = aux+1;
        end
    end
end

data_v2 = zeros(sum(valid_p,1),1);
for a = 1:sum(valid_p,1)
    data_v2(a) = data_v(sum(valid_p)+a)-data_v(a);    
end


figure
sbox_varsize(group_id, data_v,'', '', ['w = ' num2str(contexts{1,ctx})], {'S'; 'F'}, 0, 0, [])
figure
[p_value,stat1,stat2] = signrank(data_v2,zeros(sum(valid_p),1),'tail','right');
sbox_varsize(ones(sum(valid_p,1),1), data_v2,  '', '', ['p = ' num2str(p_value)], {''}, 0, 0, [])




% Tables EXPLORE THE TWO TABLES

matrix_tab = zeros(sum(valid_p),5);
matrix_order = zeros(sum(valid_p),5);
aux = 1;
for a = 1:length(valid_p)
    holder = zeros(1,5);
    if valid_p(a)==1
        for ct = 1:5
            for comp = 1:length(Cmodel_results{ct,1,a})
                aux_comp = find(Cmodel_results{ct,3,a} == max(Cmodel_results{ct,3,a}));
                if comp == aux_comp
                holder(1,ct) = Cmodel_results{ct,1,a}(comp);   
%                 holder(1,ct) = holder(1,ct) + Cmodel_results{ct,3,a}(comp)*Cmodel_results{ct,1,a}(comp);
                end
            end
        end
        matrix_tab(aux,:) = holder;
        [~,I] = sort(holder);
        for d = 1:length(holder)
            matrix_order(aux,d) = find(I == d);
        end
        aux = aux+1;
    end
end

matrix_counts = zeros(5,5);

for c = 1:5
   for b= 1:5
      matrix_counts(c,b) = sum( matrix_order(:,c) == b ); 
   end
end

idxes = kmeans(choices(find(valid_p == 1)),2);
choices_rect = choices(find(valid_p == 1));

Emucount5 = 0;
Maxcount5 = 0;
Emulators = find(idxes == 1);
Maximazers = find(idxes == 2);
for a = 1:size(matrix_order, 1)
    if ~isempty(find(Emulators == a)) %#ok<EFIND>
       if (matrix_order(a,2) == 5)||(matrix_order(a,2) == 4)
          Emucount5 = Emucount5 +1; 
       end
    else
       if (matrix_order(a,2) == 5)||(matrix_order(a,2) == 4)
          Maxcount5 = Maxcount5 + 1; 
       end
    end
end


patcheck1 = [];
patcheck2 = [];
for a = 1:size(matrix_order,1) 
    if (matrix_order(a,2) == 1)||(matrix_order(a,2) == 2)
       patcheck1 = [patcheck1; matrix_order(a,:)];
    end
    if (matrix_order(a,2) == 5)||(matrix_order(a,2) == 4)
       patcheck2 = [patcheck2; matrix_order(a,:)];
    end
end