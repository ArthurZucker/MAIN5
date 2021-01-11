R = 10;
h = 1;
  xc = 0; // first arc
  yc = 0;
  xc2 = 20; // second arc
  yc2 = 0;
  Point(1) = {xc,yc,0,h};
  Point(2) = {xc, yc-R, 0, h};
  Point(3) = {xc-R, yc, 0, h};
  Point(4) = {xc, yc+R, 0, h};

  Circle(1) = {2,1,3};
  Circle(2) = {3,1,4};

  Point(5) = {xc2,yc2,0,h};
  Point(6) = {xc2, yc2-R, 0, h};
  Point(7) = {xc2+R, yc2, 0, h};
  Point(8) = {xc2, yc2+R, 0, h};

  Line(5) = {4,8};
  Circle(4) = {8,5,7};
  Circle(3) = {7,5,6};
  Line(6) = {6,2};

  Curve Loop(1) = {1,2,5,4,3,6};   	// Boundary
  Plane Surface(1) = {1};     	// Surface
  Physical Surface(1) = {1}; 