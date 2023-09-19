% test changes github
% Remarks:
% The rotor file has been made first, with all the angular rotations
% In the main, the stator is added
% Then the block are defined
% repeated for all rotor position

openfemm(1);
baseFileNameSynRM = 'SynRMseg_theta';
fileExtension = '.fem';

for i = 1
%% 
%     open rotor file
    theta = i-1;
    baseFileName = 'Rotor_theta';
    fileExtension = '.fem';
    rotor_file = [baseFileName num2str(theta) fileExtension]
    opendocument(rotor_file);
    mi_probdef(0,'millimeters','planar',1E-8,70,30,(0)) %problem definition

%     add material
mi_getmaterial('Air') 
mi_getmaterial('M-15 Steel')
mi_getmaterial('20 AWG')
mi_getmaterial('Aluminum, 6061-T6')



%%
% insert stator
load('Stator_points_134.mat')   %redo with new stator ref - 134 nodes instead of 128
load('Stator_segments_134.mat')
load('Stator_arcs_134.mat')
%  Create node, then segments. To check all the information on numbers of node, segments and arc, open 'Stator.FEM' in Matlab editor. 

for i = 1 : 134      % add nodes
    mi_addnode(statorpoints134.x(i),statorpoints134.y(i));
end

i = 1;
for j = 1 : 48    % add segments (Remark: 49-72 segments are not in order for nodes connection, so need to add code)
        mi_addsegment(statorpoints134.x(i),statorpoints134.y(i),statorpoints134.x(i+1),statorpoints134.y(i+1))
%         can be done in this way because the connection points are in
%         order
        i = i+2;
end
% for segment 49-72
for j = 49 : 72
    point1 = statorsegments134.VarName1(j);
    point2 = statorsegments134.VarName2(j);
    mi_addsegment(statorpoints134.x(point1),statorpoints134.y(point1),statorpoints134.x(point2),statorpoints134.y(point2));
end
% The 12 last points are not in order in hte FEMM file. MOdification in teh coordinate files "Stator_segments_134.m" were made manually by finding the points


for k = 1 : 86    % add arcs (Remark: 81-86 arcs are not in order, so need to add code)
    point1 = statorarcs134.Point1(k);  % 1st point of the arc 
    point2 = statorarcs134.Point2(k);  % 2nd point of the arc
    angle = statorarcs134.angle(k);
    mi_addarc(statorpoints134.x(point1+1),statorpoints134.y(point1+1),statorpoints134.x(point2+1),statorpoints134.y(point2+1),angle,5);
end


% add block: 1 rotor,  2 non moveable, 3-8 slot winding, 9 slot opening 
% shaft
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop('Aluminum, 6061-T6', 0, 0, '', 0, 1,1);
% segment holder
mi_addblocklabel(0,4);
mi_selectlabel(0,4);
mi_setblockprop('Aluminum, 6061-T6', 0, 0, '', 0, 1,1);
mi_clearselected;
% slot opening
mi_addblocklabel(3.5,13);
mi_selectlabel(3.5,13);
mi_setblockprop('Air', 0, 0, '', 0, 9,1);
mi_selectgroup(9);
mi_copyrotate(0, 0, 30, 11 )
mi_clearselected;
% stator core
mi_addblocklabel(0,20);
mi_selectlabel(0,20);
mi_setblockprop('M-15 Steel', 0, 0, '', 0, 2,1);
mi_clearselected;
% airgaps 1, 2 and 3
mi_addblocklabel(12.65,0);
mi_selectlabel(12.65,0);
mi_setblockprop('Air', 0, 0, '', 0, 2,1);
mi_clearselected;
mi_addblocklabel(12.80,0);
mi_selectlabel(12.80,0);
mi_setblockprop('Air', 0, 0, '', 0, 2,1);
mi_clearselected;
mi_addblocklabel(12.95,0);
mi_selectlabel(12.95,0);
mi_setblockprop('Air', 0, 0, '', 0, 2,1);
mi_clearselected;


% add circuit property
n = 10; %number of turns
Imax = 20;  % peak current (A)
f = 50;    % frequency electric supply in (Hz)
T = 1/f;   % electrical period (sec) 
load_theta = 0;  % Load angle (rad)
t = T/(2*pi)*load_theta;  % electrical time 
% ----------> DEFINE AS LOAD ANGLE (CONTROL PARAMETERS)
i_A = Imax*sin(2*pi*f*t);
i_B = Imax*sin(2*pi*f*t - 2*pi/3) ;
i_C = Imax*sin(2*pi*f*t + 2*pi/3);
mi_addcircprop('A+', i_A, 1)
mi_addcircprop('A-', -i_A, 1)
mi_addcircprop('B+', i_B, 1)
mi_addcircprop('B-', -i_B, 1)
mi_addcircprop('C+', i_C, 1)
mi_addcircprop('C-', -i_C, 1)
% Slot A+
mi_addblocklabel(4,15.5);
mi_selectlabel(4,15.5);
mi_setblockprop('20 AWG', 0, 0, 'A+', 0, 3,n);
mi_selectgroup(3);
mi_copyrotate(0, 0, 180, 1 )
mi_clearselected;
% Slot B+
mi_addblocklabel(11.5,11.5);
mi_selectlabel(11.5,11.5);
mi_setblockprop('20 AWG', 0, 0, 'B-', 0, 4,n);
mi_selectgroup(4);
mi_copyrotate(0, 0, 180, 1 )
mi_clearselected;
% Slot C+
mi_addblocklabel(15.5,4);
mi_selectlabel(15.5,4);
mi_setblockprop('20 AWG', 0, 0, 'C+', 0, 5,n);
mi_selectgroup(5);
mi_copyrotate(0, 0, 180, 1 )
% Slot A-
mi_addblocklabel(15.5,-4);
mi_selectlabel(15.5,-4);
mi_setblockprop('20 AWG', 0, 0, 'A-', 0, 6,n);
mi_selectgroup(6);
mi_copyrotate(0, 0, 180, 1 )
mi_clearselected;
% Slot B-
mi_addblocklabel(11.5,-11.5);
mi_selectlabel(11.5,-11.5);
mi_setblockprop('20 AWG', 0, 0, 'B+', 0, 7,n);
mi_selectgroup(7);
mi_copyrotate(0, 0, 180, 1 )
mi_clearselected;
% Slot C-
mi_addblocklabel(4.5,-15.5);
mi_selectlabel(4.5,-15.5);
mi_setblockprop('20 AWG', 0, 0, 'C-', 0, 8,n);
mi_selectgroup(8);
mi_copyrotate(0, 0, 180, 1 )
mi_clearselected;

% add boundary (only outer flux null. the machine is a complete 2*pi)
mi_addboundprop('Seg_out', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
mi_selectarcsegment(0,21.5);
mi_selectarcsegment(0,-21.5);
mi_setarcsegmentprop(5,'Seg_out', 0, 1);
mi_clearselected;

%% save file
currentFileTheta = [baseFileNameSynRM num2str(theta) fileExtension];
mi_saveas(currentFileTheta);

end

mi_createmesh;
mi_analyze;
mi_loadsolution;
% mi_showmesh;
main_restore
mo_showdensityplot(1,0,1.5,0,'mag') 


