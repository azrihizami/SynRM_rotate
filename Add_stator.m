
load('Stator_points_134.mat')   %redo with new stator ref - 134 nodes instead of 128
load('Stator_segments_134.mat')
load('Stator_arcs_134.mat')
openfemm(1);
opendocument('Rotor_theta0.FEM');
% opendocument('Stator_ref.FEM');
% The rotor onto which the stator is to be added /copy-pasted.
mi_probdef(0,'millimeters','planar',1E-8,70,30,(0))
% problem definition



%  Create node, then segments
% To check all the information on numbers of node, segments and arc, open 'Stator.FEM' in Matlab editor. 

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


% Create mesh
mi_createmesh;

main_restore
mi_showgrid
mi_zoomnatural

mi_analyze()



% % Comments on improvements:
% The code redraw the geometry of an existing FEMM file. This is similar to
% copy pasting.
% The most efficient pipeline. The steps are:
% 1. All the geometry are drawn in CAD, including the sections for airgaps, then export as dxf. This will create nodes number in order when import dxf.
% 2. Import dxf in FEMM. Then save as FEMM file.
% 3. Open the FEMM file (e.g.: Stator.fem) in matlab. Identify the lines for nodes, segments, and arcs. 
% 4. Create text file of each components (nodes, arcs, and segments)
% 5. Import the txt file in matlab and resave as .m. This info will be used in the code for automatic geometry generation
% 6. Write code accordingly (as written in this editor), refering to the
% arrangement and numbering of the elements parameter in FEMM.