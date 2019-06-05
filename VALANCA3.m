clear;
rng(1);
%program notes 
%3D arrays are Y X Z
%Colon means the span the entirity of said dimesnion
h_fig = figure;
xlabel('x');
ylabel('y');
%read or set starting data
%global
t = 0.01;
total_kinetic_energy = 1;
G = 9.8;
KH = 10;
intial_vel = sqrt(2*G*KH);
theta = 45;
fc = 0.3;
%Cell Charecteristics
Height = 1;
Alt = 2;
Depth = 3;
AMass = 4;
KHead = 5;

%kinetic energy for the cell
%ENG = 3;
%assign inital state of the cells
%build the avalanche
avalanche = zeros(100,100,5);
%assign alitude
for i =1:100
    avalanche(i, :, Alt) = 100:-1:1;
    avalanche(i, :, Depth) = randi(10,100,1);
    avalanche(i, :, AMass) = 5;
    avalanche(i, :, KHead) = 3;
end

image(avalanche(:,:,Alt),'CDataMapping','scaled');
colorbar

image((avalanche(:,:,Alt) + avalanche(:,:,Depth)),'CDataMapping','scaled');
colorbar

%set the height
avalanche(:,:,Height) = avalanche(:,:,Alt) + avalanche(:,:,Depth) + avalanche(:,:,AMass) + avalanche(:,:,KHead);
%starting point for the avalanche
avalanche(50, 1, Height) = avalanche(50, 1, Height) + 9;
image(avalanche(:,:,Height),'CDataMapping','scaled');
xlabel('x');
ylabel('y');
colorbar
pause(5);
%while loop for 
while total_kinetic_energy > 0
    %increase time step
    t = t + 0.01;
    %for all cells in matrix
    for x = 1:99
        for y = 1:99
            %Determine global indicies of neighbouring cells
            neighbour_one = [y-1 x+1];
            neighbour_two = [y x+1];
            neighbour_thr = [y+1 x+1];
            %calculate outflows(by means of minimisation algortihim)
            %if theres no snow in cell, no snow to give away
            if(avalanche(y,x,1) ~= 0.0)
                outflow = avalanche(y,x,Height)/3;
                %make sure neighbours are inside bounds
                if(neighbour_one(1) < 1)
                   avalanche(neighbour_thr(1), neighbour_thr(2), Height) = avalanche(neighbour_thr(1), neighbour_thr(2), Height) + outflow;
                   avalanche(neighbour_two(1), neighbour_two(2), Height) = avalanche(neighbour_two(1), neighbour_two(2), Height) + (outflow * 2);
                elseif(neighbour_thr(1) > 100)
                   avalanche(neighbour_two(1), neighbour_two(2), Height) = avalanche(neighbour_two(1), neighbour_two(2), Height) + (outflow * 2);
                   avalanche(neighbour_one(1), neighbour_one(2), Height) = avalanche(neighbour_one(1), neighbour_one(2), Height) + outflow;
                else
                   avalanche(neighbour_one(1), neighbour_one(2), Height) = avalanche(neighbour_one(1), neighbour_one(2), Height) + outflow;
                   avalanche(neighbour_two(1), neighbour_two(2), Height) = avalanche(neighbour_two(1), neighbour_two(2), Height) + outflow;
                   avalanche(neighbour_thr(1), neighbour_thr(2), Height) = avalanche(neighbour_thr(1), neighbour_thr(2), Height) + outflow;
                end
            end
         end
            %determine outflows shift
            shift = intial_vel * t + G*(sin(theta) - fc * cos(theta)*(t*t/2));
            %Calculate effective flow(internal and external)
            %Compose flows and dtermine new thickness, mass centre, and
                %coordinates for kinetic head
            %verify mobilisation of snow cover;
            %calculate kinetic energy redution for turbulence
            %avalanche(y, x, ENG) = 1/2 * avalanche(y, x, Height) * (avalanche(y, x, Alt) * avalanche(y, x, Alt));
            %update total energy
    end
    pause(0.5);
    image(avalanche(:,:,1),'CDataMapping','scaled');
    xlabel('x');
    ylabel('y');
    colorbar
    if ~ishghandle(h_fig)   % Quit if user closes the figure window
        break;
    end
end
%loop untill flow velocity in all cells is null
    
