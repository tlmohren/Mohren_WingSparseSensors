function varargout=psychoplot4(x_vals, varargin)
% [stats]=psychoplot4(x_vals, went_right)
% [stats]=psychoplot4(x_vals, hits, sides)
%
% Fits a 4 parameter sigmoid to psychophysical data
%
% x_vals        the experimenter controlled value on each trial.
% went_right    a vector of [0,1]'s the same length as x_vals describing 
%               the response on that trials
% OR
%
% hits          a vector of the correct/incorrect history as [0,1,nan]'s.
%               Nans are exluded automatically
% sides         a vector of [-1, 1]'s or ['LR']'s that say what the subject
%               should have done on that trial
%
% The sigmoid is of the form
% y=y0+a./(1+ exp(-(x-x0)./b));
% 
% y0=beta(1)    sets the lower bound
% a=beta(2)     a+y0 is the upper bound  
% x0=beta(3)    is the bias
% b=beta(4)     is the slope



if nargin==2
    went_right=varargin{1};
elseif nargin==3
    hits=varargin{1};
    sides=varargin{2};
 
    gd=~isnan(hits);
    hits=hits(gd);
    sides=sides(gd);
    x_vals=x_vals(gd);
    
    if isnumeric(sides(1))
        went_right=(hits==1 & sides==1) | (hits==0 & sides==-1); 
    else
        sides=lower(sides);
        went_right=(hits==1 & sides=='r') | (hits==0 & sides=='l');
    end
end

[beta,resid,jacob,sigma,mse] = nlinfit(x_vals,went_right,@sig4,[0.1 .8 nanmean(x_vals) 10]);

x_s=linspace(min(x_vals), max(x_vals), 100);
[y_s,delta] = nlpredci(@sig4,x_s,beta,resid,'covar',sigma);
betaci = nlparci(beta,resid,'covar',sigma);

S.beta=beta;
S.betaci=betaci;
S.resid=resid;
S.mse=mse;
S.sigma=sigma;
S.ypred=y_s;
S.y95ci=delta;

fig_h=figure;


trial_types = unique(x_vals);
if numel(trial_types) > numel(went_right)*0.1,
	sortedM=sortrows([x_vals(:) went_right(:)]);
	rawD=jconv(normpdf(-10:10, 0, 2), sortedM(:,2)');
	ax=plot(sortedM(:,1), rawD,'o');
else
    meanD=zeros(size(trial_types));
    seD=meanD;
	for tx = 1:numel(trial_types),
		meanD(tx) = mean(went_right(x_vals == trial_types(tx)));
        %seD(tx) = stderr(went_right(x_vals == trial_types(tx)));
		% it doesn't make sense to take the stderr of a bernoulli variable.
		% instead , just make the error bars 1/sqrt(n);
		seD(tx) = sqrt(meanD(tx)*(1-meanD(tx))/sum(x_vals == trial_types(tx)));
		
	end;
	ax=errorbar(trial_types, meanD,seD);
    set(ax,'MarkerSize', 15);
    set(ax,'LineStyle','none')
    set(ax,'Marker','.')
    
    
end;
hold on

plot(x_s, y_s,'k');
plot(x_s,y_s-delta,'k:');
plot(x_s,y_s+delta,'k:');
ylim([0 1]);
ylabel('% went right')
set(gca,'YTickLabel',[0:10:100]);
if nargout>=1
    varargout{1}=S;
end


if nargout>=2
    varargout{2}=ax;
end

function y=sig4(beta,x)

y0=beta(1);
a=beta(2);
x0=beta(3);
b=beta(4);

y=y0+a./(1+ exp(-(x-x0)./b));

