function plan = runAtlasWalkingPlanning()

% Set up the model
load('data/atlas_fp.mat', 'xstar');
x0 = xstar;
r = Atlas('urdf/atlas_minimal_contact.urdf');
r = r.setInitialState(x0);


% Plan footsteps to the goal
q0 = x0(1:r.getNumDOF());
goal_pos = struct('right', [1;0;0;0;0;0], 'left', [1;0.26;0;0;0;0]);
footstep_plan = r.planFootsteps(q0, goal_pos);

% Show the result
v = r.constructVisualizer();
v.draw(0, x0);
walking_plan_data = r.planWalkingZMP(x0, footstep_plan);
[xtraj, htraj, ts] = r.planWalkingStateTraj(walking_plan_data);

if isa(v, 'BotVisualizer')
  checkDependency('lcmgl');
  lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'footstep_plan');
  footstep_plan.draw_lcmgl(lcmgl);
  lcmgl = drake.util.BotLCMGLClient(lcm.lcm.LCM.getSingleton(), 'walking_plan');
  walking_plan_data.draw_lcmgl(lcmgl);
else
  figure(25)
  footstep_plan.draw_2d();
end

v.playback(xtraj);



end

