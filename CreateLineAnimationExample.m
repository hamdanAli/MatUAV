%% Display Line Animation
% Create the initial animated line object. Then, use a loop to add 1,000
% points to the line. After adding each new point, use |drawnow| to display
% the new point on the screen.

% Copyright 2015 The MathWorks, Inc.


h = animatedline;
axis([0,4*pi,-1,1])

x = linspace(0,4*pi,1000);
y = sin(x);
for k = 1:length(x)
    addpoints(h,x(k),y(k));
    drawnow 
end

%%
% For faster rendering, add more than one point to the line each time
% through the loop or use |drawnow limitrate|.
%
% Query the points of the line.

[xdata,ydata] = getpoints(h);

%%
% Clear the points from the line.
clearpoints(h)
drawnow